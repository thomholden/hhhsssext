function param=estimparam(fun,eff,param,comp,weight,in,out)

% Store model size.
[nout,nin,ncomp]=size(param.gain);

% Accumulate expected sufficient statistics.
stat.prop=param.stren*param.prop(:)+sum(comp.prob,2);

% Estimate distribution over proportion parameters.
param.stren=sum(stat.prop);
param.prop=reshape(stat.prop/param.stren,size(param.prop));

% Store indices.
ind.in=1:nin;
ind.out=nin+1:nin+nout;

% Estimate distributions over remaining parameters.
empty=isempty(fun)||isempty(eff);
for i=1:ncomp
    
    % Compute residuals.
    res=out;
    if ~empty
        res=res-feval(fun,eff(:,i),in);
    end
    
    % Store weighted cluster assignments.
    clust=comp.prob(i,:).*weight.mean(i,:);
    
    % Accumulate expected sufficient statistics.
    stat.gain=param.gain(:,:,i)*param.scale(:,:,i)+...
        bsxfun(@times,clust,res)*in';
    stat.scale=param.scale(:,:,i)+bsxfun(@times,clust,in)*in';
    stat.noise=param.gain(:,:,i)*param.scale(:,:,i)*param.gain(:,:,i)'+...
        param.shape(i)*param.noise(:,:,i)+bsxfun(@times,clust,res)*res';
    stat.shape=param.shape(i)+sum(comp.prob(i,:));
    
    % Factorize outer-product matrix.
    fact=chol([stat.scale,stat.gain';stat.gain,stat.noise],'lower');
    
    % Estimate conditional distribution over gain parameters.
    param.gain(:,:,i)=fact(ind.out,ind.in)/fact(ind.in,ind.in);
    param.scale(:,:,i)=fact(ind.in,ind.in)*fact(ind.in,ind.in)';
    
    % Estimate marginal distribution over noise parameters.
    param.noise(:,:,i)=...
        (fact(ind.out,ind.out)*fact(ind.out,ind.out)')/stat.shape;
    param.shape(i)=stat.shape;
    
end

end