function [c,nc,t] = concordance (x,y)

% x and y concord if x is generally bigger than y
% c 	number of concordant pairs
% nc	number of non-concordant pairs
% t 	number of ties

Nx=size(x,1);
Ny=size(y,1);
if (Nx==1) | (Ny==1)
	disp('Error in concordance.m: only column vectors allowed');
	return
end

if ~(Nx==Ny)
	disp('Error in concordance.m: vectors must be same length');
	return
end

c=0;nc=0;t=0;
for i=1:Nx,
	for j=1:Ny,
		if x(i)>y(j)
			c=c+1;
		elseif x(i)<y(j)
			nc=nc+1;
		else
			t=t+1;
		end
	end
end

