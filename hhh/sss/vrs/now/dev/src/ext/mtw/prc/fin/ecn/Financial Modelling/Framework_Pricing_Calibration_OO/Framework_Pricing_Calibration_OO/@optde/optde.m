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



classdef optde < optgeneticbase
    
    properties
        % from definition of base class
        S_struct = [];
        objfunc = [];
    end
    
    properties
        lower = [];
        upper = [];
        constfunc = [];
    end
    
    methods (Access = 'public')
        function ocm = optde(S_struct,objfhandle,constfhandle)
            ocm.S_struct = S_struct;
            ocm.objfunc = objfhandle;
            if nargin < 3 || isempty(constfhandle)
                ocm.constfunc = @dummyConstraints;
            else
                ocm.constfunc = constfhandle;
            end
            ocm.lower = S_struct.FVr_minbound;
            ocm.upper = S_struct.FVr_maxbound;
        end
    end
    
    
     methods (Access = 'public')
        function [FVr_x,S_y,I_nf] = optimize(ocm)
            [FVr_x, S_y, I_nf] = deopt(@ocm.objfct,ocm.S_struct);
        end
     end
    

      methods (Access = 'public')
         function S_MSE = objfct(ocm,x,varargin)
            F_cost = ocm.objfunc(x);
            S_MSE.I_no      = 1;%number of objectives (costs)
            S_MSE.FVr_oa = F_cost;
            [S_MSE.I_nc,S_MSE.FVr_ca] = ocm.constfunc(x);
         end
      end
    
end

function [I_nc,FVr_ca] = dummyConstraints(varargin)
    I_nc = 0; FVr_ca = 0;
end



