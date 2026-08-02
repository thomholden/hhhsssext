function [t] = getthresh (x,y)

%

Nx=size(x,1);
Ny=size(y,1);
if (Nx==1) | (Ny==1)
	disp('Error in getthresh.m: only column vectors allowed');
	return
end

if ~(Nx==Ny)
	disp('Error in getthresh.m: vectors must be same length');
	return
end

if mean(x) > mean(y)
	[s,i]=sort([y;x]);
	[m,mi]=max(cumsum(2*(i<Nx+1)-1));
	t=s(mi);
else
	[s,i]=sort([x;y]);
	[m,mi]=max(cumsum(2*(i<Nx+1)-1));
	t=s(mi);
end
