function B = convective(u,v,omega,grid,D1)
%CONVECTIVE   Convective term of the Navier-Stokes equation.
%
%   Input: x     - Chebyshev-Gauss-Lobatto nodes
%          u, v  - horizontal and vertical velocity coordinates
%          omega - vorticity
%          grid  - meshgrid from x
%          D1    - first differentiation matrix
%
%   Output: B - convective term in vorticity-stream function formulation
%
%   See also   SIBE, ABBD2, PARTIALDER

%   Zoltán Csáti
%   2014/07/11

[derx dery] = partialder(omega,grid,D1);
B = u.*derx + v.*dery;