% README file for the algo trading demos
% this directory contains a number of files that were used in the
% algorithmic trading webinar and presentations. The files show three
% different models:
%
% 1. simple moving average crossover in 2D and 3D
% 2. a more complicated moving average/RSI model in 2 and 3D
% 3. a simple pairs trading example using cointegration
% 
% The files are :
% BTEST
% ------
% This is a simple backtest for a moving average crossover model. It uses
% leadlag.m and the BundDaily.xls Excel data file.
%
% BTESTPAR
% --------
% This is an extension of the above model with an intraday data set,
% bund1min.mat As well as looping over the two moving averages, it also
% loops over a sampling frequency. This takes a couple of minutes to run
% (or so) and I used it to demonstrate the utility of the Distributed
% Computing Toolbox in Matlab. It also uses the "LeadLag.m" model, and
% makes use of an iso-surface to plot the results. The graphics are
% contained in the files macross3DFig.m and isoplot.m
%
% MARISADEMO
% ----------
% This is a first cut at the moving average/rsi model. It illustrates the
% basic idea, but with the parameters that I have chosen, this doesn't
% work. It calls the model MARISA.m and RSI2.m
%
% MARISASCRIPT
% ------------
% This is the backtesting routine for the MARISA model. It cycles over
% values for moving average and also RSI and computes the value of the
% MARISA model as it goes. This is a "2D" version so I fix my sampling
% frequency to be 30 minutes.
%
% MARISA
% ------
% Moving average and RSI model. I use the RSI of a detrended price,
% together with the Moving average for trend info to generate a trading
% signal. This model calls RSI2.m
%
% To view the 3D results of MARISA and btestPAR (without DCE) you can load
% the data files marisa3Ddata.mat and macross3Ddata.mat. This gives results
% from a previous run, and can be viewed by calling the files marisa3DFig.m
% and macross3DFig.m respectively. This illustrates how to use the 3D
% iso-surface routines.
%
% SEARCHCOINT
% -----------
% this is a routine to cycle over a series of instruments taken from the
% FTSE100 and look for a cointegrated relationship between them. It uses
% the data file Portfolio_Data.mat. See the function help for how to use
% it.
%
% COINTSCRIPT
% -----------
% This is a backtesting script to see whether we can build a long/short
% pairs trading model based on the output of SEARCHCOINT. I use stocks 9
% and 23 in my example. This calls COINTSTRAT
%
% COINTSTRAT
% ----------
% basic pairs trading model using data from COINTSCRIPT. 
%
% MA_MODEL.MDL
% ------------
% Basic simulink model for the moving average crossover. First load the
% BUNDDAILY.XLS file and set a variable in the workspace called Bund, as
% follows:
% data=xlsread('BundDaily.xls');
% Bund=data(:,5);
% MA_Model
% This uses some blocks from the Signal Processing Blockset.
