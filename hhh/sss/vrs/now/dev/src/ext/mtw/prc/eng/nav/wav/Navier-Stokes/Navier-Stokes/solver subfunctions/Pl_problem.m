function [omega_l psi_l] = Pl_problem(N,sigma,D,grid,diagMatrices)
%PL_PROBLEM   Solves the P_l-problem for the vorticity-stream function 
%formulation of the steady Stokes-equations.
%
%   Input:   N            - polynomial degree
%            sigma        - parameter of the Helmholtz-equation
%            D            - second order Chebyshev differentiation matrix
%            grid         - meshgrid from the Chebyshev-Gauss-Lobatto points
%            diagMatrices - must contain the eigenvectors, their inverses
%                           and the eigenvalues as a cell array
%
%   Outputs: omega_l - vorticity solution of the P_l problem
%            psi_l - stream function solution of the P_l problem
%
%   See also   HELMHOLTZ_DIAG, GETNODE, PBAR_PROBLEM

%   The algorithm is based on 
%      Roger Peyret.: Spectral Methods for Incompressible Viscous Flow, 
%      Springer, 2002
%
%   Zoltán Csáti
%   2014/09/08

L = 4*N-4;
omega_l = cell(L,1);
psi_l = cell(L,1);
zeroBC = zeros(N+1,1);
for node = 1:L
    % Solve the Helmholtz-equation for omega_l
    RHS = zeroBC(1);
    [leftBC topBC rightBC bottomBC] = getnode(node,N);
    omega_l{node} = helmholtz_diag(N,RHS,leftBC,topBC,rightBC,bottomBC, ...
                                   sigma,D,grid,diagMatrices);
    % Solve the Poisson-equation
    RHS = -omega_l{node}(2:N,2:N); % exclude the boundary points
    psi_l{node} = helmholtz_diag(N,RHS,zeroBC,zeroBC,zeroBC,zeroBC,0, ...
                                 D,grid,diagMatrices);  
end