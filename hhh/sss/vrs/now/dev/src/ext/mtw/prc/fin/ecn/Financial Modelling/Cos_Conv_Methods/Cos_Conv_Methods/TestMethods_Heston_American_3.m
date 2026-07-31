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



% TestMethods_Heston_A3
% Pricing American options using CONV and COS method
% Calculate  speed and deviation from reference value for an American
%    option to a Bermudan changing the number of grid points
% Model : Heston model
% Method; COS and CONV

clear; clc;
n = (5:15);             % N = 2^n grid points
Nex = 12;               % number of exercise opportunities
num = size(n, 2);

S0 = 100;               % spot price of underlying
strike = 110;           % strike price

r = 0.1;                % risk-free rate
t = 1;                  % term to maturity
q = 0;                  % dividend yield

cp = -1;                % call (1) put (-1)

parity = 0;             % use put-call parity (1) or not (0)
% The Heston model
model = 'Heston';
vInst = 0.02;
vLong = 0.02;
kappa = 0.2;
omega = .5;
rho = -.8;

c1 = (r-q).*t + 0.5*((1-exp(-kappa*t))*(vLong-vInst)/kappa - vLong*t);
c2 = abs(1/8/kappa^2*(omega*t.*exp(-kappa*t)*(vInst-vLong)*(8*kappa*rho-4*omega)...
                    +8*rho*omega*(1-exp(-kappa*t))*(2*vLong-vInst)...
                    +2*vLong*t*(-4*kappa*rho*omega + omega^2 + 4*kappa^2)...
                    +omega^2/kappa*((vLong-2*vInst)*exp(-2*kappa*t)...
                    +vLong*(6*exp(-kappa*t)-7)+2*vInst)...
                    +8*kappa*(vInst-vLong)*(1-exp(-kappa*t))));
c4 = 0.0;
            
mu = (r-q).*t + 0.5*((1-exp(-kappa*t))*(vLong-vInst)/kappa - vLong*t);

result_p = zeros(2, num);
result_t = result_p;

NAverage = 5;
d = 6;
% COSINE method
Lcos = 13;     

c = [c1 c2 c4];
% pricing function for a Bermudan option and the COS method
pricefunccosb = @(x) FFTCOS_B(x, Nex, Lcos, c, cp, model, S0, t, r, q, strike, vInst, vLong, kappa, omega,rho);
% reference value an American option using Richardson extrapolation
refa_cos =1/21 * ...
    (64* FFTCOS_B(15, 2^(d+3), Lcos, c, cp, model, S0, t, r, q, strike, vInst, vLong, kappa, omega,rho) ...
    - 56*FFTCOS_B(15, 2^(d+2), Lcos, c, cp, model, S0, t, r, q, strike, vInst, vLong, kappa, omega,rho) ...
    + 14*FFTCOS_B(15, 2^(d+1), Lcos, c, cp, model, S0, t, r, q, strike, vInst, vLong, kappa, omega,rho) ...
    - FFTCOS_B(15, 2^d, Lcos, c, cp, model, S0, t, r, q, strike, vInst, vLong, kappa, omega,rho));

% CONV method
delta = 40;
Lconv = 3;% delta * sqrt(t *(c2^2 + t^2));
% pricing function for a Bermudan option and the CONV method
pricefuncconvb = @(x) FFTCONV_B(x, Lconv, 0.5, cp, model, S0, t, r, q, strike, Nex, vInst, vLong, kappa, omega,rho);
% refrence value an American option using Richardson extrapolation
refa_conv = 1/21 * ...
   (64* FFTCONV_B(15, Lconv, 0.5, cp, model, S0, t, r, q, strike, 2^(d+3), vInst, vLong, kappa, omega,rho) ...
   - 56*FFTCONV_B(15, Lconv, 0.5, cp, model, S0, t, r, q, strike, 2^(d+2), vInst, vLong, kappa, omega,rho) ...
   + 14*FFTCONV_B(15, Lconv, 0.5, cp, model, S0, t, r, q, strike, 2^(d+1), vInst, vLong, kappa, omega,rho) ...
   - FFTCONV_B(15, Lconv, 0.5, cp, model, S0, t, r, q, strike, 2^(d), vInst, vLong, kappa, omega,rho));

for k = 1:num
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefunccosb(n(k));
    end
    result_t(1,k) = (cputime - res_t) / NAverage * 1000;
    result_p(1,k) = (refa_cos - res)/refa_cos;
    
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefuncconvb(n(k));
    end
    result_t(2,k) = (cputime - res_t) / NAverage * 1000;
    result_p(2,k) = (refa_conv - res)/refa_conv;
end

YMatrix = [(abs(result_p(1,:))); (abs(result_p(2,:)))];
createfigure_convergence_ab(n,YMatrix,'Error','COS','CONV','rel. error (%)');
%plot(n,[log(abs(result_p(1,:))); log(abs(result_p(2,:))); log(abs(result_p(3,:)));log(abs(result_p(4,:)))]);
YMatrix = [(abs(result_t(1,:))); (abs(result_t(2,:)))];
createfigure_convergence_ab(n,YMatrix,'CPU Time','COS','CONV','CPU Time (msec)');
figure('Color',[1 1 1]);box('on');hold on; 
plot(result_t(1,:),(abs(result_p(1,:))),'Color',[0 0 0],'Marker','v','LineStyle','--','DisplayName','COS');
plot(result_t(2,:),(abs(result_p(2,:))),'Color',[0 0 0],'Marker','diamond','LineStyle',':','DisplayName','CONV');
% Create xlabel
xlabel('CPU Time');

% Create ylabel
ylabel('rel. error (%)');

% Create title
title('Time / Error Plot');

% Create legend
legend('show');
hold off;
%result_t
%result_p

