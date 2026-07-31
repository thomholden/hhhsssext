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



classdef modelvisitor < handle
    % Since no virtual functions are available we only state one function
    % and use if statement in the inherited classes for modelvisitor
    % each call in the if statement would correspond to a classes in real
    % oo programming
    methods (Abstract)
        y = visit(m,model)
    end
    
    %usually:
    % methods (Abstract)
    %   y = visit(m,model1)
    %   y = visit(m,model2)
    %   ...
    %   y = visit(m,modelx)
    
    % inherited class has to implement one of the above function
end

