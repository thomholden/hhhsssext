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
S = 100;                            % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];         % maturities

r = 0.0;                            % zero rate
d = 0;                              % dividends

K = 80:1:120;                       % Strike range

rows = length(T);
cols = length(K);

FFTopt = ones(rows,cols);           % stores the model prices 
ImpliedVol = FFTopt;                % stores implied volatilities

tit = 'Implied Volatility - NIG GOU';

legend_base = 'Base scenario';

%% Specify the base model 
alpha = 6.1882;                     % NIG model parameter
beta = 0;                           % NIG model parameter
delta = 0.1622;                     % NIG model parameter
mu = 0;                             % NIG model parameter

a = 1.2517;                         % GOU clock parameter
b = 0.5841;                         % GOU clock parameter
lambda = 0.6282;                    % GOU clock parameter

for j=1:rows    %wrt time
    FFTopt(j,:) = CallPricingFFT('NIGOU',S,K,T(j),r,d,alpha,beta,delta,lambda,a,b);

    ImpliedVol(j,:) = blsimpv(S, K, r, T(j), FFTopt(j,:));
end

%% Prepare
FFTopt_low = FFTopt; FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol; ImpliedVol_high = ImpliedVol;

%% Changing lambda
lambda_low = .25;
lambda_high = 1.5;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('NIGOU',S,K,T(j),r,d,alpha,beta,delta,lambda_low,a,b);
    FFTopt_high(j,:) = CallPricingFFT('NIGOU',S,K,T(j),r,d,alpha,beta,delta,lambda_high,a,b);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);


%% Changing a
a_low = .25;
a_high = 3;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('NIGOU',S,K,T(j),r,d,alpha,beta,delta,lambda,a_low,b);
    FFTopt_high(j,:) = CallPricingFFT('NIGOU',S,K,T(j),r,d,alpha,beta,delta,lambda,a_high,b);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing a low';
legend_high = 'Changing a high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);

%% Changing b
b_low = .25;
b_high = 3;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('NIGOU',S,K,T(j),r,d,alpha,beta,delta,lambda,a,b_low);
    FFTopt_high(j,:) = CallPricingFFT('NIGOU',S,K,T(j),r,d,alpha,beta,delta,lambda,a,b_high);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing b low';
legend_high = 'Changing b high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);
