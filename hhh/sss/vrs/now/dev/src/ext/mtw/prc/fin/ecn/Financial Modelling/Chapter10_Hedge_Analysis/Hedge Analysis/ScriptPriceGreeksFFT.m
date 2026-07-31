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
K = (20:180)';
r = 0.03;
d = 0.0;
T = 1;

%model parameters Black/Scholes
modelBS.ID = 'BlackScholes';    %model identifyer
modelBS.params = 0.2;           %sigma

%model parameters Variance Gamma
modelVG.ID = 'VarianceGamma';   %model identifyer
%modelVG.params = [0.125;        %sigma 
%                  0.375;        %nu
%                  0.2];         %theta
modelVG.params = [0.12;        %sigma 
                  0.2;        %nu
                  -0.14];         %theta
%model parameters CGMY
modelCGMY.ID = 'CGMY';          %model identifyer
modelCGMY.params = [.1;        %C 
                  .75;          %G
                  1.0;          %M
                  .25];         %Y
              
%model parameters Heston
modelHeston.ID = 'Heston';      %model identifyer
modelHeston.params = [0.04;     %vInst 
                      0.04;     %vLong
                       0.5;     %kappa
                       0.2;     %omega
                     -0.8];     %rho             


%array containing all defined models
modelVec = [modelBS;modelVG;modelCGMY;modelHeston];

indModel = 2;

%fft parameter
N = 2^13;
eta = 0.05;
L = 20;

%result matrices
resultMatLewis = zeros(length(modelVec),length(K),3);
resultMatCarrMadan = resultMatLewis;
resultMatCosine = resultMatLewis;
resultMatConvolution = resultMatLewis;

%analytic Black/Scholes benchmark
benchmarkMat = resultMatLewis;

dummy = CosineMethodCallPricingFFT(N,L,modelVec(2),S,K,T,r,d);;

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


indStrike = find(K == 120);

fprintf('\nFFT %s Call prices/delta/gamma for K = %6.2f',modelVec(indModel).ID,K(indStrike))
fprintf('\n-------------------------------------------------')
if strcmp(modelVec(indModel).ID,'BlackScholes')
    fprintf('\nAnalytical Black Scholes Values')
    fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', benchmarkMat(indModel,indStrike,1),benchmarkMat(indModel,indStrike,2),benchmarkMat(indModel,indStrike,3))
