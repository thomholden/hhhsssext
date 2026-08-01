function mat = myEIGBalance(mat)
%--------------------------------------------------------------------------
% Syntax:       mat = myEIGBalance(mat);
%
% Inputs:       mat is an arbitrary square matrix
%
% Outputs:      mat (upon return) is the balanced version of mat. That is,
%               it has the same same eigenvalues but is more "numerically
%               stable."
%               
% Description:  This function returns a balanced version of the input
%               matrix that has the same eigenvalues but will, in general,
%               be more numerically stable.
%
%               NOTE: The balanced version of mat will, in general, have
%               different eigenvectors than the original version.
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 3, 2012
%--------------------------------------------------------------------------

RADIX = 2;

% Check input size
[m,n] = size(mat);
if (m ~= n)
    error('Input matrix must be square');
end

% Perform matrix balancing
sqrdx = RADIX * RADIX;
last = 0;
while (last == 0)
    last = 1;
    for i = 1:n
        r = 0.0;
        c = 0.0;
        for j = 1:n
            if (j ~= i)
                c = c + abs(mat(j,i));
                r = r + abs(mat(i,j));
            end
        end
        if ((c ~= 0) && (r ~= 0))
            g = r / RADIX;
            f = 1.0;
            s = c + r;
            while (c < g)
                f = f * RADIX;
                c = c * sqrdx;
            end
            g = r * RADIX;
            while (c > g)
                f = f / RADIX;
                c = c / sqrdx;
            end
            if ((c + r) / f < 0.95 * s)
                last = 0;
                g = 1.0 / f;
                for j = 1:n
                    mat(i,j) = mat(i,j) * g;
                    mat(j,i) = mat(j,i) * f;
                end
            end
        end
    end
end
