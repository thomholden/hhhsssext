function [H varargout] = myHessHouseholder(mat)
%--------------------------------------------------------------------------
% Syntax:       H = myHessHouseholder(mat);
%               [H Q] = myHessHouseholder(mat);
%
% Inputs:       mat is an arbitrary N x N matrix
%
% Outputs:      H is an upper Hessenberg matrix that is similar (in the
%               linear algebra sense) to mat. In particular, this means
%               that H has the same eigenvalues as input mat.
%
%               Q is the similarity transformation such that
%               mat = Q * H * Q';
%
% Description:  This function uses the Householder reduction algorithm to 
%               compute an upper Hessenberg matrix H that is similar
%               (in the linear algebra sense) to mat with respect to
%               similarity transformation Q. That is, mat = Q * H * Q'.
%
%               NOTE: In particular, H has same eigenvalues as input mat.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 3, 2012
%--------------------------------------------------------------------------

% Check input matrix size
[m,n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Initialize variables
H = mat;
V = cell(1,n-2);

% Perform Householder transformation to upper Hessenberg form
for k = 1:(n-2)
    v = H((k+1):n,k);
    sgn = sign(v(1));
    if (sgn == 0)
        sgn = 1;
    end
    v(1) = v(1) + sgn * norm(v);
    v = v / norm(v);
    H((k+1):n,k:n) = H((k+1):n,k:n) - 2 * v * (v' * H((k+1):n,k:n));
    H(:,(k+1):n) = H(:,(k+1):n) - (2 * (H(:,(k+1):n) * v)) * v';
    V{k} = v;
end

% Return user-requested information
if (nargout == 2)
    % Construct Q
    % NOTE: Could exploit sparsity to speed up these multiplications
    Q = eye(n);
    for j = (n-2):-1:1
        Q((j+1):n,:) = Q((j+1):n,:) - (2 * V{j}) * (V{j}' * Q((j+1):n,:));
    end
    varargout{1} = Q;
end
