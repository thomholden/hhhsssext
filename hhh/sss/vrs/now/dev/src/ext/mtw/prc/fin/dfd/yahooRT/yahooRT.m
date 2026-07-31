function c = yahooRT(varargin)
%YAHOORT Extends the YAHOO datafeed to allow real-time access for Yahoo Premium
%Finance subscribers.
%
%   C = YAHOORT verifies that the URL finance.yahoo.com is accessible and
%   creates a connection handle.
%
%   C = YAHOORT(USER,PWD) logs into Yahoo as USER\PWD. If you subscribe to Yahoo
%   Premium, subsequent FETCH operations will return real-time data. This uses
%   the default YAHOO connection properties.
%
%   C = YAHOORT(YH,USER,PWD) uses the YAHOO datafeed object YH for subsequent
%   data fetches. Use this format when you wish to override the default YAHOO
%   connection settings, such as when connecting to Yahoo! through a proxy
%   server.
%
%   C = YAHOORT(...,LOGINFORM) uses the login form at the URL identified by
%   LOGINFORM.
%
%   See also YAHOO, CLOSE, FETCH, GET, ISCONNECTION.
%
%   Eric C. Johnson, 28-Jun-2008
%   Adapted from YAHOO
%   Copyright 1999-2008 The MathWorks, Inc.