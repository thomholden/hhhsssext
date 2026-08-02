% function [k] = ks (x,y)

% function [k] = ks (x,y)
% Get Kolmogorov-Smirnoff distance between two distributions
% See page 626 Press et.al.

% Get the cumulative distributions

Nx=length(x);
Ny=length(y);
x1=sort(x);
y1=sort(y);

k=0;fn1=0;fn2=0;j1=1;j2=1;
while j1<=Nx & j2 <=Ny,
	d1=x1(j1);d2=y1(j2);
	if d1<=d2
		j1=j1+1;
		fn1=j1/Nx;
	end
	if d2<=d1
		j2=j2+1;
		fn2=j2/Ny;
	end
	dt=abs(fn1-fn2);
	if dt > k
		k=dt;
	end
end



	




