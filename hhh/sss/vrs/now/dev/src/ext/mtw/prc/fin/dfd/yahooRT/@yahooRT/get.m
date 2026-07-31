function v = get(c,p)
%GET    Get YahooRT connection properties.
%   V = GET(C,'PropertyName') returns the value of the specified 
%   properties for the Yahoo connection object.  'PropertyName' is
%   a string or cell array of strings containing property names.
%
%   V = GET(C) returns a structure where each field name is the name
%   of a property of C and each field contains the value of that 
%   property.
%
%   The property names are:
%
%   url
%
%   See also YAHOO, CLOSE, FETCH, ISCONNECTION.

%   Author(s): C.F.Garvin, 02-25-00
%   Copyright 1999-2003 The MathWorks, Inc.
%   $Revision: 1.6.2.2 $   $Date: 2004/04/06 01:06:08 $

if nargin > 1

  try
    %First try this object	
    v = c.(p);

  catch

    %Maybe the property belongs to the parent YAHOO object
    try		
      v = get(c.yahoo,p);
    catch
      error('datafeed:yahooRT:invalidProperty','Invalid %s connection property: '' %s ''.',class(c),p)
    end

  end
  
else

  % Return structure of entire object
  v = struct(c);
  v.yahoo = struct(v.yahoo);  
  
end