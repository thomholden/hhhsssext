function varargout = myCholesky(mat,varargin)
%--------------------------------------------------------------------------
% Syntax:       L = myCholesky(mat);
%               L = myCholesky(mat,'lower');
%               U = myCholesky(mat,'upper');
%               [U D] = myCholesky(mat, 'UD');
%               [L D] = myCholesky(mat, 'LD');
%
% Inputs:       mat is a symmetric, positive definite square matrix
%               
%               Note: myCholesky() forces mat symmetric by only accesing
%               its upper triangle and assuming mat(i,j) = mat(j,i)
%               
%               mode can be {'upper','lower','UD','LD'}.
%               The default is 'lower'
%
% Outputs:      When mode == 'lower', L is a lower triangular matrix s.t.
%               mat = L * L';
%
%               When mode == 'upper', U is an upper triangular matrix s.t.
%               mat = U' * U;
%
%               When mode == 'UD', U is a unit upper triangular matrix,
%               and D is a diagonal matrix s.t.
%               mat = U * D * U';
%
%               When mode == 'LD', L is a unit lower triangular matrix,
%               and D is a diagonal matrix s.t.
%               mat = L' * D * L;
%
% Description:  This function computes the Cholesky or Unit Cholesky
%               Decomposition of the input square, positive definite, and
%               (assumed) symmetric matrix. If mat is not positive
%               definite, an error message is displayed.
%
%               Note: This script can easily be modified to test if a
%               symmetric matrix is positive definite.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         June 28, 2012
%--------------------------------------------------------------------------

CHOL_TOL = 1e-15;
UD_TOL = 1e-15;

[n m] = size(mat);

if (n ~= m)
    error('Input matrix must be square');
end

if nargin > 1
    mode = varargin{1};
else
    mode = 'lower';
end

if (strcmpi(mode,'UD') || strcmpi(mode,'LD')) 
    U = zeros(n);
    D = zeros(n);
    
    for j = n:-1:1
        for i = j:-1:1
            sum = mat(i,j);
            for k = (j+1):n
                sum = sum - U(i,k) * D(k,k) * U(j,k);
            end
            if (i == j)
                if (sum <= UD_TOL)
                    error('Input matrix is not positive definite');
                else
                    D(j,j) = sum;
                    U(j,j) = 1;
                end
            else
                U(i,j) = sum / D(j,j);
            end
        end
    end
    
    if strcmpi(mode,'LD')
        varargout{1} = U';
        varargout{2} = D;
    else
        varargout{1} = U;
        varargout{2} = D;
    end
else
    L = mat;
    d = zeros(n,1);
    
    for i = 1:n
        for j = i:n
            sum = L(i,j);
            for k = (i-1):-1:1
                sum = sum - L(i,k)*L(j,k);
            end
            if (i == j)
                if (sum <= CHOL_TOL)
                    error('Input matrix is not positive definite');
                end
                d(i) = sqrt(sum);
            else
                L(j,i) = sum / d(i);
            end
        end
    end

    for i = 1:n
        for j = 1:(i-1)
            L(j,i) = 0;
        end
        L(i,i) = d(i);
    end

    if strcmpi(mode,'upper')
        varargout{1} = L';
    else
        varargout{1} = L;
    end
end
