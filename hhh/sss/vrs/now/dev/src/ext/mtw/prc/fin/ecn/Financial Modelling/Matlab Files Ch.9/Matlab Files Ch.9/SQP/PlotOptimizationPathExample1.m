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



load iterMatEx1
% load iterMat1Ex1

% Plots the contour of the objective function
% the feasible domain and marks the optimal solution
% for the following example

%Example 1:         min f(x1,x2) = -5x1+x1^2-5x2+x2^2
% accoring to       g1(x1,x2) = x1+2x2-8  <= 0
%                   g2(x1,x2) = 3x1+x2-9  <= 0
%                                   x1,x2 >= 0

%The optimal solution is given by x1 = 2.2, x2 = 2.4

x = (0:0.1:4)';
[xdata1,ydata1] = meshgrid(x,x);
zdata1 = -5*xdata1 + xdata1.^2 -5*ydata1 + ydata1.^2;

g1 = xdata1 + 2*ydata1 -8;
g2 = 3*xdata1 + ydata1 -9;

I = g1 <= 0 & g2 <= 0;

X1 = xdata1(I);
Y1 = ydata1(I);

% Create figure
figure1 = figure('Color',[1 1 1]);
colormap('gray');

% Create axes
axes1 = axes('Parent',figure1,'Layer','top','FontSize',14);
xlim(axes1,[0 4]);
ylim(axes1,[0 4]);
box(axes1,'on');
hold(axes1,'all');

% Create contour
contour(xdata1,ydata1,zdata1,'LineWidth',2);

% Create plot
plot(X1,Y1,'Marker','.','LineStyle','none','Color',[0 0 0]);

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
