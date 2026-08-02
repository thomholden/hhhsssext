% Example script ACD_Simul and ACD_Fit for ACD(1,1)
% It will first simulate a ACD model and then fit it using the fitting
% function

clear;
load Example_Data.mat;
addpath('mFiles_ACD');

%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose your distribution (just comment the one you dont want)

dist='exp';
% dist='weibull';

% Choose your flavor (parameters)

q=2;
p=2;
x=dur;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[specOut]=ACD_Fit(x,dist,q,p);    % Fitting

plot([specOut.h x]);
title('Duration Simulation and Modelling');
legend('Fitted Duration', 'Real Duration');
xlabel('Observations');
ylabel('Durations');

rmpath('m_Files_ACD');