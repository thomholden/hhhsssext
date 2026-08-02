function [comp,weight,const]=estimvar(fun,eff,param,in,out,ndeg)

% Store model size and number of points.
[nout,~,ncomp]=size(param.gain);
[~,npoint]=size(in);

% Allocate space for distributions over variables.
comp.prob=zeros(ncomp,npoint);
weight.mean=zeros(ncomp,npoint);
weight.rate=zeros(ncomp,npoint);

% Allocate space for log-likelihoods.
loglik=zeros(ncomp,npoint);

% Evaluate natural log-parameters.
prop=psi(param.stren*param.prop)-psi(param.stren);

% Estimate distributions over variables.
empty=isempty(fun)||isempty(eff);
for i=1:ncomp
    
    % Factorize noise matrix.
    fact=chol(param.noise(:,:,i),'lower');
    
    % Compute half of expected log-determinant.
    logdet=sum(log(diag(fact)))+(nout/2)*log(param.shape(i)/2)-...
        sum(psi((param.shape(i)+1-(1:nout))/2))/2;
    
    % Compute residuals.
    res=out-param.gain(:,:,i)*in;
    if ~empty
        res=res-feval(fun,eff(:,i),in);
    end
    
    % Evaluate expected squared errors.
    err=nout*sum((chol(param.scale(:,:,i),'lower')\in).^2,1)+...
        sum((fact\res).^2,1);
    
    % Check number of degrees of freedom.
    if isinf(ndeg)
        
        % Set distribution over weights.
        weight.mean(i,:)=1;
        weight.rate(i,:)=inf();
        
        % Compute marginal log-likelihoods.
        loglik(i,:)=-(nout/2)*log(2*pi())-logdet-err/2;
        
    else
        
        % Estimate conditional distribution over weights.
        weight.mean(i,:)=(ndeg+nout)./(ndeg+err);
        weight.rate(i,:)=(ndeg+err)/2;
        
        % Compute marginal log-likelihoods.
        loglik(i,:)=gammaln((ndeg+nout)/2)-gammaln(ndeg/2)-...
            (nout/2)*log(pi()*ndeg)-logdet-((ndeg+nout)/2)*log1p(err/ndeg);
        
    end
    
end

% Compute component log-probabilities.
comp.prob=bsxfun(@plus,prop(:),loglik);

% Evaluate log-normalization constants.
const=max(comp.prob,[],1);
const=const+log(sum(exp(bsxfun(@minus,comp.prob,const)),1));

% Normalize to obtain marginal component probabilities.
comp.prob=exp(bsxfun(@minus,comp.prob,const));

end