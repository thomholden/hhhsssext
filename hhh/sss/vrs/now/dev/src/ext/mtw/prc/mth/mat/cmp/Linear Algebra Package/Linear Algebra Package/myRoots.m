function r = myRoots(c)
%--------------------------------------------------------------------------
% Syntax:       r = myRoots(c);
%
% Inputs:       c is an vector of polynomial coefficients
%
% Outputs:      r is a vector of length length(c) - 1 containing the roots
%               (sorted in descending order) of the polynomial:
%
%    p(z,c) = c(1) * z^(n-1) + c(2) * z^(n-2) + ... + c(n-1) * z + c(n)
%
% Description:  This function returns the roots (zeros) of the polynomial
%               defined by the input coefficient vector c by computing the
%               eigenvalues of the Companion Matrix associated with c.
%
% Note:         myRoots(c) returns the same as MATLAB's roots(c)
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         September 9, 2012
%--------------------------------------------------------------------------

% Remove leading zeros from c
c = c(find(c,1,'first'):end);

% Remove trailing zeros and remember them as roots at zero
n_leadTrim = length(c);
c = c(1:find(c,1,'last'));
r = zeros(n_leadTrim - length(c),1);

% Form companion matrix
C = myCompanionMatrix(c);

% Compute polynomial roots via eig(C)
r = sort([r;eig(C)],'descend');
