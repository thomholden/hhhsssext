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
F = 100;                            % Spot prices
T = 1;                              % maturity

K = 20:1:180;                       % Strike range

cols = length(K);

tit = 'Implied Volatility - SABR';
legend_base = 'Base scenario';

%% Specify the base model 
alpha = 0.2;                % instantanuous variance of base parameter set  
beta = 0.5;                 % long term variance of base parameter set
rho = 0;                    % mean reversion speed of variance of base parameter set
nu = 0.2;                   % volatility of variance of base parameter set


ImpliedVol = svol_2(alpha, beta, rho, nu, F, K, T);

%% Changing vInst
alpha_low = 0.1;
alpha_high = 0.3;

    ImpliedVol_low = svol_2(alpha_low, beta, rho, nu, F, K, T);
    ImpliedVol_high = svol_2(alpha_high, beta, rho, nu, F, K, T);
    
legend_low = 'Changing \alpha low';
legend_high = 'Changing \alpha high';

createfigure_smile(K,ImpliedVol, ImpliedVol_low, ImpliedVol_high, tit, legend_base, legend_low, legend_high);


%% Changing vLong
beta_low = 0.1;
beta_high = 0.7;

    ImpliedVol_low = svol_2(alpha, beta_low, rho, nu, F, K, T);
    ImpliedVol_high = svol_2(alpha, beta_high, rho, nu, F, K, T);
    

legend_low  = 'Changing \beta low';
legend_high = 'Changing \beta high';

createfigure_smile(K,ImpliedVol, ImpliedVol_low, ImpliedVol_high, tit, legend_base, legend_low, legend_high);
%% Changing kappa
rho_low = -0.8;
rho_high = 0.8;

    ImpliedVol_low = svol_2(alpha, beta, rho_low, nu, F, K, T);
    ImpliedVol_high = svol_2(alpha, beta, rho_high, nu, F, K, T);
    

legend_low  = 'Changing \rho low';
legend_high = 'Changing \rho high';

createfigure_smile(K,ImpliedVol, ImpliedVol_low, ImpliedVol_high, tit, legend_base, legend_low, legend_high);
%% Changing omega
nu_low = 0.1;
nu_high = 0.8;

    ImpliedVol_low = svol_2(alpha, beta, rho, nu_low, F, K, T);
    ImpliedVol_high = svol_2(alpha, beta, rho, nu_high, F, K, T);


legend_low  = 'Changing \nu low';
legend_high = 'Changing \nu high';

createfigure_smile(K,ImpliedVol, ImpliedVol_low, ImpliedVol_high, tit, legend_base, legend_low, legend_high);
%% Changing F
F_low = 95;
F_high = 105;

    ImpliedVol_low = svol_2(alpha, beta, rho, nu, F_low, K, T);
    ImpliedVol_high = svol_2(alpha, beta, rho, nu, F_high, K, T);
    

legend_low  = 'Changing F(0) low';
legend_high = 'Changing F(0) high';

createfigure_smile(K,ImpliedVol, ImpliedVol_low, ImpliedVol_high, tit, legend_base, legend_low, legend_high);
