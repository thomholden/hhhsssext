function [n]=myndims(X)
%  MYNDIMS   Number of dimensions.
%      N = MYNDIMS(X) returns the number of dimensions in the array X.
%      The number of dimensions in an array is NOT always greater than
%      or equal to 2 (unlike Matlab's NDIMS).  
%      scalars return 0
%      vectors return 1
%      MD arrays return M where M all all non-singleton elements
%
%      See also NDIMS, SIZE.


sv=size(X);

if all(sv==1),
  n=0;
else
  n=sum(sv~=1);
end
  