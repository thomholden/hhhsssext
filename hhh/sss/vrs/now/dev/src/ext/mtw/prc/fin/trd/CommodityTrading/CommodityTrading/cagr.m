function [ rtn ] = cagr( series, scalingFactor )

% Copyright 2013 The MathWorks, Inc.

    rtn = (series(end)/series(1))^(scalingFactor/length(series))-1;

end

