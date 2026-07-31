function [omega_bar psi_bar] = Pbar_problem(N,L_red,xi,omega_l,psi_l)
%PBAR_PROBLEM   Solves the P_bar-problem for the vorticity and the stream
%function.
%
%   Inputs: N       - polynomial degree
%           L_red   - number of boundary points excluding the four corners 
%                     and four additional points so that the influence matrix
%                     is regular
%           xi      - coefficients obtained from the influence matrix equation
%           omega_l - solutions of the P_l-problem for the vorticity
%           psi_l   - solutions of the P_l-problem for the stream function
%
%   Outputs: omega_bar - vorticity solution of the P_bar-problem
%            psi_bar   - stream function solution of the P_bar-problem
%
%   See also   PL_PROBLEM

%   The algorithm is based on 
%      Roger Peyret.: Spectral Methods for Incompressible Viscous Flow, 
%      Springer, 2002
%
%   Zoltán Csáti
%   2014/07/05

% Preallocate the required sizes
omega_bar = zeros(size(omega_l{1}));
psi_bar = omega_bar;
% Delete the values belonging to the skipped nodes
omega_l(N) = []; omega_l(2*N-3) = []; omega_l(3*N-4) = []; omega_l(4*N-7) = [];
psi_l(N) = []; psi_l(2*N-3) = []; psi_l(3*N-4) = []; psi_l(4*N-7) = [];
% Calculate omega_bar and psi_bar as the sum of the known function values
for k = 1:L_red
    psi_bar = psi_bar + psi_l{k}*xi(k);
    omega_bar = omega_bar + omega_l{k}*xi(k);
end