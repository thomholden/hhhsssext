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



function TS = Initialize(TS)
%Initializes the Trigger Swap

    %Initialize as LMM Derivative
    TS = Initialize@IRD.LMMDer(TS);
    
    %Check, if the input is valid
    if( (TS.e > 0 && TS.e < TS.m) && (TS.s >= 0 && TS.s < 1) && (TS.kappa >= 0 && TS.kappa < 1) && (TS.N > 0) )
        TS.SendMessage('Trigger Swap initialized.\n');
    else
        TS.SendMessage('TrigSwap: Invalid input!');
    end    
    
end
