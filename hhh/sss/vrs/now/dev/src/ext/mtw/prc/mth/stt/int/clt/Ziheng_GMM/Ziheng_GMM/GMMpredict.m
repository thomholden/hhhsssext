function [label p] = GMMpredict(X,model)

% This function computes the probability of each mixture given the data and GMM model.
% Author: Ziheng Wang. Date: 11/27/2012
% Contact wangz10@rpi.edu if you have any questions.
% Copyright (C) 2014 Ziheng Wang
% Input:
%	X: N*M array. Each row is one sample. Each col is one feature.
%	model: the learned GMM model
% Output:
%	label: N*1 array. label(i) gives the mixture label for the ith sample
%	p: N*mixture_num array. Each row is the probabilities of one sample. Each col corresponds to one mixture

p = zeros(size(X,1),model.mixture_num);
for j = 1:model.mixture_num
	p(:,j) = model.weight(j)*gaussPDF(X,model.mu(j,:),model.sigma(j,:));
end
[~,label] = max(p,[],2);
end