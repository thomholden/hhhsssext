function B = myNullspaceONB(mat)
%--------------------------------------------------------------------------
% Syntax:       B = myNullspaceONB(mat);
%
% Inputs:       mat is an arbitrary M x N matrix
%
% Outputs:      B is an N x (N - R) matrix whose columns constitute an
%               orthonormal basis (ONB) for the nullspace of input mat.
%               Here R is the rank of input mat.
%
% Description:  This function returns an ONB for the nullspace of input
%               mat.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 11, 2012
%--------------------------------------------------------------------------

% Compute singular values and right singular vectors via myEIG()
% Note: (mat' * mat) is always symmetric or Hermitian
[V D] = myEIG((mat' * mat));

% Sort singular values and vectors in descending order
[~,inds] = sort(diag(D),'descend');
V = V(:,inds);

% Compute rank(mat)
% Note: Use myRank(), and therefore mySVD(), to estimate rank because the
% computation is more stable than eigenvalues of (mat' * mat) from myEIG()
r = myRank(mat);

% Return ONB of null(mat)
B = V(:,(r+1):end);
