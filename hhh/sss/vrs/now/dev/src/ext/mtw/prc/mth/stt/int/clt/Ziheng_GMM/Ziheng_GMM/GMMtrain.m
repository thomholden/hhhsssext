function model = GMMtrain(samples,options)

% This function learns a gaussian mixture model from the given data.
% Each dimension of the data is assumed to be independent!!!!!!!!!!
% Author: Ziheng Wang. Date: 11/27/2012.
% Contact wangz10@rpi.edu if you have any questions.
% Copyright (C) 2014 Ziheng Wang
% Input:
%	samples: N*M array. Each row is a sample. Each col is a feature.
%	options.mixutre_num: number of mixtures
%	options.print_option: if 1, print the loglikelihood of each itertaion.
%   options.loglik_threshold: the convergence criteria. default: 1e-3
%   options.max_iter: max iterations. default: 50
% Output:
%	model.mu: mixture_num*M array. Each row is the means for one mixture.
%	model.sigma: mixture_num*M array. Each row is the variances for one mixture.
%	model.weight: 1*M array.
% 	model.mixture_num: mixture_num

if ~isfield(options,'print_option')
    options.print_option = 0;
end
if ~isfield(options,'loglik_threshold')
    options.loglik_threshold = 1e-3;
end
if ~isfield(options,'max_iter')
    options.max_iter = 50;
end

%% initialization of mu, sigma, weight with Kmeans
ini_options.K = options.mixture_num;
centers = yael_kmeans(samples',ini_options);
mu = centers';
feature_num = size(samples,2);
sample_num = size(samples,1);
sigma = 0.5*ones(options.mixture_num,feature_num);
weight = rand(1,options.mixture_num);
weight = weight./sum(weight);

%% EM
Pxi = zeros(sample_num,options.mixture_num);
loglik_old = -realmax;

for i = 1:options.mixture_num
    %Compute probability p(x|i)
    Pxi(:,i) = gaussPDF(samples,mu(i,:),sigma(i,:));
end

converged = 0;
iter = 0;
while ~converged
    iter = iter + 1;
	%% E step
	%Compute posterior probability p(i|x)
	Pix_tmp = repmat(weight,[sample_num 1]).*Pxi;
	Pix_tmp(Pix_tmp < realmin) = realmin;
	Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 options.mixture_num]);
	%Compute cumulated posterior probability
	E = sum(Pix);

	%% M step
	for i = 1:options.mixture_num
		weight(i) = E(i)/sample_num;
		mu(i,:) = Pix(:,i)'*samples/E(i);
		sigma(i,:) = Pix(:,i)'*((samples-repmat(mu(i,:),sample_num,1)).*(samples-repmat(mu(i,:),sample_num,1)))/E(i);  
		sigma(i,:) = sigma(i,:) + 1e-5;
	end

	%% compute the joint likelihood
    for i = 1:options.mixture_num
		Pxi(:,i) = gaussPDF(samples,mu(i,:),sigma(i,:));
    end
	F = Pxi*weight';
	F(F<realmin) = realmin;
	loglik = sum(log(F));
	
	%% check if stop
	if options.print_option == 1
		fprintf('loglik: %f\n',loglik);
	end
	if (abs((loglik/loglik_old)-1) < options.loglik_threshold) || iter > options.max_iter 
		converged = 1;
	end
	loglik_old = loglik;
end
for i = 1:options.mixture_num
  sigma(i,:) = sigma(i,:) + 1e-5;
end
model.mu = mu;
model.sigma = sigma;
model.weight = weight;
model.mixture_num = options.mixture_num;
end




