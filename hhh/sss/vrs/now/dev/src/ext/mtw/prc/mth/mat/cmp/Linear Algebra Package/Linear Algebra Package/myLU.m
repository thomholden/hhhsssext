function [L U varargout] = myLU(mat)
%--------------------------------------------------------------------------
% Syntax:       [L U] = myLU(mat);
%               [L U P] = myLU(mat);
%               [L U P detSign] = myLU(mat);
%
% Inputs:       mat is a square nonsingular matrix
%               
% Outputs:      [L U] = myLU(mat);
%               L is a permuted lower triangular matrix and U is an upper
%               triangular matrix such that L * U = mat
%
%               [L U P] = myLU(mat);
%               L is a lower triangular matrix, U is an upper triangular
%               matrix, and P is a permutation matrix such that
%               L * U = P * mat. Note: P is unitary, so P' * L * U = mat;
%
%               [L U P detSign] = myLU(mat);
%               L is a lower triangular matrix, U is an upper triangular
%               matrix, and P is a permutation matrix such that
%               L * U = P * mat. Note: P is unitary, so P' * L * U = mat;
%               detSign = 1 when P permutes an even number of times, and
%               detSign = -1 when P permutes an odd number of times. This
%               syntax is useful for computing the determinant of mat.
%               Namely: det(mat) = prod(diag(U)) * detSign;
%
% Description:  This function computes the LU decomposition of the square
%               input mat, which decomposes the input mat into the product
%               of a (permuted) lower triangular matrix and an upper
%               triangular matrix.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         June 28, 2012
%--------------------------------------------------------------------------

tinyNum = eps;
[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end
L = eye(n);
U = mat;
perm = 1:n;
P = zeros(n);
scaleVect = zeros(n,1);
detSign = 1;

for i = 1:n
    big = 0;
    for j = 1:n
        temp = abs(U(i,j));
        if (temp > big)
            big = temp;
        end
    end
    if (big ~= 0.0)
        scaleVect(i) = 1.0 / big;
    end
end
for j = 1:n
    for i = 1:(j-1)
        sum = U(i,j);
        for k = 1:(i-1)
            sum = sum - U(i,k) * U(k,j);
        end
        U(i,j) = sum;
    end
    big = 0.0;
    for i = j:n
        sum = U(i,j);
        for k = 1:(j-1)
            sum = sum - U(i,k) * U(k,j);
        end
        U(i,j) = sum;
        dummy = scaleVect(i) * abs(sum);
        if (dummy >= big)
            big = dummy;
            pivotIndex = i;
        end
    end
    if (j ~= pivotIndex)
        for k=1:n
            dummy = U(pivotIndex,k);
            U(pivotIndex,k) = U(j,k);
            U(j,k) = dummy;
        end
        detSign = detSign * -1;
        scaleVect(pivotIndex) = scaleVect(j);
    end
    dummy = perm(pivotIndex);
    perm(pivotIndex) = perm(j);
    perm(j) = dummy;
    if (U(j,j) == 0)
        U(j,j) = tinyNum;
    end
    if (j ~= n)
        dummy = 1.0 / U(j,j);
        for i = (j+1):n
            U(i,j) = U(i,j) * dummy;
        end
    end
end

for i = 1:n
    for j = 1:(i-1)
        L(i,j) = U(i,j);
        U(i,j) = 0;
    end
    P(i,perm(i)) = 1;
end

switch nargout
    case 2
        varargout = {};
        L = P'*L;
    case 3
        varargout{1} = P;
    case 4
        varargout{1} = P;
        varargout{2} = detSign;
end
