function inv = myTriInv(mat,mode)
%--------------------------------------------------------------------------
% Syntax:       inv = myTriInv(mat,'lower');
%               inv = myTriInv(mat,'upper');
%
% Inputs:       mat is a square input matrix that is upper triangular when
%               mode == 'upper' and lower triangular when mode == 'lower'.
%
% Outputs:      inv is the matrix inverse of input mat
%              
% Description:  This function returns the matrix inverse of the square
%               upper triangular input mat.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 12, 2012
%--------------------------------------------------------------------------

inv = myTriSysSol(mat,eye(size(mat,2)),mode);
