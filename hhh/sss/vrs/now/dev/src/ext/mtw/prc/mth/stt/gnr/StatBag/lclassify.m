function [c,tp,tn,fp,fn] = lclassify (x,y,t)

% function [c,tp,tn,fp,fn] = lclassify (x,y,t)
% classify two class data using decision threshold t
% Return c-number correct, tp-true positives, tn-true negatives
% fp-false positives, fn-false negatives
% x is the label (0 or 1)
% y is the classifier output

x=x(:);
y=y(:);

Nx=size(x,1);
Ny=size(y,1);
if ~(Nx==Ny)
	disp('Error in lclassify.m: vectors must be same length');
	return
end

d=[x,y];
tp=sum(d(:,1)==1 & d(:,2)>=0.5);
tn=sum(d(:,1)==0 & d(:,2)<0.5);
n=sum(d(:,1)==0);
p=sum(d(:,1)==1);
fn=p-tp;
fp=n-tn;
c=tp+tn;
