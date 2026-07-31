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
sv_struct.kappa = 0.5;
sv_struct.omega = 0.15;
sv_struct.theta = 0.2;
sv_struct.rho = -0.7;
sv_struct.v0 = 0.2;
sv_struct.S0 = 100.0;
sv_struct.lambda = 0.06;
sv_struct.muj = 0.05;
sv_struct.sigmaj = 0.1;

vg_struct.c = 1;
vg_struct.g = 1;
vg_struct.m = 1;
vg_struct.S0 = 100;
vg_struct.cgm = true;

mbd = modelbuilderdirector();   % init modelbuilderdirector
hmb = hestonmodelbuilder();      % init concrete builder (heston)
vgmb = vgmodelbuilder();
mbd.setmodelbuilder(hmb);       % pass concrete builde to director
hm = mbd.buildmodel(sv_struct,'eq'); 

bmb = batesmodelbuilder();      % init concrete builder (bates)
mbd.setmodelbuilder(bmb);       % pass concret builder to director
bm = mbd.buildmodel(sv_struct, 'eq');

mbd.setmodelbuilder(vgmb);
vgm = mbd.buildmodel(vg_struct, 'eq');
hm.print()
bm.print()
vgm.print()
clear hm;
clear bm;
clear vgm;
clear hmb;
clear bmb;
clear vgmb;
clear mbd;
clear sv_struct;
clear vg_struct;