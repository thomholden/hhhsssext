function x = builduniverse(y,s,d1,d2,p)
%BUILDUNIVERSE Portfolio matrix with total return price data from Yahoo.
%   X = BUILDUNIVERSE(Y,S,D1,D2,P) builds a portfolio matrix using Yahoo
%   data to compute a total return price series.  X is an Mx(N+1) matrix
%   where N is the number of securities.  Column 1 of the matrix contains
%   MATLAB date numbers and the remaining columns are the total return
%   prices for each security.
%  
%   Y is the Yahoo connection handle, S is a cell array of security
%   identifiers, D1 and D2 are the start and end dates for the data
%   request, and P is the periodicity flag.  P can be entered as:
%
%   'd' for daily values.
%   'w' for weekly values.
%   'm' for monthly values.
%
%   Note that data providers report price, action and dividend data 
%   differently.   The user should verify that the data returned by this
%   method contains the expected results.  This function is meant for
%   demonstration purposes only.
%
%   See also FETCH, TRPDATA.

% Copyright 2005 The MathWorks, Inc.

%Default periodicity is daily
if nargin < 4
  p = 'd';
end

%Convert security list to cell array
if ischar(s)
  s = cellstr(s);
end

%Determine number of securities
numsec = length(s);

%Show progress
h = waitbar(0,'Loading securities from Yahoo...');
      
for i = 1:numsec
  
  %Add symbols to structure
  u(i).symbol = s{i};
  
  %Update progress
  waitbar(i/numsec,h,['Loading ' s{i} ' from Yahoo...'])
  
  %Get price, action and dividend data for each security
  %Trap intermittent failures when downloading web data
  try
    [prc,act,div] = trpdata(y,s{i},d1,d2,'d');
  catch
    [prc,act,div] = trpdata(y,s{i},d1,d2,'d');
  end
  
  %Calculate total return price series
  u(i).tr = totalreturnprice(prc,act,div);
  
end

close(h)

%Convert structure into matrix with NaN's representing missing data

%Get list of all possible dates from data
tmpdates = u(1).tr(:,1);
for i = 2:numsec
  tmpdates = unique([tmpdates;u(i).tr(:,1)]);
end

%Preallocate output matrix
numdates = length(tmpdates);
x = nan(length(tmpdates),numsec+1);
x(:,1) = tmpdates;
for i = 1:numsec
  [c,ai,bi] = intersect(tmpdates,u(i).tr(:,1));
  x(ai,i+1) = u(i).tr(bi,2);
end
    
    
function trprc = totalreturnprice(prc,act,div)
%TOTALRETURNPRICE Total return price time series.
%   TRPRC = TOTALRETURNPRICE(PRC,ACT,DIV) generates a total return price 
%   time series given price data, action or split data, and 
%   dividend data.
%
%   Inputs:
%
%     PRC - An Mx2 matrix of price data where column 1 is MATLAB date 
%     numbers and column 2 is price values.
%
%     ACT - An Nx2 matrix of action or split data where column 1 is MATLAB date 
%     numbers and column 2 is split ratios.
%
%     DIV - An Px2 matrix of dividend data where column 1 is MATLAB date 
%     numbers and column 2 is dividend payouts.
%
%   Output:
%  
%     TRPRC - An Mx2 matrix of price data where column 1 is MATLAB date 
%     numbers and column 2 is total return price values.
%
%     See also MONTHLYRETURNS.


prc = sortrows(prc);
act = sortrows(act);
div = sortrows(div);

% get number of dates from price data
maxindex = size(prc,1);

% set up date indexing for the prc, div, and act arrays
pindex = 1;
pdate = prc(pindex,1);

if size(div,1) > 0
    dindex = 1;
    ddate = div(dindex,1);
end

if size(act,1) > 0
    aindex = 1;
    adate = act(aindex,1);
end

% calculate total return prices and put into trprc array
trprc = zeros(maxindex,2);
trprc(1,:) = [pdate, 1];

for pindex = 2:maxindex

    pdate = prc(pindex,1);
    trval = prc(pindex,2);

    if size(div,1) > 0
        if (ddate == pdate) && (dindex <= size(div,1))
            
           % process dividend data and then increment
            trval = trval + div(dindex,2);
            
            dindex = dindex + 1;
            if dindex <= size(div,1)
                ddate = div(dindex,1);
            end
        end
    end
    
    trval = trval / prc(pindex - 1,2);

    if size(act,1) > 0
        if (adate == pdate) && (aindex <= size(act,1))
            
            % process action data and then increment
            trval = trval * act(aindex,2);
        
            aindex = aindex + 1;
            if aindex <= size(act,1)
                adate = act(aindex,1);
            end
        end
    end
    
    trval = trval * trprc(pindex - 1,2);
    
    trprc(pindex,:) = [pdate, trval];
end
