function det = myDet(mat)
%--------------------------------------------------------------------------
% Syntax:       det = myDet(mat);
%
% Inputs:       mat is a square matrix
%               
% Outputs:      det is the determinant of input mat
%
% Description:  This function computes the determinant of the input mat
%               from its LU decomposition.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         June 28, 2012
%--------------------------------------------------------------------------

if (size(mat,1) ~= size(mat,2))
    error('Input matrix must be square');
end
[~,U,~,detSign] = myLU(mat);
det = prod(diag(U)) * detSign;
