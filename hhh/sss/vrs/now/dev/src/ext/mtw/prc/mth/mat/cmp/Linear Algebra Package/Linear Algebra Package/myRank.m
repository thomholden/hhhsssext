function r = myRank(mat)
%--------------------------------------------------------------------------
% Syntax:       r = myRank(mat);
%
% Inputs:       mat is an arbitrary matrix
%
% Outputs:      r is the rank of input mat
%              
% Description:  This function returns the rank of the input mat, defined
%               as the number of singular values of mat greater than the
%               tolerance SVD_TOL of mySVD().
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 6, 2012
%--------------------------------------------------------------------------

[~,S,~] = mySVD(mat,'compact');
r = size(S,1);