end
fprintf('\nLewis Method: N = %d, eta = %1.3f',N,eta)
fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', resultMatLewis(indModel,indStrike,1),resultMatLewis(indModel,indStrike,2),resultMatLewis(indModel,indStrike,3))
fprintf('\nCarr Madan Method: N = %d, eta = %1.3f',N,eta)
fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', resultMatCarrMadan(indModel,indStrike,1),resultMatCarrMadan(indModel,indStrike,2),resultMatCarrMadan(indModel,indStrike,3))
fprintf('\nCosine Method: N = %d, L = %d',N,L)
fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', resultMatCosine(indModel,indStrike,1),resultMatCosine(indModel,indStrike,2),resultMatCosine(indModel,indStrike,3))
fprintf('\nConvolution Method:  N = %d, L = %d',N,L')
fprintf('\nprice = %f\tDelta = %f\tGamma = %f\n', resultMatConvolution(indModel,indStrike,1),resultMatConvolution(indModel,indStrike,2),resultMatConvolution(indModel,indStrike,3))
fprintf('\n-------------------------------------------------\n')

if strcmp(modelVec(indModel).ID,'BlackScholes')
    figure('Color',[1 1 1]); hold on;
    plot(K,resultMatLewis(indModel,:,2)','-o','Color',[0 0 0]);
    plot(K,resultMatCarrMadan(indModel,:,2)','--x','Color',[0 0 0]);
    plot(K,resultMatCosine(indModel,:,2)','Color',[0 0 0]);
    plot(K,resultMatConvolution(indModel,:,2)',':d','Color',[0 0 0]);
    plot(K,benchmarkMat(indModel,:,2)','-','Color',[0 0 0]);
    hold off;
    legend('Lewis', 'CarrMadan', 'Cosine','Convolution','BlackScholes')
    xlabel('Strike'); ylabel('\Delta'); title('\Delta Calculation for Black-Scholes')
    figure('Color', [1 1 1]); hold on;
    plot(K,resultMatLewis(indModel,:,3)','-o','Color',[0 0 0]);
    plot(K,resultMatCarrMadan(indModel,:,3)','--x','Color',[0 0 0]);
    plot(K,resultMatCosine(indModel,:,3)','Color',[0 0 0]);
    plot(K,resultMatConvolution(indModel,:,3)',':d','Color',[0 0 0]);
    plot(K,benchmarkMat(indModel,:,3)','-','Color',[0 0 0]);
    hold off;
    legend('Lewis', 'CarrMadan', 'Cosine','Convolution','BlackScholes')
    xlabel('Strike'); ylabel('\Gamma'); title('\Gamma Calculation for Black-Scholes')
    
    figure('Color', [1 1 1]); hold on;
    plot(K,((benchmarkMat(indModel,:,2)-resultMatLewis(indModel,:,2))./benchmarkMat(indModel,:,2))','-o','Color',[0 0 0]);
    plot(K,((benchmarkMat(indModel,:,2)-resultMatCarrMadan(indModel,:,2))./benchmarkMat(indModel,:,2))','--x','Color',[0 0 0]);
    plot(K,((benchmarkMat(indModel,:,2)-resultMatCosine(indModel,:,2))./benchmarkMat(indModel,:,2))','-.s','Color',[0 0 0]);
    plot(K,((benchmarkMat(indModel,:,2)-resultMatConvolution(indModel,:,2))./benchmarkMat(indModel,:,2))',':d','Color',[0 0 0]);
    hold off;
    legend('Rel. Error Lewis', 'Rel. Error CarrMadan', 'Rel. Error Cosine', 'Rel. Error Convolution')
    xlabel('Strike'); ylabel('Rel. Error (%)'); title(strcat('Relative Error \Delta Calculation for ', modelVec(indModel).ID))
    ylim([-.0025 .0025]);
    
    figure('Color', [1 1 1]); hold on;
    plot(K,((benchmarkMat(indModel,:,3)-resultMatLewis(indModel,:,3))./benchmarkMat(indModel,:,3))','-o','Color',[0 0 0]);
    plot(K,((benchmarkMat(indModel,:,3)-resultMatCarrMadan(indModel,:,3))./benchmarkMat(indModel,:,3))','--x','Color',[0 0 0]);
    plot(K,((benchmarkMat(indModel,:,3)-resultMatCosine(indModel,:,3))./benchmarkMat(indModel,:,3))','-.s','Color',[0 0 0]);
    plot(K,((benchmarkMat(indModel,:,3)-resultMatConvolution(indModel,:,3))./benchmarkMat(indModel,:,3))',':d','Color',[0 0 0]);
    hold off;
    legend('Rel. Error Lewis', 'Rel. Error CarrMadan', 'Rel. Error Cosine', 'Rel. Error Convolution')
    xlabel('Strike'); ylabel('Rel. Error (%)'); title(strcat('Relative Error \Gamma Calculation for ', modelVec(indModel).ID))
    ylim([-.005 .005]);
else
    figure('Color', [1 1 1]); hold on;
    plot(K,resultMatLewis(indModel,:,2)', '-o','Color',[0 0 0]);
    plot(K,resultMatCarrMadan(indModel,:,2)','--x','Color',[0 0 0]);
    plot(K,resultMatCosine(indModel,:,2)','-.s','Color',[0 0 0]);
    plot(K,resultMatConvolution(indModel,:,2)',':d','Color',[0 0 0]);
    hold off;
    legend('Lewis', 'CarrMadan', 'Cosine','Convolution')
    xlabel('Strike'); ylabel('\Delta'); title(strcat('\Delta Calculation for ', modelVec(indModel).ID))
    ymin = min(resultMatCosine(indModel,:,2)); ymax = max(resultMatCosine(indModel,:,2));
    ylim([ymin ymax]);
    
    figure('Color', [1 1 1]);hold on;
    plot(K,resultMatLewis(indModel,:,3)', '-o','Color',[0 0 0]);
    plot(K,resultMatCarrMadan(indModel,:,3)','--x','Color',[0 0 0]);
    plot(K,resultMatCosine(indModel,:,3)','-.s','Color',[0 0 0]);
    plot(K,resultMatConvolution(indModel,:,3)',':d','Color',[0 0 0]);
    hold off;    legend('Lewis', 'CarrMadan', 'Cosine','Convolution')
    xlabel('Strike'); ylabel('\Gamma'); title(strcat('\Gamma Calculation for ',modelVec(indModel).ID));
    ymin = min(resultMatCosine(indModel,:,3)); ymax = max(resultMatCosine(indModel,:,3));
    ylim([ymin ymax]);
    
    figure('Color', [1 1 1]); hold on;
    plot(K,((resultMatCosine(indModel,:,2)-resultMatLewis(indModel,:,2))./resultMatCosine(indModel,:,2))','-o','Color',[0 0 0]);
    plot(K,((resultMatCosine(indModel,:,2)-resultMatCarrMadan(indModel,:,2))./resultMatCosine(indModel,:,2))','--x','Color',[0 0 0]);
    plot(K,((resultMatCosine(indModel,:,2)-resultMatConvolution(indModel,:,2))./resultMatCosine(indModel,:,2))',':d','Color',[0 0 0]);
    hold off;
    legend('Rel. Error Lewis', 'Rel. Error CarrMadan', 'Rel. Error Convolution')
    xlabel('Strike'); ylabel('Rel. Error (%)'); title(strcat('Relative Error (to COS) \Delta Calculation for ', modelVec(indModel).ID))
    ylim([-.5 .5]);

    figure('Color', [1 1 1]); hold on;
    plot(K,((resultMatCosine(indModel,:,3)-resultMatLewis(indModel,:,3))./resultMatCosine(indModel,:,3))','-o','Color',[0 0 0]);
    plot(K,((resultMatCosine(indModel,:,3)-resultMatCarrMadan(indModel,:,3))./resultMatCosine(indModel,:,3))','--x','Color',[0 0 0]);
    plot(K,((resultMatCosine(indModel,:,3)-resultMatConvolution(indModel,:,3))./resultMatCosine(indModel,:,3))',':d','Color',[0 0 0]);
    hold off;
    legend('Rel. Error Lewis', 'Rel. Error CarrMadan', 'Rel. Error Convolution')
    xlabel('Strike'); ylabel('Rel. Error (%)'); title(strcat('Relative Error (to COS) \Gamma Calculation for ', modelVec(indModel).ID))
    ylim([-.5 .5]);
end


    