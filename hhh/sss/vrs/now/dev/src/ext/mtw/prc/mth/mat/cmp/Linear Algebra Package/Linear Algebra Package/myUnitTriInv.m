function inv = myUnitTriInv(mat,mode)
%--------------------------------------------------------------------------
% Syntax:       inv = myUnitTriInv(mat,'lower');
%               inv = myUnitTriInv(mat,'upper');
%
% Inputs:       mat is a square input matrix that is unit upper triangular
%               when mode == 'upper' and unit lower triangular when
%               mode == 'lower'.
%
% Outputs:      inv is the matrix inverse of input mat
%              
% Description:  This function returns the matrix inverse of the square unit
%               upper triangular input mat.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 12, 2012
%--------------------------------------------------------------------------

inv = myUnitTriSysSol(mat,eye(size(mat,2)),mode);
