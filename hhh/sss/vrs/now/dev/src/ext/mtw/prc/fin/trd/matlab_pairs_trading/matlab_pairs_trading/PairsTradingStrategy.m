function PairsTradingStrategy(sys)

PrimarySymbol = 'EWA';
SecondarySymbol = 'EWC';
WatchlistName='AUCASpread';

% Only execute on the primary symbol of the pair
if(~strcmp(sys.BarData.Symbol,PrimarySymbol))
    return;
end
% Current is the primary symbol
Primary=sys.BarData;
% Load the secondary bar data from the watchlist. The last boolean
% parameter indicates that the secondary data will be synchronized to the
% primary data, which means that missing bars are filled with previous values
% and extra bars are removed so that primary and secondary will have exactly 
% the same number of bars.
Secondary=GetBarData(sys,WatchlistName,SecondarySymbol,true);

% Trading parameters can be used in a parameter sweep. If we are not
% running a parameter sweep, these parameters will default to the second 
% parameter passed to the 'GetTradingParameter' function. 
AveragePeriod=sys.GetTradingParameter('Period', 100);
UpperThreshold=sys.GetTradingParameter('UpperThreshold', 1.5);
LowerThreshold=sys.GetTradingParameter('LowerThreshold', 1);

PairRatio = Primary.Close/Secondary.Close;

Average = Sma(PairRatio, AveragePeriod);
RatioStdDev = StdDev(PairRatio, AveragePeriod);
RatioStdDev.Name = 'StdDev';

% Calculate the ZScore and plot the thresholds
ZScore = (PairRatio - Average) / RatioStdDev;
ZScore.Name = 'ZScore';
ZScoreUpper=DataSeries(sys.Date, 'Upper Threshold', sys.BarData.Frequency, UpperThreshold);
ZScoreUpperNegative=DataSeries(sys.Date, 'Negative Upper Threshold', sys.BarData.Frequency, -1* UpperThreshold);
ZScoreLower=DataSeries(sys.Date, 'Lower Threshold', sys.BarData.Frequency, LowerThreshold);
ZScoreLowerNegative=DataSeries(sys.Date, 'Negative Lower Threshold', sys.BarData.Frequency, -1 * LowerThreshold);

PlotDataSeries(sys, ZScore, 'blue', 'ZScore');
PlotDataSeries(sys, ZScoreUpper, 'red', 'ZScore');
PlotDataSeries(sys, ZScoreLower, 'green', 'ZScore');
PlotDataSeries(sys, ZScoreLowerNegative, 'green', 'ZScore');
PlotDataSeries(sys, ZScoreUpperNegative, 'red', 'ZScore');

% Confiure ZScore chart to 70% in size compared to the price chart
ConfigureChart(sys, 'ZScore', 70, true);

% Primary entry and exit signals
AddShortSignal(sys, ZScore>=ZScoreUpper, ZScore<=ZScoreLower);
AddLongSignal(sys, ZScore<=ZScoreUpperNegative, ZScore>=ZScoreLowerNegative);

% Switch to the secondary context. All functions called after
% 'SwitchSymbol' are executed an the secordary symbol until 
% 'RestoreContext' is called.
SwitchSymbol(sys, SecondarySymbol, true);
AddLongSignal(sys, ZScore>=ZScoreUpper, ZScore<=ZScoreLower);
AddShortSignal(sys, ZScore<=ZScoreUpperNegative, ZScore>=ZScoreLowerNegative);
RestoreSymbol(sys);

% Plot the secondary symbol
PlotBarData(sys, Secondary, 'darkblue', 'darkblue', 1, 'Pane');
ConfigureChart(sys, 'Pane', 100, false);
HideVolume(sys);

end