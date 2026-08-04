function [flag]=binop(varargin)
% test of various binary operators applied to 2 space-time indeces
% 
% 
  
  if ~isa(varargin{1},'SpaceTime') | ~isa(varargin{2},'SpaceTime')
    error('Binary Operators defined only for SpaceTime class objects.');
  end
  
  [spiA,spiB,op]=deal(varargin{:});
  flag=1;				% presume true
  
  % checking dimensions
  parA=[spiA.T spiA.C];
  parB=[spiB.T spiB.C];
  if any(parA~=parB)
    warning('Logical Operation ambigous for non-matching index Dimension');
  end

  switch lower(op)
   case 'lt',
    parA=[spiA.T spiA.C spiA.ti spiA.ch];% parameters needing checks
    parB=[spiB.T spiB.C spiB.ti spiB.ch];
    if any(parA>parB)
      flag=0;
    end
   case 'eq'
    parA=[spiA.T spiA.C spiA.ti spiA.ch];% parameters needing checks
    parB=[spiB.T spiB.C spiB.ti spiB.ch];
    if any(parA~=parB)
      flag=0;
    end
   case 'ne'
    parA=[spiB.T spiB.C spiA.ti spiA.ch];% parameters needing checks
    parB=[spiB.T spiB.C spiB.ti spiB.ch];
    if all(parA==parB)
      flag=0;
    end
   otherwise
    error(sprintf('Operator %s not defined.',lower(op)));
  end