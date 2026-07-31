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



classdef nigmodelbuilder < modelbuilder
    
    properties
        pmodel; %normal inverse gaussian model
    end
    
    methods
        function m = nigmodelbuilder(params)
        if (nargin == 0 || isempty(params))
            default.alpha = 1; default.usealpha = 1;
            default.beta = 1; default.usebeta = 1;
            default.delta = 1; default.usedelta = 1;
            params = default;
        end
        m.pmodel=nigmodel(params);
        end
  end
    
    methods (Static)
        function y = buildparam(params)
            y.pmodel = nigmodel(params);
        end
        
        function y = buildmarket(y,market)
            y.pmodel.pmarket = market;
        end
    end
end