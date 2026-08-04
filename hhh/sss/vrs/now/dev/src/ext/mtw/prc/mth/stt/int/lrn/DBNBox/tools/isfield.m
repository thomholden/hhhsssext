function tf = isfield(s,f)
%ISFIELD True if field is in structure array.
%   F = ISFIELD(S,'field') returns true if 'field' is the name of a field
%   in the structure array S.
%
%   See also GETFIELD, SETFIELD, FIELDNAMES.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1997/11/21 23:24:27 $

if isa(s,'struct') 
  tf = any(strcmp(fieldnames(s),f));
else
  try 
    s=struct(s);
    tf = any(strcmp(fieldnames(s),f));
  catch
    tf = logical(0);
  end
end


