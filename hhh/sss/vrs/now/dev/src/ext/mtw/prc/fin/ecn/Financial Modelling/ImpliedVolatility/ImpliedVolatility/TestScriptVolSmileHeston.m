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
S = 100;                         % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];      % maturities

r = 0;                           % discount factors
d = 0;                           % dividends

K = 80:1:120;                    % Strike range

rows = length(T);cols = length(K);

FFTopt = ones(rows,cols);                   % initializing matrix -> stores the model prices 
ImpliedVol = FFTopt;                        % stores implied volatilities

tit = 'Implied Volatility - Heston Model';
legend_base = 'Base scenario';

%% Specify the base model 
vInst = 0.02;                  % instantanuous variance of base parameter set  
vLong = 0.02;                  % long term variance of base parameter set
kappa = 0.1;                   % mean reversion speed of variance of base parameter set
omega = 0.2;                   % volatility of variance of base parameter set
rho = 0;                       % correlation of base parameter set


for j=1:rows    %wrt time
    FFTopt(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho);
    ImpliedVol(j,:) = blsimpv(S, K, r, T(j), FFTopt(j,:));
end

%% Prepare
FFTopt_low = FFTopt; FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol; ImpliedVol_high = ImpliedVol;

%% Changing vInst (V(0)
vInst_low = 0.015;
vInst_high = 0.025;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst_low,vLong,kappa,omega,rho);
    FFTopt_high(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst_high,vLong,kappa,omega,rho);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing V(0) low';
legend_high = 'Changing V(0) high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);


%% Changing vLong(Theta)
vLong_low = 0.015;
vLong_high = 0.025;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong_low,kappa,omega,rho);
    FFTopt_high(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong_high,kappa,omega,rho);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing \Theta low';
legend_high = 'Changing \Theta high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

%% Changing kappa
kappa_low = 0.05;
kappa_high = 0.2;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong,kappa_low,omega,rho);
    FFTopt_high(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong,kappa_high,omega,rho);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing \kappa low';
legend_high = 'Changing \kappa high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

%% Changing nu
omega_low = 0.1;
omega_high = 0.4;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong,kappa,omega_low,rho);
    FFTopt_high(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong,kappa,omega_high,rho);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing \nu low';
legend_high = 'Changing \nu high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

%% Changing rho
rho_low = -0.8;
rho_high = 0.8;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho_low);
    FFTopt_high(j,:) = CallPricingFFT('Heston',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho_high);
        % lp(S,K,T,r,d,vInst,vLong,kappa,omega,rho)
    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing \rho low';
legend_high = 'Changing \rho high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);
