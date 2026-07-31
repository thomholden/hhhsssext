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



classdef ape < objectivefuncbase
    properties
        dataMarket = [];    % market data   (quoted prices)
        weights = [];       % weights for model prices
        NOpt = [];
    end
    
    methods
        function y = val(OBJ, x)
            % absolute percentage error
            y = 1/(OBJ.NOpt) * sum(sum(abs(OBJ.weights.*(OBJ.dataMarket-x))))*OBJ.NOpt/sum(sum(OBJ.dataMarket));
        end        
    end
    
    methods
        function OBJ = ape(dataMarket_,weights_)
            OBJ.dataMarket = dataMarket_;
            OBJ.weights = weights_;
            OBJ.NOpt = sum(sum(OBJ.weights>0.0));
        end
    end
end