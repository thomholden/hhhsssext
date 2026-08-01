function inv = mySPDInv(mat)
%--------------------------------------------------------------------------
% Syntax:       inv = mySPDInv(mat);
%
% Inputs:       mat is a square, symmetric, and positive definite matrix.
%
% Outputs:      inv is the matrix inverse of the input mat.
%              
% Description:  This function efficiently computes the matrix inverse of
%               the square, symmetric, and positive definite input matrix
%               mat. An error is returned if mat does not meet these
%               qualifications.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 12, 2012
%--------------------------------------------------------------------------

[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

%{
%
%       This is the procedure, but its better to avoid full matrix
%       multiplication when matrices are sparse in line 3
%
[U D] = myUD(mat);
Uinv = myUnitTriInv(U,'upper');
inv = Uinv' * diag(1./diag(D)) * Uinv;
%
%
%
%}

% Sparsity-aware (in-place) algorithm
[inv D] = myUD(mat);
inv = myUnitTriInv(inv,'upper');
for i = 1:n
    inv(i,i) = 1/D(i,i);
end

for i = n:-1:1
    for j = 1:(i-1)
        inv(i,j) = inv(j,i) * inv(j,j);
    end
    for j = n:-1:i
        if (i < j)
            inv(i,j) = inv(i,j) * inv(i,i);
        end
        for k = 1:(i-1)
            inv(i,j) = inv(i,j) + inv(k,j) * inv(i,k);
        end
        inv(j,i) = inv(i,j);
    end
end
