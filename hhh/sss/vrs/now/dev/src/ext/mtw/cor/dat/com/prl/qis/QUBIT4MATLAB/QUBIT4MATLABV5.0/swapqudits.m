% swapqudits    Swap two qudits of a qudit register
%   swapqudits(rho,k,l) swaps qubits k and l of the quantum state
%   rho. A state vector can also be given instead of
%   the density matrix rho. If the system is not a qubit
%   register, but a register of higher dimensional qudits
%   then we can use the form swapqudits(rho,k,l,d)
%   where d gives the dimension. If the density matrix given is sparse, 
%   then swapqudits will also produce a sparse matrix.

function mm=swapqudits(m,k,l,varargin)

if isempty(varargin)
    d=2;
elseif length(varargin)==1
    d=varargin{1};
else
    error('Wrong number of input arguments.');
end %if

N=floor(log2(max(size(m)))/log2(d)+0.5);
pattern=N:-1:1;
pattern(N-k+1)=l;
pattern(N-l+1)=k;
mm=reorder(m,pattern,d);


