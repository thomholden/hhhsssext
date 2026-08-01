function varargout = myQL(mat)
%--------------------------------------------------------------------------
% Syntax:       L = myQL(mat);
%               [Q L] = myQL(mat);
%
% Inputs:       mat is a square matrix
%               
% Outputs:      Q is an orthogonal matrix
%
%               L is a lower triangular matrix
%
%               Note: mat = Q * L;
%
% Description:  This function computes the QL decomposition of the input
%               matrix, which decomposes the input matrix into the product
%               of an orthogonal matrix Q and lower triangular matrix L.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         November 20, 2012
%--------------------------------------------------------------------------

% Compute QR and manipulate to get QL
[Q R] = myQR(fliplr(mat));
Q = fliplr(Q);
L = rot90(R,2);

% Output user-requested data
if (nargout == 2)
    varargout{1} = Q;
    varargout{2} = L;
else
    varargout{1} = L;
end
