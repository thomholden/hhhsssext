function val = getobspar(obj,k,varargin)
%  val=getobspar(obj,k,prop_name)
%   OR
%  val=getobspar(obj,k,prop_name1,prop_name2,prop_name3,....)  
%
% GET Get property value of  specified field of the k-th
% observation model class object.
%
% Basically does a get(obj.obsmodel{k})


val=get(obj.obsmodel{k},varargin{:});




