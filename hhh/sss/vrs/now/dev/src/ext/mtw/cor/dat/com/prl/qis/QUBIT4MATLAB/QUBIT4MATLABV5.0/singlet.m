%singlet   Defines a singlet state.
%   singlet(n) gives the state vector for an n-qubit singlet state.
%   (This is a state with zero total angular momentum.)
%   If argument n is omitted than the default is taken to be
%   the value of global variable N as default.
%   The function is implemented only for n=2 and n=4.

function s=singlet(varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if

if N==2,
   s=[0 1 -1 0].'/sqrt(2);
elseif N==4,
   s=zeros(16,1);
   s(3+1)=1;
   s(12+1)=1;
   s(6+1)=-0.5;
   s(9+1)=-0.5;
   s(5+1)=-0.5;
   s(10+1)=-0.5;
   s=s/sqrt(s'*s);
else
    error('singlet is implemented only for N=2 and N=4.')
end %if
