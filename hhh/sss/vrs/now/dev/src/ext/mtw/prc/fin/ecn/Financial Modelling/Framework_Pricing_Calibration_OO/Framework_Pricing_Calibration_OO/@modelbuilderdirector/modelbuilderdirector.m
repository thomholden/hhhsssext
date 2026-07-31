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



classdef modelbuilderdirector < handle
    %modelbuilderdirector
    %   Detailed explanation goes here
    
    properties
        pmodelbuilder;
    end
    
    methods
        function m = modelbuilderdirector()
            m.pmodelbuilder = [];
        end
        function y = setmodelbuilder(m,mb)
            m.pmodelbuilder = mb;
            y = true;
        end
        function y = getmodel(m)
            y = m.pmodel;
        end
        function y = buildmodel(m,params,market)
            mbuilder = m.pmodelbuilder.buildparam(params);
            model = m.pmodelbuilder.buildmarket(mbuilder,market);
            y = model.pmodel;
            %m.pmodelbuilder.buildparam(params); % set the parameter
            %m.pmodelbuilder.buildmarket(market);% set the market
            %y = m.pmodelbuilder.pmodel;         % return the model
        end
    end
end

