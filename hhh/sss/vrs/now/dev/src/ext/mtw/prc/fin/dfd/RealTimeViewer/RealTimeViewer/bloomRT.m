function bloomRT(obj,event,Conn,ticker)
% BLOOMRT plots incoming ticker data from Bloomberg.
%
% BLOOMRT is used in conjuction with the DEFINEBLOOMTIMER.m m-file and the
% Datafeed Toolbox
%
% Author:
% Brian Kiernan
% The MathWorks
% August 27, 2004

persistent Pricevector Timevector

if isempty(Pricevector)
    % Fetch first instance of ticker's price
    LastPrice = fetch(Conn,ticker,'GETDATA','Last_Price'); 
    
    Pricevector = LastPrice.Last_Price;
    Pricevector = 100*rand;
    Timevector = datenum(event.Data.time);
    scatter(Timevector(end),Pricevector(end),'filled')

else
    % Fetch ticker price from Bloomberg
    LastPrice = fetch(Conn,ticker,'GETDATA','Last_Price');

    Pricevector = [Pricevector LastPrice.Last_Price];
    Timevector = [Timevector datenum(event.Data.time)];
    
    % Test for up or down movement and lable graph points accordingly
    if LastPrice.Last_Price > Pricevector(end-1)
        disp('price is higher')
        scatter(Timevector(end),Pricevector(end),'g','filled')
    elseif LastPrice.Last_Price < Pricevector(end-1)
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