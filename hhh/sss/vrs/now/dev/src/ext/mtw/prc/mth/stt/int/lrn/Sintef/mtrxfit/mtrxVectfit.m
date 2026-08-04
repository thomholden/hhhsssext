function [SERA,SERC,SERD,SERE,rmserr]=mtrxVectfit(bigY,symmflag,s,Niter,SERAstart,weight,...
                                          kill,asympflag,spy,logx,logy,errplot,skip);  

%     =============================================================================
%     =   Routine: mtrxvectfit.m                                                  =
%     =   Version 1.0                                                             =
%     =   Last revised: 19.03.2002                                                = 
%     =   Programmed by: Bjorn Gustavsen,                                         =
%     =   SINTEF Energy Research, N-7465 Trondheim, NORWAY                        =
%     =   This file is part of the "matrixfitter-package":                        =
%     =   B. Gustavsen, "Rational approximation of frequency dependent admittance =
%     =   matrices", IEEE Trans. PWRD, vol. 17, no. 4, Oct. 2002, pp. 1093-1098.  =
%     =============================================================================
%
% PURPOSE : Calculate the rational least squares approximation of a matrix 
%              Y(s)=C*(s*I-A)^(-1)*B +D +s*E
%
% APPROACH: Stacking all matrix elements into a single vector which is fitted using
%           a sparse implementation of "Vector Fitting".       
%             
% INPUT :
%
% bigY(Nc,Nc,Ns) : matrix function to be fitted. 
%                 Nc : dimension of Y(s)
%                 Ns : number of frequency samples 
%
% symm_flag=0 --> Y(s) is unsymmetric
% symm_flag=1 --> Y(s) is symmetric  (increases efficiency and saves memory)
% 
% s(Ns,1) : vector of frequency points [rad/sec] 
%
% Niter :  N.o. iterations used by Vector Fitting for identifying poles 
%          (recommended value: 3 or higher)
%
% SERAstart(N,1): starting poles
%
% weight(Nc,Nc,Ns): The rows in the system matrix are weighted using this array. Can be used for
%                   achieving high accuracy at given frequency samples. 
%                   If no weighting desired, use: weight=ones(Ns,1) --> Same weight for all samples
% 
% kill=0 --> unstable poles are kept unchanged
% kill=1 --> unstable poles are deleted
% kill=2 --> unstable poles are 'flipped' into the left half plane
%            (kill=2 is the recommended choice)
%
% asympflag=1 --> order(numerator)=order(denominator)-1 ('Strictly proper')
% asympflag=2 --> order(numerator)=order(denominator)   ('Proper')
% asympflag=3 --> order(numerator)=order(denominator)+1 ('Improper') 
%
% spy=1 -->  Plotting of results on screen: 
%              figure(2): magnitude functions
%              figure(3): phase angles  
%                cyan trace    : Y
%                magenta trace : (Y)fit 
%                green trace   : Y - (Y)fit
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

%
% OUTPUT :
% 
% Y(s)=SERC*(s*I-diag(SERA))^(-1)*SERB +SERD +s.*SERE
%
% SERA(N,1)     : matrix A (diagonal)
% SERB(Nc*N,Nc) : matrix B
% SERC(Nc,Nc*N) : matrix C
% SERD(Nc,Nc)   : matrix D (is produced if asympflag=2 or 3)
% SERE(Nc,Nc)   : matrix E (is produced if asympflag=3)
% rmserr        : root-mean-square error of approximation for Y(s)
%
%%******************************************************************************* 
% NOTE: This program is in the public domain and may be used by anyone. If the  *
%       program code (or a mofified version) is used in a scientific work, or   *
%       in a commercial program, then reference should be made to the following:*
%       B. Gustavsen, "Rational approximation of frequency dependent admittance *
%       matrices", IEEE Trans. PWRD, vol. 17, no. 4, Oct. 2002, pp. 1093-1098.  *
%********************************************************************************
%
% Bug-fixes :
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nc=length(bigY(:,1,1)); Ns=length(s); N=length(SERAstart);

disp('Stacking matrix columns into single column...'); 
if symmflag==1
  nnn=Nc*(Nc+1)/2; %n.o. elements in upper triangle
else
  nnn=Nc^2;
end
f=zeros(nnn,Ns);
weightarr=zeros(Ns,nnn);

if symmflag==1
  tell=0;
  for col=1:Nc
    for row=col:Nc
      tell=tell+1;
      f(tell,:)=squeeze(bigY(row,col,:)).'; %stacking elements into a single vector
      weightarr(:,tell)=squeeze(weight(row,col,:)); 
      if row~=col
        weightarr(:,tell)=weightarr(:,tell).*sqrt(2);
      end
    end
  end
else;
  tell=0;
  for col=1:Nc
    for row=1:Nc
      tell=tell+1;
      f(tell,:)=squeeze(bigY(row,col,:)).'; %stacking elements into a single vector
      weightarr(:,tell)=squeeze(weight(row,col,:)); 
    end
  end
end %if symmflag=1

disp('Vector Fitting...')

SERA=SERAstart;
poleflag=1;
for iter=1:Niter
  [SERA,BB,CC,DD,EE,rmserr]=spaVectfit(f,s,SERA,weightarr,poleflag,kill,asympflag,spy,logx,logy,errplot,skip);  
end


SERC=zeros(Nc,Nc,N);
SERD=zeros(Nc,Nc);
SERE=zeros(Nc,Nc);
tell=0;
if symmflag==1
  for col=1:Nc
    for row=col:Nc
      tell=tell+1;
      SERD(row,col)=DD(tell);
      SERE(row,col)=EE(tell);
      SERC(row,col,:)=CC(:,tell).'; 
    end
  end
  for m=1:N
    SERC(:,:,m)=SERC(:,:,m)+(SERC(:,:,m)-diag(diag(SERC(:,:,m)))).';
  end
  SERD=SERD+(SERD-diag(diag(SERD))).';
  SERE=SERE+(SERE-diag(diag(SERE))).';
else
  for col=1:Nc
    for row=1:Nc
      tell=tell+1;
      SERD(row,col)=DD(tell);
      SERE(row,col)=EE(tell);
      SERC(row,col,:)=CC(:,tell).'; 
    end
  end
end %if symmflag==1



