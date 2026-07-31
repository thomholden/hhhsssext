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
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



classdef fftbase
    % the base class for all fft baed pricers
    properties (Abstract)
        pN;
        peta;
        lambda;
        b;
        ku;
        jvec;
        vj;
    end
    
    methods (Abstract)
        currentN = getCurrentN(OBJ)
        currentfunc = getCurrentFunc(OBJ)
        currentVj = getCurrentVj(OBJ)
        currentEta = getCurrentEta(OBJ)
        currentjvec = getCurrentJvec(OBJ)
        currentku = getCurrentKu(OBJ)
        curentB = getCurrentB(OBJ)
        %y = price1()                    % price1 computes the price for Calls or Puts
        %y = price2()                    % price2 computes the price for Calls and Puts
        y = price()
    end
end