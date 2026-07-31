function F = ABBD2(Dt,f,B,omega_old,omega_oldold,nu)
%ABBD2   Second order Adams-Bashforth/backward-difference method for the 
%Navier-Stokes equation.
%
%   Inputs: Dt    - time step
%           f     - forcing term at the current time
%           B     - nonlinear convective term
%           omega_old    - vorticity one time-step before
%           omega_oldold - vorticity two time-steps before
%           nu    - kinematic viscosity
%
%   Output: F - discretized right hand side of the Helmholtz-equation at
%               the current time
%
%   See also   SIBE

%   Zoltán Csáti
%   2014/07/11

F = 1/nu*(-f + 2*B{end}-B{end-1} - (4*omega_old-omega_oldold)/(2*Dt));