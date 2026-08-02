function div=evaldiv(prior,post)

% Store model size.
ncomp=numel(prior.prop);

% Evaluate divergence between proportion parameters.
div=dirich(prior.prop,prior.stren,post.prop,post.stren);

% Add divergence between gain and noise parameters.
for i=1:ncomp
    div=div+gausswish(prior.gain(:,:,i),prior.scale(:,:,i),...
        prior.noise(:,:,i),prior.shape(i),post.gain(:,:,i),post.scale(:,:,i),...
        post.noise(:,:,i),post.shape(i));
end

end



function div=dirich(pprop,pstren,qprop,qstren)

% Evaluate divergence between Dirichlet distributions.
div=gammaln(qstren)-gammaln(pstren)-...
    sum(gammaln(qstren*qprop)-gammaln(pstren*pprop))+...
    sum((qstren*qprop-pstren*pprop).*(psi(qstren*qprop)-psi(qstren)));

end



function div=gausswish(pgain,pscale,pnoise,pshape,qgain,qscale,qnoise,qshape)

% Store number of rows and columns.
[nrow,ncol]=size(pgain);

% Factorize scale and noise matrices.
pscale=chol(pscale,'lower');
pnoise=chol(pnoise,'lower');
qscale=chol(qscale,'lower');
qnoise=chol(qnoise,'lower');

% Initialize divergence.
div=0;

% Add conditional divergence between Gauss distributions.
div=div+nrow*sum(log(diag(qscale)))-nrow*sum(log(diag(pscale)))+...
    (nrow/2)*sum(sum((qscale\pscale).^2))-nrow*ncol/2+...
    sum(sum((qnoise\(qgain-pgain)*pscale).^2))/2;

% Store half of expected log-determinant.
det=sum(log(diag(qnoise)))+(nrow/2)*log(qshape/2)-...
    sum(psi((qshape+1-(1:nrow))/2))/2;

% Add marginal divergence between Wishart distributions.
div=div+(pshape-qshape)*det-(qshape/2)*nrow+...
    (pshape/2)*sum(sum((qnoise\pnoise).^2))-...
    pshape*sum(log(diag(pnoise)))+...
    qshape*sum(log(diag(qnoise)))+...
    sum(gammaln((pshape+1-(1:nrow))/2))-...
    sum(gammaln((qshape+1-(1:nrow))/2))-...
    nrow*(pshape/2)*log(pshape/2)+...
    nrow*(qshape/2)*log(qshape/2);

end