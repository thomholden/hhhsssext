function [gma] = ugaussmix (m,dev,N)

% function [gma] = ugaussmix (m,dev,N)
% Return N samples from a gaussian mixture model
% The mixing coefficients are uniform
% m 	column vector of component means
% dev	column vector of component deviations
% N 	number of samples to generate

if size(m,2) > 1 | size(dev,2) > 1
	disp('Error in ugaussmix: vectors must be in column format');
	return
end
if ~(size(m,1) == size(dev,1))
	disp('Error in ugaussmix: vectors must be same length');
	return
end
M=size(m,1);

% Generate N samples from M mixtures
a = m*ones(1,N) + dev*randn(1,N);

% Pick off 1 mixture sample for each N
x=ceil(rand(1,N)*M);
i=[1:1:N];
r=full(sparse(x,i,ones(1,N),M,N));
mra=r.*a;
gma=mra(find(~(mra==0)));

