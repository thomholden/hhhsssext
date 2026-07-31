function randomRT(obj,event,ticker)
% RANDOMRT plots random stock data using RANDN.
%
% RANDOMRT is used in conjuction with the DEFINERANDOMTIMER.m m-file
%
% Author:
% Brian Kiernan
% The MathWorks
% August 27, 2004

persistent Pricevector Timevector

if isempty(Pricevector)
%     % Create random price if Yahoo isn't available
    LastPrice.Last = 100*rand;
    
    Pricevector = LastPrice.Last;
    Timevector = datenum(event.Data.time);
    scatter(Timevector(end),Pricevector(end),'filled')

else
%   % Create random price if Yahoo isn't available
    LastPrice.Last = 100*rand;
    
    Pricevector = [Pricevector LastPrice.Last];
    Timevector = [Timevector datenum(event.Data.time)];
    
    % Test for up or down movement and lable graph points accordingly
    if LastPrice.Last > Pricevector(end-1)
        disp('price is higher')
        scatter(Timevector(end),Pricevector(end),'g','filled')
    elseif LastPrice.Last < Pricevector(end-1)
        disp('price is lower')
        scatter(Timevector(end),Pricevector(end),'r','filled')
        %set(circs(1),'markeredgecolor','g')
    else
        scatter(Timevector(end),Pricevector(end),'filled')
    end
    
    % Find and delete line plot so as not to plot too many lines
    dummyline = findobj(gca,'type','line');
    if ~isempty(dummyline)
        delete(dummyline)
    end
    
    circs = findobj(gca,'type','hggroup');
    xdata = flipud(cell2mat(get(circs,'xdata')));
    ydata = flipud(cell2mat(get(circs,'ydata')));
    plot(xdata,ydata)
end

datetick('x',13)
title(['Real Time Price Series for ', ticker])
ylabel('Price (USD)')
grid on
hold on