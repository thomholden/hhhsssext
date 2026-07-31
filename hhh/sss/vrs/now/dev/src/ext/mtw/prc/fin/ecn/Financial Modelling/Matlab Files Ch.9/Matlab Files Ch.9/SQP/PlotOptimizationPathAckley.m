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



load iterMatAckley
% load iterMat1Ackley

% Plots the contour of the objective function
% the feasible domain and marks the optimal solution
% for the following example

x = (-3:0.1:3)';
[xdata1,ydata1] = meshgrid(x,x);
zdata1 = exp(1)+20*(1-exp(-0.2*sqrt(0.5*(xdata1.^2+ydata1.^2))))...
        -exp(0.5*(cos(2*pi*xdata1)+cos(2*pi*ydata1)));


% Create figure
figure1 = figure('Color',[1 1 1]);
colormap('gray');

% Create axes
axes1 = axes('Parent',figure1,'Layer','top','FontSize',14);
xlim(axes1,[-3 3]);
ylim(axes1,[-3 3]);
box(axes1,'on');
hold(axes1,'all');

% Create contour
contour(xdata1,ydata1,zdata1,'LineWidth',2);

% Create plot
plot(vecX(1,:),vecX(2,:),'Marker','*','LineStyle','-','Color',[0 0 0],'MarkerSize',10,'LineWidth',2);

% Create xlabel
xlabel('$x_1$','Interpreter','latex','FontSize',20);

% Create ylabel
ylabel('$x_2$','Interpreter','latex','FontSize',20);

% Create textbox
annotation(figure1,'textbox',...
    [0.561714285714286 0.566469726322936 0.0406666666666667 0.0485994984996093],...
    'Interpreter','latex',...
    'String',{'$x^\star$'},...
    'FontSize',20,...
    'FitBoxToText','off',...
    'LineStyle','none');
