% Example use of KS statistic

pdev=10;
pmean=10;
N=1000;

disp('Normal data');
x=pdev*randn(N,1)+pmean;

sdev=std(x);
smean=mean(x);

nx=(x-smean)/sdev;

prob = ksone (nx,'cdf_norm');
disp(sprintf('Prob normal = %1.4f', prob));

disp('Uniform data');
x=pdev*rand(N,1)+pmean;

sdev=std(x);
smean=mean(x);

nx=(x-smean)/sdev;

prob = ksone (nx,'cdf_norm');
disp(sprintf('Prob normal = %1.4f', prob));

