% ex4d.m             
%
% Fitting all elements of the admittance matrix Y of a six-terminal system 
% (power system distribution network) while reducing likelihood of
% passivity violations.
%
% -Reading frequency admittance matrix Y(s) from disk.
% -Creating a state-space model with common pole set using the procedure in ex4c.m 
% -Throwing out poles above the upper frequency limit -->A,B
% -Recalculating C,D,E (with poles unchanged) by refitting
% -Enforcing eigenvalues of D,E to be positive --> Dmod, Emod
% -Forming Ymod=Y -(D+s*Emod)
% -Fitting Ymod with D=0,E=0, poles unchanged -->C
% -Forming resulting model: A,B,C,Dmod,Emod
% -Converting state-space model into pole-residue model (a,R,Dmod,Emod):
%
% This example script is part of the vector fitting package (v2.1) 
% Last revised: 27.10.2005. 
% Created by:   Bjorn Gustavsen.
%

clear all


N=50; %order of approximation
Niter1=5; %Fitting column sum: n.o. iterations
Niter2=3; %Fitting column: n.o. iterations

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


tic
disp('-----------------S T A R T--------------------------')

disp('****Stacking matrix elements (lower triangle) into single column ...')
tell=0;
for col=1:Nc
  for row=col:Nc
    tell=tell+1;
    f(tell,:)=squeeze(bigY(row,col,:)).'; %stacking elements into a single vector
  end
end


AA=sparse([]); BB=sparse([]); CC=[]; DD=[]; EE=[];
bigf=[]; bigfit=[];


%Complex starting poles :
w=s/i;
bet=linspace(w(1),w(Ns),N/2);
poles=[];
for n=1:length(bet)
  alf=-bet(n)*1e-2;
  poles=[poles (alf-i*bet(n)) (alf+i*bet(n)) ]; 
end


%weight=ones(1,Ns);
%weight=1./abs(f);
weight=1./sqrt(abs(f));

%Fitting options
VF.relax=1;      %Use vector fitting with relaxed non-triviality constraint
VF.kill=2;            %Enforcing stable poles
VF.asymp=3;       %Fitting includes D and E
VF.spy1=0; 
VF.spy2=1; 
VF.logx=0; 
VF.logy=1; 
VF.errplot=1;
VF.phaseplot=1;

VF.skip_pole=0; 
VF.skip_res=1;
VF.use_normal=1; 
VF.use_sparse=1;
VF.cmplx_ss=1;  %=1 --> Will generate state space model with diagonal A
VF.legend=1;

  

%Forming (weighted) column sum:
g=0;
for n=1:Nc
  %g=g+f(n,:); %unweighted sum     
  g=g+f(n,:)/norm(f(n,:));
  %g=g+f(n,:)/sqrt(norm(f(n,:)));     
end
weight_g=1./abs(g);

disp('****Calculating improved initial poles by fitting column sum ...')
for iter=1:Niter1
   disp(['   Iter ' num2str(iter)])
   if iter==Niter1,VF.skip_res=0; end
  [SER,poles,rmserr,fit]=vectfit2(g,s,poles,weight_g,VF);  
end
 
disp(['****Fitting column ...'])
VF.skip_res=1;
for iter=1:Niter2
  disp(['   Iter ' num2str(iter)])
  if iter==Niter2, VF.skip_res=0; end
  [SER,poles,rmserr,fit1]=vectfit2(f,s,poles,weight,VF);  
end

%Storing the state-spacemodel:
%Aold=SER.A; Bold=SER.B; Cold=SER.C; Dold=SER.D; Eold=SER.E;
SERold=SER;
[SERold]=tri2full(SERold); 


%===========================================
% Throwing out high-frequency poles:
fit2=fit1;
remove_HFpoles=1; %==1 --> Throw out poles (and refit residues) 
factor_HF=1;
if remove_HFpoles==1
  disp(['****Throwing out high-frequency poles: ...'])  
  ind=find( abs(poles)>factor_HF*abs(s(end)) ); 
  poles(ind)=[]; %Deleting poles above upper frequency limit
  N=length(poles);
  disp(['****Refitting residues: ...'])
  VF.skip_pole=1;   
  [SER,poles,rmserr,fit2]=vectfit2(fit1,s,poles,weight,VF); 
