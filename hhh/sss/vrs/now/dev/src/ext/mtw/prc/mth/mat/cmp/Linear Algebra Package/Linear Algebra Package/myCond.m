function cond = myCond(mat)
%--------------------------------------------------------------------------
% Syntax:       cond = myCond(mat);
%
% Inputs:       mat is an arbitrary matrix
%
% Outputs:      cond is the condition number of input mat, defined as the
%               ratio of the largest singular value to the smallest
%               singular value.
%              
% Description:  This function returns the condition number of the input
%               mat. A large condition number indicates that the input mat
%               is nearly singular.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         July 6, 2012
%--------------------------------------------------------------------------

s = mySVD(mat,'full');
if (any(s == 0))
    cond = inf;
else
    cond = max(s)/min(s);
end
