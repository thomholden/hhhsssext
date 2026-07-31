function [p x] = baryint(xj,fj,x)
%BARINT   Perform barycentric Lagrange-interpolation.
%   [P X] = BARINT(XJ,FJ,X) returns the interpolated function values at X 
%   based on the known points (XJ,FJ).
%
%   Note: This program is a reduced-functionality version of BARINT.
%
%   See also   BARWEIGHT, BARINT

%   The algorithm is based on the article
%      Berrut, J.-P. and Trefethen, L. N.: Barycentric Lagrange Interpolation,
%      SIAM Rev., vol. 46, no. 3, pp. 501-517, 2004
%
%   Zoltán Csáti
%   2014/05/30

% Obtain the barycentric weights
w = barweight(xj);
% Transpose vectors xj,fj,x if necessary
if size(x,2) == 1 % x is a column vector
    x = x.';   % x must be a row vector
end
if size(fj,2) == 1 % fj is a column vector
    fj = fj.'; % fj must be a row vector
end
xj = xj(:); % force xj to be a column vector
% Perform barycentric interpolation
A = x(ones(length(xj),1),:); % equivalently, A = repmat(x,length(xj),1);
A = bsxfun(@minus,A,xj);
A = bsxfun(@times,1./A,w);
counter = fj*A;
denominator = sum(A);
p = counter./denominator;
% If xj and x overlap each other for some data points, the formula divides 
% by zero and the solution in NaN. It does not affect visualization since
% MATLAB ignores NaN values.
NaNoccurred = isnan(p);
if any(NaNoccurred)
    warning('MATLAB:baryint:divisionByZero', ...
      'There is(are) %d overlapping data point(s).', sum(NaNoccurred));
end