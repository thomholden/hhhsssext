function [chisq,p] = chisq (tp,fp,fn,tn)

% function [csq,pcsq] = chisq (tp,fp,fn,tn)
% Calculate chisq statistic for 2 by 2 contingency table
% Also return associated p-value
% tp	true positives
% fp	false positives
% fn 	false negatives
% tn	true negatives

% See p.84 UCL LAB BOOK 4 and p.77 UCL LAB BOOK 2
% or Siegel. Nonparametric statistics. p. 289

m=tp+fp;
n=fn+tn;
r=tp+fn;
s=fp+tn;

chisq=(r+s)*(tp*tn-fp*fn)^2/(m*n*r*s);
p=pchisq(chisq,1);

