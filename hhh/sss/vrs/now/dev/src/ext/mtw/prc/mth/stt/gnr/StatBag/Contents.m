% STATBAG version 1.0
%
% April 28 1998
%
% Examples
% xlindisc1		- example of linear discriminant analysis (LDA)
% xlindisc2		- pruned_lda
%
% Data generation
%
%	normal		- generate normally distributed data
%	bernoulli	- generate bernoulli distributed data
%	gaussian2D	- generate 2D normal data
%	ugaussmix 	- generate gaussian mixture data with uniform mixers
%
% Statistics
%
%	mad		- mean absolute deviation
%
% Measures of correlation and agreement
%
%	chisq		- get Chi Sq statistic for 2x2 contingency table
% 	kappa		- Kappa coeffiecient
%	auc		- area under Receiver Operating Characteristic curve
%	ks		- Kolmogorov-Smirnoff statistic
%
% Classification
%
%	classify	- classify two-class data
%	lclassify	- classify 2-class data where first variable is binary 
%	rclassify	- as above but with reject option as well
%	opcurve		- plots whole operating curve (correct vs reject rate)
%
%	classify-new	- classify single point
%	classify-rate	- classify two-class data returning prop. correct
%	lindisc	 	- get multivariate linear discriminant
%	clindisc	- classification from multivar linear discriminant
%	plindisc	- plot decision boundary for 2D lindisc
%	nn		- nearest-neighbour (NN) classifier
%	knn		- k-nearest-neighbour (kNN) classifier
%
% Regression
%
% 	linreg		- multivariate linear regression
% 	linfwd		- forward pass through linear model
%	regress		- univariate linear regression
%	
% Feature selection
%
%	forward		- linear model with forward selection of vars
%	forwards	- as above but different inputs
%    	pruned_lindisc 	- backward method
%
%
% Cross-validation
%
%	vfold		- vfold cross validation of classifiers
% 	l1out		- leave-one-out validation for various classifiers
%
%
% Combined routines
%	
%	forward_vfold	- vfold validation of forward
%	ulin_l1out	- leave-1-out validation lin discrim with univar feat selection
%
% Significance testing
%
%	ttest		- difference of means test
%	pauc		- get significance of AUC statistic
%	pchisq		- get significance of chisq statistic
%	pnorm		- get significance of normal Z statistic
%	cdf_norm	- 1-pnorm
%	pdiffbin	- are two binned distributions different ?
%	pdiff		- are two distributions different ?
%	ksone		- 1D Kolmogorov Smirnoff statistic
%	xksone		- Example use of ksone
%
% Internally used routines
%
%	binvar		- bin up variables
%	getthresh	- get decision threshold for two-class problems
%	concordance	- get number of pairs that concord
%  	deuclid		- get euclidian distance
%  	dmeuclid	- get euclidian distance
%	ugauss		- evaluate univariate gaussian function 
%	cauchy		- evaluate univariate cauchy function 
% 	normalis	- normalise data

