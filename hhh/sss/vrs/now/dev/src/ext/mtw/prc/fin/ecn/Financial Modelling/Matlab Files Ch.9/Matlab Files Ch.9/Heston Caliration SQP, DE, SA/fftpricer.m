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



function cp = fftpricer(model,fftStruct,option)
% Function fftpricer calculates European call option prices
% by use of the Fast Fourier Transformation technique
%-----------------------------------------------------------------------
% Input:    fftStruct: struct of FFT parameters
%               fields: pricer -> function handle to fft pricing routine
%                       N > 0(multiple of 2, e.g. N = 2^14),
%                       eta > 0(small real number,e.g. eta = 0.1)
%           option: struct of option parameters
%               fields: S -> Spot price (size: 1 x 1)
%                       K -> Strike (size: M x 1)
%                       r -> risk free interest rate (size: 1 x 1)
%                       d -> dividend yield (size: 1 x 1)
%                       T -> maturity in years (size: P x 1)
%           model: struct of model parameters
%               fields: modelID -> model name string
%                       params -> vector of model parameters
%
% Output:   cp: vector of option prices (M*P x 1)
%-----------------------------------------------------------------------
pricerFFT = fftStruct.pricer;

lenT = length(option.T);
lenK = length(option.K);
cp = zeros(lenT*lenK,1);
for i = 1:lenT
    cp((i-1)*lenK+1:i*lenK,1) = pricerFFT(fftStruct,model,...
                       option.S,option.K,option.T(i),option.r,option.d);
end