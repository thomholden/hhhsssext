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



function PriceAndGreeks = PricerFactory(pricer)
 
    if strcmp(pricer.ID,'Cosine')
        PriceAndGreeks = @(model,S,K,T,r,d)CosineMethodCallPricingFFT(pricer.N,pricer.L,model,S,K,T,r,d);
    elseif strcmp(pricer.ID,'Carr')   
        PriceAndGreeks = @(model,S,K,T,r,d)CarrMadanCallPricingFFT(pricer.N,pricer.eta,model,S,K,T,r,d);
    elseif strcmp(pricer.ID,'Lewis')
        PriceAndGreeks = @(model,S,K,T,r,d)LewisCallPricingFFT(pricer.N,pricer.eta,model,S,K,T,r,d);    
    elseif strcmp(pricer.ID,'Conv')
        PriceAndGreeks = @(model,S,K,T,r,d)ConvolutionMethodCallPricingFFT(pricer.N,pricer.L,model,S,K,T,r,d);
    elseif strcmp(pricer.ID,'BlackScholes')
        PriceAndGreeks = @(model,S,K,T,r,d)BlackScholesPrice(S,K,r,T,model.params(1));    
    end
      
end