function varargout = myTriDiagHouseholder(mat,varargin)
%--------------------------------------------------------------------------
% Syntax:       T = myTriDiagHouseholder(mat);
%               T = myTriDiagHouseholder(mat,'false');
%               [d od] = myTriDiagHouseholder(mat);
%               [d od] = myTriDiagHouseholder(mat,'false');
%               [T Q] = myTriDiagHouseholder(mat,'true');
%               [d od Q] = myTriDiagHouseholder(mat,'true');
%
% Inputs:       mat is a symmetric N x N matrix
%
%               OutputQ can be {'true','false'}. When OutputQ is 'true',
%               the similarity transformation Q is returned. When OutputQ
%               is 'false', the similarity transformation Q is not
%               returned. The default value is 'false'.
%
% Outputs:      T is a symmetric tridiagonal matrix that is similar (in the
%               linear algebra sense) to mat. In particular, this means
%               that T has the same eigenvalues as input mat.
%
%               d contains the N diagonal elements of T
%
%               od contains the N-1 sub/super-diagonal elements of T
%               
%               Q is the similarity transformation such that
%               mat = Q * T * Q';
%
% Description:  This function uses the Householder reduction algorithm to 
%               compute a symmetric tridiagonal matrix T that is similar 
%               (in the linear algebra sense) to mat with respect to
%               similarity transformation Q. That is, mat = Q * T * Q'.
%
%               NOTE: In particular, T has same eigenvalues as input mat.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 3, 2012
%--------------------------------------------------------------------------

symTol = 1e-8;

% Check input matrix size
[m,n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Make sure input is real
if ~isreal(mat)
    error('Input matrix must be real valued');
end

% Make sure input matrix is symmetric
if (max(max(abs(mat - mat'))) > symTol)
    error('Input matrix is not symmetric to working precision');
end

% Parse inputs
if (nargin == 2)
    if strcmpi(varargin{1},'true')
        OutputQ = 1;
    else
        OutputQ = 0;
    end
else
    OutputQ = 0;
end

% Initialize variables
d = zeros(n,1); % main diagonal of T
od = zeros(n,1); % super/sub-diagonal of T (trimmed to length n-1 later)
Q = mat;

% Perform Householder reduction to tridiagonal form
for i = n:-1:2
    l = i - 1;
    h = 0.0;
    scale = 0.0;
    if (l > 1)
        for k = 1:l
            scale = scale + abs(Q(i,k));
        end
        if (scale == 0.0)
            od(i) = Q(i,l);
        else
            for k = 1:l
                Q(i,k) = Q(i,k) / scale;
                h = h + Q(i,k) * Q(i,k);
            end
            f = Q(i,l);
            if (f >= 0.0)
                g = -sqrt(h);
            else
                g = sqrt(h);
            end
            od(i) = scale * g;
            h = h - f * g;
            Q(i,l) = f - g;
            f = 0.0;
            for j = 1:l
                if (OutputQ == 1)
                    Q(j,i) = Q(i,j) / h;
                end
                g = 0.0;
                for k = 1:j
                    g = g + Q(j,k) * Q(i,k);
                end
                for k = (j+1):l
                    g = g + Q(k,j) * Q(i,k);
                end
                od(j) = g / h;
                f = f + od(j) * Q(i,j);
            end
            hh = f / (h + h);
            for j = 1:l
                f = Q(i,j);
                g = od(j) - hh * f;
                od(j) = g;
                for k = 1:j
                    Q(j,k) = Q(j,k) - (f * od(k) + g * Q(i,k));
                end
            end
        end
    else
        od(i) = Q(i,l);
    end
    d(i) = h;
end
d(1) = 0.0;
od = od(2:end);
if (OutputQ == 1)
    for i = 1:n
        l = i - 1;
        if (d(i) ~= 0)
            for j = 1:l
                g = 0.0;
                for k = 1:l
                    g = g + Q(i,k) * Q(k,j);
                end
                for k = 1:l
                    Q(k,j) = Q(k,j) - g * Q(k,i);
                end
            end
        end
        d(i) = Q(i,i);
        Q(i,i) = 1.0;
        for j = 1:l
            Q(j,i) = 0.0;
            Q(i,j) = 0.0;
        end
    end
else
    for i = 1:n
        d(i) = Q(i,i);
    end
end

% Return user-requested information
if (nargout == 2)
    if (OutputQ == 1)
        varargout{1} = diag(d) + diag(od,-1) + diag(od,1);
        varargout{2} = Q;
    else
        varargout{1} = d;
        varargout{2} = od;
    end
elseif (nargout == 3)
    varargout{1} = d;
    varargout{2} = od;
    varargout{3} = Q;
else
    varargout{1} = diag(d) + diag(od,-1) + diag(od,1);
end
