function conv=isconv(bound,tol)

% Store number of iterations.
niter=numel(bound);

% Check convergence.
if niter>1
    conv=max(2*abs(bound(niter)-bound(niter-1)),eps())<=...
        tol*(abs(bound(niter))+abs(bound(niter-1)));
else
    conv=false();
end

end