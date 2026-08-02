
function [X,backmap] = scale(DATA,w)

%   [X,backmap] = scale(DATA,w)
%   [X,backmap] = scale(DATA)
%
% Function for normalizing data variances.
%
% Input parameter:
%  - DATA: Data to be manipulated
%  - w: Intended variances or importances (optional)
% Return parameters:
%  - X: Modified data matrix
%  - backmap: Matrix for getting back to original coordinates
%    NOTE: backmap*X(i,:)' == DATA(i,:)'.
%
% Heikki Hyotyniemi Dec.1, 2000


[k,n] = size(DATA);
if (n>k) disp('Data matrix should be transposed?'); end
if nargin < 2
   w = ones(n,1);
elseif size(w,2) > 1
   w = w';
end

R = DATA'*DATA/k;
backmap = diag(sqrt(diag(R)./w));
X = DATA*inv(backmap);