end
%===========================================


%===========================================
disp('****Enforcing positive realness for D, E...')
  tell=0;
  for col=1:Nc
    for row=col:Nc
      tell=tell+1;
      DD(row,col)=SER.D(tell);  EE(row,col)=SER.E(tell);
    end
  end
  DD=DD+(tril(DD,-1)).';
  EE=EE+(tril(EE,-1)).';

  %Calculating Dmod, Emod: 
  [V,L]=eig(DD); for n=1:Nc, if L(n,n)<0, L(n,n)=0; end, end; DD=V*L*V^(-1);
  [V,L]=eig(EE); for n=1:Nc, if L(n,n)<0, L(n,n)=0; end, end; EE=V*L*V^(-1);
  I=ones(length(poles),1);
  tell=0;
  %Calculating fmod:
  for col=1:Nc
    for row=col:Nc
      tell=tell+1;
      Dmod(tell)=DD(row,col); Emod(tell)=EE(row,col);
      fmod(tell,:)=fit2(tell,:) -Dmod(tell) -s.*Emod(tell);
    end
  end

  disp('****Refitting C while enforcing D=0, E=0 ...')
  VF.skip_pole=0;
  VF.cmplx_ss=1;
  VF.asymp=1;
  [SER,poles,rmserr,fit3]=vectfit2(fmod,s,poles,weight,VF);
  SER.D=Dmod;
  SER.E=Emod;
  for tell=1:length(fit3(:,1))
    fit3(tell,:)=fit3(tell,:) +SER.D(tell) +s.*SER.E(tell);
  end  
    
disp('****Transforming model of lower matrix triangle into state-space model of full matrix ...')
  [SER]=tri2full(SER);  
 

disp('****Generating pole-residue model ...')
[R,a]=ss2pr(SER.A,SER.B,SER.C);
  
  
%Finally, we compare the results (all elements):
freq=s/(2*pi*i);
figure(3),
for row=1:Nc
  for col=1:Nc
    dum=squeeze(bigY(row,col,:));
    h1=semilogy(freq,abs(dum).','b');hold on
  end
end  
h2=semilogy(freq,abs(fit1).','r');
h3=semilogy(freq,abs(fit2).','g--');
h4=semilogy(freq,abs(fit3).','k-.');hold off
legend([h1(1) h2(1) h3(1) h4(1)],'Original','After fitting','After removing HF poles and refitting','After enf. PD for D,E and refitting')
xlabel('Frequency [Hz]')
title('Rational approximation, all matrix elements');


disp('****Checking passivity (sweeping) ...')
spass=2*pi*i*linspace(0,2*freq(end),4*Ns); Nspass=length(spass); freqpass=spass/(2*pi*i);

A=SER.A; B=SER.B; C=SER.C; D=SER.D; E=SER.E;
Aold=SERold.A; Bold=SERold.B; Cold=SERold.C; Dold=SERold.D; Eold=SERold.E;  
Iold=sparse(ones(length(Aold(:,1)),1));
I=  sparse(ones(length(A(:,1)),1));
Gold=zeros(Nc,Nspass); G=Gold;
for k=1:Nspass
  sk=sparse(spass(k));
  Yfitold=Cold*diag( ( sk*Iold -diag(Aold) ).^(-1) )*Bold +Dold +sk*Eold;
  Yfit   =C*diag( ( sk*I -diag(A) ).^(-1) )*B +D +sk*E;
  Gold(:,k)=eig(real(Yfitold));
  G(:,k)   =eig(real(Yfit));
end

figure(4),
h5=plot(freqpass,Gold.','b');hold on
h6=plot(freqpass,G.','r--');hold off
legend([h5(1) h6(1)],'Original model','After removing HF poles and enf. PD for D,E')
xlabel('Frequency [Hz]')
title('Eigenvalues of Re{Y(s)}]');


disp('-------------------E N D----------------------------')
toc




