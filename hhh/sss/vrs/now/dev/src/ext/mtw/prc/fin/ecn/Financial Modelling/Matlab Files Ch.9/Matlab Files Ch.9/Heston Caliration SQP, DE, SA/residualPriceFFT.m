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



function R = residualPriceFFT(x,PM,fftStruct,option,modelID)
% Function residualPriceFFT calculates residual vector R(x) - PM - P(x)
% between European call option prices observed on the market PM and 
% model prices P(x) calculated for the model parameters x
%----------------------------------------------------------------------
% Input:    x: vector model parameters of length n
%           PM: vector of market prices of length M >= n
%           fftStruct: struct of FFT parameters
%               fields: pricer -> function handle to fft pricing routine
%                       N -> multiple of 2, e.g. N = 2^14
%                       eta -> (small real number > 0,e.g. eta = 0.1)
%           option: struct of option parameters
%               fields: S -> Spot price
%                       K -> Strike 
%                       r -> risk free interest rate 
%                       d -> dividend yield 
%                       T -> maturity in years
%           modelID: model name string
%
% Output:   R: vector of residuals PM_i - P_i(x), i = 1,...,M
%----------------------------------------------------------------------

% initializes the model struct
model.ID = modelID; 
model.params = x;

% return residual vector PM - P(x)
R = PM - fftpricer(model,fftStruct,option);

