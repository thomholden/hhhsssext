function [DimLabels]=makelabel(intvec,varargin);
%  [DimLabels]=makelabel(intvec,PreStr,PostStr);
%  contruct a cell array containing a indeces in from of a string
%  preseeded and followed by strings.
%  e.g.
%    DimLabels=makelabel(1:3,'S(',')');
%  gives
%    {'S(1)';'S(2)';'S(3)'}
  

  switch length(varargin)
   case 0
    PreStr='';
    PostStr='';
   case 1
    PreStr=varargin{1};
    PostStr='';
   case 2
    PreStr=varargin{1};
    PostStr=varargin{2};
   otherwise
    error('Too many input arguments');
  end
    
  N=length(intvec(:));
  DimLabels=cellstr([repmat(PreStr,N,1),int2str(intvec(:)),repmat(PostStr,N,1)]);