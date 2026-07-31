% schmidt   Schmidt coefficients of a pure state.
%   Used in the form schmidt(state,list) where state is
%   a state vector and list is a list of qubits in order to
%   define bi-partitioning. Qubit numbering is the same as 
%   in the case of the function remove.

function coeff=schmidt(state,list)
coeff=sqrt(real(eig(remove(ketbra(state),list))));
