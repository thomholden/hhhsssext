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



%  XDATA1:  surface xdata
%  YDATA1:  surface ydata
%  ZDATA1:  surface zdata

x = (-10:0.11:10)';
[xdata1,ydata1] = meshgrid(x,x);
zdata1 = exp(xdata1).*(4*xdata1.^2+2*ydata1.^2+4*xdata1.*ydata1 + 2*ydata1 + 1);

% Create figure
figure1 = figure('Color',[1 1 1]);
colormap('gray');

% Create axes
axes1 = axes('Parent',figure1,'FontSize',14,'FontName','Helvetia');
xlim(axes1,[-10 10]);
ylim(axes1,[-10 10]);
grid(axes1,'off');
box(axes1,'on');
hold(axes1,'all');

% Create surf
contour(xdata1,ydata1,log10(zdata1),25,'Parent',axes1,'LineWidth',1.5)

I = xdata1.*ydata1-xdata1-ydata1 < -1.5 & -xdata1.*ydata1 < 10;
plot(xdata1(I),ydata1(I),'k.')

% Create title
title({'Contour of $f(x) = \exp(x_1)(4x_1^2+2x_2^2+4x_1x_2 + 2x_2 + 1)$ and feasible domain $\mathcal{X}$'},'FontSize',16,'Interpreter','latex','FontName','Helvetia');