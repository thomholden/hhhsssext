function [c,tp,tn] = classify (x,y,t)

% function [c,tp,tn] = classify (x,y,t)
% classify two class data using decision threshold t
% Return c-number correct, tp-true positives, tn-true negatives

disp('Warning from classify.m: There is a BUG in the logic');

Nx=size(x,1);
Ny=size(y,1);
if (Nx==1) | (Ny==1)
	disp('Error in classify.m: only column vectors allowed');
	return
end

if ~(Nx==Ny)
	disp('Error in classify.m: vectors must be same length');
	return
end

if mean(x) > mean(y)
	tp=sum(x>=t);
	tn=sum(y<t);
	c=tp+tn;
else
	tp=sum(y>=t);
	tn=sum(x<t);
	c=tp+tn;
end
