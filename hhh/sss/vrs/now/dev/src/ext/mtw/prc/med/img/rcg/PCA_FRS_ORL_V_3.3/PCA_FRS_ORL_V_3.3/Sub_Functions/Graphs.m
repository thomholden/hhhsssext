function []=Graphs();
%% Loading LOOCV Results
if (exist('LOOCV_Results\Average_LOOCV.mat','file') && exist('LOOCV_Results\R.mat','file'))
load('LOOCV_Results\Average_LOOCV.mat','Average_LOOCV');
load('LOOCV_Results\R.mat');
[val,ind]=max(Average_LOOCV);
%% Graphing LOOCV Recognition Results
 figure('Name','Recognition Percentage vs Number of PCA Dimensions','NumberTitle','off')
 plot(1:dimensions,Average_LOOCV,'LineWidth',3);
 hold on
 plot(ind,Average_LOOCV(ind),'o','LineWidth',2,...
                              'MarkerEdgeColor','r',...
                              'MarkerFaceColor','g',...
                              'MarkerSize',8)
 grid minor
 title('Recognition Percentage vs Number of PCA Dimensions');
 xlabel('Number of PCA Dimensions');
 ylabel('Recognition Percentage');
 legend('Recognition Percentage','Maximum Recogntion %','Location','Best')
%% Graphing LOOCV Time/Dimensions Results
 figure('Name','Recognition Time vs Number of PCA Dimensions','NumberTitle','off')
 for i = 1:dimensions
 mean_time(i)=mean(R{1,i}(:,2));
 end
 mean_time=(mean_time/ns)*1000;
 v=mean(mean_time);
 ul=v+std(mean_time);
 ll=v-std(mean_time);
 plot(mean_time,'LineWidth',2)
 hold on
 plot(1:dimensions,repmat(ul,1,dimensions),'r','LineWidth',2);
 plot(1:dimensions,repmat(v,1,dimensions),'k','LineWidth',2);
 plot(1:dimensions,repmat(ll,1,dimensions),'r','LineWidth',2);
 plot(ind,mean_time(ind),'o','LineWidth',2,...
                              'MarkerEdgeColor','r',...
                              'MarkerFaceColor','g',...
                              'MarkerSize',8)
 grid minor
 title('Mean Recognition Time per image vs Number of PCA Dimensions');
 xlabel('Number of PCA Dimensions');
 ylabel('Mean Recognition Time per image in (miliseconds)');
 legend('Mean Recognition Time','standard deviation +','Mean Time','standard deviation -','Maximum Recogntion %');
 %% Results Summary
 fprintf('%.2f %% Maximum Recognition is achieved at %d number of dimensions for mean recogntion time per image %f miliseconds\n\n',val,ind,mean_time(ind));
 else
    fprintf('Perform LOOCV Test first\n');
 end