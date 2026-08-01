function C = myCompanionMatrix(c)
%--------------------------------------------------------------------------
% Syntax:       C = myCompanionMatrix(c);
%
% Inputs:       c is a vector of length n + 1 of polynomial coefficients
%
% Outputs:      C is the Companion Matrix associated with input coefficient
%               vector c
%
% Description:  This function returns the n x n companion matrix C of the
%               coefficients in input c (of length n + 1) defined by
%
%               C = [ -d(1) -d(2)  ... -d(n-1) -d(n) ]
%                   [   1     0    ...    0      0   ]
%                   [   0     1    ...    0      0   ]
%                   [   .     .    .      .      .   ]
%                   [   .     .     .     .      .   ]
%                   [   .     .      .    .      .   ]
%                   [   0     0    ...    1      0   ]
%
%               where d = c(2:n) ./ c(1)
%
% Note:
%
%   det(z*I - C) = p(z,c) = c(1) * z^n + ... + c(n) * z + c(n+1)
%
%      i.e., the eigenvalues of C are the roots of the p(z,c)
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 9, 2012
%--------------------------------------------------------------------------

c = c(:)';
n = length(c) - 1;
C = [(-1 / c(1)) * c(2:end);[eye(n-1) zeros(n-1,1)]];
