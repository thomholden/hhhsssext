function [invM L_red] = influencematrix(N,psi_l,grid,D1)
%INFLUENCEMATRIX   Determines the inverse of the influence matrix.
%
%   Inputs:  N     - polynomial degree
%            psi_l - stream function solution of the P_l-problem
%            grid  - meshgrid from the Chebyshev-Gauss-Lobatto points
%            D1    - first differentiation matrix
%
%   Outputs: invM  - inverse of the influence matrix
%            L_red - number of boundary points excluding the four corners 
%                    and four additional points so that the influence matrix
%                    is regular 
%
%   See also   PL_PROBLEM, PARTIALDER

%   Zoltán Csáti
%   2014/07/05

L = size(psi_l,1);
L_red = L-4;
M = zeros(L_red,L);
% Create the influence matrix
for l = 1:L
    [derx dery] = partialder(psi_l{l},grid,D1);
    % Create the influence matrix and delete the specific points
    M(:,l) = [-derx(2:N,1); dery(end,3:N-1)'; derx(2:N,end); -dery(1,3:N-1)'];
end
% Remove the corresponding columns
M = [M(:,1:N-1) M(:,N+1:2*N-3) M(:,2*N-1:3*N-3) M(:,3*N-1:4*N-5)];
% Invert the influence matrix
invM = inv(M);