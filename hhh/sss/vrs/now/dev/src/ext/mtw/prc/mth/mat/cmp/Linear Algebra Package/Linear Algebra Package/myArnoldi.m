function [H varargout] = myArnoldi(mat,varargin)
%--------------------------------------------------------------------------
% Syntax:       H = myArnoldi(mat);
%               H = myArnoldi(mat,k);
%               [H Q] = myArnoldi(mat);
%               [H Q] = myArnoldi(mat,k);
%
% Inputs:       mat is an arbitrary N x N square matrix
%
%               k is the number of Arnoldi iterations to apply. The default
%               value is N.
%
% Outputs:      H is a k x k upper Hessenberg matrix that is similar
%               (in the linear algebra sense) to mat. In particular, this
%               means that, when k < N, the eigenvalues of H closely
%               approximate a subset of mat eigenvalues, and, when k = N,
%               the eigenvalues of H and mat are equal.
%
%               Q is the N x k similarity transformation such that
%               mat * Q = Q * H.
%
%               NOTE: When k == n, we have the complete similarity
%               transformation mat = Q * H * Q'. When k < n, we have only
%               mat ~ Q * H * Q'.
%
% Description:  This function uses the Arnoldi algorithm to compute an
%               upper Hessenberg matrix H that is similar (in the
%               linear algebra sense) to mat with respect to similarity
%               transformation Q. That is, mat = Q * H * Q'. Note that
%               equality holds only for k = N. For k < N, mat * Q = Q * H
%               exactly, but mat ~ Q * T * Q'.
%
%               NOTE: When k = N, H has same eigenvalues as input mat. For
%               k < N, the eigenvalues of H (Ritz values) approximate the k
%               largest magnitude eigenvalues of mat.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 3, 2012
%--------------------------------------------------------------------------

% Check input matrix size
[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Parse user inputs
if (nargin == 2)
    NUM = varargin{1};
else
    NUM = n;
end

% Initialize variables
Q = zeros(n,NUM+1);
Q(:,1) = randn(n,1);
Q(:,1) = Q(:,1) / norm(Q(:,1));
H = zeros(NUM);

% Perform Arnoidi reduction to Hessenberg form
for k = 2:NUM+1
    Q(:,k) = mat * Q(:,k-1);
    for j = 1:(k-1)
        H(j,k-1) = Q(:,j)' * Q(:,k);
        Q(:,k) = Q(:,k) - H(j,k-1) * Q(:,j);
    end
    if (k ~= NUM+1)
        H(k,k-1) = norm(Q(:,k));
        Q(:,k) = Q(:,k) / H(k,k-1);
    end
end

% Return user-specified information
if (nargout == 2)
    varargout{1} = Q(:,1:NUM);
end
