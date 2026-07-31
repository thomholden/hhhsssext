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



function stop = PlotItBest(options,optimvalues, flag,S_struct)

stop = false;
switch flag
    % first iteration
    case 'init'
        set(gcf,'Color',[1 1 1])
        set(gca,'FontSize',16,'FontName','Helvecia')

        colormap('gray')
        % plot best solutions
        plotBest = plot(optimvalues.bestx(1),optimvalues.bestx(2),...
                        'Marker', '.','MarkerSize',20,...
                            'Color', [0 0 0],'LineWidth',2);
        set(plotBest,'Tag','PlotItBest');
        xlim([-3 3]);
        ylim([-3 3]);
        box('on');
        hold('all');
        % plot contour lines
        contour(S_struct.FVc_xx,S_struct.FVc_yy,S_struct.FM_meshd,20,'LineWidth',1.5);
    % all other iterations
    case 'iter'
        plotBest = findobj(get(gca,'Children'),'Tag','PlotItBest');
        newX = [get(plotBest,'Xdata') optimvalues.bestx(1)];
        newY = [get(plotBest,'Ydata') optimvalues.bestx(2)];
        set(plotBest,'Xdata',newX, 'Ydata',newY);

end

end