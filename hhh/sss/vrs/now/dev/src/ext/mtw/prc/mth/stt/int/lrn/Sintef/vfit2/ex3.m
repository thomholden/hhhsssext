% ex3.m             
%
% Fitting a measured admittance function from distribution transformer
% (single element)
%
% -Reading frequency response f(s) from disk. (contains 1 element)
% -Fitting f(s) using vectfit2.m 
%   -Initial poles: 3 linearly spaced complex pairs (N=6)
%   -3 iterations
%
% This example script is part of the vector fitting package (v2.1) 
% Last revised: 27.10.2005. 
% Created by:   Bjorn Gustavsen.
%

clear all

fid1=fopen('03pk10.txt','r');       
  [A1]=fscanf(fid1,'%f',1); %Skipper den første linja..
  [A2]=fscanf(fid1,'%f',1); 

f=zeros(1,160);
for k=1:160   
  [A1]=fscanf(fid1,'%f',1);
  [A2]=fscanf(fid1,'%f',1); 
  f1=real(A1*exp(i*A2*pi/180));
  f2=imag(A1*exp(i*A2*pi/180));
  f(1,k)=f1+i*f2;
end

w=2*pi*linspace(0,10e6,401); w(1)=[]; w(161:400)=[];
s=i.*w; Ns=length(s);

%=====================================
% Rational function approximation of f(s):
%=====================================

N=6; %Order of approximation 

%Complex starting poles :
bet=linspace(w(1),w(Ns),N/2);
poles=[];
for n=1:length(bet)
  alf=-bet(n)*1e-2;
  poles=[poles (alf-i*bet(n)) (alf+i*bet(n)) ]; 
end

weight=ones(1,Ns); %No weighting
%weight=1./abs(f); %Weighting with inverse of magnitude function

VF.relax=1;      %Use vector fitting with relaxed non-triviality constraint
VF.kill=2;       %Enforce stable poles
VF.asymp=3;      %Include both D, E in fitting    
VF.skip_pole=0;  %Do not skip pole identification
VF.skip_res=0;   %Do not skip identification of residues (C,D,E) 
VF.use_normal=0; %Use Normal Equations
VF.use_sparse=1; %Use sparse computations
VF.cmplx_ss=1;   %Create real-only state space model

VF.spy1=0;       %No plotting for first stage of vector fitting
VF.spy2=1;       %Create magnitude plot for fitting of f(s) 
VF.logx=0;       %Use linear abscissa axis
VF.logy=1;       %Use logarithmic ordinate axis 
VF.errplot=1;    %Include deviation in magnitude plot
VF.phaseplot=1;  %Include plot of phase angle
VF.legend=0;     %do NOT include legends in plots

disp('vector fitting...')
Niter=5;
for iter=1:Niter
  if iter==Niter, VF.legend=1; end %Include legend in final plot
  disp(['   Iter ' num2str(iter)])
  [SER,poles,rmserr,fit]=vectfit2(f,s,poles,weight,VF); 
  rms(iter,1)=rmserr;
end
disp('Done.')


