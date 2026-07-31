%% Author : Shujaat Khan, Shujaat123@gmail.com
clc
clear all
close all
addpath('Sub_Functions');
Results=[];
Precision=[];
Recall=[];
ss=10; % sample set size
ns=40; % number of subjects
% ind=randperm(ss);% randomizing the selection of training and testing images
ind=[4 10 2 1 8 3 7 9 6 5];
dimensions=13; % Number of desired dimensions
DatabasePath='Database\ORL\s'; % DatabasePath
ff='.pgm'; % file format of Images
for TrNum=1:(ss-1)
% ind=randperm(ss);% randomizing the selection of training and testing images    
TsNum=ss-TrNum; % Remained Number of Images for testing
if (dimensions<1 | dimensions>TrNum*ns)
    fprintf('Dimensions selection is incorrect it should be in the range of %d and %d\n',1,TrNum*ns);
    return
end
%% Creating Database of Training and Testing Images
    escImages=ind(TrNum+1:ss); % Escape Images for testing    
    [Tr,DS]=CDT(ns,DatabasePath,ff,escImages);
    escImages=ind(1:TrNum); % Escape Images that are already used in training
    [Ts,TDS]=CDT(ns,DatabasePath,ff,escImages);

    %% Performing PCA_Test
    [recp,rectime,outd,recd]= PCA_NEW(Tr,Ts,TrNum,TsNum,dimensions,TrNum);
    [P,R]= PRR(ns,TsNum,outd,recd); % Precision and Recall Results
    
    Results=[Results;recp,rectime,TDS,DS];
    Precision=[Precision; P];
    Recall=[Recall; R];

end
%% Graphing Results
figure('Name','Recognition Percentage vs Number of Training sample per class','NumberTitle','off')
bar(1:TrNum,Results(:,1,1,1)*100);
title('Recognition Percentage vs Number of Training sample per class');
xlabel('Number of Training sample per class');
ylabel('Recognition Percentage');

figure('Name','Precision and Recall Results','NumberTitle','off')
subplot(2,1,1)
pcolor(Precision'*100)
colorbar();
xlabel('Number of Training sample per class');
ylabel('Class ID');
title('Precision Results')

subplot(2,1,2)
pcolor(Recall'*100)
colorbar();
xlabel('Number of Training sample per class');
ylabel('Class ID');
title('Recall Results')