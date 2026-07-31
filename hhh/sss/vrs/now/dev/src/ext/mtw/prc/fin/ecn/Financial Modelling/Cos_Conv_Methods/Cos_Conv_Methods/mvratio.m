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



% function y = mvratio(S0,Strike, prices, K, levymeasure,i_lb,i_ub)
% 
% v = interp1(Strike,prices,K,'linear','extrap');
% 
% f1 = @(x) (exp(x) - 1) .* exp(x) .* interp1(Strike,prices,K*exp(-x)) .* levymeasure(x);
% 
% f2 = @(x) v * (exp(x) - 1) .* levymeasure(x);
% 
% f3 = @(x) (exp(x)-1).^2 .* levymeasure(x);
% 
% eps = 10^(-8);
% 
% s1 = quad(f1,i_lb,-eps) + quad(f1,eps,i_ub);
% s2 = quad(f2,i_lb,-eps) + quad(f2,eps,i_ub);
% s3 = quad(f3,i_lb,-eps) + quad(f3,eps,i_ub);
% 
% num = s1-s2;
% denum = s3;
% 
% y = num/denum/S0;


function y = mvratio(S0,Strike, prices, K, levymeasure,i_lb,i_ub)

v = interp1(Strike,prices,K,'linear','extrap');     % option values at K

f2 = @(x) (exp(x) - 1) .* levymeasure(x);

f3 = @(x) (exp(x)-1).^2 .* levymeasure(x);

eps = 10^(-8);

    s2 = v * (quad(f2,i_lb,-eps) + quad(f2,eps,i_ub));
    s3 = quad(f3,i_lb,-eps) + quad(f3,eps,i_ub);
    s1 = zeros(length(K),1);

    for jj = 1:length(K)
        f1 = @(x) (exp(x) - 1) .* exp(x) .* interp1(Strike,prices,K(jj)*exp(-x)) .* levymeasure(x);
        s1(jj) = quad(f1,i_lb,-eps) + quad(f1,eps,i_ub);
    end

num = s1-s2;
denum = s3;

y = num/denum/S0;