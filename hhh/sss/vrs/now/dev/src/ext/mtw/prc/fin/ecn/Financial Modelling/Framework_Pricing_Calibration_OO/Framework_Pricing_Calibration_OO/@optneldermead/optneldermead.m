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



classdef optneldermead < optgeneticbase
    properties
        % from defintion ob base class
        S_struct = [];
        objfunc = [];        % objective function        
    end
    
    properties
        options = [];
        lower = [];         % parameters lower bound
        upper = [];         % parameters upper bound
    end
    
    methods (Access = 'public')
        function ocm = optneldermead(S_struct, objfhandle)
            
            ocm.S_struct = S_struct;
            ocm.objfunc = objfhandle;
            ocm.lower = S_struct.lb;
            ocm.upper = S_struct.ub;
            ocm.options = S_struct.options;
        end
  
        function [x, f] = optimize(ocm)
            [x, f] = ocm.fminsearchbnd(ocm.objfunc, ocm.S_struct.start, ocm.S_struct.lb, ocm.S_struct.ub, ocm.options);
        end       
    end
    
    
    methods(Static, Access = 'private')
        [x, f] = fminsearchbnd(objfunc, x0, lb, ub, options);
    end
end