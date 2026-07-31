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



% Test the model visitor

% create the struct to build a heston model
sv_struct.kappa = 0.5;              % mean reversion
sv_struct.omega = 0.15;             % volatility of variance
sv_struct.theta = 0.2;              % long term variance
sv_struct.rho = -0.7;               % correlation
sv_struct.v0 = 0.2;                 % initial variance
sv_struct.S0 = 100.0;               % spot price

mbd = modelbuilderdirector();       % init modelbuilderdirector
hmb = hestonmodelbuilder();         % init particular builder (heston)
mbd.setmodelbuilder(hmb);           % pass the builder to director
hm = mbd.buildmodel(sv_struct,'eq');% build the model 

hm.print()

hmv = modelvisitor1(8);             % init modelvisitor
hmv.print()                         % print
hm.accept(hmv);                     % call visitor
hmv.print()                         % print

% delete all classes
clear hm;
clear hmb;
clear mbd;
clear hmv;