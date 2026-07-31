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



function B = Initialize(B)
%Initializes the Bermudan Swaption B

    %Initialize as LMM Derivative
    B = Initialize@IRD.LMMDer(B);
    
    %Check, if the input is valid
    if( (B.K > 0 && B.K < 1) && (B.phi == 1 || B.phi == -1) && (B.nom > 0) && (B.d > 1) )
        B.SendMessage('BSwap initialized.\n');
    else
        B.SendMessage('BSwap: Invalid input!');
    end    
    
end
