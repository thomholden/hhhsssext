% qsize   Size in qudits. Both qsize(v,d) and qsize(rho,d) can be used,
%         where d is the dimension of the qudit. If d is omitted, then
%         it is assumed to be 2.

function q=qsize(matrix,varargin)

if isempty(varargin)
    d=2;
elseif length(varargin)==1
    d=varargin{1};
else
    error('Wrong number of input arguments.')
end %if

[sy,sx]=size(matrix);
q=log2(max(sx,sy))/log2(d);
