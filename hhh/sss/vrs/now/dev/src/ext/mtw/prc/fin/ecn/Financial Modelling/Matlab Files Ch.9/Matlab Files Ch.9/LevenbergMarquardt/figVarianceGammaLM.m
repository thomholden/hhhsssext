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




load 'vgLM'
xstar = [0.125; 0.375; 0.2];

% Create figure
figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'FontSize',14);
view(axes1,[-149.5 30]);
grid(axes1,'on');
hold(axes1,'all');

% Create plot3
plot3(X(1,:),X(2,:),X(3,:),'Parent',axes1,'MarkerSize',7,'Marker','o','LineWidth',1.5,...
    'DisplayName','$x^k$',...
    'Color',[0 0 0]);

% Create plot3
plot3(xstar(1),xstar(2),xstar(3),'Parent',axes1,'MarkerSize',18,'Marker','*',...
    'LineStyle','none',...
    'LineWidth',1.5,...
    'Color',[0 0 0],...
    'DisplayName','$x^\star=(0.125,0.375,0.2)^\top$');

% Create xlabel
xlabel('$\sigma$','Interpreter','latex','HorizontalAlignment','right',...
    'FontSize',27,...
    'FontName','Agency FB','Position',[-0.7626048166055137,3.9199196471712896,1.191666429935041]);

% Create ylabel
ylabel('$\nu$','Interpreter','latex','FontSize',27,'FontName','Agency FB',...
    'HorizontalAlignment','left','Position',[-0.9241885996729162,3.6915726006856975,1.2200119060015626]);

% Create zlabel
zlabel('$\theta$','Interpreter','latex','FontSize',27,...
    'FontName','Agency FB','Rotation',0);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Interpreter','latex','FontSize',18,'Location','NorthEast');

