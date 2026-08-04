% Generate coherent or incoherent time series and get MAR coefficients
% - then regenerate data using MAR model
% and get (cross)-spectra from MAR coefficients

% MAR underestimates COV(Zt) - the noise component

ns=128;
total_seconds=5;
noise=1;
f=10;
[x1,y1,e]=coherent(f,total_seconds,ns,sqrt(noise));
%[x1,y1,e]=incoherent(f,total_seconds,ns,noise,0.1);
t=[1/ns:1/ns:total_seconds];

%figure
%plot(t,x1);
%hold on
%plot(t,y1+5);

% Get MAR model of multivariate time series
p=8;
mar = mar_learn ([x1(:),y1(:)],p);
%Y   = mar_gen   (mar, total_seconds*ns, e);
Y   = mar_gen   (mar, total_seconds*ns);

disp('Spectra of original series');
plot_cohere(x1,y1,t,ns);

disp('Spectra of artificial series generated from learnt MAR model');
plot_cohere(Y(1,:),Y(2,:),t,ns);

% This shows that the noise cov being underestimated can be a problem
% mar2.noise_cov=mar.noise_cov;
% Y3   = mar_gen   (mar2, total_seconds*ns);
% plot_cohere(Y3(1,:),Y3(2,:),t,ns);

mar_plot_spectra(mar,1,2,ns);



