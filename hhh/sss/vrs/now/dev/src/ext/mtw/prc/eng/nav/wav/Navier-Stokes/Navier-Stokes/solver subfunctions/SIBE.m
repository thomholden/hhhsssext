function F = SIBE(Dt,f,B,omega,nu)
%SIBE   Semi-implicit backward-Euler method for the Navier-Stokes equation.
%
%   Inputs: Dt    - time step
%           f     - forcing term at the current time
%           B     - nonlinear convective term
%           omega - vorticity one time-step before
%           nu    - kinematic viscosity
%
%   Output: F - discretized right hand side of the Helmholtz-equation at
%               the current time
%
%   See also   ABBD2

%   Zoltán Csáti
%   2014/07/11

F = 1/nu*(-f + B{end} - omega/Dt);