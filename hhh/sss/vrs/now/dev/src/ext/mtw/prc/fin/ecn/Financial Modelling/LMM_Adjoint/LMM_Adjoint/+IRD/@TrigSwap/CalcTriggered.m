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



function TS = CalcTriggered(TS)
%Calculates the time indices in all paths at which Swap is Triggered
%   Value is set to TS.m+1, if not triggered

    tstart = TS.StartMessage('Calculating trigger times...');

    TS.Triggered = ones(TS.paths,1) * (TS.m+1);
    
    for omega = 1:TS.paths
        for n = TS.e:TS.m
            if(TS.LIBORs(n,n,omega)>TS.K(n))
                TS.Triggered(omega) = n;
                break
            end
        end
    end
    
    TS.EndMessage(tstart);

end

