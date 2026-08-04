% tutorial.m
%
% Example described in user_manual.pdf
%
%     =============================================================================
%     =   Routine: tutorial.m                                                     =
%     =   Version 1.0                                                             =
%     =   Last revised: 19.03.2002                                                = 
%     =   Programmed by: Bjorn Gustavsen,                                         =
%     =   SINTEF Energy Research, N-7465 Trondheim, NORWAY                        =
%     =   This file is part of the "matrixfitter-package":                        =
%     =   B. Gustavsen, "Rational approximation of frequency dependent admittance =
%     =   matrices", IEEE Trans. PWRD, vol. 17, no. 4, Oct. 2002, pp. 1093-1098.  =
%     =============================================================================
%
clear all

Ns=501;    %Number of frequency samples
Nc=2;      %Size of Y (after reduction)
bigY=zeros(Nc,Nc,Ns);
Y=zeros(4,4);
s=2*pi*i*logspace(1,5,Ns);

%Component values: 
R1=1;    L1=1e-3; C1=1e-6;
R2=5;    L2=5e-3;
R3=1;    C3=1e-6;
L4=1e-3;
R4=1e-2; L5=20e-3;
R6=10;   C6=10e-6;
R7=1;    C7=2e-6;

%Building Y, reduction:
for k=1:Ns
  sk=s(k);
  y1=1/( R1+sk*L1+1/(sk*C1) );
  y2=1/( R2+sk*L2 );
  y3=1/( R3+1/(sk*C3));
  y4=1/( R4+sk*L4);
  y5=1/(sk*L5);
  y6=1/( R6+1/(sk*C6) );
  y7=1/( R7+1/(sk*C7) );
  
  Y(1,1)= y1+y3;
  Y(2,2)= y4;
  Y(3,3)= y3 +y4 +y5 +y6;
  Y(4,4)= y1 +y2 +y6 +y7;
  
  Y(1,3)=-y3; Y(1,4)=-y1;
  Y(2,3)=-y4;
  Y(3,1)=-y3; Y(3,2)=-y4; Y(3,4)=-y6;
  Y(4,1)=-y1; Y(4,3)=-y6;
  
  %Eliminating nodes 3 and 4:
  Yred=Y(1:2,1:2)-Y(1:2,3:4)*Y(3:4,3:4)^(-1)*Y(3:4,1:2);
  bigY(:,:,k)=Yred;

  %bigY(1,1,k)=bigY(1,1,k)-1e-4; %Modifying element (1,1) to see the 
                                 %effect of pass. enf.
end  


%================================================
%=           MATRIX FITTING                     =
%================================================ 
N=8;                   %Order of approximation                  
symmflag=0;            %Treat Y as a symmetric matrix (fit upper triangle only) 
SERAstart=[];          %Specify only if startpoleflag==0  
startpoleflag=2;       %Will use logarithmically spaced, complex poles
weight=ones(2,2,Ns);   %Will use same weight for all elements, at all frequencis
kill=2;                %Enforce stable poles
asympflag=3;           %Fitting will include terms D and E  
spy=1;                 %Will plot the fitted matrices (figure(1), figure(2))
logx=1;                %Plotting is done using logaritithmic abscissa axis 
logy=1;                %Plotting is done using logaritithmic ordinate axis
errplot=1;             %Will include fitting error in the plot  
skip=0;                
Niter=2;               %Number of iterations by Vector Fitting
passiveflag=1;         %Will enforce passivity for the fitted Y  
s_pass=2*pi*i*logspace(-1,7,301); %Frequency samples where passivity will be enforced

[SERA,SERC,SERD,SERE,A,B,C,D,E,rmserr]=...
   mainfit(bigY,symmflag,s,N,SERAstart,startpoleflag,weight,...
          kill,asympflag,spy,logx,logy,errplot,skip,Niter,passiveflag,s_pass);




