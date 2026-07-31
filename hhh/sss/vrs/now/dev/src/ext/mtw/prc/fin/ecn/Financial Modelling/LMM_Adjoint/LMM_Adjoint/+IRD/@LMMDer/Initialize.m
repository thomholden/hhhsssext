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



function LD = Initialize(LD)
%Initializes the LMM Derivative LD

    %Check, if the input is valid
    if( (length(LD.L) == LD.m) && (length(LD.sigma) == LD.m) && (LD.paths > 0) && (LD.msg == 1 || LD.msg==0) )
        LD.Price = 0;
        LD.Delta = zeros(1,LD.m);
        LD.Gamma = zeros(LD.m,LD.m);
        LD.Vega = zeros(1,LD.m);
        LD.SendMessage('Input validated. LMM Derivative initialized.\n');
    else
        display('Invalid input!');
    end    
end
