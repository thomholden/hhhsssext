function B = myRangeONB(mat,varargin)
%--------------------------------------------------------------------------
% Syntax:       B = myRangeONB(mat);
%               B = myRangeONB(mat,'SVD');
%               B = myRangeONB(mat,'QR');
%
% Inputs:       mat is an arbitrary M x N matrix
%
%               mode can be {'SVD','QR'} and controls the technique used to
%               compute B. The default is 'SVD'.
%
% Outputs:      B is an M x R matrix whose columns constitute an
%               orthonormal basis (ONB) for the range of input mat. Here R
%               is the rank of input mat.
%              
% Description:  This function returns an ONB for the range of input mat
%               using the SVD (or QR, if desired) decomposition.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 11, 2012
%--------------------------------------------------------------------------

% Parse inputs
if (nargin == 2)
    mode = varargin{1};
else
    mode = 'SVD';
end

% Compute range ONB
if strcmpi(mode,'QR')
    % Perform QR decomposition
    [m n] = size(mat);
    if (m == n)
        % myQR() can only handle square matrices (for now)
        [Q R] = myQR(mat);
    else
        [Q R] = qr(mat);
    end
    
    % Compute rank
    tol = eps * sqrt(sum(sum(abs(mat).^2)));
    r = sum(abs(diag(R)) > tol);
    
    % Return ONB
    B = Q(:,1:r);
else
    % Compute ONB via SVD
    [B,~,~] = mySVD(mat,'compact');
end
