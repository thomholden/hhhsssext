%% Author : Shujaat Khan, Shujaat123@gmail.com
clc
clear all
close all
addpath('Sub_Functions');
Average_LOOCV=[];
ss=10; % sample set size
ns=40; % number of subjects
ind=[ss-1:-1:1 10];
dimensions=0; % Number of desired dimensions
DatabasePath='Database\ORL\s'; % DatabasePath
ff='.pgm'; % file format of Images
TrNum=ss-1; % For LOOCV, N-1 images for training leaving one for cross validation
Test_Length=360; % Testing for Maximum number of PCA dimensions
complete=0; % Completion Flag set to '0'
for dimensions=1:TrNum*ns
if (exist('LOOCV_Results\Average_LOOCV.mat','file') && exist('LOOCV_Results\R.mat','file'))
load('LOOCV_Results\Average_LOOCV.mat','Average_LOOCV');
load('LOOCV_Results\R.mat');
if (dimensions>=Test_Length)
   fprintf('LOOCV Test Complete\nTo Start new Test choose Test Length and delete LOOCV_Results\n');
%% Graphing LOOCV Results
 Graphs
 complete=1; % Completion Flag set to '1'
    return
end
dimensions=dimensions+1;
end
if (dimensions<1 | dimensions>TrNum*ns)
    fprintf('Dimensions selection is incorrect it should be in the range of %d and %d\n',1,TrNum*ns);
    return
end
if ~complete
Results=[];
for i=1:ss

TsNum=ss-TrNum; % Remained Number of Images for testing

%% Creating Database of Training and Testing Images
% load(strcat('Data_Mat/T',int2str(i),'.mat'));
    escImages=ind(TrNum+1:ss); % Escape Images for testing    
    [Tr,DS]=CDT(ns,DatabasePath,ff,escImages);
    escImages=ind(1:TrNum); % Escape Images that are already used in training
    [Ts,TDS]=CDT(ns,DatabasePath,ff,escImages);
%     save(strcat('Data_Mat/T',int2str(i),'.mat'),'Tr','DS','Ts','TDS');
    %% Performing PCA_Test
    [recp,rectime]= PCA_NEW(Tr,Ts,TrNum,TsNum,dimensions,i);
    Results=[Results;recp,rectime,TDS,DS];
    %% Index shifting for LOOCV
    ind=shift_left(ind); % shift_left is the custom function available in Sub_Functions Folder
end

Average_LOOCV(dimensions)=mean(Results(:,1,1,1))*100;
fprintf('\nFor %d PCA dimensions LOOCV mean : %f\n\n',dimensions,Average_LOOCV(dimensions));
R{dimensions}=Results;
end
if ~exist('LOOCV_Results','dir')
    mkdir('LOOCV_Results');
end
save('LOOCV_Results\R.mat','R','dimensions','ns');
save('LOOCV_Results\Average_LOOCV.mat','Average_LOOCV','dimensions');
end