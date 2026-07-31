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



function Gamma = FD_Gamma(LD)
    
    Gamma = zeros(LD.m,LD.m);
    msg = LD.msg;
    
    LD.msg = 0;
    for i=1:LD.m
        for j=1:LD.m
            Li = LD.L(i);                 %save old values
            Lj = LD.L(j);
            
            LD.L(i) = Li + LD.epsilon;     %run top right difference
            LD.L(j) = Lj + LD.epsilon;
            LD = LD.CalcPrice;
            tr = LD.Price;
            LD.L(i) = Li + LD.epsilon;     %run bottom right difference
            LD.L(j) = Lj - LD.epsilon;
            LD = LD.CalcPrice;
            br = LD.Price;
            LD.L(i) = Li - LD.epsilon;     %run bottom left difference
            LD.L(j) = Lj + LD.epsilon;
            LD = LD.CalcPrice;
            bl = LD.Price;
            LD.L(i) = Li - LD.epsilon;     %run top left difference
            LD.L(j) = Lj - LD.epsilon;
            LD = LD.CalcPrice;
            tl = LD.Price;        
            
            LD.L(i) = Li;                 %restore old value
            LD.L(j) = Lj;
            
            Gamma(i,j) = (tr-br-bl+tl)/(4 * LD.epsilon * LD.epsilon);  %avg
        end
    end
    
    LD.msg=msg;

end
