% Example script ACD_Simul and ACD_Fit for ACD(2,2)
% It will first simulate a ACD model and then fit it

clear;

addpath('mFiles_ACD');

%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nr=1000;    % How many observations in the simulation

% Choose your distribution (just comment the one you dont want)

% dist='exp';
dist='weibull';

% Choose your parameters

Coeff.w=.2;         % constant in expected duration (psi)
Coeff.q=[.1 .1];    % Coeff at duration in t-1 (alpha)
Coeff.p=[.2 .4];    % Coeff at expected duration in t-1 (beta)
Coeff.y=.8;         % just for weibull dist

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q=size(Coeff.q,2);
p=size(Coeff.p,2);

simulDur=ACD_Simul(nr,Coeff,q,p,dist);  % Simulation

[specOut]=ACD_Fit(simulDur,dist,q,p);    % Fitting

plot([specOut.h simulDur]);
title('Duration Simulation and Modelling');
legend('Fitted Duration', 'Real Duration');
xlabel('Observations');
ylabel('Durations');

rmpath('m_Files_ACD');