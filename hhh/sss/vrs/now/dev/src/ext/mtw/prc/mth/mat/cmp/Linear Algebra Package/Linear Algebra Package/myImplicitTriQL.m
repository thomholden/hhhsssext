function varargout = myImplicitTriQL(varargin)
%--------------------------------------------------------------------------
% Syntax:       e = myImplicitTriQL(T);
%               e = myImplicitTriQL(d,od);
%               [V D] = myImplicitTriQL(T);
%               [V D] = myImplicitTriQL(d,od);
%               [V D] = myImplicitTriQL(T,Q);
%               [V D] = myImplicitTriQL(d,od,Q);
%               e = myImplicitTriQL(T,k);
%               e = myImplicitTriQL(d,od,k);
%               [V D] = myImplicitTriQL(T,k);
%               [V D] = myImplicitTriQL(d,od,k);
%               [V D] = myImplicitTriQL(T,Q,k);
%               [V D] = myImplicitTriQL(d,od,Q,k);
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
    error('Input syntax error. Type ''help myImplicitTriQL'' for assistance');
end

% Introspect to see if the user wants the eigenvectors too
if (nargout == 2)
    OutputV = 1;
else
    OutputV = 0;
end

% Warn user that algorithm is unstable for NUM > 1 (for now...?)
if (NUM > 1)
    warnState = warning;
    warning on; %#ok
    warning('myImplicitTriQL:instability','myImplicitTriQL() is unstable when computing 2 or more eigenvalues/eigenvectors. Use myImplicitTriQR() instead');
    warning(warnState);
end

% Implicit QL Algorithm (finds the eigenvalues of the symmetric tridiagonal
% matrix T and the eigenvectors of the similarity matrix w.r.t similarity
% transformation Q (when Q = eye(n), these are just the eigenvectors of T.)
m = 0;
for l = 1:NUM
    iter = 0;
    while (m ~= l)
        for m = l:(n-1)
            dd = abs(d(m)) + abs(d(m+1));
            if (abs(od(m)) <= eps * dd)
                break;
            end
        end
        if (m ~= l)
            iter = iter + 1;
            if (iter >= maxIters)
                error(['myImplicitTriQL() didn''t converge after ' num2str(maxIters) ' iterations']);
            end
            g = (d(l+1) - d(l)) / (2.0 * od(l));
            r = SafeDistance(g,1.0);
            g = d(m) - d(l) + od(l) / (g + abs(r) * sign(g));
            s = 1.0;
            c = 1.0;
            p = 0.0;
            for i = (m-1):-1:l
                f = s * od(i);
                b = c * od(i);
                r = SafeDistance(f,g);
                od(i+1) = r;
                if (r == 0.0)
                    d(i+1) = d(i+1) - p;
                    od(m) = 0.0;
                    break;
                end
                s = f / r;
                c = g / r;
                g = d(i+1) - p;
                r = (d(i) - g) * s + 2.0 * c * b;
                p = s * r;
                d(i+1) = g + p;
                g = c * r - b;
                if (OutputV == 1)
                    for k = 1:n
                        f = Q(k,i+1);
                        Q(k,i+1) = s * Q(k,i) + c * f;
                        Q(k,i) = c * Q(k,i) - s * f;
                    end
                end
            end
            if ((r == 0.0) && (i >= l))
                continue;
            end
            d(l) = d(l) - p;
            od(l) = g;
            od(m) = 0.0;
        end
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
