function [Algo_Performance ,Buy_Hold_Performance, P_n_L]...
                     = Simple_Moving_Average_Algorithm(Short_MA,Long_MA)
                    
                 %% Simple Moving Average Example
%
%       Here is an example, demonstrating how to implement a trading
%       strategy and perform analysis.
%
%       This is a basic technical analysis indicator, comparing two
%       different moving averages of different time periods. When the
%       shorter moving average crosses above the longer moving average, a
%       buy signal is executed, and when the shorter moving average crosses
%       below the longer moving average, a sell signal is executed.
%
%       C            = Vecotr of closing prices of the asset being traded
%       D            = Vector of dates corresponding the to closing prices
%                      vector
%       V1           = Vector of the calculated short period simple moving
%                      average
%       V2           = Vector of the calculated long period simple moving
%                      average
%       Buy_Signal   = Trading instruction which executes a 'buy' trade
%       Sell_Signal  = Trading instruction which executes a 'sell' trade
%       P_n_L        = Structure containing all trade data 
%
%
%       Example
%
%       [Algo_Performance ,Buy_Hold_Performance, P_n_L]...
%                     = Simple_Moving_Average_Algorithm(100,250)

load ('ftse_10yr')

%       The data being used is the FTSE 100 index between '01-Jan-2001' and
%       '31-Dec-2010'

C = fliplr(data(:,5)'); D = fliplr(data(:,1)'); % flip the vectors

%       Calculation of Simple Moving Averages
%
%       'tsmovavg' is a built-in MATLAB function that comes with the 
%       'Financial Toolbox'. 

V1 = tsmovavg(C, 's', Short_MA); % Short Moving Average Vector
V2 = tsmovavg(C, 's', Long_MA); % Long Moving Average Vector

                    % Applying trading strategy

        Buy_Signal = V1 > V2;       % strategy upon which buy signals are 
                                    % executed
        
        Sell_Signal = V1 < V2;      % strategy upon which sell signals are
                                    % executed                                                       

P_n_L = Buy_only_trade_execution_algo(C,D,Buy_Signal,Sell_Signal);
                                    % Execute the trading algorithm
                                   
n = 10; % Length of data (years), required for analysis

%       For detailed explanation on the analysis tools used to assess
%       performance of a particular strategy, see 'Trade_Analysis' for more
%       detail.
%
%       The Financial Toolbox is required for Sharpes Ratio.

[Algo_Performance, Buy_Hold_Performance] = Trade_Analysis(P_n_L,n,C);

Trade_Plots(C,D,n,P_n_L) % plots trades and price data

% Plot the moving averages on a price graph

figure(2)

plot(D,C); hold on
plot(D,V1,'r','Linewidth',2.0); hold on; plot(D,V2,'g','Linewidth',2.0)
datetick('x',10) % format datenum on x-axis
end



