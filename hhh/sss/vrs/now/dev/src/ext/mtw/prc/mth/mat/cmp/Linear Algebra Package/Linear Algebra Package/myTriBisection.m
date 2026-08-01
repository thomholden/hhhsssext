function [e varargout] = myTriBisection(varargin)
%--------------------------------------------------------------------------
% Syntax:       e = myTriBisection(T);
%               e = myTriBisection(d,od);
%               e = myTriBisection(T,m1,m2);
%               e = myTriBisection(d,od,m1,m2);
%               [e, its] = myTriBisection(T);
%               [e, its] = myTriBisection(d,od);
%               [e, its] = myTriBisection(T,m1,m2);
%               [e, its] = myTriBisection(d,od,m1,m2);
%               [e, its, errBnd] = myTriBisection(T);
%               [e, its, errBnd] = myTriBisection(d,od);
%               [e, its, errBnd] = myTriBisection(T,m1,m2);
%               [e, its, errBnd] = myTriBisection(d,od,m1,m2);
%               
% Inputs:       T is an N x N symmetric tridiagonal matrix.
%               
%               d contains the N diagonal elements of a symmetric
%               tridiagonal matrix.
%               
%               od contains the N-1 super/sub-diagonal elements of a
%               symmetric tridiagonal matrix.
%               
%               m1 is the index of the FIRST sorted (ascending) eigenvalue
%               to return. The default value is 1.
%               
%               m2 is the index of the LAST sorted (ascending) eigenvalue
%               to return. The default value is N.
%               
%               EXAMPLE: N = 5, m1 = 2, m2 = 4 returns the 2nd - 4th
%               ascending eigenvalues of a (N x N) tridiagonal matrix.
%               
% Outputs:      e is a vector of length (m2 - m1 + 1) containing the m1
%               through m2 ordered eigenvalues of T.
%               
%               its is the number of bisections required for the
%               eigenvalues to converge.
%               
%               errBnd is an upper bound on the numerical error of each
%               output eigenvalue.
%               
% Description:  This function uses a bisection algorithm to compute a range
%               (including all, if desired) of the sorted (ascending)
%               eigenvalues of a symmetric tridiagonal matrix.
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         September 3, 2012
%--------------------------------------------------------------------------

% Knobs
eps1 = 1e-6;

% Parse user inputs
if (nargin == 1)
    T = varargin{1};
    d = diag(T);
    od = diag(T,1);
    m1 = 1;
    m2 = length(d);
elseif (nargin == 2)
    d = varargin{1};
    od = varargin{2};
    m1 = 1;
    m2 = length(d);
elseif (nargin == 3)
    T = varargin{1};
    d = diag(T);
    od = diag(T,1);
    m1 = varargin{2};
    m2 = varargin{3};
elseif (nargin == 4)
    d = varargin{1};
    od = varargin{2};
    m1 = varargin{3};
    m2 = varargin{4};
else
    error('Input syntax error. Type ''help myTriBisection'' for assistance');
end

% Initialize variables
od = [0;od(:)];
odSqr = od.^2;
n = length(d);

% Perform bisection
odSqr(1) = 0;
od(1) = 0;
emin = d(n) - abs(od(n));
emax = d(n) + abs(od(n));
for i = (n-1):-1:1
    h = abs(od(i)) + abs(od(i+1));
    if ((d(i) + h) > emax)
        emax = d(i) + h;
    end
    if ((d(i) - h) < emin)
        emin = d(i) - h;
    end
end
if ((emin + emax) > 0)
    errBnd = eps * emax;
else
    errBnd = eps * -emin;
end
if (eps1 <= 0)
    eps1 = errBnd;
end
errBnd = 0.5 * eps1 + 7 * errBnd;
e0 = emax;
wu = zeros(m2,1);
e = zeros(m2,1);
for i = m1:m2
    wu(i) = emin;
    e(i) = emax;
end
its = 0;
for k = m2:-1:m1
    eu = emin;
    for i = k:-1:m1
        if (eu < wu(i))
            eu = wu(i);
            break;
        end
    end
    
    if (e0 > e(k))
        e0 = e(k);
    end
    
    while ((e0 - eu) > 2 * eps * (abs(eu) + abs(e0)) + eps1)
        e1 = (eu+e0)/2;
        its = its + 1;
        a = 0;
        q = 1;
        for i = 1:n
            if (q ~= 0)
                q = d(i) - e1 - odSqr(i) / q;
            else
                q = d(i) - e1 - abs(od(i)) / eps;
            end
            if (q < 0)
                a = a + 1;
            end
        end
        if (a < k)
            if (a < m1)
                eu = e1;
                wu(m1) = e1;
            else
                eu = e1;
                wu(a+1) = e1;
                if (e(a) > e1)
                    e(a) = e1;
                end
            end
        else
            e0 = e1;
        end
    end
    e(k) = (e0 + eu) / 2;
end

% Return user-specified information
e = sort(e(m1:m2),'descend');
if (nargout == 2)
    varargout{1} = its;
elseif (nargout == 3)
    varargout{1} = its;
    varargout{2} = errBnd;
end
