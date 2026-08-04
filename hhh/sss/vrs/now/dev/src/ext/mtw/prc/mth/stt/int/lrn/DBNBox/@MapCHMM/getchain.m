function val = getchain(obj,k,varargin)
%  val=getchain(obj,k,prop_name)
%   OR
%  val=getchain(obj,k,prop_name1,prop_name2,prop_name3,....)  
%
% GET Get property value of  specified field of the k-th
% chain object.
%
% Basically does a get(obj.chain(k))

if length(varargin)==1,
  val=eval(sprintf('obj.chain{k}.%s;',varargin{1}));
else
  val=eval(sprintf('get(obj.chain{k}.%s,varargin{2:end});', varargin{1}));
end

% old val=get(obj.chain(k),varargin{:});




