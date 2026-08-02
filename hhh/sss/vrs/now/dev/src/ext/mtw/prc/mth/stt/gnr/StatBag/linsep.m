function [x0,x1] = linsep (N,show)

% Generate two-class two-dimensional linearly separable data
% by having two gaussians with EQUAL covariance matrices

x1=randn(N/2,2)+3;
y1=ones(N/2,1);
x0=randn(N/2,2)+1;
y0=zeros(N/2,1);

if show==1
	plot(x1(:,2),x1(:,1),'x');
	hold on
	plot(x0(:,2),x0(:,1),'o');
	hold off
end

x=[x1;x0];
y=[y1;y0];

