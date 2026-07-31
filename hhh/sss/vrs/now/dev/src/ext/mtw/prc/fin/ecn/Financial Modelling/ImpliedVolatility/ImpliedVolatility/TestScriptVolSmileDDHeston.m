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


%% Parameters
S = 100;                                   % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];      % maturities

r = 0;                      % discount factors
d = 0;                              % dividends

K = 80:1:120;                           % Strike range

rows = length(T);
cols = length(K);

FFTopt = ones(rows,cols);                   % initializing matrix -> stores the model prices 
ImpliedVol = FFTopt;                        % stores implied volatilities

tit = 'Implied Volatility - DD Heston Model';

legend_base = 'Base scenario';

%% Specify the base model 
vInst = 0.02;                  % instantanuous variance of base parameter set  
vLong = 0.02;                  % long term variance of base parameter set
kappa = 0.1;                   % mean reversion speed of variance of base parameter set
omega = 0.2;                   % volatility of variance of base parameter set
rho = 0;                       % correlation of base parameter set                   
lambda = 1;                     % lambda
b = 0.5;                       % displacement parameter
% cf (characteristic function) for the heston model

for j=1:rows    %wrt time
    FFTopt(j,:) = CallPricingFFT('DDHeston',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho, lambda,b);
    ImpliedVol(j,:) = blsimpv(S, K, r, T(j), FFTopt(j,:));
end

%% Prepare
FFTopt_low = FFTopt; FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol; ImpliedVol_high = ImpliedVol;


%% Changing lambda
lambda_low = .2;
lambda_high = 1.8;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = CallPricingFFT('DDHeston',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho, lambda_low, b);
    FFTopt_high(j,:) = CallPricingFFT('DDHeston',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho, lambda_high, b);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

%% Changing b
b_low = 0.3;
b_high = 0.7;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = CallPricingFFT('DDHeston',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho, lambda, b_low);
    FFTopt_high(j,:) = CallPricingFFT('DDHeston',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho, lambda, b_high);
    
    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing a low';
legend_high = 'Changing a high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);