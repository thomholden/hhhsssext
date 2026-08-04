 function [SERA,SERC,SERD,SERE,A,B,C,D,E,rmserr]=...
      mainfit(bigY,symmflag,s,N,SERAstart,startpoleflag,weight,...
              kill,asympflag,spy,logx,logy,errplot,skip,Niter,passiveflag,s_pass);  


%     ======================================================
%     =   Routine: mainfit.m                               =
%     =   Version 1.0                                      =
%     =   Last revised: 02.09.2004                         = 
%     =   Programmed by: Bjorn Gustavsen,                  =
%     =   SINTEF Energy Research, N-7465 Trondheim, NORWAY =
%     =   This file is part of the "matrixfitter-package"  = 
%     ======================================================
%
% PURPOSE : Calculate the rational least squares approximation of a matrix Y(s)
%
%       - as a sum of partial fractions: 
%                   N   SERCijm
%           Yij(s)=SUM(---------  ) +SERDij +s*SEREij ("ij" denotes element i,j)
%                  m=1 (s-SERAm)               
%
%       - as a state-space model:
%              Y(s)=C*(s*I-A)^(-1)*B +D +s*E
%
%       - as an equivalent electrical network in the form of branch cards for ATP.
%         (only applies when Y(s) is an admittance matrix) 
%            
%           with option of passivity enforcement  
%
% INPUT :
%
% bigY(Nc,Nc,Ns) : matrix function to be fitted. 
%                 Nc : dimension of Y(s)
%                 Ns : number of frequency samples 
%
% symm_flag=0 --> Y(s) is treated as unsymmetric
% symm_flag=1 --> Y(s) is treated as symmetric  (increases efficiency and saves
%                                                                       memory)
% 
% s(Ns,1) : vector of frequency points [rad/sec] 
%
% N : number of starting poles (used when startpoleflag~=0)
%
% SERAstart(N,1) : vector of starting poles [rad/sec] 
%
% startpoleflag=0 --> SERAstart is used as starting poles
% startpoleflag=1 --> automatic gen. of commplex, linearly spaced starting poles
% startpoleflag=2 --> automatic gen. of commplex, log. spaced starting poles
% startpoleflag=3 --> automatic gen. of real, log. spaced starting poles
%
% weight(Nc,Nc,Ns): the rows in the system matrix of the least squares problem 
%                   are weighted using this array. 
%                   The elements in weight correspond directly to the elements in
%                   bigY. Thus, ecah element in bigY can be weighted individually.
%                   If no weighting is desired, use:
%                   weight=ones(Nc,Nc,Ns) --> Same weight for all samples
%
%   
% kill=0 --> unstable poles are kept unchanged
% kill=1 --> unstable poles are deleted
% kill=2 --> unstable poles are 'flipped' into the left half plane
%            (kill=2 is the recommended choice)
%
% asympflag=1 --> SERD=0,  SERE=0,  D=0,  E=0
% asympflag=2 --> SERD~=0, SERE=0,  D~=0, E=0
% asympflag=3 --> SERD~=0, SERE~=0, D~=0, E~=0
%
% spy=1 -->  Plotting of results on screen: 
%              figure(1): magnitude functions
%              figure(2): phase angles  
%                cyan trace    : Y
%                magenta trace : (Y)fit 
%                green trace   : |(Y - (Y)fit)|
%
% logx=0 --> Plotting using linear absissa axis
% logx=1 --> Plotting using logarithmic absissa axis             
%
% logy=0 --> Plotting using linear ordinate axis
% logy=1 --> Plotting using logarithmic ordinate axis
% errplot=1--> Will include fitting error in the plot  
%
% skip=1 --> Will not plot results during iterations (pole identifiction) 
%
% Niter :  N.o. iterations used for identifying poles 
%           (recommended value: 3 or higher)
% 
% passiveflag=0 --> Passivity will not be enforced
% passiveflag=1 --> Passivity is enforced 
%
% s_pass(Ns,1) : Vector of frequency samples for which passivity is enforced 
%
%
% OUTPUT :
% 
%         N
% Yij(s)=SUM( SERC(i,j,m)/(SERA(m) ) +Dij +s*Eij  (i=1,Nc,j=1,Nc)
%        m=1
%
% Y(s)=C*(s*I-diag(A))^(-1)*B +D +s*E
%
% SERA(N,1)     
% SERC(Nc,Nc,N)
% SERD(Nc,Nc)   : matrix D (is produced if asympflag=2 or 3)
% SERE(Nc,Nc)   : matrix E (is produced if asympflag=3)
%
% A(N*N,1)   : matrix A (diagonal)
% B(Nc*N,Nc) : matrix B
% C(Nc,Nc*N) : matrix C
% D(Nc,Nc)   : matrix D (is produced if asympflag=2 or 3)
% E(Nc,Nc)   : matrix E (is produced if asympflag=3)
%
% rmserr        : root-mean-square error of approximation for Y(s)
%
%******************************************************************************** 
% NOTE: This program is in the public domain and may be used by anyone. If the  *  
%       program code (or a mofified version) is used in a scientific work, or   *  
%       in a commercial program, then reference should be made to the           *
%       following:                                                              * 
%                                                                               * 
%   [1] B. Gustavsen and A. Semlyen, "Rational approximation of frequency domain*
%       responses by Vector Fitting", IEEE Trans. PWRD, vol. 14, no. 3,         *
%       July 1999, pp. 1052-1061"                                               *
%                                                                               *
%   [2] B. Gustavsen, "Computer code for rational approximation of frequency    *
%       dependent admittance matrices, IEEE Trans. PWRD, vol. 17, no. 4,        *
%       October 2002, pp. 1093-1098.                                            *
%                                                                               * 
%********************************************************************************
%
% Bug-fixes : 02.08.2004: 
%             - Startpoleflag=3 gave incorrect starting poles.    
%               Now it correctly gives log. spaced real poles over the fitting range.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nc=length(bigY(:,1,1)); Ns=length(s); 

if startpoleflag==1 %Complex, linearly spaced starting poles 
  bet=linspace(s(1)/i,s(Ns)/i,N/2);
  SERAstart=[];
  for n=1:length(bet)
    alf=-bet(n)*1e-2;
    SERAstart=[SERAstart (alf-i*bet(n)) (alf+i*bet(n)) ]; 
  end
  N=length(SERAstart);
elseif startpoleflag==2 %Complex, logaritmically spaced starting poles
  bet=logspace(log10(s(1)/i),log10(s(Ns)/i),N/2);
  SERAstart=[];
  for n=1:length(bet)
    alf=-bet(n)*1e-2;
    SERAstart=[SERAstart (alf-i*bet(n)) (alf+i*bet(n)) ]; 
  end
elseif startpoleflag==3
  SERAstart=-logspace(log10(s(1)/i),log10(s(Ns)/i),N); % Real, logarithmically spaced starting poles 
else
  SERAstart=SERAstart; %Provided in the function call
  N=length(SERAstart);
end 

[SERA,SERC,SERD,SERE,rmserr]=mtrxVectfit(bigY,symmflag,s,Niter,SERAstart,weight,...
                                          kill,asympflag,spy,logx,logy,errplot,skip);  

%========================================
%= Passivity enforcement
%========================================  
if passiveflag==1
  disp('Enforcing passivity...')
  [SERA,SERC,SERD,SERE]=passive(SERA,SERC,SERD,SERE,bigY,s_pass,logx);
  %[SERA,SERC,SERD,SERE]=passive_bjorn(SERA,SERC,SERD,SERE,Niter,symmflag,bigY,s_pass,s,weight,kill,asympflag,spy,logx,logy,errplot,skip);
end


%Calculating the rmserror:
for k=1:Ns
  tell=0;
  for row=1:Nc
    for col=1:Nc
      tell=tell+1;
      Y(row,col)=SERD(row,col)+s(k)*SERE(row,col);
      Y(row,col)=Y(row,col)+sum(squeeze(SERC(row,col,1:N))./(s(k)-SERA(1:N)));
      diff(tell,k)=Y(row,col)-bigY(row,col,k);      
    end
  end
end
rmserr=norm(diff,'fro')/sqrt(Nc^2*Ns);

%========================================
%= Network synthesization :
%========================================     

disp('Generating equivalent electrical network...')
netgen(SERA,SERC,SERD,SERE); 

%========================================
%= State Equations :
%========================================
disp('Generating statespace model...')
A=zeros(Nc*N,1);
for col=1:Nc
  A((col-1)*N+1:col*N)=SERA;
end   
B=zeros(Nc*N,Nc);
for col=1:Nc
  B((col-1)*N+1:col*N,col)=ones(N,1);
end
C=zeros(Nc,Nc*N);
for row=1:Nc
  for col=1:Nc 
    C(row,(col-1)*N+1:col*N)=squeeze(SERC(row,col,1:N)).';
  end    
end
D=SERD;
E=SERE;

disp(['rms-error : ' num2str(rmserr)])



