function obj = setchain(obj,k,varargin)
%  obj=setchain(obj,k,prop_name)
%   OR
%  obj=setchain(obj,k,prop_name1,prop_name2,prop_name3,....)  
%
% SET Set property value of  specified field of the k-th
% chain object.
%
% Basically does a set(obj.chain(k))

if length(varargin)==2,
  evalstr=sprintf('obj.chain{k}.%s=varargin{2};',varargin{1});
  eval(evalstr);
else
  evalstr=sprintf('obj.chain{k}.%s=set(obj.chain{k}.%s,varargin{2:end});',...
		  varargin{1},varargin{1});
  eval(evalstr);
end

%old obj.chain{k}=set(obj.chain{k},varargin{:});




