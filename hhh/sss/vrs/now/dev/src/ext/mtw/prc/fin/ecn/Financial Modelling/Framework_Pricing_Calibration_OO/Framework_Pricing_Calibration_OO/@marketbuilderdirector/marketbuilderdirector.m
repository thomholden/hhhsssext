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



classdef marketbuilderdirector < handle
    %marketbuilderdirector
    %   Detailed explanation goes here
    
    properties
        pmarketbuilder;     % market to be build
    end
    
    methods
        % constructor
        function m = marketbuilderdirector()
            m.pmarketbuilder = [];  
        end
        
        % set the marketbuilder returns true if successfull
        function y = setmarketbuilder(m,mb)
            m.pmarketbuilder = mb;
            y = true;
        end
        
        % get the market 
        function y = getmarket(m)
            y = m.pmarket;
        end
        
        % build the market
        function y = buildmarket(m,market)
            m.pmarketbuilder.buildmarket(market);   % set the market
            y = m.pmarketbuilder.pmarket;           % return the model
        end
    end
end