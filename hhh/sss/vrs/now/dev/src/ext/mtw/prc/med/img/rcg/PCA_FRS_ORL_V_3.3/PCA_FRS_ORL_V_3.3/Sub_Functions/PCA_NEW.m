function [recp,rectime,outd,recd]= PCA_NEW(Tr,Ts,TrNum,TsNum,dimensions,sno)
% Program Combine different functions to perform FaceRecognition Task
% syntax is [recp,rectime]= PCA_NEW(Tr,Ts,TrNum,TsNum,dimensions)
% where recp =recognition percentage on the scale of 0 to 1,
% rectime=recognition time in seconds
% Tr = Training Images Matrix of MXN size where M is number of elements per
% sample and N is Number of Samples
% Ts = Testing Images Matrix of MXO size where M is number of elements per
% sample and O is Number of Samples
% TsNum = Testing Number of images per person
% TrNum = Training Number of images per person
% dimensions = Number of Dimensions in which you want to reduce the data

%% Calculating Mean of Training Data
TDS=size(Ts,2);
DS=size(Tr,2);

M=mean(Tr,2);
% M=median(Tr,2);
% M=mode(Tr,2);

%% Perform PCA to get Eigenfaces in reduced dimensions
[Eigenfaces] = PCA_Core(Tr,M,dimensions); 

%% Projecting Training & Testing Images in Eigenspace
[ProjectedImages] = Image_Projection(Tr,M,Eigenfaces);
[ProjectedTestImages] = Image_Projection(Ts,M,Eigenfaces); 

%% Recognizing Images usign euclidean distance
[recp,rectime,outd,recd] = Recognition(ProjectedTestImages,ProjectedImages,TDS,DS,TrNum,TsNum,sno); 
end