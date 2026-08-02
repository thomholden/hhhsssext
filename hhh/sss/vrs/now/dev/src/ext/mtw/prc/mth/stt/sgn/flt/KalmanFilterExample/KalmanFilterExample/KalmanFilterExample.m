%% Estimating the constant value x(k)=x(k+1)=0.12345 
% Created by Lazaros Moysis http://users.auth.gr/lazarosm/
%
% Using the measurement z(k)=x(k)+w(k) where w is a white noise
% w~N(0,0.01), we'll implement Kalman's filter algorithm for discrete time.
%% Create the noise and data
% create a random sequence of numbers. function randn draws numbers from
% standard normal distribution.
r=0.01;
noise=randn(1,150);
% create the random white noise sequence by multiplying the set of random
% numbers by the %standard deviation (tipiki apoklisi) of w.
w=sqrt(r)*noise;
% create the measurements vector
zmeasure=0.12345+w;
% create the real-time constant vector
xconstant1(1:150)=0.12345;
%%  The kalman filter algorithm (first 150 estimations)
     xprior(1)=0;
     Pprior(1)=1;
     K(1)=Pprior(1)/(Pprior(1)+r);
    xpost(1)=xprior(1)+K(1)*(zmeasure(1)-xprior(1));
    Ppost(1)=(1-K(1))*Pprior(1);
for i=2:150
    xprior(i)=xpost(i-1);
    Pprior(i)=Ppost(i-1);
    K(i)=Pprior(i)/(Pprior(i)+r);
    xpost(i)=xprior(i)+K(i)*(zmeasure(i)-xprior(i));
    Ppost(i)=(1-K(i))*Pprior(i);
end
k=1:150;
%% Plotting the results
fig = figure;
set(fig, 'Position', [100 100 900 500]);
% The above two commands help determine the size and position of the figure
plot(k,xpost(k),'*',k,zmeasure(k),'g--',k,xconstant1(k),'r')
legend('estimation','measurements','real-time quantity')
xlabel 'time (discrete)'
title 'Kalman Filtering'
%% References
% [1] Ôechnical staff, the analytic sciences corporation, edited by Arthur
% Gelb (1974). Applied Optimal Estimation. The MIT Press.
%
% [2] Feng Lin (2007). Robust Control Design, An optimal control approach.
% John Wiley and Sons.
%
% [3] Alok Sinha (2007). Linear Systems, Optimal and Robust Control. CRC
% Press.
%
% [4] Lazaros Moysis 2012, The Kalman FIlter (In Greek), Assignment for the
% M.Sc. course "Optimal Control of systems".
% http://users.auth.gr/lazarosm/KalmanFilter-MoysisLazaros.pdf
