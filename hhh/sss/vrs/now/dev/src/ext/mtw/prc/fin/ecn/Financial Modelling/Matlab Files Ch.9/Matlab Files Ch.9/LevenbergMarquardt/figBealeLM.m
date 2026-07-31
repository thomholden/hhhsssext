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

x = (-4:0.15:4)';
[xdata1,ydata1] = meshgrid(x,x);
zdata1 = beale(xdata1,ydata1);

% Create figure
figure1 = figure('Color',[1 1 1]);
colormap('gray');

% Create axes
axes1 = axes('Parent',figure1,'FontSize',14,'FontName','Helvetia');
xlim(axes1,[-4 4]);
ylim(axes1,[-4 4]);
grid(axes1,'on');
box(axes1,'on');
hold(axes1,'all');


load iterBealeLM
plot(X(1,:),X(2,:),'-k.','Parent',axes1,'LineWidth',1.5,'MarkerSize',22)

load iterBealeSLM
plot(sX(1,:),sX(2,:),'--k*','Parent',axes1,'LineWidth',1.5,'MarkerSize',14)
legend('LM','secantLM')


% Create contour plot
contour(xdata1,ydata1,log10(zdata1),20,'Parent',axes1,'LineWidth',1)

% Create title
title({'Progress of the LM-method for the Beale Function Example'},'FontSize',16,'FontName','Helvetia');

% Create figure
figure2 = figure('Color',[1 1 1]);

% Create axes
axes2 = axes('Parent',figure2,'FontSize',16,'FontName','Helvetia');
grid(axes2,'off');
box(axes2,'on');
% hold(axes2,'all');

semilogy(1:17,perf.f,'kv',1:22,sperf.f,'ko','Parent',axes2,'MarkerSize',12,'LineWidth',1.5)
leg = legend('LM', 'secantLM');
set(leg,'Interpreter','latex','FontName','Helvetia','FontSize',18)
xlabel('$k$','Interpreter','latex','FontName','Helvetia','FontSize',20)
ylabel('$f(x^k)$','Interpreter','latex','FontName','Helvetia','FontSize',20)