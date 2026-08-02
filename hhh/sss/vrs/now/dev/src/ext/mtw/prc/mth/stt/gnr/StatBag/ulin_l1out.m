function [r,pcsq] = ulin_l1out(class0,class1,vars)

% function [r,pcsq] = ulin_l1out(class0,class1,vars)
% Leave 1 out validation of 
% Univariate feature selection then linear discriminant
% r	proportion correct
% pcsq	associated p-value

[tn,tp,fp,fn]=l1out(class0,class1,'culindisc',vars);
r=(tp+tn)/(tp+tn+fp+fn);
[csq,pcsq] = chisq (tp,fp,fn,tn);


