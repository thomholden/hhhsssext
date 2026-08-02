% Script for Generalized Gamma 3d movie

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_frames=50;    % how many frames in movie (change details in movie)
n_points=50;    % how many points plotted (change details in movie   

min_k=.5;   % minimum value of k
max_k=2.5;  % maximum value of k

min_sigma2=.01; % minimum value of sigma^2
max_sigma2=2;   % maximum value of sigma^2

min_Series=1;   % minimum value for series
max_Series=5;   % minimum value for series

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=linspace(min_k,max_k,n_points);
sigma2=linspace(min_sigma2,max_sigma2,n_frames)';

series=linspace(min_Series,max_Series,n_points)';

k=repmat(k,n_points,1);
series=repmat(series,1,n_points);

figure('position',[ 50 80 1150 650]);
axis tight
for i = 1:n_frames
    
    prob_burr=(1.^(-k).*k.*series.^(k-1)) ./ ( (1+sigma2(i).*1.^(-k).*series.^k).^(1./sigma2(i)+1) );
    surf(series,k,prob_burr,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
    title(['The Burr Dist 3d Plot - Value of \sigma^2 = ' num2str(sigma2(i))],'FontWeight','bold','FontSize',12);
    xlabel('Series','FontWeight','bold','FontSize',12);
    ylabel('Value of k','FontWeight','bold','FontSize',12);
    zlabel('Probability','FontWeight','bold','FontSize',12);
    
%     view([-114.5 58]);    % UNCOMENT IT FOR A DIFFERENT POINT OF VIEW

    axis([min_Series-.2 max_Series min_k max_k 0 1]);
    colorbar;
    M(i) = getframe();
    
end