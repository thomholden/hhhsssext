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



%clear; clc;
S0 = 100; r = 0.03; d = 0.0; T = 1; K = 100;

%number = 0.1:0.1:3;
number = 3;
mv = zeros(length(number),3);
for kk = 1:length(number)

i_lb = -number(kk); i_ub = -i_lb;

int_step = 0.01;
intrange = i_lb:int_step:i_ub;
Strike = 1:1:400;%exp(intrange) *K;
Strike1 = 1:1:4000;

cp = 1;             % choice of call (=1) or put (=-1)
parity = 0;                    % use put-call parity (1) or not (0)


model = 'Merton';       % choice of asset price model

% Selection of share price model parameters
switch model
    
    case 'BlackScholes'
        sigma = 0.25;                % volatility of the share, per sqrt(unit) time
        
        L = 10; n = 6;
        
        mu = (r - d - 0.5 * sigma^2) * T;
        
        c1 = mu;
        c2 = sigma^2 * T;
        c4 = 0;
        c = [c1, c2, c4];
        prices = FFTCOS_E(n, L, c, cp, model, S0, T, r, d, Strike', sigma);
        levymeasure = @(x) 0;
    case 'Merton'
        sigma =0.25; 
        mu_j = 0.05;
        sigma_j = 0.15;
        lambda = 0.1;
        
        L = 20; n = 13;
        
        c1 = (r-d + lambda*mu_j - 0.5*sigma^2).*T;
        c2 = (lambda*(sigma_j^2+mu_j^2)+sigma^2).*T; 
        c4 = (lambda*(3*sigma_j^2*(sigma_j^2+2*mu_j^2)+mu_j^4)).*T;
        c = [c1, c2, c4];
        prices1 = FFTCOS_E(n, L, c, cp, model, S0, T, r, d, Strike', sigma, mu_j, sigma_j, lambda);
        prices = zeros(4000,1);
        prices(1:length(prices1)) = prices1;
        levymeasure = @(x) lambda / (2*pi*sigma_j) * exp(-0.5*(x-mu_j).^2/sigma_j^2);
    case 'VarianceGamma'
        sigma = 0.12;                % volatility of the share, per sqrt(unit) time
        theta = -0.14;
        nu = 0.2;
        
        L = 20; n = 13;
        
        mu = (r - d + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));
        
        c1 = (mu + theta) * T;
        c2 = (sigma^2 + nu * theta^2) * T;
        c4 = 3 * (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * T;
        c = [c1, c2, c4];
        prices1 = FFTCOS_E(n, L, c, cp, model, S0, T, r, d, Strike', sigma, nu, theta);
        prices = zeros(4000,1);
        prices(1:length(prices1)) = prices1;
        levymeasure = @(x) levymvg(x,sigma,nu,theta);
    case 'NIG'
        alphaNIG = 18.42141;
        betaNIG = -15.08623;
        deltaNIG =  0.31694;
        
        L = 20; n = 12;
        
        mu = r - d;
        
        c1 = ((betaNIG*deltaNIG)/(sqrt(alphaNIG^2 - betaNIG^2)) + mu) * T;
        c2 = T * alphaNIG^2 * deltaNIG / ((alphaNIG^2 - betaNIG^2)^(3/2));
        c4 = 3 * T * alphaNIG^2 * (alphaNIG^2 + 4*betaNIG^2) * deltaNIG / ((alphaNIG^2 - betaNIG^2)^(7/2));
        c = [c1, c2, c4];
        
        prices1 = FFTCOS_E(n, L, c, cp, model, S0, T, r, d, Strike', alphaNIG, betaNIG, 0, deltaNIG);
        prices = zeros(4000,1);
        prices(1:length(prices1)) = prices1;
        levymeasure = @(x) levymnig(x,alphaNIG,betaNIG,deltaNIG);
end


mv(kk,1) = Strike(1);
mv(kk,2) = Strike(end);
mv(kk,3) = mvratio(S0,Strike1,prices,K,levymeasure,i_lb,i_ub);


end
K = 10:.5:190;
result = mvratio1(S0,Strike1,prices,K',levymeasure,0.1,3);
figure('Color', [1 1 1]);plot(K,result,'-o','Color', [0 0 0]);
xlabel('Strike');
ylabel('Mean Variance Ratio');
title(model);

