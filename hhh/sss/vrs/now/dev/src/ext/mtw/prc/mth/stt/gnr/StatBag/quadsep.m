function [x0,x1] = quadsep (N,cov0,cov1,show)

% function [x0,x1] = quadsep (N,cov0,cov1,show)
% Generate two-class two-dimensional quadratically separable data
% by having two gaussians with UNEQUAL covariance matrices
% N 	total number of data points
% cov0  cov matrix of one blob eg. [1,0;0,1];
% cov1  cov matrix of the other eg. [1,0.5;0.5,1];

x1=gaussian2D(N/2,[3,3],cov1);
y1=ones(N/2,1);

x0=gaussian2D(N/2,[1,1],cov0);
y0=zeros(N/2,1);

if show==1
	plot(x1(:,2),x1(:,1),'x');
	hold on
	plot(x0(:,2),x0(:,1),'o');
	hold off
end

x=[x1;x0];
y=[y1;y0];

