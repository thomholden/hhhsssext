function varargout = myLanczosR(mat,varargin)
%--------------------------------------------------------------------------
% Syntax:       M = myLanczosR(mat);
%               M = myLanczosR(mat,k);
%               M = myLanczosR(mat,km,kn);
%               [U M V] = myLanczosR(mat);
%               [U M V] = myLanczosR(mat,k);
%               [U M V] = myLanczosR(mat,km,kn);
%
% Inputs:       mat is an arbitrary m x n matrix
%
%               km is the number of LEFT-hand Lanczos iterations to
%               perform
%
%               kn is the number of RIGHT-hand Lanczos iterations to
%               perform
%
%               k is the number of Lanczos iterations to perform. The
%               default value is min(m,n)
%
%               NOTE: When k is specified, myLanczosR() internally sets
%               km = m - min(m,n) + k
%               kn = n - min(m,n) + k
%
% Outputs:      M is a km x kn dense matrix. When km < m or kn < n, the 
%               min(km,kn) singular values of M approximate min(km,kn)
%               singular values of input mat. When km = m and kn = n, the
%               singular values of M are identical to the singular values
%               of M.
%
%               U is an m x km matrix such that U' * U = eye(km). In
%               particular, when km = m, U is orthogonal (or unitary when
%               mat is complex-valued.)
%
%               V is an n x kn matrix such that V' * V = eye(kn). In
%               particular, when kn = n, V is orthogonal (or unitary when
%               mat is complex-valued.)
%               
% Description:  This function uses the Lanczos algorithm with full
%               reorthogonalization to compute a km x kn matrix M whose
%               min(km,kn) singular values approximate min(km,kn) singular
%               values of input mat. This function optionally returns
%               matrices U and V such that U * M * V' is a low-dimensional
%               reconstruction of mat. In partictular, when km = m and
%               kn = n, we have mat = U * M * V', and the singular
%               values of M and mat are equal.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 12, 2012
%--------------------------------------------------------------------------

% Get input matrix size
[m n] = size(mat);

% Parse user inputs
if (nargin == 2)
    k = varargin{1};
    minmn = min(m,n);
    km = m - minmn + k;
    kn = n - minmn + k;
elseif (nargin == 3)
    km = varargin{1};
    kn = varargin{2};
else
    km = m;
    kn = n;
end

% Compute left-hand Lanczos unitary transformation
[~,U] = myLanczos((mat*mat'),km,'true');

% Compute right-hand Lanczos unitary transformation
[~,V] = myLanczos((mat'*mat),kn,'true');

%
% Compute low-dimensional Lanczos approximation of mat
%
% NOTE:
%
% In general, M is the solution to the system of equations
%
% { T1 = M  * M'
% { T2 = M' * M 
%
% where
%
% T1 = myLanczos(( mat  * mat' ),km,'true');
% T2 = myLanczos(( mat' * mat  ),kn,'true');
%
M = U' * mat * V;

if (nargout == 3)
    varargout{1} = U;
    varargout{2} = M;
    varargout{3} = V;
else
    varargout{1} = M;
end
