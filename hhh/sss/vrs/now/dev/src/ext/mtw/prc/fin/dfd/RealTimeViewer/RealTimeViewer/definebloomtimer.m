% Script to define a timer object that reads and plot live market data
% from Bloomberg automatically.  TimerFcn is BLOOMRT.m.
%
% To start the process, type the following at the command prompt:
%
%   >> definebloomtimer,start(t)
% 
% To stop the process, type the following at the command prompt:
%   >> stop(t),delete(t)
% 
% Author:
% Brian Kiernan
% The MathWorks
% August 27, 2004

% open Bloomberg connection
Conn = bloomberg;
% Conn = 6;
ticker = 'IBM US Equity';
period = 5;

t = timer('TimerFcn',{@bloomRT, Conn, ticker},'ExecutionMode', ...
    'fixedRate', 'Period', period,'StopFcn','close(Conn)');