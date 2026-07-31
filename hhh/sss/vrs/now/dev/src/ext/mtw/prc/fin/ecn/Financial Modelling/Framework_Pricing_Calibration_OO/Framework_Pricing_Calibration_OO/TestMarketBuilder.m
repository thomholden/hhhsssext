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



% define the struct for the stochastic volatility models 
sv_struct.maturities = [1 2 3];
sv_struct.strikes = [.8 .9 1 1.1 1.2 1.3];
sv_struct.striketype = 1;
sv_struct.volcube = [0.1 0.2 0.3 0.4 0.5 0.6; ...
                     0.11 0.21 0.31 0.41 0.51 0.61; ...
                     0.21 0.22 0.32 0.42 0.52 0.62];
sv_struct.quotetype = 'a';
sv_struct.underlying= 'eq';


mbd = marketbuilderdirector();   % init modelbuilderdirector
omb = optionmarketbuilder();      % init concrete builder (heston)
mbd.setmarketbuilder(omb); 
om = mbd.buildmarket(sv_struct); 

om.print()

clear om;
clear omb;
clear mbd;
clear sv_struct;

sv_struct.maturities = [];
sv_struct.strikes = [];
sv_struct.striketype = [];
sv_struct.volcube = [];
sv_struct.quotetype = [];
sv_struct.underlying= [];


mbd = marketbuilderdirector();   % init modelbuilderdirector
omb = optionmarketbuilder();      % init concrete builder (heston)
mbd.setmarketbuilder(omb); 
om = mbd.buildmarket(sv_struct); 

om.print()

clear om;
clear omb;
clear mbd;
clear sv_struct;