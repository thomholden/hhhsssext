function [k,p] = kappa (tp,fp,fn,tn)

% function [k,p] = kappa (tp,fp,fn,tn)
% Calculate kappa statistic for 2-by-2 contingency table
% Also return associated p-value
% tp	true positives
% fp	false positives
% fn 	false negatives
% tn	true negatives

% See p.15 UCL LAB BOOK 6
% or Siegel. Nonparametric statistics. p. 289

n=tp+fp+fn+tn;
num = 2 * (tp*tn-fp*fn);
denom = num + n * (fp+fn);
k = num / denom;

p0=(fp+tn)/n;
p1=1-p0;
pc=p0^2+p1^2;
num = pc - (pc * pc);
denom = n * (1-pc) * (1-pc);
devk = sqrt (num / denom);

% Is kappa significantly different to k=0
z=(k-0)/devk;
p=pnorm(z);

