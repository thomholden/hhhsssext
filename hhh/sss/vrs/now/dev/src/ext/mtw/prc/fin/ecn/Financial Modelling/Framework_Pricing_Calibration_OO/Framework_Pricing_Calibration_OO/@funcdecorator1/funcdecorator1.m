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



classdef funcdecorator1 < funcdecorator
    %UNTITLED3 Summary of this class goes here
    %  Decorator to implement f(g(x))
    
    properties
        pfhandle;   % this now a function of y = f(x)
        pfhandle2;  % this is now a function y = g(x)
    end
    
    methods
        function m = funcdecorator1(fhandle)
            m.pfhandle = fhandle;
            m.pfhandle2 = @(x) sin(x);
        end
        function y = f(m,x)
            y = m.pfhandle(m.pfhandle2(x)); % f(g(x))
        end
    end
    
end

