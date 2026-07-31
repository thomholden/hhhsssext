function mat = createLags(vec, lags) 
% CREATELAGS generates lagged versions of an input vector or matrix to 
% generate a predictor matrix. 
% 
% USAGE: 
% predictorMatrix = createLags(series, lags) 
% 
% Here series is a numObs-by-numDim matrix of observations. If numDim > 1, 
% it implies the input series is a multidimensional series. lags is a 
% vector of integer lags where 0 corresponds to no lag, +1,+2,+3... correspond to 
% lags of 1,2,3... steps, and -1,-2,-3 correspond to "leads" of 1,2,3 
% steps. predictorMatrix is a numObs-by-numDim*numLags matrix of the 
% shifted versions of the input matrix
%
% x = [1 2 3 4; -1 -2 -3 -4]' 
% y = createLags(x, [-1 0 2])

% Copyright 2013 The MathWorks, Inc.

[numObs, numDim] = size(vec); 
numLags = length(lags); 
mat = NaN(numObs, numDim * numLags); 
for i = 1:length(lags) 
mStaInd = max(1, lags(i)+1); 
mEndInd = min(numObs, lags(i)+numObs); 
vStaInd = max(1, 1-lags(i)); 
vEndInd = min(numObs, numObs-lags(i)); 

mat(mStaInd:mEndInd, (i-1)*numDim+1:i*numDim) = vec(vStaInd:vEndInd,:); 
end