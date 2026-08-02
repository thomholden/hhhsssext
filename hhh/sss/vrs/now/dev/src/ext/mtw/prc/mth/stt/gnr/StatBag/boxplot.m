function [] = boxplot (x0)

% Function not yet written

disp('Function not yet written');

n=length(x0);
xs0=sort(x0);
lower_quartile=xs0(n*0.25);
upper_quartile=xs0(n*0.75);
xmed0=median(x0);
xlwhisker=mean(x0)-3*std(x0);
xuwhisker=mean(x0)+3*std(x0);


