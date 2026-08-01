function varargout = mySVDc(A,varargin)
%--------------------------------------------------------------------------
% Syntax:       [U S V] = mySVDc(A);
%               [U S V] = mySVDc(A,'full');
%               [U S V] = mySVDc(A,'compact');
%               s = mySVDc(A);
%               s = mySVDc(A,'full');
%               s = mySVDc(A,'compact');
%
% Inputs:       A is an arbitrary M x N complex-valued matrix
%               mode can be {'full','compact'}
%
% Outputs:      When mode == 'full':
%               U is an M x M unitary matrix, S is an M x N diagonal
%               matrix of singular values, and V is an N x N unitary
%               matrix. Alternatively, s is a vector of length min(M,N) of
%               singular values.
%
%               When mode == 'compact':
%               U is an M x R matrix, S is an R x R diagonal matrix of
%               singular values, V is an N x R matrix. Alternatively, s is
%               a vector of length R of singular values. Here R = rank(A).
%
%               In either case, U, S, and V satisfy the following relation:
%               A = U * S * V';
%              
% Description:  This function computes the singular value decomposition
%               (SVD) of the complex-valued matrix A. When
%               mode == 'compact', this function returns the compact SVD
%               containing only the R pairs of vectors corresponding to the
%               R nonzero singular values of input A. Here R = rank(A).
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         November 27, 2012
%--------------------------------------------------------------------------

% Hack tolerance
hacktol = 1e-8;

% Input check
if (nargin > 1)
  mode = varargin{1};
else
  mode = 'full';
end

% Get input size
[m n] = size(A);
N = min(m,n);

% Construct hacked matrix that can be used to compute SVD of a
% complex-valued matrix using only a real SVD 
Ar = real(A);
Ai = imag(A);
A2 = [Ar Ai;-Ai Ar];

if (nargout ~= 3)
    % Compute singular values only
    if strcmpi(mode,'compact')
        % Discard zero singular values
        st = mySVD(A2,'compact');
    else
        % Keep all singular values
        st = mySVD(A2,'full');
    end
    
    % Return user requested information
    s = st(1:2:end);
    varargout{1} = s;
else
    % Compute entire SVD
    [Ut St Vt] = mySVD(A2,'full');

    % Permute columns of U into correct order
    U2 = zeros(size(Ut));
    U2(:,1:N) = Ut(:,1:2:(2*N));
    U2(:,(N+1):(2*N)) = Ut(:,2:2:(2*N));

    % Permute diagonal entries of S into correct order
    st = diag(St);
    s = st(1:2:(2*N));

    % Permute columns of V into correct order
    V2 = zeros(size(Vt));
    V2(:,1:N) = Vt(:,1:2:(2*N));
    V2(:,(N+1):(2*N)) = Vt(:,2:2:(2*N));

    % Construct complex-valued U from SVD hack
    U = zeros(m);
    U(:,1:N) = U2(1:m,1:N) - 1i * U2((m+1):(2*m),1:N);

    % Construct S from SVD hack
    S = zeros(m,n);
    for i = 1:N
        S(i,i) = s(i);
    end

    % Construct complex-valued V from SVD hack
    V = zeros(n);
    V(:,1:N) = V2(1:n,1:N) - 1i * V2((n+1):(2*n),1:N);

    % Throw an error if the complex-valued SVD hack has failed
    avg_element_error = sqrt(sum(sum(abs(U * S * V' - A).^2)) / (m * n));
    if (avg_element_error > hacktol)
        error('mySVDc() HACK FAIL - SVD of A2 was not sorted as expected');
    end
    
    % Return user requested information
    if strcmpi(mode,'compact')
        % Compute singular value tolerance
        SVD_TOL = max(m,n) * max(s) * eps(class(A));

        % Determine rank to working tolerance
        r = sum(s > SVD_TOL);
    
        % Return compact SVD
        varargout{1} = U(:,1:r);
        varargout{2} = S(1:r,1:r);
        varargout{3} = V(:,1:r);
    else
        % Return full SVD
        varargout{1} = U;
        varargout{2} = S;
        varargout{3} = V;
    end
end
