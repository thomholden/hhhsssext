function [ Eigenfaces ] = PCA_Core(Tr,M,dimensions)
%PCA_CORE Perform Principal Component Analysis
%   Steps are as follows

%% Find the mean centered data 'A'
 A=Tr-repmat(M,1,size(Tr,2));

 %% Find Covariance Matrix's Eigenvector 'using Surogate Method to reduce Computational Cost
 L=cov(A); % surogate Matrix of mean subtracted 
 [U D]=eig(L);% Eigen Vectors of Surogate Matrix

 %% Sorting Eigenvectors to select the most dominent eigenvectors
 L_eig_vec = [];
 eigValue=diag(D);
 [eigValue,IX]=sort(eigValue,'descend');
 L_eig_vec=U(:,IX);

%% normailization (optional)
 norm_eigVector=sqrt(sum(L_eig_vec.^2));
 L_eig_vec=L_eig_vec./repmat(norm_eigVector,size(L_eig_vec,1),1);

%% dimensionality reduction
 Eigenfaces = A * L_eig_vec(:,1:dimensions);
end

