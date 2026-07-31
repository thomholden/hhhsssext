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



classdef optionmarket < market
    % This is the class for modeling an option market
    %  Data:
    %  maturities - all maturities for which option quotes are available
    %  strikes    - strikes for which option quotes are available
    %  striketype - determines the striketype
    %                1 - moneyness
    %                2 - absolute
    %                3 - delta
    %  tenors      - tenors of swaps (only for ir derivatives)
    %  volcube     - values
    %  quotetype   - determines if the quotes are bsprice, bsvol, normal
    %                vol
    %  underlying   - eq, ir, fx, etc.
    
    properties (Constant)
        markettype = 'option';
    end
    
    properties %(SetAccess = 'public', GetAccess = 'public')
        maturities = [];    % maturities for quoted options
        strikes = [];       % strikes for quoted options
        striketype = [];    % determines how the strike is quoted
                            % abs, moneyness, detla
        volcube = [];       % all volatilities from the market
                            % could be 1d, 2d or 3d
        quotetype = [];     % price, volatility
                            % determines how the option is quoted
                            % bsprice, bsvolatility, nvolatility
        underlying = [];    % eq, ir, fx, etc.
   
    end
    
    % constructor
    methods
        function m = optionmarket(maturities, ...
                                  strikes, ...
                                  striketype, ...
                                  volcube, ...
                                  quotetype, ...
                                  underlying)
            m.maturities = maturities;
            m.strikes = strikes;
            m.striketype = striketype;
            m.volcube = volcube;
            m.quotetype = quotetype;
            m.underlying = underlying;
        end
    end
    
    % get
    methods (Access = 'public')
        function y = getmat(m)
            % get the maturities
            y = m.maturities;
        end
        
        function y = getstrikes(m)
            % get the strikes
            y = m.strikes;
        end
        
        function y = getstriketype(m)
            % get the strike type
            y = m.striketype;
        end
        
        function y = getcube(m)
            % get the volatility values
            y = m.volcube;
        end
        
        function y = getquotetype(m)
            % get the quotetype
            y = m.quotetype;
        end
        
        function y = getunderlying(m)
            % get the underyling market
            y = m.underlying;
        end
        
        function print(m)
            sprintf('I am a %s market',m.markettype)
        end
    end
    
    methods
        function y = getvolt(m,x)
            % this function interpolates in one dimension
            % it is used for interpolation of a volatility term structure
            y = interp1(m.maturities,m.volcube,x);
        end
        
        function y = getvolts(m,x,y)
            % this function interpolaties in two dimensions
            % it is used for interpolation of a volatility termstructure
            % and a strike structure
            y = interp2(m.maturities, m.strikes, m.volcube, x, y);
        end
        
    end
    
end
