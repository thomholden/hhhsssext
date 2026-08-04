% ex5.m             
%
% The program approximates f(s) with rational functions. f(s) is a vector of 5 elements
% represnting one column of the propagation matrix of a transmission line (parallell AC and DC line).
% The elements of the prop. matrix have been backwinded using a common time delay equal
% to the lossless time delay of the line. 
%
% -Reading frequency response f(s) from disk. (contains 5 elements)
% -Fitting f(s) using vectfit2.m 
% -Initial poles: 7 linearly spaced complex pairs (N=14)
% -5 iterations
%
% This example script is part of the vector fitting package (v2.1) 
% Last revised: 27.10.2005. 
% Created by:   Bjorn Gustavsen.

clear all

Ns=60; f=zeros(5,Ns); w=zeros(Ns,1); 
fid1=fopen('w.txt','r');
fid2=fopen('h.txt','r');
for k=1:Ns
  [w(k)]=fscanf(fid1,'%e',1);
  for n=1:5 
    [a1]=fscanf(fid2,'%e',1); [a2]=fscanf(fid2,'%e',1);
    f(n,k)=a1+i*a2;
  end
end
fclose(fid1);fclose(fid2);
s=i*w;

%=====================================
% Rational function approximation of f(s):
%=====================================


N=14; %Order of approximation 

%Complex starting poles :
bet=linspace(w(1),w(Ns),N/2);
%bet=logspace(log10(w(1)),log10(w(Ns)),N/2);
poles=[];
for n=1:length(bet)
  alf=-bet(n)*1e-2;
  poles=[poles (alf-i*bet(n)) (alf+i*bet(n)) ]; 
end

% Real starting poles :
%poles=-linspace(w(1),w(Ns),N); 
%poles=-logspace(log10(w(1)),log10(w(Ns)),N); 

%Parameters for Vector Fitting : 

weight=ones(1,Ns);
%weight=1./abs(f);

VF.relax=1;      %Use vector fitting with relaxed non-triviality constraint
VF.kill=2;       %Enforce stable poles
VF.asymp=1;      %Fitting with D=0, E=0 
VF.skip_pole=0;  %Do NOT skip pole identification
VF.skip_res=0;   %Do NOT skip identification of residues (C,D,E) 
VF.use_normal=1; %Use Normal Equations instead of QR decomp.
VF.use_sparse=1; %Use sparse computations (pole identification)
VF.cmplx_ss=1;   %Create complex state space model

VF.spy1=0;       %No plotting for first stage of vector fitting
VF.spy2=1;       %Create magnitude plot for fitting of f(s) 
VF.logx=1;       %Use logarithmic abscissa axis
VF.logy=1;       %Use logarithmic ordinate axis 
VF.errplot=1;    %Include deviation in magnitude plot
VF.phaseplot=1;  %Also produce plot of phase angle (in addition to magnitiude)
VF.legend=0;     %Do NOT include legends in plots

Niter=5;
for iter =1:Niter
  if iter==Niter, VF.legend=1;end
  [SER,poles,rmserr,fit]=vectfit2(f,s,poles,weight,VF);
  rms(iter,1)=rmserr;
end




