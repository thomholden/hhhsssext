function val = gettxpar(obj,varargin)
%  val=gettxpar(obj,prop_name)
%   OR
%  val=gettxpar(obj,prop_name1,prop_name2,prop_name3,....)  
%
% GET Get property value of the specified field of the
% state transition model class object
% Basically does a get(obj.txmodel)

val=get(obj.txmodel,varargin{:});




