% thstate   Thermal state of a system with a given Hamiltonian
%    thstate(H,kT) is the thermal state of a system described by a
%    Hamiltonian at temperature kT. 

function rho=thstate(H,kT)
   rho=expm(-H/kT);
   rho=rho/trace(rho);