% ex5.m             
%
% The program creates artificial frequency response f(s) for a single 
% time delay. Then f(s) is fitted using Vector Fitting.
% -Fitting f(s) using vectfit2.m 
% -Initial poles: 15 linearly spaced complex pairs (N=30)
% -3 iterations
%
% This example script is part of the vector fitting package (v2.1) 
% Last revised: 27.10.2005. 
% Created by:   Bjorn Gustavsen.




%

clear all




tau=1e-5; %time delay of 10 microsec
s=2*pi*i*linspace(0,1e6); Ns=length(s);
w=s/i;
f=zeros(1,Ns);
for k=1:Ns
  f(1,k)=exp(-s(k)*tau);  
end

%=====================================
% Rational function approximation of f(s):
%=====================================


N=30; %Order of approximation 

%Complex starting poles :
bet=linspace(w(1),w(Ns),N/2);
poles=[];
for n=1:length(bet)
  alf=-bet(n)*1e-2;
  poles=[poles (alf-i*bet(n)) (alf+i*bet(n)) ]; 
end

% Real starting poles :
%poles=-linspace(w(1),w(Ns),N); 
 
%Parameters for Vector Fitting : 

weight=ones(1,Ns);

VF.relax=1;      %Use vector fitting with relaxed non-triviality constraint
VF.kill=2;       %Enforce stable poles
VF.asymp=3;      %Include both D, E in fitting    
VF.skip_pole=0;  %Do NOT skip pole identification
VF.skip_res=1;   %DO skip identification of residues (C,D,E) 
VF.use_normal=1; %Use Normal Equations
VF.use_sparse=1; %Use sparse computations
VF.cmplx_ss=0;   %Create real-only state space model

VF.spy1=0;       %No plotting for first stage of vector fitting
VF.spy2=1;       %Create magnitude plot for fitting of f(s) 
VF.logx=0;       %Use linear abscissa axis
VF.logy=1;       %Use logarithmic ordinate axis 
VF.errplot=1;    %Include deviation in magnitude plot
VF.phaseplot=1;  %Do NOT produce plot of phase angle
VF.legend=1;     %Include legends in plots


disp('vector fitting...')
Niter=3;
for iter=1:Niter
  if iter==Niter, VF.skip_res=0; end
  disp(['   Iter ' num2str(iter)])
  [SER,poles,rmserr,fit]=vectfit2(f,s,poles,weight,VF);
  rms(iter,1)=rmserr;
end
rms