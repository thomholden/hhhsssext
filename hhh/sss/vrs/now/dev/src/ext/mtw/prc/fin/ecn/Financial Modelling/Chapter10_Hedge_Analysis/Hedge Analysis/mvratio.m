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
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function y = mvratio(S0,Strike, prices, K, levymeasure,dt,i_ub)

% add = zeros(1);
% prices = [prices;add'];
% discretizes the intergal
xval2 = dt:dt:i_ub;
xval1 = -xval2;

% denominator
v = interp1(Strike,prices,K,'spline');     % option value at K
f2 = @(x) (exp(x) - 1) .* levymeasure(x);
s2 = v * dt*(sum(f2(xval1)) + sum(f2(xval2)));

% nominator

% minus part
f3 = @(x) (exp(x)-1).^2 .* levymeasure(x);
s3 = dt*(sum(f3(xval1)) + sum(f3(xval2)));
% plus part   
s1 = zeros(length(K),1);
    
Xval1 = (exp(xval1) - 1) .* exp(xval1) .*  levymeasure(xval1);
Xval2 = (exp(xval2) - 1) .* exp(xval2) .*  levymeasure(xval2);

    for jj = 1:length(K)
        Ka = K(jj)*exp(-xval1);
        a = interp1(Strike,prices,Ka);
        Kb = K(jj)*exp(-xval2);
        b = interp1(Strike,prices,Kb);
        s1(jj) = (sum(Xval1 .* a) ...
            + sum(Xval2.*b))*dt;
    end

% putting everything together
num = s1-s2;
denum = s3;

y = num/denum/S0;
end