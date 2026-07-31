% shiftquditsright    Shift the qudits to the right
%   shiftquditsright(rho,n) shift the qubits of the state rho
%   by n qubits to the right. If n is not given, then it is
%   taken to be one. A state vector can also be given instead of
%   the density matrix rho. If the system is not a qubit
%   register, but a register of higher dimensional qudits
%   then we can use the form shiftquditsright(rho,n,d)
%   where d gives the dimension.

function mm=shiftquditsright(m,varargin)

if isempty(varargin)
    n=1;
    d=2;
elseif length(varargin)==1
    n=varargin{1};
    d=2;
elseif length(varargin)==2
    n=varargin{1};
    d=varargin{2};
else
    error('Wrong number of input arguments.');
end %if

n=-n;

N=log2(max(size(m)))/log2(d);
if 0>n,
   mm=reorder(m,[(N+n-1):-1:(-n),N:-1:N+n],d);
elseif n>0,
   mm=reorder(m,[N-n:-1:1 N:-1:N-n+1],d);
end %if


