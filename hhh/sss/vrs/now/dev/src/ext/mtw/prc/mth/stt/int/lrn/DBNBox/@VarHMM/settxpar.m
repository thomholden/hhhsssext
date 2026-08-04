function obj = settxpar(obj,varargin)
%  val=setobspar(obj,prop_name,prop_val)
%
% SET Set property value of  specified field of the k-th
% observation model class object.
%
% Basically does a set(obj.txmodel)

obj.txmodel=set(obj.txmodel,varargin{:});




