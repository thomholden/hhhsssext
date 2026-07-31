% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Nikolai Nowaczyk
%   	    Joerg Kienitz
%           Daniel Wetterau
%           
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Nikolai Nowaczyk, Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function propYData = DrawPlot(LD, K, propX, propY, range)
%Plots Properties
%   K is a vector of values for propX, which is plotted against all values
%   of a possibly matrix valued property propY (typically Price, Delta,
%   Gamma, Vega)
%   range is a vector of logicals, which can be used to specify the part
%   of plotY you want to plot. It is assumed that
%   numel(range)=numel(LD.(propy))

    tstart = LD.StartMessage('Calculating plot data... ');

    %Calculate sizes
    N = max(size(K));
    m = numel(LD.(propY));
        
    propyData=zeros(m,N);

    %Store old values
    msg = LD.msg;
    LD.msg = 0;
    frozen = LD.frozen;
    LD.frozen = 0;
    propXold = LD.(propX);
    propYold = LD.(propY);

 
    %Calculate plot data
    for n=1:N
        LD.(propX) = K(n);
        propYData(:,n) = reshape(LD.(propY),[1,m]);
    end

    LD.SendMessage('plotting... ');

    %Draw actual plot
    figure;
    hold on
    if(isempty(range))
        rangeresh = ones(1,m);
    else
        rangeresh = reshape(range,[1,m]);
    end
        
    for n = 1:m
        if(rangeresh(n))
            plot(K,propYData(n,:));
        end
    end
    hold off
    %title('Strikes / Vegas');
    xlabel(propX);
    ylabel(propY);

    %Restore old values
    LD.(propX) = propXold;
    LD.(propY) = propYold;
    LD.msg = msg;
    LD.frozen = frozen;

    LD.EndMessage(tstart);

end

