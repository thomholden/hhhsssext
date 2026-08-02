function [a,b] = binvar (x,y,Nbins)

% function [a,b] = binvar (x,y,Nbins)
% Bin up variables x and y into Nbins

xmax=max(x);
xmin=min(x);
ymax=max(y);
ymin=min(y);
vmax=max([xmax,ymax]);
vmin=min([xmin,ymin]);

dv=(vmax-vmin)/Nbins;
for i=1:Nbins,
	v=vmin+(i-1)*dv;
	a(i)=length(find(x>=v & x<(v+dv)));
	b(i)=length(find(y>=v & y<(v+dv)));
end

