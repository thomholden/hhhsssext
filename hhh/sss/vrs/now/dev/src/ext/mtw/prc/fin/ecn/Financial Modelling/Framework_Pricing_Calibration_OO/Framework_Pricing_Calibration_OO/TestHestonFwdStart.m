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



% Test Heston Forward Start
%--------------------------------

% model parameter
vInst = 0.04;
vLong = 0.04;
kappa = 1.5;
omega = 0.5;
rho = -0.8;


% option description
S = 100;
K = (60:10:140)';
T_end = 1;
r = 0.03;
d = 0;

% forward start time
t_start = 0.01;


params.v0 = vInst;
params.theta = vLong;
params.kappa = kappa;
params.omega = omega;
params.rho = rho;

model = hestonmodel(params);

% sigma = 0.2;
% params.sigma = sigma;
% model = bsmodel(params);

N = 18;
eta = 0.05;
alpha = .75;
fftpricer_cm = fftcm(N,eta,alpha,model);

L = 10;
fftpricer_cos = fftcos(N,L,model);


P0T = exp(-r*T_end);
% call prices
c_cm = fftpricer_cm.price(T_end,t_start,S,d,P0T,model.parvec,K/S,ones(1,length(K)));

c_cos = fftpricer_cos.price(T_end,t_start,S,d,P0T,model.parvec,K/S,ones(1,length(K)));

display(c_cm)
display(c_cos)