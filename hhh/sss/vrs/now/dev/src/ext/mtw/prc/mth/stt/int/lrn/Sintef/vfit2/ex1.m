% ex1.m             
%
% Fitting an artificially created frequency response (single element)
%
% -Creating a 3rd order frequency response f(s)
% -Fitting f(s) using vectfit2.m 
%   -Initial poles: 3 logarithmically spaced real poles
%   -1 iteration
%
% This example script is part of the vector fitting package (v2.1) 
% Last revised: 27.10.2005. 
% Created by:   Bjorn Gustavsen.
%
clear all

%Frequency samples:
Ns=101;
s=2*pi*i*logspace(0,4,Ns); 

disp('Creating frequency response f(s)...') 
for k=1:Ns
  sk=s(k);
  f(1,k) = 2/(sk+5) + (30+j*40)/(sk-(-100+j*500)) ...
+ (30-j*40)/(sk-(-100-j*500)) + 0.5;
end


%Initial poles for Vector Fitting:
N=3; %order of approximation
poles=-2*pi*logspace(0,4,N); %Initial poles

weight=ones(1,Ns); %All frequency points are given equal weight

VF.relax=1;      %Use vector fitting with relaxed non-triviality constraint
VF.kill=2;       %Enforce stable poles
VF.asymp=3;      %Include both D, E in fitting    
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
VF.legend=1;     %Do include legends in plots



disp('vector fitting...')
[SER,poles,rmserr,fit]=vectfit2(f,s,poles,weight,VF); 
disp('Done.')

disp('Resulting state space model:')
A=full(SER.A)
B=SER.B
C=SER.C
D=SER.D
E=SER.E
rmserr 