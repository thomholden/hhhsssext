% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau)
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


InitVariables;              % example parameterisation

T = [0.25 1 5 10];          % maturities
xi = 1;                     % volatility of variance
kappa = 0.2;                % mean reversion speed

for k=1:length(T);
    PlotFigure5(T(k),kappa,xi,V, ['T=', num2str(T(k))])
end

for k=1:length(xi);
    PlotFigure5(T(2),kappa,xi,V,['\nu=', num2str(xi(k))])
end

for k=1:length(kappa);
    PlotFigure5(T(2),kappa,xi,V,['\kappa=', num2str(kappa(k))] )
end