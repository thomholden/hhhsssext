
function [X,backmap] = whiten(DATA)

%   [X,backmap] = whiten(DATA)
%
% Function for whitening the data.
%
% Input parameter:
%  - DATA: Data to be manipulated
% Return parameters:
%  - X: Modified data matrix
%  - backmap: Matrix for getting back to original coordinates
%    NOTE: backmap*X(i,:)' == DATA(i,:)'.
%
% Heikki Hyotyniemi Dec.1, 2000


[k,n] = size(DATA);
if (n>k) disp('Data matrix should be transposed?'); return; end

R = DATA'*DATA/k;
backmap = chol(R); %sqrtm(R);
X = DATA*inv(backmap);
