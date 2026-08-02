
function [X,barX] = center(DATA)

%   [X,barX] = center(DATA)
%
% Function for mean centering the data.
%
% Input parameter:
%  - DATA: Data to be modeled
% Return parameters:
%  - X: Moved data matrix
%  - barX: center of DATA
%
% Heikki Hyotyniemi Dec.1, 2000


[k,n] = size(DATA);
if (n>k) disp('Data matrix should be transposed?'); end

barX = mean(DATA)';
X = DATA - ones(k,1)*barX';
