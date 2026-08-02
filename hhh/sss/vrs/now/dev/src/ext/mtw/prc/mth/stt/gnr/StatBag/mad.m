function [s] = mad (x)

% function [s] = mad (x)
% Calculate mean absolute deviation of matrix or column vector

med=median(x);

% Now process data so that elements are absolute deviations from median
N=size(x,1);
xabsdev=abs(x-ones(N,1)*med);

s=mean(xabsdev);

