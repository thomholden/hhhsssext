function [Algo_Performance, Buy_Hold_Performance] = ...
                                                Trade_Analysis(P_n_L,n,C)

%       Given the results of a trading strategy, we can calculate the 
%       following measures to evaluate the performance of the strategy.
% 
%       -   Annualised Return = geometric average of rate of return 
%           during thetrading horizon
%       -   Annualised Volatility = volatility of rate of return during 
%           the trading horizon
%       -   SR = risk adjusted rate of return (Sharpe Ratio) during 
%           the trading horizon
%       -   p_in = proportion of in the market periods to the whole 
%           trading horizon
%       -   NumOfTrades = number of executed trades during the trading 
%           horizon 

                        %% Algorithm Performance

Algo_Performance = struct ('Annualised_Rate_of_Return',[],...
                           'Annualised_Volatility',[],...
                           'Sharpes_Ratio',[],...
                           'P_in',[],...
                           'NumOfTrades',[]);

%       Rate of return of the asset during a single period r_k is 
%       calculated at time T/N(k) from the asset prices at time T/N(k-1) 
%       and T/N(k) (P_k-1 and P_k respectively) as ln(P_k)-ln(P_k-1)
%
%       Rate of return during the whole trading periods R is a sum of 
%       rates of return in each period, and a geometric mean of a single 
%       period return r is obtained by dividing R by the number of 
%       periods N.
                       
            r = log(P_n_L.exit_long_price) - log(P_n_L.enter_long_price);

            Algo_Performance.Annualised_Rate_of_Return = sum(r) / n;

%       The annualsied volatility (sigma) is the standard deviation of the
%       instruments yearly logarithmic return. The generalised volatility
%       sigma_T for time horizon T in years is expressed as:
%
%                       sigma_T = sigma * sqrt(T)
%
%       Therefore, if the daily logarithmic returns of a stock have a 
%       standard deviation of sigma_SD and the time period of returns is P, 
%       the annualized volatility is:
%
%                       sigma = sigma_SD / sqrt(P)
%
%       A common assumption is that P = 1/252 (there are 252 trading days 
%       in any given year). Then, if sigma_SD = 0.01 the annualized 
%       volatility is:
%
%                   sigma_annual = 0.01 / sqrt(1/252)

            Algo_Performance.Annualised_Volatility = std(r)*sqrt(252);

            Algo_Performance.Sharpes_Ratio = sharpe(r,0);

            Algo_Performance.P_in = sum(P_n_L.exit_long_i - ...
                                P_n_L.enter_long_i)/length(C);
                    
            Algo_Performance.NumOfTrades = length(P_n_L.enter_long_price);

                       %% Buy and Hold Performance
Buy_Hold_Performance = struct ('Annualised_Rate_of_Return',[],...
                               'Annualised_Volatility',[],...
                               'Sharpes_Ratio',[],...
                               'P_in',[],...
                               'NumOfTrades',[]);

r_b     = [];
r_b(1)  = 0;
                       
for j = 2:length(C)
    
    r_b(j) = log(C(j)) - log(C(j-1));
    
end
    
            Buy_Hold_Performance.Annualised_Rate_of_Return = sum(r_b) / n;    
    
            Buy_Hold_Performance.Annualised_Volatility = ...
                                                    std(r_b)*sqrt(252);
            
            Buy_Hold_Performance.Sharpes_Ratio = sharpe(r_b,0);
            
            Buy_Hold_Performance.P_in = 1;
            
            Buy_Hold_Performance.NumOfTrades = 1;
    
end