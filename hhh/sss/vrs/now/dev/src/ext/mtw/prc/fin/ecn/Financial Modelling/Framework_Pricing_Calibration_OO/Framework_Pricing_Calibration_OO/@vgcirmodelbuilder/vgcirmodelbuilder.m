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



classdef vgcirmodelbuilder < modelbuilder
    
    properties
        pmodel;
    end
    
    methods
        function m = vgcirmodelbuilder(params)
            if (nargin == 0 || isempty(params))
                default.c = 1; default.usec = 1;
                default.g = 1; default.useg = 1;
                default.m = 1; default.usem = 1;
                default.kappa = 1; default.usekappa = 1;
                default.eta = 1; default.useeta = 1;
                default.lambda = 1; default.uselambda = 1;
                params = default;
            end
            m.pmodel = vgcirmodel(params);
        end
    end
    
    methods (Static)
  
        function y = buildparam(params)
            y.pmodel = vgcirmodel(params);
        end
        
        function y = buildmarket(y,market)
            y.pmodel.pmarket = market;
        end
    end

end