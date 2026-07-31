function c = close(c) 
%CLOSE Close connection to Yahoo.
%   CLOSE(C) closes the connection, C, to the Yahoo web site. The authenticated
%   session is purged.
%
%   See also YAHOORT.

%   Eric C. Johnson, 29-Jun-2008
%   Copyright 1999-2002 The MathWorks, Inc.

c.session = '';
