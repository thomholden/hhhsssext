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



function PlotIt(FVr_temp,iter,S_struct)

    % Create figure
    figure1 = figure('Color',[1 1 1]);
    colormap('gray');
    
    % Create axes
    axes1 = axes('Parent',figure1,'FontSize',14);
    grid(axes1,'on');
    hold(axes1,'all');
    
%     % Create subplot1 axes
%     ylim(subplot1,[-10 10]);
%     view(subplot1,[-29.5 40]);
%     grid(subplot1,'on');
%     hold(subplot1,'all');
% 
%     % Plot surface + contour + population
%     surfc(S_struct.FVc_xx,S_struct.FVc_yy,S_struct.FM_meshd,'Parent',subplot1,'EdgeColor','none');
%     plot3(S_struct.FM_pop(:,1),S_struct.FM_pop(:,2),ackley1(S_struct.FM_pop(:,1),S_struct.FM_pop(:,2)),...
%               'Parent', subplot1,'MarkerSize',20,'Marker','.','LineStyle','none','Color',[0 0 0]);
%     
%     % Create title
%     %title(sprintf('Ackley''s function + Population individuals after the %d-th Evolution',iter),'FontSize',14,'Parent',subplot1);
%     
%     
%     % Create subplot2 axes
%     subplot2 = subplot(1,2,2,'Parent',figure1,'Layer','top','FontSize',14,'FontName','Helvecia');
%     xlim(subplot2,[-3 3]);
%     ylim(subplot2,[-3 3]);
%     box(subplot2,'on');
%     hold(subplot2,'all');
% 
%     % Plot contour + population
%     contour(S_struct.FVc_xx,S_struct.FVc_yy,S_struct.FM_meshd,20,'LineWidth',1.5,'Parent',subplot2);
%     plot(S_struct.FM_pop(:,1),S_struct.FM_pop(:,2),'Parent',subplot2,'MarkerSize',20,'Marker','.',...
%             'LineStyle','none','Color',[0 0 0]);
    
    %title(sprintf('Ackleys function + population \n Iteration: %d ',iter));