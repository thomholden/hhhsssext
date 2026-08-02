% Example script ACD_Simul and ACD_Fit for ACD(1,1)
% It will first simulate a ACD model and then fit it using the fitting
% function

clear;

addpath('mFiles_ACD');

%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nr=1000;    % How many observations in the simulation

% Choose your distribution (just comment the one you dont want)

% dist='exp';
dist='weibull';

% Choose your flavor (parameters)

Coeff.w=.1; % constant in expected duration (psi)
Coeff.q=.2; % Coeff at duration in t-1 (alpha)
Coeff.p=.7; % Coeff at expected duration in t-1 (beta)
Coeff.y=.8; % just for weibull dist

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q=size(Coeff.q,2);
p=size(Coeff.p,2);

simulDur=ACD_Simul(nr,Coeff,q,p,dist);  % Simulation

rmpath('m_Files_ACD');