function varargout = myEIGs(mat,varargin)
%--------------------------------------------------------------------------
% Syntax:       e = myEIGs(mat);
%               [v e] = myEIGs(mat);
%               d = myEIGs(mat,k);
%               [V D] = myEIGs(mat,k);
%
% Inputs:       mat is an arbitrary square matrix
%
%               k is the number of largest eigenvalues/eigenvectors to
%               compute. The default value is 1.
%
% Outputs:      e is the largest eigenvalue of input mat
%
%               v is the eigenvector corresponding to the largest
%               eigenvalue of input mat
%
%               d is a vector containing the k largest eigenvalues of mat
%
%               D is a diagonal matrix whose (diagonal) elements are the
%               largest k eigenvalues of mat
%
%               V is a matrix whose ith column is the eigenvector
%               corresponding to the ith eigenvalue in D
%               
% Description:  This function efficiently computes a few of the largest
%               (algebraic) eigenvalues and corresponding eigenvectors of
%               input mat.
%
%               NOTE: For symmetric matrices, this function uses the
%               Lanczos tridiagonalization algorithm and then applies the
%               implicit QL algorithm to find the eigenvalues/eigenvectors
%               of the resulting similar tridiagonal matrix.
%
%               NOTE: For asymmetric matrices, this function just calls
%               MATLAB's eigs(). Asymmetric matrix eigenvalues are tedious!
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 3, 2012
%--------------------------------------------------------------------------

symTol = 1e-8;

% Check matrix size
[m n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Parse inputs
if (nargin == 2)
    k = varargin{1};
else
    k = 1;
end

% Set eigenvector flag
if (nargout == 2)
    ComputeEigVecs = 'true';
else
    ComputeEigVecs = 'false';
end

if ((max(max(abs(mat - mat'))) > symTol) || ~isreal(mat))
    % Computing the eigenvalues/eigenvectors of asymmetric matrices is
    % highly unstable, so we'll just use MATLAB (actually LAPACK) to
    % perform these computations
    if strcmpi(ComputeEigVecs,'true')
        % Compute k largest (algebraic) eigenvalues/eigenvectors
        [V D] = eigs(mat,k,'LA');
        
        % Make sure eigenvalues are sorted in descending order
        d = diag(D);
        [d ind] = sort(d,'descend');
        D = diag(d);
        V = V(:,ind);
    else
        % Balance mat to increase numerical stability
        mat = myEIGBalance(mat);
        
        % Compute k largest (algebraic) eigenvalues
        d = eigs(mat,k,'LA');
        
        % Make sure eigenvalues are sorted in descending order
        d = sort(d,'descend');
    end
else
    % Compute tridiagonal matrix T and (optional) similarity transformation
    % Q such that mat = Q * T * Q'.
    %
    % NOTE: Diagonal and sub/super-diagonal elements of T are stored in
    % vectors d and od, respectively.
    %
    % NOTE: Here T = diag(d) + diag(od,-1) + diag(od,1);
    %
    if strcmpi(ComputeEigVecs,'true')
        % Algorithm: Householder Reduction to tridiagonal form
        [d od Q] = myTriDiagHouseholder(mat,'true');
    else
        % First balance mat to increase numerical stability
        mat = myEIGBalance(mat);
        
        % Algorithm: Householder Reduction to tridiagonal form
        [d od] = myTriDiagHouseholder(mat);
    end

    % Compute eigenvalues/eigenvectors of original input matrix efficiently
    % through its tridiagonal form mat = Q * T * Q'.
    %
    % NOTE: Here T = diag(d) + diag(od,-1) + diag(od,1);
    %
    if strcmpi(ComputeEigVecs,'true')
        % Algorithm: Implicitly-shifted tridiagonal QR method
        [V D] = myImplicitTriQR(d,od,Q,k);
    else
        % Algorithm: Bisection
        d = myTriBisection(d,od,n-k+1,n);
    end
end

%
% Output user-requested information
%
if (nargout == 2)
    varargout{1} = V;
    varargout{2} = D;
else
    varargout{1} = d;
end
