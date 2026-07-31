function weight = barweight(x)
%BARWEIGHT   Barycentric weights.
%   WEIGHT = BARWEIGHT(X) returns the barycentric weights for an arbitrary
%   set of points X.
%
%   See also   DERMATRIX

%   The algorithm is based on the article
%      Berrut, J.-P. and Trefethen, L. N.: Barycentric Lagrange Interpolation,
%      SIAM Rev., vol. 46, no. 3, pp. 501-517, 2004
%
%   Zoltán Csáti
%   2014/05/29

n = numel(x);
x = x(:); % force x to be a column vector
X = x(:,ones(1,n)); % same as X = repmat(xj,1,n), but faster
sub = X-X.';
sub(logical(eye(n))) = 1; % change the diagonal entries from 0 to 1
weight = prod(sub,2); % take the product along the rows
weight = 1./weight;