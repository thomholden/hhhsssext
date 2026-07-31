function [omega_tilde psi_tilde X Y] = Ptilde_problem(N,f,gleft,gtop, ...
    gright,gbottom,sigma,D,grid,diagMatrices)
%Solves the P_tilde-problem for the vorticity-stream function formulation 
%of the steady Stokes-equations.
%
%   Inputs:  N            - polynomial degree
%            f            - external force
%            gleft        - normal boundary condition on the left edge
%            gtop         - normal boundary condition on the top edge
%            gright       - normal boundary condition on the right edge
%            gbottom      - normal boundary condition on the bottom edge
%            sigma        - parameter of the Helmholtz-equation
%            D            - second order Chebyshev differentiation matrix
%            grid         - meshgrid from the Chebyshev-Gauss-Lobatto points
%            diagMatrices - must contain the eigenvectors, their inverses
%                           and the eigenvalues as a cell array
%
%   Outputs: omega_tilde - vorticity solution of the P_tilde-problem
%            psi_tilde   - stream function solution of the P_tilde-problem
%            X, Y        - meshgrid from the Chebyshev-Gauss-Lobatto points
%
%   See also   PL_PROBLEM, PBAR_PROBLEM, HELMHOLTZ_DIAG, GETNODE

%   The algorithm is based on 
%      Roger Peyret.: Spectral Methods for Incompressible Viscous Flow, 
%      Springer, 2002
%
%   Zoltán Csáti
%   2014/07/13

zeroBC = zeros(N+1,1);
[omega_tilde X Y] = helmholtz_diag(N,f,zeroBC,zeroBC,zeroBC,zeroBC, ...
                                   sigma,D,grid,diagMatrices);
psi_tilde = helmholtz_diag(N,-omega_tilde(2:N,2:N),gleft,gtop,gright, ...
                                   gbottom,0,D,grid,diagMatrices);