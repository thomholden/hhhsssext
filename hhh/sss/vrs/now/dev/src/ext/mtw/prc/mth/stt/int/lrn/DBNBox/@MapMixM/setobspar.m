function obj = gstobspar(obj,k,varargin)
%  val=setobspar(obj,k,prop_name,prop_val)
%
% SET Set property value of  specified field of the k-th
% observation model class object.
%
% Basically does a set(obj.obsmodel{k})

obj.obsmodel{k}=set(obj.obsmodel{k},varargin{:});




