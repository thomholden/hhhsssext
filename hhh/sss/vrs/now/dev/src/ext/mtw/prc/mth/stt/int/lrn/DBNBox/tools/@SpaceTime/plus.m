function [spi]=plus(varargin)
%  spi=spi+1;  or 
%  spi=spi+[1 1];			
% increment space-time index by real number <d> or vector of from [time
% index,space index]
% 

  if isa(varargin{1},'SpaceTime') & isa(varargin{2},'double');
    inspi=varargin{1};
    d=varargin{2};
  elseif  isa(varargin{1},'double') & isa(varargin{2},'SpaceTime');
    inspi=varargin{2};
    d=varargin{1};
  else
    error('Operation defined only for double.');
  end
  spi=inspi;
  spi.ovfl=0;				% reset overflow

  L=[spi.T spi.C];
  switch spi.type
   case 'linear'
    if prod(size(d))==1,		% d is just a real
      spi.tc=spi.tc+d;
      if spi.tc~=min(max(spi.tc,1),spi.TC);% made tc  1<tc<TC ?
	spi=[];
	return;
      end
      %spi.tc=min(max(spi.tc,1),spi.TC);	% make tc  1<tc<TC
      [spi.ti,spi.ch]=ind2sub(L,spi.tc);
    else
      spi.ti=d(1)+spi.ti;			% d is vector [ti,ch]
      spi.ch=d(2)+spi.ch;
      if  spi.ti~=min(max(spi.ti,1),spi.T)% made ti  1<ti<T ?
	spi=[];
	return;
      end
      if spi.ch~=min(max(spi.ch,1),spi.C)% made ch  1<ch<C ?
	spi=[];
	return;
      end
      %spi.ti=min(max(spi.ti,1),spi.T);	% make ti  1<ti<T
      %spi.ch=min(max(spi.ch,1),spi.C);	% make ch  1<ch<C
      spi.tc=mysub2ind(L,spi.ti,spi.ch);	
    end
   case {'ccyclic','tcyclic'}
    % This section implements time first cyclic behavious of the index 
    l=mysub2ind(L,spi.ti,spi.ch);		% current index
    if prod(size(d))==1,		% d is just a real
      l=l+d;
    else
      d(1)=d(1)+spi.ti;			% d is vector [ti,ch]
      d(2)=d(2)+spi.ch;
      d(1)=spi.T*(mod(d(1),spi.T)==0)+mod(d(1),spi.T);
      d(2)=spi.C*(mod(d(2),spi.C)==0)+mod(d(2),spi.C);
      l=mysub2ind(L,d(1),d(2));
    end
    l=spi.TC*(mod(l,spi.TC)==0)+mod(l,spi.TC);
    spi.tc=l;
    [spi.ti,spi.ch]=ind2sub(L,l);
   otherwise
    error(sprintf('Unknown index behaviour %s!',spi.type));
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function ndx = mysub2ind(siz,varargin)
%SUB2IND Linear index from multiple subscripts.
%   SUB2IND is used to determine the equivalent single index
%   corresponding to a given set of subscript values.
%
%   IND = SUB2IND(SIZ,I,J) returns the linear index equivalent to the
%   row and column subscripts in the arrays I and J for an matrix of
%   size SIZ.
%
%   IND = SUB2IND(SIZ,I1,I2,...,In) returns the linear index
%   equivalent to the N subscripts in the arrays I1,I2,...,In for an
%   array of size SIZ.
%
%   See also IND2SUB.
 
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.10 $  $Date: 1997/11/21 23:30:18 $

if length(siz)<=nargin-1,
  siz = [siz ones(1,nargin-length(siz)-1)];
else
  siz = [siz(1:nargin-2) prod(siz(nargin-1:end))];
end
for i=length(varargin):-1:1,
  mn(i) = min(varargin{i}(:));
  mx(i) = max(varargin{i}(:));
  s{i} = size(varargin{i});
end
%if any(mn < 1) | any(mx > siz), error('Out of range index.'); end
if length(s)>1 & ~isequal(s{:}),
   error('The subscripts must all the be same size.');
end
n = length(siz);
k = [1 cumprod(siz(1:end-1))];
ndx = 1;
for i = 1:n,
  ndx = ndx + (varargin{i}-1)*k(i);
end

