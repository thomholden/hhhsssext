% Script to define a timer object that reads and plot live market data
% from Yahoo automatically.  TimerFcn is YAHOORT.m.
%
% To start the process, type the following at the command prompt:
%
%   >> defineyahootimer,start(t)
% 
% To stop the process, type the following at the command prompt:
%   >> stop(t),delete(t)
% 
% Author:
% Brian Kiernan
% The MathWorks
% August 27, 2004

% open Yahoo connection
Conn = yahoo;

% Define ticker symbol of the Price you want returned
ticker = 'IBM';
period = 5;

% % Real Time operation
t = timer('TimerFcn',{@yahooRT, Conn, ticker},'ExecutionMode', ...
    'fixedRate', 'Period', period,'StopFcn','close(Conn)');