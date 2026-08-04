% ex4c.m             
%
% Fitting all elements of the admittance matrix Y of a six-terminal system 
% (power system distribution network)
%
% -Reading frequency admittance matrix Y(s) from disk.
% -Stacking the (21) elements of the lower triangle of Y into a single
%  column f(s)
% -Fitting g(s)=sum(f(s)) using vectfit2.m --> new initial poles
%   -Initial poles: 25 linearly spaced complex pairs (N=50)
%   -5 iterations
% -Fitting elements of vector f(s) using a common pole set 
%  (3 iterations)
% -Convering resulting state-space model into a model for the full Y using tri2full.m.
% -Converting state space model (A,B,C,D,E) into a pole-residue model (a,R,D,E) using ss2pr.m
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

disp('****Stacking matrix elements (lower triangle) into single column....')
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
  [SER,poles,rmserr,fit]=vectfit2(f,s,poles,weight,VF);  
end

A=SER.A; B=SER.B; C=SER.C; D=SER.D; E=SER.E; 


%======================================================================
%This section demonstrates usage of parameter VF.skip_pole to remove
%poles above upper frequency limits (which tend to be a source of high
%frequency passivity violations).

remove_HFpoles=0; %Do NOT throw out poles
%remove_HFpoles=1; %Throw out poles (and refit residues)
if remove_HFpoles==1
  disp(['****Throwing out high-frequency poles: ...'])  
  ind=find( abs(diag(A))>abs(s(end)) ); 
  A(ind,:)=[]; A(:,ind)=[]; %Deleting poles above upper frequency limit
  B(ind)=[];
  C(:,ind)=[];
  N=length(A);
  disp(['****Refitting residues: ...'])
  VF.skip_pole=1;   VF.cmplx_ss=0;
  %!![A,B,C,D,E,rmserr,fit]=vectfit2(f,s,A,weight,VF); 
  [SER,rmserr,fit]=vectfit2(f,s,A,weight,VF);   
end

%======================================================================
  
disp('****Transforming model of lower matrix triangle into state-space model of full matrix....')
[SER]=tri2full(SER);


disp('****Generating pole-residue model....')
[R,a]=ss2pr(SER.A,SER.B,SER.C);


disp('-------------------E N D----------------------------')
toc

