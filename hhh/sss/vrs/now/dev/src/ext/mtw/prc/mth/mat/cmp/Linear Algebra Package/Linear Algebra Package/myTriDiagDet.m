function det = myTriDiagDet(mat)
%--------------------------------------------------------------------------
% Syntax:       det = myTriDiagDet(mat);
%
% Inputs:       mat is an N x N tridiagonal matrix
%               
% Outputs:      det is the determinant of input mat
%
% Description:  This function computes the determinant of the tridiagonal
%               input mat efficiently using the recursive relation for
%               det(mat(1:k,1:k)) as k = 1:N.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 7, 2012
%--------------------------------------------------------------------------

% Check input size
[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Recursively compute det(mat)
detR = zeros(n+1,1);
detR(1) = 1;
detR(2) = mat(1,1);
for i = 3:(n+1)
    detR(i) = mat(i-1,i-1) * detR(i-1) - mat(i-1,i-2) * mat(i-2,i-1) * detR(i - 2);
end
det = detR(n+1);
