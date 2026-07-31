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



%This Script file calculates the prices and greeks(delta,gamma)
%of a european call option with different fft methods(CarrMadan, Lewis,
%Cosine, Convolution) for the following models(Black/Scholes,
%Variance Gamma, CGMY, Heston)

%option parameters
S = 100;
K = (40:160)';
r = 0.02;
d = 0.01;
T = 0.1;

%model parameters Black/Scholes
modelBS.ID = 'BlackScholes';    %model identifyer
modelBS.params = 0.2;           %sigma

% model parameters Merton
%modelM.ID = 'Merton';
%modelM.params = [0.2; 0.05; 0.1; 0.1];

%model parameters Variance Gamma
modelVG.ID = 'VarianceGamma';   %model identifyer
modelVG.params = [0.125;        %sigma 
                  0.375;        %nu
                  0.2];         %theta

%model parameters CGMY
modelCGMY.ID = 'CGMY';          %model identifyer
modelCGMY.params = [1.0;        %C 
                  5.0;          %G
                  5.0;          %M
                  1.5];         %Y
              
%model parameters Heston
modelHeston.ID = 'Heston';      %model identifyer
modelHeston.params = [0.04;     %vInst 
                      0.04;     %vLong
                       1.5;     %kappa
                       0.5;     %omega
                     -0.8];     %rho             


%array containing all defined models
modelVec = [modelBS;modelVG;modelCGMY;modelHeston];

%fft parameter
N = 2^14; %2^10;
eta = 0.1;
L = 40; %20;

%result matrices
resultMatLewis = zeros(length(modelVec),length(K),3);
resultMatCarrMadan = resultMatLewis;
resultMatCosine = resultMatLewis;
resultMatConvolution = resultMatLewis;

%analytic Black/Scholes benchmark
benchmarkMat = resultMatLewis;

for i = 1:length(modelVec)
    [price_tmp, delta_tmp, gamma_tmp] = LewisCallPricingFFT(N,eta,modelVec(i),S,K,T,r,d);
    resultMatLewis(i,:,:) = [price_tmp, delta_tmp, gamma_tmp];
    [price_tmp, delta_tmp, gamma_tmp] = CarrMadanCallPricingFFT(N,eta,modelVec(i),S,K,T,r,d);
    resultMatCarrMadan(i,:,:) = [price_tmp, delta_tmp, gamma_tmp];
    [price_tmp, delta_tmp, gamma_tmp] = CosineMethodCallPricingFFT(N,L,modelVec(i),S,K,T,r,d);
    resultMatCosine(i,:,:) = [price_tmp, delta_tmp, gamma_tmp];
    [price_tmp, delta_tmp, gamma_tmp] = ConvolutionMethodCallPricingFFT(N,L,modelVec(i),S,K,T,r,d);
    resultMatConvolution(i,:,:) = [price_tmp, delta_tmp, gamma_tmp];
    if strcmp(modelVec(i).ID,'BlackScholes')
        benchmarkMat(i,:,1) = blsprice(S,K,r,T,modelVec(i).params,d);
        benchmarkMat(i,:,2) = blsdelta(S,K,r,T,modelVec(i).params,d);
        benchmarkMat(i,:,3) = blsgamma(S,K,r,T,modelVec(i).params,d);
    end
end

% fprintf('\nFFT Black/Scholes Call prices/delta/gamma for K=S')
% fprintf('\n-----------------------------------')
% fprintf('\nLewis Method: N = %d, eta = %1.3f',N,eta)
% fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', resultMatLewis(1,K==S,1),resultMatLewis(1,K==S,2),resultMatLewis(1,K==S,3))
% fprintf('\nCarr Madan Method: N = %d, eta = %1.3f',N,eta)
% fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', resultMatCarrMadan(1,K==S,1),resultMatCarrMadan(1,K==S,2),resultMatCarrMadan(1,K==S,3))
% fprintf('\nCosine Method: N = %d, L = %d',N,L)
% fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', resultMatCosine(1,K==S,1),resultMatCosine(1,K==S,2),resultMatCosine(1,K==S,3))
% fprintf('\nConvolution Method:  N = %d, L = %d',N,L')
% fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', resultMatConvolution(1,K==S,1),resultMatConvolution(1,K==S,2),resultMatConvolution(1,K==S,3))
% fprintf('\nAnalytic Formula:')
% fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', benchmarkMat(1,K==S,1),benchmarkMat(1,K==S,2),benchmarkMat(1,K==S,3))
% fprintf('\n-----------------------------------\n')
%
% figure
% plot(K,[resultMatLewis(1,:,2)',resultMatCarrMadan(1,:,2)',resultMatCosine(1,:,2)',resultMatConvolution(1,:,2)',benchmarkMat(1,:,2)'])
% legend('Lewis_\Delta', 'CarrMadan_\Delta', 'Cosine_\Delta','Convolution_\Delta','BlackScholes_\Delta')
% figure
% plot(K,[resultMatLewis(1,:,3)',resultMatCarrMadan(1,:,3)',resultMatCosine(1,:,3)',resultMatConvolution(1,:,3)',benchmarkMat(1,:,3)'])
% legend('Lewis_\Gamma', 'CarrMadan_\Gamma', 'Cosine_\Gamma','Convolution_\Gamma','BlackScholes_\Gamma')
% 
model = 4;
figure
plot(K,[resultMatLewis(model,:,1)',resultMatCarrMadan(model,:,1)',resultMatCosine(model,:,1)',resultMatConvolution(model,:,1)'])
legend('Lewis', 'CarrMadan', 'Cosine','Convolution')
figure
plot(K,[resultMatLewis(model,:,2)',resultMatCarrMadan(model,:,2)',resultMatCosine(model,:,2)',resultMatConvolution(model,:,2)'])
legend('Lewis_\Delta', 'CarrMadan_\Delta', 'Cosine_\Delta','Convolution_\Delta')
figure
plot(K,[resultMatLewis(model,:,3)',resultMatCarrMadan(model,:,3)',resultMatCosine(model,:,3)',resultMatConvolution(model,:,3)'])
legend('Lewis_\Gamma', 'CarrMadan_\Gamma', 'Cosine_\Gamma','Convolution_\Gamma')





