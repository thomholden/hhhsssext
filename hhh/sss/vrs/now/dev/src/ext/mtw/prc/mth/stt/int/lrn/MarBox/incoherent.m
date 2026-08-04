function [x,y,e] = incoherent (f,total_seconds, ns, noise, ctime)

% function [x,y,e] = incoherent (f,total_seconds, ns, noise, ctime)
%
% Generate two incoherent 10Hz time-series
% ie. they have a random phase lag
% f                 basic frequency
% total_seconds     to generate
% ns                samples per second
% ctime                 coherency time (in seconds)

%total_seconds=2;
%ns=128;

t=[1/ns:1/ns:total_seconds];
T=size(t,2);
s=cos(2*pi*f*t);

% Number of phase changes Np
Np=ceil(total_seconds/ctime);
% Number of samples in phase
Ip=ceil(ctime*ns);

pc=2*pi*rand(1,Np);
phi=reshape((pc'*ones(1,Ip))',Np*Ip,1);

% Cut off last few samples of phase vector if necessary
phi=phi(1:T,:)';
s2=cos(2*pi*f*t+phi);
e1=noise*randn(1,T);
x=s+e1;

% make y correlated to x
e2=noise*randn(1,T);
y=s2+e2;

e=[e1;e2];













