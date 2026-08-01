function R = mySPDSqrt(S)
%--------------------------------------------------------------------------
% Syntax:       R = mySPDSqrt(S);
%
% Inputs:       S is a square, symmetric, and positive semidefinite matrix
%
% Outputs:      R is the matrix square root of S (i.e., S = R * R)
%              
% Description:  This function efficiently computes the matrix square root
%               of the square, symmetric, and positive definite input S.
%               An error is returned if S is not square, symmetric, or 
%               positive semidefinite.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         November 29, 2012
%--------------------------------------------------------------------------

% Positive definiteness tolerance
spd_tol = 1e-6;

% Parse user inputs
[m n] = size(S);
if (m ~= n)
    error('Error - Input matrix must be square');
end

% Compute matrix square root via SVD
[U S V] = mySVD(S);
if (max(max(abs(U - V))) > spd_tol)
    error('Error - Input matrix must be symmetric and positive (semi)definite');
end
R = U * diag(sqrt(diag(S))) * U';
