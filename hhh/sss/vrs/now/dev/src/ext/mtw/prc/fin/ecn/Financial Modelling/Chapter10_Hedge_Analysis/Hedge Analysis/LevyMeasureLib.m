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



function levymeasure = LevyMeasureLib(model,params,x)
%---------------------------------------------------------
% Levy Measure Library of the following models:
%---------------------------------------------------------
% Black Scholes
% Merton Jump Diffusion
% Variance Gamma
% Normal Inverse Gaussian
%---------------------------------------------------------


ME1 = MException('VerifyInput:InvalidNrOfArguments',...
    'Invalid number of Input arguments');
ME2 = MException('VerifyInput:InvalidModel',...
    'Undefined Model');


if strcmp(model.ID,'BlackScholes')
    if length(params) == 1
        funobj = @Black_levymeasure;
    else 
        throw(ME1)
    end
elseif strcmp(model.ID,'Merton')
    if length(params) == 4
        funobj = @Merton_levymeasure;
    else 
        throw(ME1)
    end
elseif strcmp(model.ID,'VarianceGamma')
    if length(params) == 3
        funobj = @VG_levymeasure;
    else 
        throw(ME1)
    end
elseif strcmp(model.ID,'NIG')
    if length(params) == 3
        funobj = @NIG_levymeasure;
    else
        throw(ME1)
    end
else
    throw(ME2)
end

levymeasure = feval(funobj,params,x);

end


%% Explicit Implementation of the Levy Measures
%-----------------------------------------------------------------------

% Black Scholes    
function levymeasure = Black_levymeasure(params,x)
      levymeasure = 0;
end

% Merton Jump Diffusion
function levymeasure = Merton_levymeasure(params,x)
    mu_j = params(2); sigma_j = params(3); lambda = params(4);
    levymeasure = lambda / (2*pi*sigma_j) * exp(-0.5*(x-mu_j).^2/sigma_j^2);
end

% Variance Gamma
function levymeasure = VG_levymeasure(params,x)
    
    sigma = params(1); nu = params(2); theta = params(3);
    
    C = 1/nu;
    G = 1/(sqrt(0.25 * theta^2*nu^2 + 0.5* sigma^2)-0.5*theta*nu);
    M = 1/(sqrt(0.25 * theta^2*nu^2 + 0.5* sigma^2)+0.5*theta*nu);
   
    levymeasure(x<0) = C  *exp( G*x(x<0)) ./ abs(x(x<0));
    levymeasure(x>0) = C * exp(-M*x(x>0)) ./ x(x>0);
    levymeasure(x==0) = 0;
    
end

% Normal Inverse Gaussian
function levymeasure = NIG_levymeasure(params,x)
    
   alphaNIG = params(1); betaNIG = params(2); deltaNIG = params(3);

   levymeasure(x~=0) =  deltaNIG*alphaNIG/pi * exp(betaNIG*x(x~=0)) .* besselk(1,alphaNIG*abs(x(x~=0)))./ abs(x(x~=0));
   levymeasure(x==0) =  0;
    
end

