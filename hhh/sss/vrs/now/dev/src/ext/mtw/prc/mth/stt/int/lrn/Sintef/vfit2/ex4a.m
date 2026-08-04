% ex4a.m             
%
% Fitting 1st column of the admittance matrix of 6-terminal system 
% (power system distribution network)
%
% -Reading frequency admittance matrix Y(s) from disk.
% -Extracting 1st column: f(s) (contains 6 elements)
% -Fitting f(s) using vectfit2.m 
%   -Initial poles: 25 linearly spaced complex pairs (N=50)
%   -5 iterations
%
% This example script is part of the vector fitting package (v2.1) 
% Last revised: 27.10.2005. 
% Created by:   Bjorn Gustavsen.
%

clear all

disp('Reading data from file ...') %--> s(1,Ns), bigY(Nc,Nc,Ns)
fid1=fopen('fdne.txt','r');
Nc=fscanf(fid1,'%f',1);
Ns=fscanf(fid1,'%f',1);
bigY=zeros(Nc,Nc,Ns); s=zeros(1,Ns);
for k=1:Ns
  s(k)=fscanf(fid1,'%e',1);
  for row=1:Nc
    for col=1:Nc
      dum1=fscanf(fid1,'%e',1);
      dum2=fscanf(fid1,'%e',1);   
      bigY(row,col,k)=dum1+j*dum2;
    end
  end
end
s=i*s;
fclose(fid1);



%Extracting first column:
for n=1:Nc
  f(n,:)=squeeze(bigY(n,1,:)).';
end  

tic
disp('-----------------S T A R T--------------------------')


%Fitting parameters:

N=50; %Order of approximation 
%Complex starting poles :
w=s/i;
bet=linspace(w(1),w(Ns),N/2);
poles=[];
for n=1:length(bet)
  alf=-bet(n)*1e-2;
  poles=[poles (alf-i*bet(n)) (alf+i*bet(n)) ]; 
end


%weight=ones(Nc,Ns);
%weight=1./abs(f);
weight=1./sqrt(abs(f));

%Fitting options
VF.relax=1;      %Use vector fitting with relaxed non-triviality constraint
VF.kill=2;       %Enforce stable poles
VF.asymp=3;      
VF.spy1=0; 
VF.spy2=1; 
VF.logx=0; 
VF.logy=1; 
VF.errplot=1;
VF.phaseplot=1;

VF.skip_pole=0; 
VF.skip_res=0;
VF.use_normal=1; 
VF.use_sparse=1;
VF.cmplx_ss=0;
VF.legend=0;

Niter=5;
disp('*****Fitting column...')
for iter=1:Niter
  disp(['   Iter ' num2str(iter)])  
  if iter==Niter, VF.legend=1;end
  [SER,poles,rmserr,fit]=vectfit2(f,s,poles,weight,VF);  
  rms(iter)=rmserr;
end

disp('-------------------E N D----------------------------')
toc
