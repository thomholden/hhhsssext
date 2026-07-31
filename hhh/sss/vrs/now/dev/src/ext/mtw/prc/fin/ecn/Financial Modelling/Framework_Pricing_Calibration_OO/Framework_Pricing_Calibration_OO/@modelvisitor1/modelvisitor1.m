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



classdef modelvisitor1 < modelvisitor

    properties (SetAccess = 'public', GetAccess = 'public')
        a;
    end
    
    methods
        function obj = modelvisitor1(value)
            obj.a = value;
        end
        
        function print(m)
            sprintf('I am a Heston model visitor, the value is %d',m.a)
        end
        
        function y = visit(modelvisitor,model)
            %if strcmp(model.Modelname,'Heston')
                fprintf('Visiting Heston');
                modelvisitor.a = model.getval() * 5.0;
                y = true;
          %  end
        end
    end
    
end

