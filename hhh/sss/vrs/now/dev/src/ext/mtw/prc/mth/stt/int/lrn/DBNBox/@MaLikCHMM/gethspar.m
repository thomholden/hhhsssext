function val = gethspar(obj,varargin)
%  val=gethspar(obj,prop_name)
%   OR
%  val=gethspar(obj,prop_name1,prop_name2,prop_name3,....)  
%
% GET Get property value of the specified field of the
% state transition model class object
% Basically does a get(obj.chschain)



val=get(obj.chschain,varargin{:});




