%% SIMPLE X-Y PLOT WITH BLACK-FILLED MARKERS
figure
plot(1:10,1:10,'ko','MarkerEdgeColor','k','MarkerFaceColor','w')
xlabel('x label')
ylabel('y label')
title('x-y plot')

% print
print('-depsc2','-loose','xy_plot')

% tidy up
pretty_xyplot

% prepare output
readyforprint([3 3],8,'r','w',0.5)

% print
print('-depsc2','-loose','nice_xy_plot')
fixPSlinestyle('nice_xy_plot.eps','nice_xy_plot.eps');

% and a jpeg, because we need it for the Mathworks website
print('-djpeg','nice_xy_plot')


%% PEAKS FUNCTION

% generate the plot
figure
[X,Y,Z] = peaks(30);
subplot(1,2,1)
surfc(X,Y,Z)
colormap hsv
axis([-3 3 -3 3 -10 5])
xlabel('x label')
ylabel('y label')
zlabel('z label')
title('Surface Plot')

subplot(1,2,2)
contourf(X(1,:),Y(:,1),Z)
colormap hsv
axis([-3 3 -3 3])
set(gca,'DataAspectRatio',[1 1 1])
xlabel('x label')
ylabel('y label')
title('Rotated Surface Plot')
cb = colorbar('Location','SouthOutside')
set(get(cb,'XLabel'),'String','Value')
legend('Peaks Function')
set(legend,'Location','NorthEast')

% print
print('-depsc2','-loose','raw_peaks')

% tidy up
pretty_xyplot
caxis([-10 10])

% prepare output
readyforprint([6 3.5],8,'k','w',0.5)

% print
print('-depsc2','-loose','nice_peaks')
fixPSlinestyle('nice_peaks.eps','nice_fixed_peaks.eps');

% and a jpeg, because we need it for the Mathworks website
print('-djpeg','nice_peaks')

%% close the figure we just created
close

%% SCATTER PLOT
figure
x = 1:25;
y = randg(10,25,1);
gscatter(x,y, floor(y/5))

xlabel('x label')
ylabel('y label')
title('Gscatter Using Random Numbers')
set(legend,'Location','Best')

% print
print('-depsc2','-loose','random_numbers')

% tidy up
pretty_xyplot

% prepare output
readyforprint([3 3],8,'b','w',0.5)

% print
print('-depsc2','-loose','nice_random_numbers')
fixPSlinestyle('nice_random_numbers.eps','nice_random_numbers.eps');
print('-djpeg','nice_random_numbers')