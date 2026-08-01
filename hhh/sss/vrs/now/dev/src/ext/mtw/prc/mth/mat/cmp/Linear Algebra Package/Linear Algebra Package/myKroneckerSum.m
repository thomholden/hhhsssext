function C = myKroneckerSum(A,B)
%--------------------------------------------------------------------------
% Syntax:       C = myKroneckerSum(A,B);
%
% Inputs:       A and B are square matrices of arbitrary size
%               
% Outputs:      C is the Kronecker sum of A and B
%
% Description:  This function comptues the Kronecker sum of inputs A and B
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 17, 2012
%--------------------------------------------------------------------------

[m p] = size(A);
[n q] = size(B);
if ((m ~= p) || (n ~= q))
    error('Input matrices must be square');
end

C = myKroneckerProduct(eye(n),A) + myKroneckerProduct(B,eye(m));
