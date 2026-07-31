function [rtnStats, index, labels]=ComputeStatistics(rtnData,frequency)

% Copyright 2013 The MathWorks, Inc.

rtnStats =  struct;
labels = {'CAGR', 'MaxDrawdown', 'Sharpe', 'Sortino', ...
           'ProfitableTrades'};

if (~isempty(rtnData))
    index = ret2tick(rtnData,100);
    rtnStats.Sortino = sortino(rtnData,0);
    rtnStats.Sharpe = sharpe(rtnData,0);
    rtnStats.MaxDrawdown = maxdrawdown(index);
    switch(frequency)
        case {'M','m'}
            scalingFactor=12;
        case {'W','w'}
            scalingFactor=52;
        otherwise
            scalingFactor=365;
    end
    
    rtnStats.CAGR=cagr(index,scalingFactor);
else
    rtnStats.ProfitableTrades=0;
    rtnStats.Sortino=0;
    rtnStats.Sharpe=0;
    rtnStats.MaxDrawdown=0;
    rtnStats.CAGR=0;
end

end