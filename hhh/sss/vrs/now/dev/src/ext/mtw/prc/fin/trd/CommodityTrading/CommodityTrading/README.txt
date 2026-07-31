SCRIPTS WALKTHROUGH

Demo_A_DataImportAndCleanup - retrieves data from multiple sources (CSV, SQLite, Yahoo Finance). This script can be examined to see how the data retrieval can be setup. 
WARNING: This script will overwrite 'StageA.mat', the main MAT file used to store our commodity data.

Demo_B_ExploreData - generates aggregate and groupwise plots of commodity data.

Demo_C_TrendFollowing - sets up and tests a trend following strategy (absolute momentum).

Demo_D_CrossSectionalMomentumStrategy - demonstrates a cross-sectional momentum strategy.

Demo_E_StrategyAcrossSectors - demonstrates a cross-sectional momentum "catch-up" strategy across sectors.

Demo_F_TestingCrossSectionalSectorStrategy - tests the above strategy against different lookback windows and indicators.

Demo_G_CrossSectionalBacktest - performs strategy backtests against the test set of data.

Demo_H_InterfacingWithXTrader - shows how to retrieve instrument information from the X_TRADER trading platform.

Demo_H_OrderSubmissionWithXTrader - shows how to submit trade orders to the X_TRADER platform.

DATA USED IN THIS DEMO

1. The data shown in the webinar can be obtained from commercial datafeed providers, or from public sources such as Quandl: www.quandl.com.

2. The data included in this package ('StageA.mat') is *fake* and is intended solely for workflow demonstration purposes.

3. I have included a sample file in the 'Datasets\' folder to show how Demo_A can import data from CSV files. The data in this file is *fake*.

OTHER PACKAGES USED

This package uses the "Intelligent Dynamic Date Ticks" File Exchange submission: http://www.mathworks.com/matlabcentral/fileexchange/27075-intelligent-dynamic-date-ticks .


Copyright 2013 The MathWorks, Inc.