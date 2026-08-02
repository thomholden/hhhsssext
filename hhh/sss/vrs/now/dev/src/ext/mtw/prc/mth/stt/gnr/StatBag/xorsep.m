function [x0,x1,y0,y1] = xorsep (N,dev,showdata)

% function [x0,x1,y0,y1] = xorsep (N,dev,showdata)
% Generate two-dimensional continuous XOR data
% N 	number of data points
% dev	deviation of each gaussian - bigger values give more overlap
% show	1 for plot, 0 for not

x1a=gaussian2D(N/4,[3,3],[dev,0;0,dev]);
y1a=ones(N/4,1);
x1b=gaussian2D(N/4,[1,1],[dev,0;0,dev]);
y1b=ones(N/4,1);

x0a=gaussian2D(N/4,[3,1],[dev,0;0,dev]);
y0a=zeros(N/4,1);
x0b=gaussian2D(N/4,[1,3],[dev,0;0,dev]);
y0b=zeros(N/4,1);

x0=[x0a;x0b];
x1=[x1a;x1b];
y0=[y0a;y0b];
y1=[y1a;y1b];

x=[x1a;x1b;x0a;x0b];
y=[y1a;y1b;y0a;y0b];

if showdata == 1
	plot(x1a(:,2),x1a(:,1),'x');
	hold on
	plot(x1b(:,2),x1b(:,1),'x');
	plot(x0a(:,2),x0a(:,1),'o');
	plot(x0b(:,2),x0b(:,1),'o');
	hold off
end

