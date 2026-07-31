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

tit = 'Implied Volatility - Heston-Hull-White Model';

legend_base = 'Base scenario';

%% Specify the base model 
vInst = 0.02;                  % instantanuous variance of base parameter set  
vLong = 0.02;                  % long term variance of base parameter set
kappa = 0.1;                   % mean reversion speed of variance of base parameter set
omega = 0.2;                   % volatility of variance of base parameter set
rho = 0;                       % correlation of base parameter set

lambda = 0.2;
eta = 0.02;

icurveData =  [0.999884333380315;0.996803132736937;0.993568709230647;0.990285301195274;0.986945903402709;0.983557350486521;0.980185549124449;0.976782934344041;0.973361992614499;0.969976793305220;0.966616749933289;0.962914317958160;0.959904777446077;0.920091903961326;0.882870065420196;0.847186544281939;0.812742515687365;0.779459552415061;0.747152463119429;0.715745016074346;0.685138723808460;0.655753392359115;0.627333845297308;0.599226698198774;0.572763319281569;0.547259133751455;0.523441996253080;0.499646068368557;0.477507905873099;0.456481811728753;0.436385788738282;0.417350253831050;0.399187111819286;0.381865611666566;0.365435617455498;0.349786183601181;0.334806921914717;0.320548897004994;0.306983265264429;0.294081800917050;0.282443547729164;0.269929224010243];
icurveDates = [734472;734501;734534;734562;734591;734622;734653;734683;734713;734744;734775;734807;734836;735202;735567;735931;736298;736663;737028;737393;737758;738125;738489;738854;739219;739585;739949;740316;740680;741046;741411;741776;742140;742507;742872;743237;743602;743967;744334;744698;745063;745429];
icurveInterpMethod = 'spline';
icurveType = 'Discount';
icurveSettle = 734471;
irdc = IRDataCurve(icurveType,icurveSettle,icurveDates,icurveData);

CP = ones(1,length(K));

for j=1:rows    %wrt time
    r=0;
    FFTopt(j,:) = CallPricingFFT('HestonHullWhite',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho,lambda,eta,irdc);
    r = -log(interp1(icurveDates,icurveData,icurveSettle+360*T(j)))/T(j);
    ImpliedVol(j,:) = blsimpv(S, K, r, T(j), FFTopt(j,:));
    %ImpliedVol(j,:) = impliedvola(S*exp(r*T(j)),K,T(j),FFTopt(j,:),CP);% 
end

%% Prepare
FFTopt_low = zeros(rows,cols);
FFTopt_high = zeros(rows,cols);
ImpliedVol_low = zeros(rows,cols);
ImpliedVol_high = zeros(rows,cols);

%% Changing lambda
lambda_low = .1;                    % changing parameter (low value)
lambda_high = .3;                   % changing parameter (high value)


for j=1:rows    %wrt time
    r=0;
    FFTopt_low(j,:) = CallPricingFFT('HestonHullWhite',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho,lambda_low,eta,irdc);
    FFTopt_high(j,:) = CallPricingFFT('HestonHullWhite',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho,lambda_high,eta,irdc);

    r = -log(interp1(icurveDates,icurveData,icurveSettle+360*T(j)))/T(j);
    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);


%% Changing eta_base
eta_low = .01;
eta_high = .03;

for j=1:rows    %wrt time
    r= 0;
    FFTopt_low(j,:) = CallPricingFFT('HestonHullWhite',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho,lambda,eta_low,irdc);
    FFTopt_high(j,:) = CallPricingFFT('HestonHullWhite',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho,lambda,eta_high,irdc);

    r = -log(interp1(icurveDates,icurveData,icurveSettle+360*T(j)))/T(j);
    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing \eta low';
legend_high = 'Changing \eta high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

%% Changing curve_base
zero = -log(icurveData)./(icurveDates-icurveSettle)*360 - 0.001;
icurveData_low = exp(-zero .*(icurveDates-icurveSettle)/360);
zero = -log(icurveData)./(icurveDates-icurveSettle)*360 + 0.001;
icurveData_high = exp(-zero .*(icurveDates-icurveSettle)/360);

irdc_low = IRDataCurve(icurveType,icurveSettle,icurveDates,icurveData_low);
irdc_high = IRDataCurve(icurveType,icurveSettle,icurveDates,icurveData_high);

for j=1:rows    %wrt time
    r=0;
    FFTopt_low(j,:) = CallPricingFFT('HestonHullWhite',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho,lambda,eta,irdc_low);
    FFTopt_high(j,:) = CallPricingFFT('HestonHullWhite',S,K,T(j),r,d,vInst,vLong,kappa,omega,rho,lambda,eta,irdc_high);
 
    r = -log(interp1(icurveDates,icurveData,icurveSettle+360*T(j)))/T(j);
    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end


legend_low  = 'Changing curve low';
legend_high = 'Changing curve high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

