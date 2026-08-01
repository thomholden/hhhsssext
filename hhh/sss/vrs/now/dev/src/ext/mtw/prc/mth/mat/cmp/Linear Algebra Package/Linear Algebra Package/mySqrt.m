function R = mySqrt(A)
%--------------------------------------------------------------------------
% Syntax:       R = mySqrt(A);
%
% Inputs:       A is an arbitrary square matrix
%
% Outputs:      R is the matrix square root of A (i.e., A = R * R)
%
%               NOTE: If A is not symmetric and positive semidefinite
%               (i.e., it has negative or complex eigenvalues) then R will
%               be complex-valued
%
% Description:  This function efficiently computes the matrix square root
%               of the square input matrix A.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         November 29, 2012
%--------------------------------------------------------------------------

% Symmetric tolerance
symTol = 1e-8;

% Check input matrix size
[m n] = size(A);
if (m ~= n)
    error('Error - Input matrix must be square');
end

% Perform eigendecomposition
[V D] = myEIG(A);

% Check for symmetry
if ((max(max(abs(A - A'))) > symTol) || ~isreal(A))
    % Non-symmetric case
    if isreal(V)
        % V is real-valued, so use myInv() to invert
        R = V * diag(sqrt(diag(D))) * myInv(V);
    else
        % V is complex-valued, so use backslash opertor to invert
        R = V * diag(sqrt(diag(D))) / V;
    end
else
    % Symmetric case
    R = V * diag(sqrt(diag(D))) * V';
end
