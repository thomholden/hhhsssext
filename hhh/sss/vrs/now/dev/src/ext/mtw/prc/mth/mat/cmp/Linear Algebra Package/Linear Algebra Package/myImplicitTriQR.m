function varargout = myImplicitTriQR(varargin)
%--------------------------------------------------------------------------
% Syntax:       e = myImplicitTriQR(T);
%               e = myImplicitTriQR(d,od);
%               [V D] = myImplicitTriQR(T);
%               [V D] = myImplicitTriQR(d,od);
%               [V D] = myImplicitTriQR(T,Q);
%               [V D] = myImplicitTriQR(d,od,Q);
%               e = myImplicitTriQR(T,k);
%               e = myImplicitTriQR(d,od,k);
%               [V D] = myImplicitTriQR(T,k);
%               [V D] = myImplicitTriQR(d,od,k);
%               [V D] = myImplicitTriQR(T,Q,k);
%               [V D] = myImplicitTriQR(d,od,Q,k);
%
% Inputs:       T is an N x N symmetric tridiagonal matrix
%
%               d is a vector containing the N diagonal elements of T
%
%               od is a vector containing the N-1 sub/super-diagonal
%               elements of T
%
%               Q is the similarity transformation such that, for some
%               N x N matrix, M, of interest, M = Q * T * Q'.
%
%               k is the number of largest (algebraic) eigenvalues and
%               (optionally) eigenvectors to return. The default is N.
%
% Outputs:      e is a vector containing the sorted k largest (algebraic)
%               eigenvalues of T (and therefore of M as well since T and M
%               are similar w.r.t. Q.)
%
%               V is the N x k matrix whose ith column is the eigenvector
%               of M (when Q is specified) or T (when Q is not specified)
%               corresponding to the kth eigenvalue in D.
%
%               D is the k x k diagonal matrix containing whose digaonal
%               entries are the sorted k largest (algebraic) of T (and
%               therefore of M as well since T and M are similar w.r.t. Q.)
%               
%               Thus, when Q is given:
%               M = V * D * V^(-1);
%
%               When Q is not given:
%               T = V * D * V^(-1);
%               M = (Q * V) * D * (Q * V)^(-1);
%
% Description:  This function computes the k largest eigenvalues of the
%               symmetric tridiagonal matrix T. When a similarity
%               transformation Q is specified such that, for some matrix M,
%               M = Q * T * Q', these eigenvalues are exactly equal to
%               the eigenvalues of M. Moreover, this function also computes
%               and returns (if desired) the eigenvectors of M (when Q is
%               specified) or the eigenvectors of T (when Q is not
%               specified) corresponding to the k largest eigenvalues of M
%               (equivalentely, the k largest eigenvalues of T.)
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 3, 2012
%--------------------------------------------------------------------------

eps = 1e-6;
maxIters = 30;

% Process input arguments
if (nargin == 1)
    T = varargin{1};
    d = diag(T);
    od = diag(T,1);
    n = length(d);
    Q = eye(n);
    NUM = n;
elseif (nargin == 2)
    [m1 n1] = size(varargin{1});
    [m2 n2] = size(varargin{2});
    if ((m1 > 1) && (n1 > 1))
        T = varargin{1};
        d = diag(T);
        od = diag(T,1);
        n = length(d);
        if ((m2 > 1) && (n2 > 1))
            Q = varargin{2};
            NUM = n;
        else
            Q = eye(n);
            NUM = varargin{2};
        end
    else
        d = varargin{1};
        od = varargin{2};
        n = length(d);
        Q = eye(n);
        NUM = n;
    end
elseif (nargin == 3)
    [m1 n1] = size(varargin{1});
    [m3 n3] = size(varargin{3});
    if ((m1 > 1) && (n1 > 1))
        T = varargin{1};
        d = diag(T);
        od = diag(T,1);
        n = length(d);
        Q = varargin{2};
        NUM = varargin{3};
    else
        d = varargin{1};
        od = varargin{2};
        n = length(d);
        if ((m3 > 1) && (n3 > 1))
            Q = varargin{3};
            NUM = n;
        else
            Q = eye(n);
            NUM = varargin{3};
        end
    end
elseif (nargin == 4)
    d = varargin{1};
    od = varargin{2};
    n = length(d);
    Q = varargin{3};
    NUM = varargin{4};
else
    error('Input syntax error. Type ''help myImplicitTriQR'' for assistance');
end

% Introspect to see if the user wants the eigenvectors too
if (nargout == 2)
    OutputV = 1;
else
    OutputV = 0;
end

% Perform implicit QR algorithm
od = [0;od(:)];
m = n;
iter = 0;
while (m > 1)
    iter = iter + 1;
    g = (d(m-1) - d(m)) / 2;
    if (g == 0)
        s = d(m) - abs(od(m));
    else
        s = d(m) - od(m) * od(m) / (g + sign(g) * SafeDistance(g,od(m)));
    end
    x = d(1) - s;
    y = od(2);
    for k = 1:(m-1)
        if (m > 2)
            xydist = SafeDistance(x,y);
            c = x / xydist;
            s = -y / xydist;
        else
            alpha = (d(1) - d(2))/od(2);
            denom = SafeDistance(1,alpha);
            c = alpha / denom;
            s = -1 / denom;
        end
        w = c * x - s * y;
        g = d(k) - d(k+1);
        z = (2 * c * od(k+1) + g * s) * s;
        d(k) = d(k) - z;
        d(k+1) = d(k+1) + z;
        od(k+1) = g * c * s + (c * c - s * s) * od(k+1);
        x = od(k+1);
        if (k > 1)
            od(k) = w;
        end
        if (k < (m-1))
            y = -s * od(k+2);
            od(k+2) = c * od(k+2);
        end
        if (OutputV == 1)
            Q(:,k:(k+1)) = Q(:,k:(k+1)) * [c s;-s c];
        end
    end
    if ((abs(od(m)) < eps * (abs(d(m-1)) + abs(d(m)))) || (iter >= maxIters))
        if (iter >= maxIters)
            warning('myImplicitTriQR:instability',['myImplicitTriQR() didn''t converge for m = ' num2str(m) ' after ' num2str(maxIters) ' iterations']);
        end
        m = m - 1;
        iter = 0;
    end
end

%
% Sort the eigenvalues
%
[d ind] = sort(d,'descend');
d = d(1:NUM);

%
% Output user-requested information
%
if (nargout == 2)
    varargout{1} = Q(:,ind(1:NUM));
    varargout{2} = diag(d);
else
    varargout{1} = d(:);
end
end

function dist = SafeDistance(a,b)
  abs_a = abs(a);
  abs_b = abs(b);
  if (abs_a > abs_b)
    dist = abs_a * sqrt(1.0 + (abs_b / abs_a)^2);
  else
    if (abs_b == 0)
      dist = 0;
    else
      dist = abs_b * sqrt(1.0 + (abs_a / abs_b)^2);
    end
  end
end
