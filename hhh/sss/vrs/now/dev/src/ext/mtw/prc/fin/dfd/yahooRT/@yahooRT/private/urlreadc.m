function [output,setcookie,status] = urlreadc(c,urlChar,method,params)
%URLREADS same as URLREAD, but allows a cookie to be passed in the HTTP/HTTPS
%header. Useful for working with authenticated HTTP/HTTPS sessions.
%
%   [OUTPUT,SETCOOKIE,STATUS] = URLREADC(C,...) performs the same actions
%   as URLREAD, but sets the HTTP/HTTPS header 'Cookie' property using the
%   session information in the YAHOORT object C. See URLREAD for the format
%   of subsequent input arguments. OUTCOOKIE is the cookie returned by the
%   server in the 'Set-Cookie' HTTP/HTTPS header field. See URLREAD for more
%   information about output arguments OUTPUT and STATUS.

%   URLREADC adapted from URLREAD by Eric C. Johnson, 29-Jun-2008
%   URLREAD written by Matthew J. Simoneau, 13-Nov-2001
%   Copyright 1984-2008 The MathWorks, Inc.
%


% This function requires Java.
if ~usejava('jvm')
   error('datafeed:yahooRT:noJVM','URLREADC requires Java.');
end

import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;

% Be sure the proxy settings are set.
com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings

% Check number of inputs and outputs.
error(nargchk(2,4,nargin))
error(nargoutchk(0,3,nargout))
if (nargin > 2) && ~strcmpi(method,'get') && ~strcmpi(method,'post')
    error('datafeed:yahooRT:invalidInput','Third argument must be either "get" or "post".');
end

% Do we want to throw errors or catch them?
if nargout == 3
    catchErrors = true;
else
    catchErrors = false;
end

% Set default outputs.
output = '';
setcookie = '';
status = 0;

% GET method.  Tack param/value to end of URL.
if (nargin > 2) && strcmpi(method,'get')
    if mod(length(params),2) == 1
        error('datafeed:yahooRT:invalidInput','Invalid parameter/value pair arguments.');
    end
    for i=1:2:length(params)
        if (i == 1), separator = '?'; else, separator = '&'; end
        param = char(java.net.URLEncoder.encode(params{i}));
        value = char(java.net.URLEncoder.encode(params{i+1}));
        urlChar = [urlChar separator param '=' value];
    end
end

%Create a urlConnection. Adapted from toolbox\matlab\iofun\private\urlreadwrite,
%for the purpose of keeping everything in a single directory.
try
  url = java.net.URL([], urlChar, sun.net.www.protocol.http.Handler);
  % Determine the proxy.
catch
  if catchErrors, return
  else error('datafeed:yahooRT:invalidURL','Could not parse the URL ''%s''',urlChar);
  end
end

% Determine the proxy.
proxy = [];
if ~isempty(char(java.lang.System.getProperty('http.proxyHost')))
  try
    ps = java.net.ProxySelector.getDefault.select(java.net.URI(urlChar));
    if (ps.size > 0)
      proxy = ps.get(0);
    end
  catch
    proxy = [];
  end
end

% Open a connection to the URL.
if isempty(char(proxy))
  conn = url.openConnection();
else
  conn = url.openConnection(proxy);
end


% Set the session cookie in the HTTP/HTTPS header
try
  conn.setRequestProperty('Cookie', c.session);
catch
  if catchErrors, return
  else error('datafeed:yahooRT:badCookie','Could not set HTTP header cookie information');
  end
end

% POST method.  Write param/values to server.
if (nargin > 2) && strcmpi(method,'post')
    try 
        conn.setDoOutput(true);
        conn.setRequestProperty( ...
            'Content-Type','application/x-www-form-urlencoded');
        printStream = java.io.PrintStream(conn.getOutputStream);
        for i=1:2:length(params)
            if (i > 1), printStream.print('&'); end
            param = char(java.net.URLEncoder.encode(params{i}));
            value = char(java.net.URLEncoder.encode(params{i+1}));
            printStream.print([param '=' value]);
        end
        printStream.close;
    catch
        if catchErrors, return
        else error('datafeed:yahooRT:connectionFailed','Could not POST to URL ''%s''',urlChar);
        end
    end
end

% Read the data from the connection.
try 
    inputStream = conn.getInputStream;
    byteArrayOutputStream = java.io.ByteArrayOutputStream;
    % This StreamCopier is unsupported and may change at any time.
    isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
    isc.copyStream(inputStream,byteArrayOutputStream);
    inputStream.close;
    byteArrayOutputStream.close;
    output = native2unicode(typecast(byteArrayOutputStream.toByteArray','uint8'),'UTF-8');
    setcookie = getcookie(conn);
catch
    if catchErrors, return
    else error('datafeed:yahooRT:connectionFailed','Error downloading from URL ''%s''',urlChar);
    end
end

status = 1;


function cookie = getcookie(conn)
%GETCOOKIE retrieves the cookie data (if any) from the HTTP/HTTPS header in CONN
%
% TODO: Add second argument allowing an existing cookie to be updated or
% appended to.

cookie = '';

% Save the returned cookie
headerFields = conn.getHeaderFields();
for k=1:headerFields.size()
   
    headerName = conn.getHeaderFieldKey(k);
    if strcmpi('set-cookie',headerName)
        ck          = conn.getHeaderField(k);        
        ck          = ck.substring(0, ck.indexOf(';'));
        ckName      = ck.substring(0, ck.indexOf('='));
        ckValue     = ck.substring(ck.indexOf('=') + 1, ck.length());
        if ~isempty(cookie)
            cookie = [char(cookie) '; ' char(ck)];
        else
            cookie = char(ck);
        end
    end
    
end