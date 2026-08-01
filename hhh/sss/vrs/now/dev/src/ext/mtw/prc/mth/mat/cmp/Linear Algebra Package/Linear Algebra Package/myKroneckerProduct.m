function C = myKroneckerProduct(A,B)
%--------------------------------------------------------------------------
% Syntax:       C = myKroneckerProduct(A,B);
%
% Inputs:       A and B matrices of arbitrary size
%               
% Outputs:      C is the Kronecker product of A and B
%
% Description:  This function comptues the Kronecker product of input
%               matrices A and B
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 17, 2012
%--------------------------------------------------------------------------

[m n] = size(A);
[p q] = size(B);

C = zeros(m*p,n*q);
for i = 1:m
    for j = 1:n
        C((i-1) * p + (1:p),(j-1) * q + (1:q)) = A(i,j) * B;
    end
end
