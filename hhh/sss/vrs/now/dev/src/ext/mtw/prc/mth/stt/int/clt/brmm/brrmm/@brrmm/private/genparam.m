function [prop,gain,noise]=genparam(param)

% Store model size.
[nout,nin,ncomp]=size(param.gain);

% Generate proportion parameters.
prop=dirich(param.prop,param.stren);

% Allocate space for remaining parameters.
gain=zeros(nout,nin,ncomp);
noise=zeros(nout,nout,ncomp);

% Generate gain and noise parameters.
for i=1:ncomp
    [gain(:,:,i),noise(:,:,i)]=gausswish(param.gain(:,:,i),...
        param.scale(:,:,i),param.noise(:,:,i),param.shape(i));
end

end



function prop=dirich(prop,stren)

% Sample from Dirichlet distribution.
prop=randg(stren*prop);
prop=prop/sum(prop);

end



function [gain,noise]=gausswish(gain,scale,noise,shape)

% Store number of rows and columns.
[nrow,ncol]=size(gain);

% Sample from marginal Wishart distribution.
fact=diag(sqrt(2*randg((shape+1-(1:nrow))/2)))+triu(randn(nrow,nrow),1);
fact=(sqrt(shape)*chol(noise,'lower'))/fact;
noise=fact*fact';

% Sample from conditional Gauss distribution.
gain=gain+(chol(noise,'lower')*randn(nrow,ncol))/chol(scale,'lower');

end