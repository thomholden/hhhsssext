%% Slightly Modified LOOCV Test: Performed after changing orignal mean
%% operation in PCA_NEW function with [mode, median] and comparision with
%% mean-PCA (Orignal) the function shows time and recognition percentage 
function []=Comparision();
clc
close all
clear all
%% Loading LOOCV Results
if (exist('PCA_mean_LOOCV_Results\Average_LOOCV.mat','file') && exist('PCA_mean_LOOCV_Results\R.mat','file') && exist('PCA_median_LOOCV_Results\Average_LOOCV.mat','file') && exist('PCA_median_LOOCV_Results\R.mat','file'))
load('PCA_mean_LOOCV_Results\Average_LOOCV.mat');
load('PCA_mean_LOOCV_Results\R.mat');

Mean_LOOCV_Results=Average_LOOCV;
R_Mean=R;

load('PCA_median_LOOCV_Results\Average_LOOCV.mat');
load('PCA_median_LOOCV_Results\R.mat');

Median_LOOCV_Results=Average_LOOCV;
R_Median=R;

load('PCA_mode_LOOCV_Results\Average_LOOCV.mat');
load('PCA_mode_LOOCV_Results\R.mat');

Mode_LOOCV_Results=Average_LOOCV;
R_Mode=R;

%% Graphing LOOCV Recognition Results
 figure('Name','Recognition Percentage vs Number of PCA Dimensions','NumberTitle','off')
 hold on
 [val1,ind1]=max(Mean_LOOCV_Results);
 plot(1:dimensions,Mean_LOOCV_Results,'LineWidth',3);
 plot(ind1,Mean_LOOCV_Results(ind1),'o','LineWidth',2,...
                              'MarkerEdgeColor','r',...
                              'MarkerFaceColor','g',...
                              'MarkerSize',8);
                          
 [val2,ind2]=max(Median_LOOCV_Results);                         
 plot(1:dimensions,Median_LOOCV_Results,'--r','LineWidth',3);
 plot(ind2,Median_LOOCV_Results(ind2),'o','LineWidth',2,...
                              'MarkerEdgeColor','y',...
                              'MarkerFaceColor','k',...
                              'MarkerSize',8);
                         
 [val3,ind3]=max(Mode_LOOCV_Results);                         
 plot(1:dimensions,Mode_LOOCV_Results,'g','LineWidth',3);
 plot(ind3,Mode_LOOCV_Results(ind3),'o','LineWidth',2,...
                              'MarkerEdgeColor','g',...
                              'MarkerFaceColor','m',...
                              'MarkerSize',8);
                          
 grid minor
 title('Recognition Percentage vs Number of PCA Dimensions');
 xlabel('Number of PCA Dimensions');
 ylabel('Recognition Percentage');
 legend('Recognition Percentage Using Orignal PCA',strcat('Maximum Recogntion :',num2str(val1),'% Using Orignal PCA'),'Recognition Percentage Using Improved(Median) PCA',strcat('Maximum Recogntion :',num2str(val2),'% Using Improved(Median) PCA'),'Recognition Percentage Using Mode PCA',strcat('Maximum Recogntion :',num2str(val3),'% Using Mode PCA'),'Location','Best')
%% Graphing LOOCV Time/Dimensions Results
 figure('Name','Recognition Time vs Number of PCA Dimensions','NumberTitle','off')
 hold on
 for i = 1:dimensions
 mean_time1(i)=mean(R_Mean{1,i}(:,2));
 end
 mean_time1=(mean_time1/ns)*1000;
%  v=mean(mean_time1);
%  ul=v+std(mean_time1);
%  ll=v-std(mean_time1);
 
 plot(mean_time1,'m','LineWidth',2)
%  plot(1:dimensions,repmat(ul,1,dimensions),'--k','LineWidth',2);
%  plot(1:dimensions,repmat(v,1,dimensions),'--r','LineWidth',2);
%  plot(1:dimensions,repmat(ll,1,dimensions),'--k','LineWidth',2);
 plot(ind1,mean_time1(ind1),'o','LineWidth',2,...
                              'MarkerEdgeColor','r',...
                              'MarkerFaceColor','g',...
                              'MarkerSize',8)
 
 for i = 1:dimensions
 mean_time2(i)=mean(R_Median{1,i}(:,2));
 end
 mean_time2=(mean_time2/ns)*1000;
%  v=mean(mean_time2);
%  ul=v+std(mean_time2);
%  ll=v-std(mean_time2);
 plot(mean_time2,'LineWidth',2)
 
%  plot(1:dimensions,repmat(ul,1,dimensions),'--r','LineWidth',2);
%  plot(1:dimensions,repmat(v,1,dimensions),'--k','LineWidth',2);
%  plot(1:dimensions,repmat(ll,1,dimensions),'--r','LineWidth',2);
 plot(ind2,mean_time2(ind2),'o','LineWidth',2,...
                              'MarkerEdgeColor','r',...
                              'MarkerFaceColor','k',...
                              'MarkerSize',8)
 for i = 1:dimensions
 mean_time3(i)=mean(R_Mode{1,i}(:,2));
 end
 mean_time3=(mean_time3/ns)*1000;
%  v=mean(mean_time2);
%  ul=v+std(mean_time2);
%  ll=v-std(mean_time2);
 plot(mean_time3,'g','LineWidth',2)
 
%  plot(1:dimensions,repmat(ul,1,dimensions),'--r','LineWidth',2);
%  plot(1:dimensions,repmat(v,1,dimensions),'--k','LineWidth',2);
%  plot(1:dimensions,repmat(ll,1,dimensions),'--r','LineWidth',2);
 plot(ind3,mean_time3(ind3),'o','LineWidth',2,...
                              'MarkerEdgeColor','m',...
                              'MarkerFaceColor','k',...
                              'MarkerSize',8)                         
                          
 grid minor
 title('Mean Recognition Time per image vs Number of PCA Dimensions');
 xlabel('Number of PCA Dimensions');
 ylabel('Mean Recognition Time per image in (miliseconds)');
 legend('Mean Recognition Time of Orignal PCA',strcat('Mean Maximum Recognition time :',num2str(mean_time1(ind1)),' milisec'),'Mean Recognition Time of Improved(Median) PCA',strcat('Mean Maximum Recognition time :',num2str(mean_time2(ind2)),' milisec'),'Mean Recognition Time of Mode PCA',strcat('Mean Maximum Recognition time :',num2str(mean_time3(ind3)),' milisec'));
 %% Results Summary
 fprintf('Using Orignal PCA %.2f %% Maximum Recognition is achieved at %d number of dimensions for mean recogntion time per image %f miliseconds\n\n',val1,ind1,mean_time1(ind1));
 fprintf('Using Improved PCA %.2f %% Maximum Recognition is achieved at %d number of dimensions for mean recogntion time per image %f miliseconds\n\n',val2,ind2,mean_time2(ind2));
 fprintf('Using Mode PCA %.2f %% Maximum Recognition is achieved at %d number of dimensions for mean recogntion time per image %f miliseconds\n\n',val3,ind3,mean_time3(ind3));
 
 else
    fprintf('Perform LOOCV Test first\n');
 end