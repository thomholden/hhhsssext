function [rate, fraction] = opcurve (t,y,c)

% function [rate,fraction] = opcurve (t,y,c)
% Plot whole operating curve of a classifier
% ie. the correct classification rate versus the classified fraction
% t	the true value (1 or 0)
% y	the estimated value form the classifier
% c	the symbol used to plot the data eg. '-'


i=1;
for r=0.0:0.01:0.4,
	[rate(i),fraction(i)]=rclassify (t,y,0.5,r);
	i=i+1;
end
plot(1-rate,fraction,c);
title('Operating curve');
xlabel('Error rate');
ylabel('Classified fraction');