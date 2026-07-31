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



%Status: beta
%performance is probably desastrous, still problems with regression
function B = LSM_Simulation(B)
%Least Squares Monte Carlo
%   Longstaff/Schwarz Algorithm to determine swaption price and optimal
%   exercise time indices. Index is set to zero, if option is not exercised

    tstart = B.StartMessage('Longstaff/Schwarz algorithm... ');
    
    B.optimal = zeros(1,B.paths);
    
    B = B.CalcSwapRatesPayoff;
    
    value = zeros(B.paths,1);
    value = B.Payoff(B.m,:).';    %value of swaption at last possible exercise index
    B.optimal(value > 0) = B.m;   %exercise, if in the money
    
    %Longstaff/Schwartz: work backwards in time and create stopping rule
     for n = B.m-1 : -1 : B.e
         
        %value = continuation value at n
%         temp = permute(B.LIBORs,[3 2 1]);
%         value = value./(1 + B.tau(n) * temp(:,n,n) );    %=^ value(omega) = value(omega)/(1+B.tau(n) * B.LIBORs(n,n,omega));
        for omega = 1:B.paths
                value(omega) = value(omega) / (1 + B.tau(n) * B.LIBORs(n, n, omega));
        end
        
        ITM = B.Payoff(n,:).' > 0;      %decide, which paths are in the money
        Y = value(ITM);                 %select ITM continuation values
        X = B.SwapRates(n,:).';         %select ITM Swaprates
        X = X(ITM);

        ITMnum = size(X,1);
        if(ITMnum > 0)               %avoid regression failure
            if(ITMnum > B.d)         %standard case
                c = polyfit(X,Y,B.d);           %linear regression using a polynomial of degree B.d
                Yexp = polyval(c,X);            %calculate expected continuation value 
            elseif(ITMnum > 1)       %polynomial of optimal degree >=1 is used
                c = polyfit(X,Y,ITMnum-1);
                Yexp = polyval(c,X);
            else                     %ITMnum = 1
                Yexp = Y;
            end

            %update exercise decision (maximally inefficient)
            k=1;
            for omega = 1:B.paths
                if(ITM(omega))
                    if(B.Payoff(n,omega) > Yexp(k))
                        value(omega) = B.Payoff(n,omega);
                        B.optimal(omega) = n;
                    end
                    k = k+1;
                end
            end
        end
        
     end
     
    %calculate value of swaption by discounting back to n=1 and averaging
    %over all paths (totally inefficient)
    Price = 0;
    for omega = 1 : B.paths
         disc = 1;
         for n = B.e-1 : -1 : 1
             disc = disc * (1 + B.tau(n) * B.LIBORs(n, n, omega));
         end
         value(omega) = value(omega) / disc;
         Price = Price + value(omega);
    end
    B.Price = Price / B.paths;
    

    B.EndMessage(tstart);
    
end
