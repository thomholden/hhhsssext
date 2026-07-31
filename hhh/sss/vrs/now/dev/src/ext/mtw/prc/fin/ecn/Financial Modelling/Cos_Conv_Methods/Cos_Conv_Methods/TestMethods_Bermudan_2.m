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



% TestMethods_B
% Pricing American options using CONV and COS method
% Calculate  speed and deviation from reference value for a Bermudan
%    option dependent on the size of the grid
% Model : Heston model
% Method; COS and CONV

clear; clc;
n = (9:15)';            % choose number of grid points (applied to Bermudan only), N = 2^n
num = size(n, 1);
Nex = 30;               % number of exercise opportunities

S0 = 100;                   % price of underlying
strike = 110;      % strike price

r = 0.1;                    % annual risk-free rate (cc)
t = 1/12;                    % time to maturity
q = 0;                      % annual dividend yield (cc)

cp = -1;                     % choice of call (=1) or put (=-1)

% The Heston model and its parameters
model = 'Heston';
vInst = 0.02;
vLong=0.02;
kappa = 0.2;
omega = .5;
rho = -.8;

% COS method
Lcos = 13;     
% cumulants for the Heston model
c1 = (r-q).*t + 0.5*((1-exp(-kappa*t))*(vLong-vInst)/kappa - vLong*t);
c2 = abs(1/8/kappa^2*(omega*t.*exp(-kappa*t)*(vInst-vLong)*(8*kappa*rho-4*omega)...
                    +8*rho*omega*(1-exp(-kappa*t))*(2*vLong-vInst)...
                    +2*vLong*t*(-4*kappa*rho*omega + omega^2 + 4*kappa^2)...
                    +omega^2/kappa*((vLong-2*vInst)*exp(-2*kappa*t)...
                    +vLong*(6*exp(-kappa*t)-7)+2*vInst)...
                    +8*kappa*(vInst-vLong)*(1-exp(-kappa*t))));
c4 = 0.0;
            
mu = (r-q).*t + 0.5*((1-exp(-kappa*t))*(vLong-vInst)/kappa - vLong*t);

c = [c1, c2, c4];
% pricing function
pricefunccos = @(x) double(FFTCOS_B(x, Nex, Lcos, c, cp, model, S0, t, r, q, strike, vInst, vLong, kappa, omega,rho));     

% CONV method
delta = 40;
Lconv = delta * sqrt(t *(c2 + r));
pricefuncconv = @(x) double(FFTCONV_B(x, Lconv, 0.5, cp, model, S0, t, r, q, strike, Nex, vInst, vLong, kappa, omega,rho));

result_p = zeros(2, size(n,1));
result_t = result_p;

NAverage = 50;
refval = pricefunccos(15);          % reference price using COS method
for k = 1:size(n)
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefunccos(n(k));
    end
    result_t(1,k) = (cputime - res_t) / NAverage * 1000;
    result_p(1,k) = (refval - res)/refval*10000;
    
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefuncconv(n(k));
    end
    result_t(2,k) = (cputime - res_t) / NAverage * 1000;
    result_p(2,k) = (refval - res)/refval*10000;
end

% plotting
YMatrix = [log(abs(result_p(1,:))); log(abs(result_p(2,:)))];
createfigure_convergence_b(n,YMatrix,'Error','COS','CONV');
%plot(n,[log(abs(result_p(1,:))); log(abs(result_p(2,:))); log(abs(result_p(3,:)));log(abs(result_p(4,:)))]);
YMatrix = [log(abs(result_t(1,:))); log(abs(result_t(2,:)))];
createfigure_convergence_b(n,YMatrix,'CPU Time','COS','CONV');
figure('Color',[1 1 1]);box('on');hold on; 
plot(result_t(1,:),log(abs(result_p(1,:))),'Color',[0 0 0],'Marker','v','LineStyle','--','DisplayName','COS');
plot(result_t(2,:),log(abs(result_p(2,:))),'Color',[0 0 0],'Marker','diamond','LineStyle',':','DisplayName','CONV');
% Create xlabel
xlabel('CPU Time');

% Create ylabel
ylabel('log(rel. error)');

% Create title
title('Time / Error Plot');

% Create legend
legend('show');
hold off;
%result_t
%result_p

