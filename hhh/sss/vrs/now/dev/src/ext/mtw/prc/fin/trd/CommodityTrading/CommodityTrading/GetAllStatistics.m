% Copyright 2013 The MathWorks, Inc.
    [bahStats,~,labels] = ComputeStatistics(bahRtn,frequency);
    [sectorStats,~,~] = ComputeStatistics(sectorRtn,frequency);
    cagrSet = [cagrSet; bahStats.CAGR sectorStats.CAGR];
    sortinoSet = [sortinoSet; bahStats.Sortino sectorStats.Sortino];
    sharpeSet = [sharpeSet; bahStats.Sharpe sectorStats.Sharpe];
    drawdownSet = [drawdownSet; bahStats.MaxDrawdown sectorStats.MaxDrawdown];
