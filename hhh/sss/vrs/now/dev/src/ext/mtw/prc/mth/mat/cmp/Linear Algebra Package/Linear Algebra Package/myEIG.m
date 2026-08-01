function varargout = myEIG(mat)
%--------------------------------------------------------------------------
% Syntax:       d = myEIG(mat);
%               [V D] = myEIG(mat);
%
% Inputs:       mat is an arbitrary square matrix
%
% Outputs:      d is a vector containing the sorted (descending)
%               eigenvalues of mat
%
%               D is a diagonal matrix whose (diagonal) elements are the
%               sorted (descending) eigenvalues of mat
%
%               V is a matrix whose ith column is the eigenvector
%               corresponding to the ith eigenvalue in D
%              
% Description:  This function computes the eigenvalue decomposition of the
%               input mat.
%
%               NOTE: The eigenvalue decomposition satisfies the relation
%               mat = V * D * V^(-1);
%
%               NOTE: When mat is symmetric or Hermitian, V^(-1) = V';
%
%               NOTE: For asymmetric or complex-valued matrices, this
%               function calls myArnoldi() to obtain the Hessenberg form of
%               mat, but then just calls MATLAB's eig() to decompose the
%               Hessenberg form. Asymmetric eigenvalue decomposition is
%               tedious!
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 3, 2012
%--------------------------------------------------------------------------

% Symmetric tolerance
symTol = 1e-8;

% Check input matrix size
[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Perform eigendecomposition
if ((max(max(abs(mat - mat'))) > symTol) || ~isreal(mat))
    % Computing the eigenvalues/eigenvectors of asymmetric matrices is
    % highly unstable, so we'll just use MATLAB (i.e., LAPACK) to
    % perform these computations
    if (nargout == 2)
        % Compute Hessenberg form of mat
        % Algorithm: Arnoldi iteration
        [H Q] = myArnoldi(mat);
        
        % Efficiently compute the eigenvalues/eigenvectors of H by
        % exploiting Hessenberg form
        [V D] = eig(H);
        
        % Return user-specified information
        [d ind] = sort(diag(D),'descend');
        varargout{1} = Q * V(:,ind);
        varargout{2} = diag(d);
    else
        % Balance mat to increase numerical stability
        mat = myEIGBalance(mat);
        
        % Compute Hessenberg form of mat
        % Algorithm: Arnoldi iteration
        H = myArnoldi(mat);
        
        % Efficiently compute and return eigenvalues of H (and hence mat)
        varargout{1} = sort(eig(H),'descend');
    end
else
    % Use my code to compute eigenvalue decomposition of symmetric matrix
    if (nargout == 2)
        % Compute tridiagonal form
        % NOTE: T = diag(d) + diag(od,-1) + diag(od,1);
        % Algorithm: Householder reduction to tridiagonal form
        [d od Q] = myTriDiagHouseholder(mat,'true');
        
        % Compute eigenvalues/eigenvectors of T (and therefore mat)
        % Algorithm: Implicitly-shifted tridiagonal QR method
        [V D] = myImplicitTriQR(d,od,Q);
        
        % Return user-requested information
        varargout{1} = V;
        varargout{2} = D;
    else
        % Balance mat to increase numerical stability
        mat = myEIGBalance(mat);
        
        % Compute tridiagonal form (ignoring eigenvectors)
        % NOTE: T = diag(d) + diag(od,-1) + diag(od,1);
        % Algorithm: Householder reduction to tridiagonal form
        [d od] = myTriDiagHouseholder(mat);
        
        % Compute and return eigenvalues
        % Algorithm: Tridiagonal bisection
        varargout{1} = myTriBisection(d,od);
    end
end
