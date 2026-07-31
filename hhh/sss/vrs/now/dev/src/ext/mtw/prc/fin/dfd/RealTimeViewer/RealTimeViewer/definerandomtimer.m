% Script to define a timer object that creates and plots random data.
% automatically.  TimerFcn is RANDOMRT.m.
%
% To start the process, type the following at the command prompt:
%
%   >> definerandomtimer,start(t)
% 
% To stop the process, type the following at the command prompt:
%   >> stop(t),delete(t)
% 
% Author:
% Brian Kiernan
% The MathWorks
% August 27, 2004

% Define Ticker Symbol
ticker = 'IBM';
period = 5;

% % Non Realtime (random number)
% This timer object will update every 5 seconds, in which it 
% will create a new random price using the RANDN command
t = timer('TimerFcn',{@randomRT, ticker},'ExecutionMode', ...
    'fixedRate', 'Period', period);