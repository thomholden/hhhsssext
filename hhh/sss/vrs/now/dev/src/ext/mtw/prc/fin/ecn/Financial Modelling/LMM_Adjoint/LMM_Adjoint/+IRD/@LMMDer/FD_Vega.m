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



function Vega = FD_Vega(LD)
    
    Vega = zeros(1,LD.m);
    msg = LD.msg;
    
    LD.msg = 0;
    for j=1:LD.m
        sigmaj = LD.sigma(j);                 %save old value
        LD.sigma(j) = sigmaj + LD.epsilon;     %run forward difference
        LD = LD.CalcPrice;
        right = LD.Price;
        LD.sigma(j) = sigmaj - LD.epsilon;     %run backward difference
        LD = LD.CalcPrice;
        left = LD.Price;
        LD.sigma(j) = sigmaj;                 %restore old value
        Vega(j) = (right - left)/(2 * LD.epsilon);  %avg
    end
    
    LD.msg=msg;

end

