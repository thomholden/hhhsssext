function [p] = cdf_norm (z)

% function [p] = cdf_norm (z)
% Return proby Z < z if Z is normally distributed with mean 0
% and deviation 1

p=1-pnorm(z);