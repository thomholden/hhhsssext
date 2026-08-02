function prob = gaussPDF(Data, Mu, Sigma)

% This function computes the gaussian probability of data given the mean and variance.
% It is designed specifically for the high dimensional data and can avoid numerical loss. 
% Each feature dimension is assumed to be independent.
% Author: Ziheng Wang. Date: 11/27/2012
% Contact wangz10@rpi.edu if you have any questions.
% Copyright (C) 2012 Ziheng Wang
% Input:
%	Data: N*M array. Each row corresponds to one sample. Each column corresponds to one feature.
%	Mu: 1*M vector. Mu(i) is the mean for the ith feature.
%	Sigma: 1*M vector. Sigma(i) is the variance for the ith feature. (note it is the variance, not the deviation)
% Output:
%	Prob: N*1 array. 


[nbData nbVar] = size(Data);
prob = zeros(nbData,1);
for i = 1:nbVar
    prob = prob -0.5*log(2*pi*Sigma(i)) -0.5*(Data(:,i)-Mu(i)).^2/Sigma(i);
end
prob = exp(prob);
end
