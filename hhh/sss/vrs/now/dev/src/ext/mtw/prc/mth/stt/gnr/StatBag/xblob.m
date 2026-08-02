function [x0,x1] = xblob(blobset,N,p1,show)

% function [x0,x1] = xblob(blobset,N,p1,show)
% blobset	which type of data set
% N		total number of points
% p1		proportion of points in blob 1
% show		set to 1 if you also want a plot of the data

if blobset==1
	% Diag Cov single blob
	cov_matrix=[1,0;0,1];
	p2=1-p1;
	x0=gaussian2D(p1*N,[2,2],cov_matrix);
	x1=gaussian2D(p2*N,[2,2],cov_matrix);
elseif blobset==2
	% Non-Diag Cov single blob
	cov_matrix=[1,0.5;0.5,1];
	p2=1-p1;
	x0=gaussian2D(p1*N,[2,2],cov_matrix);
	x1=gaussian2D(p2*N,[2,2],cov_matrix);
elseif blobset==3
	% Two blob - separated by x parallel projection
	cov_matrix=[1,0;0,1];
	p2=1-p1;
	x0=gaussian2D(p1*N,[2,2],cov_matrix);
	x1=gaussian2D(p2*N,[8,2],cov_matrix);
elseif blobset==4
	% Two blob 
	cov_matrix=[1,0.5;0.5,1];
	p2=1-p1;
	x0=gaussian2D(p1*N,[2,2],cov_matrix);
	x1=gaussian2D(p2*N,[4,0],cov_matrix);
else
	disp(sprintf('Error in xblob: Unknown data set name: %s', blobset));
end


if show==1
	hold on
	plot(x0(:,1),x0(:,2),'o');
	plot(x1(:,1),x1(:,2),'x');
end
