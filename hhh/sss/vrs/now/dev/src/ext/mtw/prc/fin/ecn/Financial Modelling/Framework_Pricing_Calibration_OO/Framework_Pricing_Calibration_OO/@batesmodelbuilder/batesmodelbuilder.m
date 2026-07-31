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



classdef batesmodelbuilder < modelbuilder
    % batesmodelbuilder initializes a batesmodel
    %   first a bates model is initalized 
    %   second the parameters are initialized wrt input data
    
    properties
        pmodel; % this is a Bates model
    end
    
    methods
        function m = batesmodelbuilder(params)
        if (nargin == 0 || isempty(params))
            default.kappa = 1; default.usekappa = 1;
            default.theta = 1; default.usetheta = 1;
            default.omega = 1; default.useomega = 1;
            default.rho = 1; default.userho = 1;
            default.v0 = 1; default.usev0 = 1;
            default.lambda = 1; default.uselambda = 1;
            default.muj = 1; default.usemuj = 1;
            default.sigmaj = 1; default.usesigmaj = 1;
            params = default;
        end
            m.pmodel = batesmodel(params);
        end
        
    end    
    
    methods (Static)
        function y = buildparam(params)
            y.pmodel = batesmodel(params);
        end
        
        function y = buildmarket(y,market)
            y.pmodel.pmarket = market;
        end
        
   end
    
        
    
end


