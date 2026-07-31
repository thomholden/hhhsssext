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



clear; clc;

%option parameter
T = 1.0;                    %option maturity
t0 = 0.0;                   %current time
S0 = 100;                   %spot price of underlying asset
d = 0.0;                    %dividend yield
df = 1.0;                   %discount factor
vecK = (1:1:200)';          %strike vector
ID = 1;                     %option Type ( call = 1, put = 2 )

%heston model parameter
% params.vInst = 0.04;      % instantaneous variance
% params.vLong = 0.04;        %long term variance
% params.kappa = 0.5;         %mean reversion speed
% params.omega = 0.2;         %volatility of variance
% params.rho = -0.8;          %correlation parameter
params(1) = 0.04; params(2) = 0.04; params(3) = 0.5; params(4) = 0.2; params(5) = -0.8;
% fft parameter
vecN = (8:13)'; eta = 0.1;
% dampening parameter of carr/madan
alpha = 1.5;
%volatility parameter for black scholes wise method
sigmabs = 0.4;

% modelbuilder
mbd = modelbuilderdirector();
heston.theta = params(1); heston.v0 = params(2);
heston.kappa = params(3); heston.omega = params(4); heston.rho = params(5);
heston.usetheta = true; heston.usev0 = true; heston.usekappa = true;
heston.userho = true; heston.useomega = true;

mbd.setmodelbuilder(hestonmodelbuilder());
model = mbd.buildmodel(heston, 'eq');
    
matPrice = zeros(length(vecK),length(vecN));

for i = 1:length(vecN)
     % black/scholes-wise method
     fftpricer = fftbs(vecN(i),eta,alpha, sigmabs, model);
     matPrice(:,i) = fftpricer.price(T,t0,S0,d,df,params,vecK./S0,ID);
     % cosine method 
     fftpricer = fftcos(vecN(i),12,model);
     matPrice(:,i) = fftpricer.price(T,t0,S0,d,df,params,vecK./S0,ID);
     % carr/madan
     fftpricer = fftcm(vecN(i),eta,alpha,model);
     matPrice(:,i) = fftpricer.price(T,t0,S0,d,df,params,vecK/S0,ID);
     % lewis method
     fftpricer = fftlewis(vecN(i),eta,model);
     matPrice(:,i) = fftpricer.price(T,t0,S0,d,df,params,vecK./S0,ID);
end

error = abs(repmat(matPrice(:,end),1,length(vecN)-1) - matPrice(:,1:end-1));

plot(vecK,log10(abs(repmat(matPrice(:,end),1,length(vecN)-1) - matPrice(:,1:end-1))));

xlabel('Strike')
ylabel(strcat({'Log_{10}(C_{'},num2str(2.^vecN(end)),'} - C_N)'),'Interpreter', 'tex')
legend(strcat({'N = '} ,num2str(2.^vecN(1:end-1))),'Position',[0.7264 0.174 0.1476 0.2409])
