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
% (C) Joerg Kienitz, Daniel Wetterau and Sven Glaser
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [  ] = PlotFigure6( V,kappa,T)
xi=[.3,.5,.8,1.3];                  % different volatility of variance
area1=xi*0;
x=0.01:.01*T:4*T; x = [0 x];        % x values; we need x(1) = 0

y=zeros(length(x),length(xi));
figure('Color', [1 1 1]);
hold on


for j=1:length(xi)
    y(:,j)=DichteVar_new(x,T,kappa,xi(j),V);    % calculate values
    area1(j) = area(x,y(:,j));                  % for plot
end


plot(x,y(:,1),'-','Color', [.6 .6 .6]);
plot(x,y(:,2),'--','Color', [.4 .4 .4]);
plot(x,y(:,3),':','Color', [.2 .2 .2]);
plot(x,y(:,4),'-.','Color', [.1 .1 .1]);
legend('\nu = 0.3','\nu = 0.5','\nu = 0.8','\nu = 1.3');
set(area1(1),'FaceColor',[.6 .6 .6],'DisplayName','\nu = 0.3');
set(area1(2),'FaceColor',[.4 .4 .4],'DisplayName','\nu = 0.5');
set(area1(3),'FaceColor',[.2 .2 .2],'DisplayName','\nu = 0.8');
set(area1(4),'FaceColor',[.1 .1 .1],'DisplayName','\nu = 1.3');
alpha(.5)
hold off
box('on');
title(['Density of the integrated variance T=', num2str(T)]);  ...
    ylabel('y'); xlabel('x'); grid('on');
end

