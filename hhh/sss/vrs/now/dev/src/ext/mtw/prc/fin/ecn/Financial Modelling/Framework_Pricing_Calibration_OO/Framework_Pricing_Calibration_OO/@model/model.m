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



classdef model < handle
% This is the base class for all financial models
    properties (Abstract)
        pnparams;            % number of modelparameters
        pparams;             % modelparameters
        pmarket;             % The markets where the model is appropriate

        parvec;    % used for calibration
        usevec;    % used for calibration
    end
    
    methods
        function y = model(m)
            m.pnparams = [];
            m.pparams = [];
            m.pmarket = [];
            m.parvec = [];
            m.usevec = [];
        end
    end
    
    %methods 
    %    function [y1, y2, y3] =  initcumulants(m,T,r,d)
    %    end
    %end
    
% Possibility to use a visitor
    methods (Abstract)
        y=accept(model, modelvisitor)   % interface for extending the model
    end
end