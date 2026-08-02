% Script for Generalized Gamma 3d movie

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_frames=50; % how many frames in movie (change details in movie)
n_points=50; % how many points plotted (change details in movie   

min_y=0.1;  % minimum value of y
max_y=1.5;  % maximum value of y

min_v=.01;  % minimum value of v
max_v=1.5;  % maximum value of v

min_Series=1;   % minimum value for series
max_Series=5;   % minimum value for series

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y=linspace(min_y,max_y,n_points);
v=linspace(min_v,max_v,n_frames)';

series=linspace(min_Series,max_Series,n_points)';

y=repmat(y,n_points,1);
series=repmat(series,1,n_points);

figure('position',[ 50 80 1150 650]);
axis tight
for i = 1:n_frames
    
    prob_ggamma=y./(gamma(v(i)).*series).*( series.*gamma(v(i)+1./y)./gamma(v(i)) ).^(y.*v(i)) ...
                .*exp(-((series.*gamma(v(i)+1./y))./gamma(v(i))).^y);

    surf(series,y,prob_ggamma,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
    title(['The GGama Dist 3d Plot - Value of v = ' num2str(v(i))],'FontWeight','bold','FontSize',12);
    xlabel('Series','FontWeight','bold','FontSize',12);
    ylabel('Value of y','FontWeight','bold','FontSize',12);
    zlabel('Probability','FontWeight','bold','FontSize',12);
    
%     view([-114.5 58]);    % UNCOMENT IT FOR A DIFFERENT POINT OF VIEW

    axis([min_Series-.2 max_Series min_y max_y 0 1]);
    colorbar;
    M(i) = getframe();
    
end