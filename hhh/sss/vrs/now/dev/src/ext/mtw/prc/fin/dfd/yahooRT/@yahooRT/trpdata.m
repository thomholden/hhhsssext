function [prc,act,div] = trpdata(y,s,d1,d2,p)
%TRPDATA Data needed to generate total return price series.
%   [PRC,ACT,DIV] = TRPDATA(Y,S,D1,D2,P) where Y is the Yahoo connection
%   handle, S is the security string, D1 is the start date, D2 is the end
%   date, and P is the periodicity flag for Yahoo.
%
%   Note that data providers report price, action and dividend data 
%   differently.   The user should verify that the data returned by this
%   method contains the expected results.  This function is meant for
%   demonstration purposes only.

% Copyright 2005 The MathWorks, Inc.

%
%   See also BUILDUNIVERSE, FETCH.

%Get price data
prc = fetch(y,s,{'Close'},d1,d2,p);

%Get raw action data and convert to ratios
tmp = fetch(y,s,{'split'});
if ~isempty(tmp)
  act = [tmp(:,1) tmp(:,2)./tmp(:,3)];
else
  act = [];
end

%Get dividend data
div = fetch(y,s,d1,d2,'v');

