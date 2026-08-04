function obj = sethspar(obj,varargin)
%  val=sethspar(obj,prop_name)
%
% SET set property value of the specified field of the
% state transition model class object
% Basically does a get(obj.hsnodes)


obj.hsnodes=set(obj.hsnodes,varargin{:});




