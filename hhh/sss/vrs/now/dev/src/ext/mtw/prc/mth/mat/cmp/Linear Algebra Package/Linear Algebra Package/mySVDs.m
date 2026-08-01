function varargout = mySVDs(mat,varargin)
%--------------------------------------------------------------------------
% Syntax:         s = mySVDs(mat);
%                 s = mySVDs(mat,k);
%                 [U S V] = mySVDs(mat);
%                 [U S V] = mySVDs(mat,k);
%
% Inputs:         mat is an arbitrary M x N matrix
%
%                 k is the desired number of largest singular values and
%                 corresponding singluar vectors. The default value is 1.
%
% Outputs:        s is a k x 1 vector containing the k largest singular
%                 values of input mat.
%
%                 U is an M x k matrix containing the k left singular
%                 vectors corresponding to the k largest singular values of
%                 mat.
%
%                 S is a k x k diagonal matrix containing the k largest
%                 singular values of mat.
%
%                 V is an N x k matrix containing the k right singular
%                 vectors corresponding to the k largest singular values of
%                 mat.
%
%                 Note: When k = min(M,N), the output of mySVDs() is
%                 identical to mySVD().
%              
% Description:    This function computes the k largest singular values and 
%                 vectors of the input matrix mat.
%
% Interpretation: U * S * V' is the best k-dimensional approximation of
%                 input mat.
%
% Author:         Brian Moore
%                 brimoor@umich.edu
%
% Date:           September 3, 2012
%--------------------------------------------------------------------------

% Parse inputs
if (nargin ~= 2)
    k = 1;
else
    k = varargin{1};
end

% Check input dimensions
[m,n] = size(mat);
if (k > min(m,n))
    error('Must have k <= min(size(mat))');
end

% Comput eigendecomposition of B
B = [zeros(m) mat;mat' zeros(n)];
[W,D] = myEIGs(B,k);
d = diag(D);
[d,ind] = sort(d,'descend');
s = d(1:k);

% Extract SVD information and return user-requested portions as specified
if (nargout < 3)
    varargout{1} = s;
else
    S = diag(s);
    W = W(:,ind(1:k));
    U = W(1:m,:);
    V = W((end-n+1):end,:);
    for i = 1:k
        U(:,i) = U(:,i) / norm(U(:,i));
        V(:,i) = V(:,i) / norm(V(:,i));
    end
    varargout{1} = U;
    varargout{2} = S;
    varargout{3} = V;
end
