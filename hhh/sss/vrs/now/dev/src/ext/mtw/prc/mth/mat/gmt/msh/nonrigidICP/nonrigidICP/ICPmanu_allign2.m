function [error,Reallignedsource]=ICPmanu_allign2(target,source)

[IDX1,d]=knnsearch(target,source);
[IDX2,D]=knnsearch(source,target);

Datasetsource=vertcat(source,source(IDX2,:));
Datasettarget=vertcat(target(IDX1(:,1),:),target);

[error,Reallignedsource] = procrustes(Datasettarget,Datasetsource,'reflection',0);
Reallignedsource=Reallignedsource(1:length(source(:,1)),:);