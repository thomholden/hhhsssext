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



classdef optsqp < optgeneticbase
    
    properties
        % from definition of base class
        S_struct = [];
        objfunc = [];
    end
    
    properties
        constfunc = [];
        lower = [];
        upper = [];
    end
    
    methods (Access = 'public')
        function ocm = optsqp(S_struct,objfhandle,constfhandle)
            ocm.S_struct = S_struct;
            ocm.objfunc = objfhandle;
            if nargin < 3 || isempty(constfhandle)
                ocm.constfunc = [];
            else
                ocm.constfunc = constfhandle;
            end
            ocm.lower = S_struct.lb;
            ocm.upper = S_struct.ub;
        end
    end
    
    
     methods (Access = 'public')
        function [xMin,fMin,savex] = optimize(ocm)
            [xMin,fMin,savex] = modSQP(ocm.objfunc,ocm.S_struct.start,ocm.constfunc,ocm.lower,ocm.upper);      
        end
     end
        
end