function [varargout]=mydeal(varargin)
% function [varargout]=MYDEAL(varargin)
% Stupid matlab cannot handle mismatch between number input and output
% arguments. In this function all output arguments are set to [] if
% there is no corresponding input variable

Nai=nargin;
Nao=nargout;

for i=1:min([Nai,Nao])
  varargout{i}=varargin{i};
end

if Nai<Nao
  for i=Nai+1:Nao,
    varargout{i}=[];
  end;
end;
  