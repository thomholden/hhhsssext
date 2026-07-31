function D = dermatrix(x,m)
%DERMATRIX   Derivative matrices for a set of interpolation points.
%   D = DERMATRIX(X,M) returns the first M derivative matrices for a given 
%   set of interpolation points given as a vector X.
%   D = DERMATRIX(X) returns the first order derivative matrix for a given 
%   set of interpolation points given as a vector X.
%
%   Example: create the first three derivative matrices for Gauss-Lobatto
%            points of order 64
%        x = LegGaussLobNodeWeight(64);
%        D = dermatrix(x,3);
%
%   See also   BARWEIGHT, LEGGAUSSLOBNODEWEIGHT, LEGPOLY

%   The algorithm is based on 
%      Kopriva D. A.: Implementing Spectral Methods for Partial Differential
%      Equations, Springer, 2009
%   For matrices of moderate size (n<100) using Legendre, Chebyshev, etc.
%   points, the summation is almost free of round-off error. However
%   for large matrices or for equidistant points the round-off error can be
%   huge. Then use the FFT formulation for differentiation or a stable 
%   summation algorithm, e.g. Jan Simon's great XSum package: 
%   http://www.mathworks.com/matlabcentral/fileexchange/26800-xsum

%   Zoltán Csáti
%   2014/06/21

x = x(:); % force x to be a column vector
n = numel(x);
w = barweight(x); % calculate the barycentric weights
% Create D in a vectorized way
X = x(:,ones(1,n));
W = w(:,ones(1,n));
D = cell(m,1);
D{1} = W'./W.*(1./(X-X'));

%% Create the first order derivative matrix
% Replace the diagonal (which is a vector of Inf or NaN) with zeros
D{1}(1:(n+1):end) = 0;
% Do the negative sum trick
D{1}(1:(n+1):end) = -sum(D{1},2);

%% Create the higher order derivative matrices using a recursion
for k = 2:m
    diagD = diag(D{k-1});
    D{k} = k./(X-X').*(W'./W.*diagD(:,ones(1,n))-D{k-1});
    D{k}(1:(n+1):end) = 0;
    D{k}(1:(n+1):end) = -sum(D{k},2);
end