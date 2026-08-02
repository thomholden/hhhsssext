function [seq,cost]=sampseq(mean,var,covar,nseq)

% Store size.
[nstate,npoint]=size(mean);

% Allocate space for return arguments.
seq=zeros(nstate,npoint,nseq);
cost=zeros(nseq,1);

% Factorize marginal variance-covariance matrix.
fact=chol(var(:,:,end),'lower');

% Store log-normalization constant.
const=(nstate/2)*log(2*pi())+sum(log(diag(fact)));

% Sample from marginal distribution.
for i=1:nseq
    res=randn(nstate,1);
    seq(:,end,i)=mean(:,end)+fact*res;
    cost(i)=const+sum(res.^2)/2;
end

% Sample sequences.
for i=npoint-1:-1:1
    
    % Compute gain.
    gain=covar(:,:,i)/var(:,:,i+1);
    
    % Factorize conditional variance-covariance matrix.
    fact=chol(var(:,:,i)-gain*covar(:,:,i)','lower');
    
    % Store log-normalization constant.
    const=(nstate/2)*log(2*pi())+sum(log(diag(fact)));
    
    % Sample from conditional distribution.
    for j=1:nseq
        res=randn(nstate,1);
        seq(:,i,j)=mean(:,i)+gain*(seq(:,i+1,j)-mean(:,i+1))+fact*res;
        cost(j)=cost(j)+const+sum(res.^2)/2;
    end
    
end

end