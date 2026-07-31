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



classdef strategytype
    
    properties

    end
    
    methods (Abstract)
        runstrategy(t)
    end
    
    methods (Static)
        function y = newtype(v)
            switch lower(v)
                case 'de'               % differential evolution
                    y = strategytype1;
                case 'sqp'              % sequential quadratic
                    y = strategytype2;
                case 'neldermead'       % nelder mead
                    y = strategytype3;
                case 'fmincon'          % matlab fmincon
                    y = strategytype4;
                case 'sa'               % simulated annealing
                    y = strategytype5;
                otherwise
                    y = errorstrategy;
            end
        end
    end
    
end

