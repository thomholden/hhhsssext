function conv=isconv(val,reltol)

% Store number of iterations.
niter=numel(val);

% Check convergence.
if niter>1
    conv=max(2*abs(val(niter)-val(niter-1)),eps())<=...
        reltol*(abs(val(niter))+abs(val(niter-1)));
else
    conv=false();
end

end