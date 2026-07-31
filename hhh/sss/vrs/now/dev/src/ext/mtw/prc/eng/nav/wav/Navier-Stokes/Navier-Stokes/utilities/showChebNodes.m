function showChebNodes(N)
%SHOWCHEBNODES   Displays the extrema of the Chebyshev polynomials of the
%first kind on the perimeter of the upper curve of a unit circle.
%
%   See also   SHOWGRID

%   Zoltán Csáti
%   2014/07/03

if nargin == 0
    N=10;
end
xCheb = cos(pi*(0:N)/N);
yCheb = sqrt(1-xCheb.^2);
x = -1:0.005:1;
y = sqrt(1-x.^2);
xAxis = zeros(1,N+1);
figure; % create a new figure so as not to overwrite the actual one
set(gca,'XLim',[-1 1], 'YLim',[0,1.002], 'DataAspectRatio',[1 1 1], 'NextPlot','Add');
line(xCheb,yCheb, 'LineStyle','none', 'Marker','o', 'MarkerSize',8, ...
    'MarkerFaceColor','blue');
line(x,y, 'LineWidth',2);
line(xCheb,xAxis, 'LineStyle','none', 'Marker','o', 'MarkerSize',8,...
    'MarkerFaceColor','red');
plot([xCheb; xCheb],[xAxis; yCheb],'b');