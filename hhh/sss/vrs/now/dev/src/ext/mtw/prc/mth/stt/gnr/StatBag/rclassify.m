function [classification_rate,classified_fraction] = rclassify (x,y,t,r)

% function [classification_rate,classified_fraction] = rclassify (x,y,t,r)
% classify two class data using decision threshold t and reject margin r
% Return c-number correct, tp-true positives, tn-true negatives
% fp-false positives, fn-false negatives
% x is the label (0 or 1)
% y is the classifier output

Nx=size(x,1);
Ny=size(y,1);
if (Nx==1) | (Ny==1)
	disp('Error in rclassify.m: only column vectors allowed');
	return
end

if ~(Nx==Ny)
	disp('Error in rclassify.m: vectors must be same length');
	return
end

d=[x,y];
tp=sum(d(:,1)==1 & d(:,2)>=t+r);
tn=sum(d(:,1)==0 & d(:,2)<t-r);
rejectp=sum(d(:,1)==1 & d(:,2)>=t-r & d(:,2)<t+r);
rejectn=sum(d(:,1)==0 & d(:,2)>=t-r & d(:,2)<t+r);
reject=rejectn+rejectp;

p=sum(d(:,1)==1);
n=sum(d(:,1)==1);

fn=p-rejectp-tp;
fp=n-rejectn-tn;

classification_rate=(tp+tn)/(n-rejectn+p-rejectp);
classified_fraction=(n+p-reject)/(n+p);