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
T = 1.0;                    % option maturity
t0 = 0.0;                   % fwd start time
S0 = 100;                   % spot price of underlying asset
d = 0.0;                    % dividend yield
df = 1.0;                   % discount factor
vecK = (1:200)';            % strike vector
ID = ones(200,1);           % option Type ( call = 1, put = 2 )

%vaiance gamma model parameter (nu, sigma, theta)
sigma = 0.25;        %
nu = 2.0;
theta = -0.1;        %

% recalculate to use a cgm parametrisation
params(1) = 1/nu;
params(2) = 1/(sqrt(0.25*theta^2*nu^2+0.5*sigma^2*nu)-0.5*theta*nu); 
params(3) = 1/(sqrt(0.25*theta^2*nu^2+0.5*sigma^2*nu)+0.5*theta*nu);

% modelbuilder for variance gamma model
mbd = modelbuilderdirector();
vg.c = params(1); vg.g = params(2); vg.m = params(3); vg.cgm = true;
vg.usec = true; vg.useg = true; vg.usem = true;
mbd.setmodelbuilder(vgmodelbuilder());
model = mbd.buildmodel(vg, 'eq');

% fft parameter
vecN = [12;13]; %2^12 = 4096, 2^13 = 8192
eta = 0.1;

%dampening parameter of carr-madan and carr-madan bs
alpha = 1.5;                
%volatility parameter for black scholes wise method
sigmabs = 0.4;

matPrice = zeros(length(vecK),length(vecN)*4);


for i = 1:length(vecN)
    %carr madan
    fftpricerCM = fftcm(vecN(i),eta,alpha, model);
    matPrice(:,4*(i-1)+1) = fftpricerCM.price(T,t0,S0,d,df,params,vecK./S0,ID);
    %carr madan + black scholes
    fftpricerCMBS = fftbs(vecN(i),eta,alpha,sigma,model);
    matPrice(:,4*(i-1)+2) = fftpricerCMBS.price(T,t0,S0,d,df,params,vecK./S0,ID);
    %cosine method
    fftpricerCOS = fftcos(vecN(i),12,model);
    matPrice(:,4*(i-1)+3) = fftpricerCOS.price(T,t0,S0,d,df,params,vecK./S0,ID);
    %lewis method
    fftpricerLewis = fftlewis(vecN(i),eta,model);
    matPrice(:,4*(i-1)+4) = fftpricerLewis.price(T,t0,S0,d,df,params,vecK./S0,ID);
    
    clear fftpricerCM fftpricerCMBS fftpricerCOS fftpricerLewis
end

% plotting
plot(vecK,(matPrice(:,5:end) - matPrice(:,1:4))./matPrice(:,5:end));
xlabel('Strike')
ylabel('(C_{8192} - C_{4096})/C_{8192}','Interpreter', 'tex')
legend('carr/madan', 'black/scholes-wise', 'cosine', 'lewis')