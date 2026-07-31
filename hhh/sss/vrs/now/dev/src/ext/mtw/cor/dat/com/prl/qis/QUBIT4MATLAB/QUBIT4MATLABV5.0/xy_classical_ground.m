% xy_classical_ground   Ground state energy of the classical xy model 
%   xy_classical_ground(Jx,Jy,B) gives the ground state energy per spin for 
%   the classical XY model in transverse field if the 
%   field strength is B and the coefficients of the xx and yy 
%   nearest neighbor coupling are Jx and Jy, respectively.
%   That is, the Hamiltonian is H= Jx*sum_k x(k) x(k+1) + 
%   Jy*sum_k y(k) y(k+1) + B*sum_k z(k), 
%   where x, y and z denote Pauli spin matrices.

function E0=xy_classical_ground(Jx,Jy,B)
% See G. Toth, Phys. Rev. A 71, 010301 (R) (2005).
M=max(abs(Jx),abs(Jy));
b=abs(B)/M;
if b>2,
    E0=-M*b;
else
    E0=-M*(1+b^2/4);
end %if

