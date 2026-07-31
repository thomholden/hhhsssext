function [params,sig] = MAcross_strategy(x,price)
%% Moving averages crossing strategy
% This function evaluate simple strategy on crossing moving
% averages. It is highly commented for easier understanding of how to
% create strategy like this or how you may modify it in WFAToolbox.
%
% Requirements:
% - MATLAB R2010a+
% - WFAToolbox (http://wfatoolbox.com/)
% 
% Toolboxes:
% - Financial Toolbox
% - Optimization Toolbox
% - Statistics Toolbox
%
% With this simple steps you may use any MATLAB functions and create your own strategy. 
% Just follow this 4 steps:
%
% 1. Function must contain input variables (price,x) and output variables [params,sig]
% like this:
%
%    [params,sig] = mystrategy(price,x)
%
% 2. Define names of variables and range for optimization by setting PARAMS
% structure in the upper part of the code. For example:
%
%   params.var = 1:2:55;
%
% 3. Get the price data from structure PRICE and calculate what you need. For
% example, a technical indicator;
%
%   output = indicator(price.Close,var);
%
% 4. Set signals by filling out a variable SIG. For example:
%
%   sig(output > 0) = 1
%   sig(output <= 0) = -1
%
% Copyright 2013, http://wfatoolbox.com

%% Declare parameters and optimization range
% Here you may define names of variables and range for optimization 
% by setting PARAMS structure

params.lead = 2:2:25;        % period of lead moving average
params.lag = 5:5:200;      % period of lag moving average
    
%% Warning! Don't change this block of code
% You may skip this block of code
var_names = fieldnames(params);
for i = 1:length(var_names)
    % 'x' is a vector of optimising parameters
    if ~isempty(x)
        eval([var_names{i},'=',num2str(x(i)),';']);
    else
        eval([var_names{i},'=',num2str(params.(var_names{i})(1)),';']);
    end
end
sig = zeros(length(price.Close),1);
%% Indicator calculation
% You may get any data that you've loaded with 
% 'Load Data' button in GUI by using structure PRICE

lead = round(lead);
lag = round(lag);

lead_ma = tsmovavg(price.Close', 'e', lead);
lag_ma = tsmovavg(price.Close', 'e', lag);

%% Signals calculation
% The main goal is to fill out signals variable SIG
% from state like this:

sig(lead_ma >= lag_ma) = 1; % buy 1 amount of asset
sig(lead_ma < lag_ma) = -1; % sell short 1 amount of asset
