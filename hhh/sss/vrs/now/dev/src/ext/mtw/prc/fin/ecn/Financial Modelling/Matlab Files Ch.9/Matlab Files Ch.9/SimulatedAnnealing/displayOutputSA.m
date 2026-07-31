% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [stop,options,optchanged] = displayOutputSA(options,optimvalues,flag)

stop   = false;
optchanged = false;

if optimvalues.iteration == 0
    fprintf('\n                       Coordiantes                  Best           Current');
    fprintf('\nIteration           x1              x2            f(x1,x2)         f(x1,x2)');
    fprintf('\n-----------------------------------------------------------------------------\n');
end

if mod(optimvalues.iteration,60) == 0
    fprintf('%5.0f      %14.6g   %14.6g   %14.6g   %14.6g\n', ...
            optimvalues.iteration,optimvalues.bestx(1),optimvalues.bestx(2), ...
            optimvalues.bestfval, optimvalues.fval);
end

