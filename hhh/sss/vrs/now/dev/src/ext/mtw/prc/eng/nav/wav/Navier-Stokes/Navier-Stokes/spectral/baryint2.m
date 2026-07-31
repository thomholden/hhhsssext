function [G X Y] = baryint2(x,F,y)
%BARINT   Perform barycentric Lagrange-interpolation in two dimensions.
%   [G X Y] = BARINT2(x,F,y) returns the interpolated function values at Y 
%   based on the known points (X,F) where X (Y) is the tensor product grid
%   created from vector x (y), respectively. X and Y are calculated.
%   G = BARINT2(x,F,y) returns the interpolated function values at Y 
%   based on the known points (X,F) where X (Y) is the tensor product grid
%   created from vector x (y), respectively. X and Y are not calculated.
%
%   Example: Evaluate the following function on a tensor product grid 
%            composed by some random x values on [0,1].
%            Interpolate the function on [0,1].
%       Solution: x = rand(1,10);
%                 [X Y] = meshgrid(x);
%                 F = @(X,Y) sin(X).*cos(Y);
%                 newAbscissas = 0:0.01:1;
%                 [interpolated Xnew Ynew] = baryint2(x,F(X,Y),newAbscissas);
%                 % Compare the interpolated and the analytical values
%                 % (the error highly depends on the distribution of the
%                 % elements of x):
%                 norm(interpolated-F(Xnew,Ynew),Inf);
%                 mesh(Xnew,Ynew,interpolated);
%
%   See also   BARYINT, BARWEIGHT, BARINT

%   The algorithm is based on 
%      Kopriva D. A.: Implementing Spectral Methods for Partial Differential
%      Equations, Springer, 2009
%
%   Zoltán Csáti
%   2014/08/04

% Obtain the barycentric weights
w = barweight(x);
% Transpose vectors x and y if necessary
if size(y,2) == 1 % y is a column vector
    y = y.';      % y must be a row vector
end
x = x(:); % force x to be a column vector
% Perform barycentric interpolation
numelx = length(x);
A = y(ones(numelx,1),:); % equivalently, A = repmat(y,length(x),1);
A = bsxfun(@minus,A,x);
A = bsxfun(@times,1./A,w);
A = A./(repmat(sum(A),numelx,1)); 
% Now the transpose of A is the discrete Lagrange interpolating polynomial.
G = transpose(A)*F*A;
if nargout > 1
    % The function meshgrid is a computationally expensive part of the code
    [X Y] = meshgrid(y);
end
% If x and y overlap each other for some data points, the formula divides 
% by zero and the solution in NaN. It does not affect visualization since
% MATLAB ignores NaN values.
NaNoccurred = isnan(G);
if any(NaNoccurred)
    warning('MATLAB:baryint2:divisionByZero', ...
      'There are %d overlapping data points.', sum(sum(NaNoccurred)));
end