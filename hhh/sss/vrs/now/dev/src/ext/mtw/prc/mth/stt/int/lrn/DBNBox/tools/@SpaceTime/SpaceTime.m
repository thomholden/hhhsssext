function [obj]=SpaceTime(varargin)
% Constructor for Space-Time index Class
%  [obj]=SpaceTime(T,C)
% Space-Time indeces loop over time and space. For example, t+1 will
% increment the time index, or, if t>T, increments space index
% and reset time index
% Data Members
%  T           largets Time index
%  C           largest Space index
%  TC          largest Space-Time index
%  ti          actual time index
%  ch          actual space index
%  tc          combined space-time space index
%  ovfl        overflow if index wraps round 
%  elcntr      element counter
%  type        index behaviour; 'linear' or 'cyclic';
%  
% Methods
%   plus()     increment by double
%   ending()   true of at right bottom corner of Space-time
%   eq()       true if 2 time indeces are equal
%   ne()       true of 2 tiem indeces are non identical
%   lt()       true of one index is smaller than the other
%   max()      returns largest attainable index
%   uplus()    increment by 1 
%   uminus()   decrement by 1
%   next()     finds next element
  

ClassName='SpaceTime';

defstruct=struct('T',[],'C',[],'TC',[],'tc',[1],'ti',1,'ch',1, ...
		 'ovfl',0,'type','cyclic','elcntr',0); 

if nargin==0,
  obj=defstruct;
  obj=class(obj,ClassName);
else
  % argument is of same class, 
  if isa(varargin{1},ClassName)
    obj=varargin{1};			% just return;
    return;
  else
    obj=defstruct;
    [T,C,type]=mydeal(varargin{:});
    
    % max Time
    if ~isempty(T)
      obj.T=T;
    end;
 
    % max Chain
    if ~isempty(C),
      obj.C=C;
    end

    obj.TC=obj.T*obj.C;
    
    % index behaviour
    if ~isempty(type),
      if ismember(lower(type),{'linear', 'tcyclic','ccyclic'}),
	obj.type=lower(type);
      else
	warning(sprintf('SpaceTime type %s not recognised. Using default',...
			type));
      end
    end
    
    obj = class(obj,ClassName);
  end;
end;


