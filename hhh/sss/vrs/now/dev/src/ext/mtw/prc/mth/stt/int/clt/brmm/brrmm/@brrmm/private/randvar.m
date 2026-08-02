function [comp,weight]=randvar(comp,weight,temp)

% Store model size and number of points.
[ncomp,npoint]=size(comp.prob);

% Randomize comp probabilities.
comp.prob=comp.prob.*max(1-temp*rand(ncomp,npoint),0);
comp.prob=bsxfun(@rdivide,comp.prob,max(sum(comp.prob,1),0));
comp.prob(isnan(comp.prob)|isinf(comp.prob))=1/ncomp;

end