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
% (C) Joerg Kienitz, Daniel Wetterau and Sven Glaser
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 

InitVariables;                      % example parameterisation

T = [0.25 1 5 10];                  % maturities
xi = [0.5 1 1.5 2];                 % volatility of variance
kappa = [0.05 0.1 0.15 0.2];        % mean reversion speed
x = [1 5 10];                       % xvalues

for k=1:length(T);
    PlotFigure3( x(2),kappa(3),xi(3),T(k),V )
end
   
for k=1:length(xi);
     PlotFigure3( x(2),kappa(3),xi(k),T(2),V )
end
 
for k=1:length(kappa);
     PlotFigure3( x(2),kappa(k),xi(3),T(2),V )
end

clear; clc;