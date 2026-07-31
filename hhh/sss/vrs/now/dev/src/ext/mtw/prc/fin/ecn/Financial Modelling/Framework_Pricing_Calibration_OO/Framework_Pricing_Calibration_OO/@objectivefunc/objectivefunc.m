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



classdef objectivefunc
    properties (SetAccess = 'private', GetAccess = 'public')
        dataMarket = [];    % market data   (quoted prices)
        dataModel = [];     % model prices  (calculated prices)
        weights = [];       % weights for model prices
        pricer = {};        % pricer for computing option prices
    end
    
    methods (Access = 'public')
        function y = price(m)
            m.modelprices = m.pricer.price();
            y = m.modelprices;
        end
    end
    
    methods(Access = 'public')
        function y = aae_base(OBJ)
            % absolute error
            [a, b] = size(OBJ.dataMarket);
            y = 1/(a*b) * sum(sum(abs(OBJ.weights.*(OBJ.dataMarket-OBJ.dataModel))));
        end
        function y = aae(OBJ,dataModel)
            [a, b] = size(OBJ.dataMarket);
            y = 1/(a*b) * sum(sum(abs(OBJ.weights.*(OBJ.dataMarket-dataModel))));            
        end
        function y = ape_base(OBJ)
            % absolute percentage error
            [a, b] = size(OBJ.dataMarket);
            y = 1/(a*b) * sum(sum(abs(OBJ.weights.*(OBJ.dataMarket-OBJ.dataModel))))*a*b/sum(sum(OBJ.dataMarket));
        end
        function y = ape(OBJ, dataModel)
            % absolute percentage error
            [a, b] = size(OBJ.dataMarket);
            y = 1/(a*b) * sum(sum(abs(OBJ.weights.*(OBJ.dataMarket-dataModel))))*a*b/sum(sum(OBJ.dataMarket));
        end        
        function y = arpe_base(OBJ)
            % absolute relaive percentage error
            [a, b] = size(OBJ.dataMarket);
            y = 1/(a*b) * sum(sum(abs(OBJ.weights.*(1 - OBJ.dataModel ./OBJ.dataMarket))));
        end
        function y = arpe(OBJ, dataModel)
            % absolute relaive percentage error
            [a, b] = size(OBJ.dataMarket);
            y = 1/(a*b) * sum(sum(abs(OBJ.weights.*(1 - dataModel ./OBJ.dataMarket))));
        end  
        function y = rmse_base(OBJ)
            % root mean square error
            [a, b] = size(OBJ.dataMarket);
            y = sqrt(1/(a*b) * sum(sum( (OBJ.weights.*(OBJ.dataMarket-OBJ.dataModel).^2) )));
        end
        function y = rmse(OBJ, dataModel)
            % root mean square error
            [a, b] = size(OBJ.dataMarket);
            y = sqrt(1/(a*b) * sum(sum( (OBJ.weights.*(OBJ.dataMarket-dataModel).^2) )));
        end
         function y = rrmse_base(OBJ)
            % root mean square error
            [a, b] = size(OBJ.dataMarket);
            y = sqrt(1/(a*b) * sum(sum( (OBJ.weights.*(OBJ.dataMarket-OBJ.dataModel).^2./OBJ.dataMarket) )));
        end
        function y = rrmse(OBJ, dataModel)
            % root mean square error
            [a, b] = size(OBJ.dataMarket);
            y = sqrt(1/(a*b) * sum(sum( (OBJ.weights.*(OBJ.dataMarket-dataModel).^2./OBJ.dataMarket) )));
        end
    end
    
    methods(Access = 'public')
        function OBJ = objectivefunc(dataMarket_,dataModel_,weights_)
            OBJ.dataMarket = dataMarket_;
            OBJ.dataModel = dataModel_;
            OBJ.weights = weights_;
        end
    end
end