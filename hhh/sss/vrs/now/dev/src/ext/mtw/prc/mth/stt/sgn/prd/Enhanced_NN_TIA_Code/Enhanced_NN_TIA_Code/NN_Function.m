function [net,eTrn,eTst] = NN(timeSeries,numInput,numOutput,hL,lFs,lR,errorGoal,epochs,momentum)

%   Function Input
%   timeSeries: a nx1 array (the raw time series)
%   numInput: number of input nodes
%   numOutput: number of output nodes
%   hL: hidden layers and nodes (e.g. [4 5] two layers with 4 and 5 nodes)
%   lFs: Acteviation funtions of each layer (e.g. {'tansig' 'purelin'})
%   lR: learning rate
%   errorGoal: Error goal
%   epochs: Number of training epochs
%   momentum: momentum factor



% Function Output

% prepare the data 
data = prepareData(timeSeries,numInput,numOutput);
dataLen = size(data,1);

trainDataLen = round(0.9*dataLen);
%testDataLen = dataLen - trainDataLen;



% Network parameters
params = struct('H',hL,'lr',lR,'goal',errorGoal,'epochs',epochs,'momentum',momentum);

% build and train the model
[net,eTrn,eTst] = MLP(data,[1:trainDataLen],[1+trainDataLen:dataLen],params,lFs,numOutput);
 
% figure('Name','Training Error');
%     plot (eTrn);
% figure('Name','Test Error');
%     plot (eTst);