function varargout = myQR(mat)
%--------------------------------------------------------------------------
% Syntax:       R = myQR(mat);
%               [Q R] = myQR(mat);
%
% Inputs:       mat is a square matrix
%               
% Outputs:      Q is an orthogonal matrix
%
%               R is an upper triangular matrix
%
%               Note: mat = Q * R;
%
% Description:  This function computes the QR decomposition of the input
%               matrix, which decomposes the input matrix into the product
%               of an orthogonal matrix Q and upper triangular matrix R.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         June 28, 2012
%--------------------------------------------------------------------------

% Check input matrix size
[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Initialize variables
R = mat;
c = zeros(n,1);
d = zeros(n,1);

% Perform Householder QR decomposition
for k = 1:(n-1)
    scale = 0.0;
    for i = k:n
        scale = max(scale, abs(R(i,k)));
    end
    if (scale == 0.0)
        c(k) = 0.0;
        d(k) = 0.0;
    else
        for i = k:n
            R(i,k) = R(i,k) / scale;
        end
        sum = 0.0;
        for i = k:n
            sum = sum + R(i,k) * R(i,k);
        end
        sigma = sqrt(sum) * sign(R(k,k));
        R(k,k) = R(k,k) + sigma;
        c(k) = sigma * R(k,k);
        d(k) = -1.0 * scale * sigma;
        for j = (k+1):n
            sum = 0.0;
            for i = k:n
                sum = sum + R(i,k) * R(i,j);
            end
            tau = sum / c(k);
            for i = k:n
                R(i,j) = R(i,j) - tau * R(i,k);
            end
        end
    end
end
d(n) = R(n,n);

% Output user-requested data
if (nargout == 2)
    % Construct Q and erase temporary data in R
    % NOTE: Could exploit sparsity to speed up these multiplications
    Q = eye(n);
    for j = (n-1):-1:1
        Q(j:n,:) = Q(j:n,:) - ((1.0 / c(j)) * R(j:n,j)) * (R(j:n,j)' * Q(j:n,:));
        R((j+1):n,j) = 0;
        R(j,j) = d(j);
    end
    varargout{1} = Q;
    varargout{2} = R;
else
    % Erase temporary data in R
    for j = (n-1):-1:1
        R((j+1):n,j) = 0;
        R(j,j) = d(j);
    end
    varargout{1} = R;
end
