function [dir,step,fail,conv]=compdir(fun,eff,param,comp,weight,in,out,...
    reg,thres,adapt,tol)

% Store model size and number of points.
[neff,ncomp]=size(eff);
[nout,npoint]=size(out);

% Allocate space for noise factors and search directions.
fact=zeros(nout,nout,ncomp);
dir=zeros(neff,ncomp);

% Initialize squared error and gradient.
err.old=(reg/2)*sum(abs(eff(:)).^2);
grad=reg*eff;

% Accumulate squared error and compute search directions.
for i=1:ncomp
    
    % Factorize noise matrix and store factor.
    fact(:,:,i)=chol(param.noise(:,:,i),'lower');
    
    % Compute normalized residuals.
    [res,jacob]=feval(fun,eff(:,i),in);
    res=fact(:,:,i)\(out-res-param.gain(:,:,i)*in);
    
    % Accumulate squared error.
    clust=comp.prob(i,:).*weight.mean(i,:);
    err.old=err.old+sum(clust.*sum(abs(res).^2,1))/2;
    
    % Accumulate gradient.
    hess=reg*eye(neff);
    for j=1:npoint
        aux=fact(:,:,i)\jacob(:,:,j);
        hess=hess+clust(j)*(aux'*aux);
        grad(:,i)=grad(:,i)-clust(j)*(aux'*res(:,j));
    end
    
    % Compute search direction.
    hess=chol(hess,'lower');
    ind=abs(diag(hess))>=max(abs(diag(hess)))*eps();
    dir(ind,i)=-hess(ind,ind)'\(hess(ind,ind)\grad(ind,i));
    
end

% Ensure search directions are descent directions.
prod=sum(grad.*dir,1);
for i=find(prod>eps())
    dir(:,i)=-grad(:,i);
    prod(i)=-sum(abs(grad(:,i)).^2);
end

% Initialize step size.
step=1;

% Back-track along search directions.
fail=false();
while true()
    
    % Initialize squared error.
    err.new=(reg/2)*sum(abs(eff(:)).^2);
    
    % Accumulate squared error.
    for i=1:ncomp
        
        % Compute normalized residuals.
        res=feval(fun,eff(:,i)+step*dir(:,i),in);
        res=fact(:,:,i)\(out-res-param.gain(:,:,i)*in);
        
        % Accumulate squared error.
        clust=comp.prob(i,:).*weight.mean(i,:);
        err.new=err.new+sum(clust.*sum(abs(res).^2,1))/2;
        
    end
    
    % Ensure sufficient decrease and adapt step size.
    if err.new<=err.old+thres*step*sum(prod)
        break
    else
        step=adapt*step;
    end
    
    % Check if step size becomes too small.
    if step<tol*(eps()+norm(eff+step*dir,'fro'))
        fail=true();
        break
    end
    
end

% Determine convergence.
conv=max(abs(grad(:)))<tol||max(abs(dir(:)./eff(:)))<tol;

end