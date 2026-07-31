% Example Script for Monkey trading. The example data here is from the
% brazilian Equity market.

clear;
addpath('m_Files');
load Example.mat;

x=Assets;   % Assets is a price matrix (time evolving with row and columns are the asstes)
n=2500;     % Number of simulations

% The next parameters can be just the median of total number of traded
% periods for each type of positions (just set to zero if not used (eg. just long positions, no short ones)

n_Periods.Long=150;             % Number of periods traded on Long positions
n_Periods.Short=100;            % Nmber of periods traded on Long positionsdays for each asset
                   
% The next parameters can just be the median of the number of assets traded
% each day for each type of position (again, you can set to zero if not
% used)

n_Assets.Long=5;                % Number of assets traded in long positions
n_Assets.Short=2;               % Number of assets traded in long positions

C=0;                            % Trading cost in percentage of invested money
tFactor=250;                    % The example data is dailly, therefore 250 days in one year

[P]=monkeytrading(Assets,n,n_Periods,n_Assets,C,tFactor);

rmpath('m_Files');