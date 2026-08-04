function [] = mar_cohere_compare (mar1, mar2)

% function [] = mar_cohere_compare (mar1, mar2)
% Compare coherence plots for two MAR models

%for k=1:p,
%  mar_real1.lag(k).a
%  mar1.lag(k).a
%end
  

% Get AR-estimated coherency of learnt HMM state 1 data
mar1=mar_cov(mar1);
[c12,f]=mar_cohere(mar1,1,2,128);
figure
plot(f,c12,':');

% Get AR-estimated coherency of true state 1 data
mar2=mar_cov(mar2);
[c12,f]=mar_cohere(mar2,1,2,128);
hold on
plot(f,c12);
%axis([0 max(f) 0 1]);
title('Coherency');
