function lik=evallik(eff,reg)

% Store model size.
[neff,ncomp]=size(eff);

% Evaluate log-likelihood.
lik=-(neff*ncomp/2)*log(2*pi()/reg)-(reg/2)*sum(abs(eff(:)).^2);

end