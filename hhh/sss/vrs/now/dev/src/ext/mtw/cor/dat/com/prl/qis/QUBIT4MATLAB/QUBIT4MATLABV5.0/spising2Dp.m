% spising2D   Hamiltonian for the 2D Ising model with aperiodic boundary condition; sparse
%            version.
%   spising2D(B,Nx,Ny) gives the Hamiltonian as a sparse matrix for the 
%   ferromagnetic Ising model in transverse field for Nx*Ny qubits, if the 
%   field strength is B and the coefficient 
%   of the nearest neighbor coupling is 1. 
%   That is, the Hamiltonian is H= - sum_k z(k) z(k+1) + B*sum_k x(k), 
%   where x and z denote Pauli spin matrices.
%   The coupling is z-z and the direction of the field is x. 
%   For the Hamiltonian aperiodic boundary condition is used.

function H=spising2D(BField,Nx,Ny)

x=[0 1;1 0];
y=[0 -i;i 0]; 
z=[1 0; 0 -1];
e=[1 0; 0 1];

% Using routines from the library to make the Ising Hamiltonian
H=-splattice(z,z,Nx,Ny)+BField*spcoll(x,Nx*Ny);
 


