% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Nikolai Nowaczyk
%   	    Joerg Kienitz
%           Daniel Wetterau
%           
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Nikolai Nowaczyk, Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function TS = MCPayoff(TS)
%Approximates fair price of the Trigger Swap using MonteCarlo

    tstart = TS.StartMessage('Calculating price... ');

    Price = 0;
    
    for omega = 1:TS.paths
        Price = Price + TSPayoff(TS,omega);
    end
    
    TS.Price = Price / TS.paths;
    
    TS.EndMessage(tstart);
    
end

%Calculates the Payoff in path omega
function payoff = TSPayoff(TS,omega)
    
    payoff = 0;
    
    %Calc Discount Factors
    PV = ones(1,TS.m);
    for j=1:TS.m
        PV(j) =  1 + TS.tau(j) * TS.LIBORs(j,j,omega);
    end
    PV = cumprod(PV);
    PV = 1 ./ PV;
    
    %Calculate Payoff
    tau = TS.Triggered(omega);
    for j=TS.e:tau-1
        payoff = payoff + TS.s * TS.tau(j)* PV(j);
    end
    for j=tau:TS.m        
        payoff = payoff + (TS.LIBORs(j,j,omega) - TS.kappa) * TS.tau(j) * PV(j);
    end
    payoff = payoff * TS.N;
    
end

