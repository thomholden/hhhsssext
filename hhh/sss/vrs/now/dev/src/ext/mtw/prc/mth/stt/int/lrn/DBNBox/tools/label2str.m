function [dlstr]=label2str(DimLabels);
% [dlstr]=label2str(DimLabels);
% 
% Convert cell array of string to one cell array of a string 
% which is DimLabels concatinated with comma separation. 
% Input
%   DimLabels     N-by-1 cell array of 1-by-K  cells containing strings 
%                of dimension labels. 
% Output
%   dlstr         N-by-1 cell array of strings
%                
%                
% e.g. label2str({'A','B'}) gives 'A,B'. 


  if ~iscell(DimLabels{1})    % just a cell array
    DimLabels={DimLabels};
  end
  for l=1:length(DimLabels),	% loop over them
    Ndl=length(DimLabels{l});  
    tmp=DimLabels{l};
    tmp(2,:)=cat(2,repmat({','},1,Ndl-1),{''});
    dlstr{l}=strcat(tmp{:});
  end;

