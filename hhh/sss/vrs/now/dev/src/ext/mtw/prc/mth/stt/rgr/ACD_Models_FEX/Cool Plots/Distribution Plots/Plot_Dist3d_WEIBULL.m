% Script for 3d plot of weibull Distribution

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_points=50; % how many points plotted (change details in movie   

min_y=0.1;  % minimum value of y
max_y=2.5;  % maximum value of y

min_Series=1;   % minimum value for series
max_Series=5;   % minimum value for series

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y=linspace(min_y,max_y,n_points);
series=linspace(min_Series,max_Series,n_points)';

y=repmat(y,n_points,1);
series=repmat(series,1,n_points);

figure('position',[50 80 1150 650]);

prob_weibull=y./(series).*(series.*gamma(1+1./y)./1).^(y).*exp(-((series.*gamma(1+1./y)./1)).^y);

surf(series,y,prob_weibull,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
xlabel('Series','FontWeight','bold','FontSize',12);
ylabel('Value of y','FontWeight','bold','FontSize',12);
zlabel('Probability','FontWeight','bold','FontSize',12);
title('The Weibull Distribution in 3D','FontWeight','bold','FontSize',12);
axis([min_Series-.2 max_Series min_y max_y 0 1]);
colorbar;