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



classdef optionmarketbuilder < marketbuilder
    % optionmarketbuilder initializes an optionmarket
    %   first a heston model is initalized 
    %   second the parameters are initialized wrt input data
    
    properties
        pmarket; % this is an options market
    end
    
    methods
        function m = optionmarketbuilder()
            default.maturities = [];
            %default.strikes = [];
            %default.striketype = [];          
            %default.volcube = [];        
            %default.quotetype = [];          
            %default.underlying = [];
            
            m.pmarket = optionmarket([],[],[],[],[],[]);
            %m.pmarket = [];
            %optionmarket(default.maturities,...
            %    default.strikes, ...
            %    default.striketype, ...
            %    default.volcube, ...
            %    default.quotetype, ...
            %    default.underlying);
        end
        
        % take in a struct params
        function buildmarket(m,params)
            m.pmarket.maturities = params.maturities;
            m.pmarket.strikes = params.strikes;
            m.pmarket.striketype = params.striketype;
            m.pmarket.volcube = params.volcube;
            m.pmarket.quotetype = params.quotetype;
            m.pmarket.underlying = params.underlying;
        end
    end
    
end

