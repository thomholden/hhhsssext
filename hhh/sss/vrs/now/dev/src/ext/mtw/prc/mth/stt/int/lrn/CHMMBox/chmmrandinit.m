function [chmm] = chmmrandinit (X,Y,chmm,covtype)

% function [chmm] = chmmrandinit (X,Y,chmm,covtype)
%
% Initialise Gaussian observation CHMM model 
% using a randomly initialised static Gaussian Mixture Model
% (calling hmmrandinit )
%
% X		N x p data matrix
% hmm		hmm data structure
% covtype	'full' or 'diag' covariance matrices


[chmm.hmmone] = hmmrandinit (X,chmm.hmmone,covtype(1,:));
[chmm.hmmtwo] = hmmrandinit (Y,chmm.hmmtwo,covtype(2,:));

