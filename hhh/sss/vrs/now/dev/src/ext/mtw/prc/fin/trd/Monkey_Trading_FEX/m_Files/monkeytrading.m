%  ARE YOU MORE SKILLED THAN A MONKEY AT TRADING STOCKS?
%
% DESCRIPTION:
%     This function performs n simulations with random trades in the
%     market, and outputs return, standard deviation and sharpe ratio (all annualized) 
%     for all simulations. With this information you can check if a particular performance 
%     indicator from a trading strategy (eg. annualized return) is just a case of chance or not.
%     From the academic point of view, this method is called bootstrap method for assessing
%     performance and this particular algorithm coded here is a variant of such.
%
% USAGE: [annRet,annStd,annSharpe]=monkeytrading(x,n,n_Periods,n_Assets,C,tFactor)
%
%       INPUT:
%               x - A matrix with the prices of all assets that were
%               available to trade in the tested period. The row are the
%               prices for each period and each collums represents one
%               particular stock.
%
%               n - Number of simulations. Should be higher than 1000 in
%               order to get consistent results.
%
%               n_Periods - Number of periods trading in the market. Obviously,
%               it should be lower than the lenght of x. (see example
%               script for how to input it)
%
%               n_Assets - Number of assets traded for each day. If you're
%               trading a different number of assets each day, just use an
%               average. (see example script for how to input it)
%
%               C - Trading cost per trade (in percentage) (eg. 0.1% per trade, C=0.001)
%
%               tfactor - The time factor, that is, how many units of
%               time within one year. For instance, if the data has dailly frequency, then
%               tFactor=250 (250 working days in one year). If data is monthly prices, then 
%               tFactor=12. 
%
%       OUTPUT:
%               annRet - A vector with the annualized return of the n simulations. A
%               histogram of annRet is also given at the end of the
%               function
%
%               annStd -  A vector with the annualized standard deviation
%               of the n simulations. A histogram of annStd is also given at the end of the
%               function
%
%               annSharpe - A vector with the annualized sharpe ratio (annRet/annStd) of the n
%               simulations. A histogram of annSharpe is also given at the end of the
%               function.
%
%   Author: Marcelo Scherer Perlin
%   Email:  marceloperlin@gmail.com
%   ICMA / University of Reading
%   Created: November/2006
%   Last Update: December/2007
%
%   Feel free to use it and modify it for your own interest. 

function [annRet,annStd,annSharpe]=monkeytrading(x,n,n_Periods,n_Assets,C,tFactor)

[nr,nc]=size(x);

if tFactor<0
    error('The input tFactor must be an positive value');
end

if nargin~=6
    error('Some input argument is missing. The function uses 6 arguments');
end

if nargin==5
    C=0.001;
end

if (n_Assets.Long+n_Assets.Short)>nc
    error('The sum n_Assets for each type of trades should be lower than the number of columns in x');
end

if (n_Periods.Long+n_Periods.Short)>nr-1
    error('The sum n_Periods for each type of trades should be lower than the length of x minus 1 (one obs lost in return calculation)');
end

ret=log(x(2:end,:)./x(1:end-1,:));  % Calculation of lof returns from price matrix

% Prealocation of large Matrices

Bsign_Short=zeros(nr-1,nc);
Bsign_Long=zeros(nr-1,nc);
annRet=zeros(n,1);
annSharpe=zeros(n,1);
annStd=zeros(n,1);

for p=1:n

    % Creation of Random days to enter the market and trade

    Rand_T=randperm(nr-1);
    Bsign_D_L=Rand_T(1:n_Periods.Long);
    Bsign_D_S=Rand_T(1:n_Periods.Short);

    % Selection of random assets to trade in the random days

    Rdn_Assets_L0=randperm(nc);
    Rdn_Assets_L=Rdn_Assets_L0(1,1:n_Assets.Long);

    Rdn_Assets_S0=randperm(nc);
    Rdn_Assets_S=Rdn_Assets_S0(1,1:n_Assets.Short);

    % Computation of trading signals

    Bsign_Long(Bsign_D_L,Rdn_Assets_L)=1;
    Bsign_Short(Bsign_D_S,Rdn_Assets_S)=-1;

    Bsign_T=Bsign_Long+Bsign_Short;

    % Computation of portfolio Weights

    Port_Weight=Bsign_T./(n_Assets.Long+n_Assets.Short);
    
    % Computation of the number of trades required (more details at
    % the description of trades()

    [nTL]=trades(Bsign_Long);
    [nTS]=trades(Bsign_Short);
    
    % Computation of Pure Returns

    ret_T=sum(ret.*Port_Weight,2)+(sum(nTL+abs(nTS),2)~=0)*log((1-C)/(1+C));

    % Computation of outputs (annualzied return, annualized standard deviation, 
    % annualized sharpe)
    
    annRet(p,1)=mean(ret_T)*tFactor;
    annStd(p,1)=std(ret_T)*sqrt(tFactor);
    annSharpe(p,1)=annRet(p,1)/annStd(p,1);

    % Cleaning up the trading signals matrix

    Bsign_Long=zeros(nr-1,nc);
    Bsign_Short=zeros(nr-1,nc);
    Bsign_T=zeros(nr-1,nc);

    % Just a simple progress bar
    fprintf(1,['\nSimulating Monkey Number #',num2str(p),' (out of ',num2str(n),')']);

end

fprintf(1,'\n\n*** Simulations Done (while you check results the monkeys will rest) ***\n');

fprintf(1,'\nConsidering your input choices, a monkey with no skill whatsoever would earn, in average:\n\n');
fprintf(1,['Annualized Raw Return:    ' num2str(mean(annRet)) '\n']);
fprintf(1,['Annualized Std Deviation: ' num2str(mean(annStd)) '\n']);
fprintf(1,['Annualized Sharpe Ratio:  ' num2str(mean(annSharpe)) '\n']);

figure(1);
histfit(annRet);
xlabel('Annualized Raw Returns from the Simulations','FontSize',12);
ylabel('Frequency','FontSize',12);

figure(2);
histfit(annStd);
xlabel('Annualized Standard Deviations of the Returns from the Simulations','FontSize',12);
ylabel('Frequency','FontSize',12);

figure(3);
histfit(annSharpe);
xlabel('Annualized Sharpe Ratios from the Simulations','FontSize',12);
ylabel('Frequency','FontSize',12);