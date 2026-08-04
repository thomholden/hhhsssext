function [obj]=Pointer(varargin);
% [obj]=Pointer(addr,CA)
% 
% contructor for pointer
% Datamembers:
%   addr:       index of cell element containing the pointer data
%   CA:         name (string) of the global cell array containing the data
% Methods
%   subsasgn()  sets values of pointer fields
%   subsref()   gets values of pointer fields

ClassName='Pointer';

defstruct=struct('addr',[],'CA','');

if nargin==0
  obj=defstruct;
  obj=class(obj,ClassName);
else
  % argument is of same class, 
  if isa(varargin{1},ClassName)
    obj=varargin{1};			% just return;
    return;
  else
    obj=defstruct;
    [addr,CA]=mydeal(varargin{:});
    
    % identifier(s)
    if ~isempty(addr)
       obj.addr=addr;
    end;
    
    if ~isempty(CA),
       obj.CA=CA;
       eval(sprintf('global %s;',CA));
       if eval(sprintf('isempty(%s)',CA))
          error(sprintf('Error declaring %s as global',CA));
       end
    end;
    
    obj = class(obj,ClassName);
  end;
end;

