function [SERA,SERC,SERD,SERE]=passive(SERA,SERC,SERD,SERE,bigY,sPR,logx);

%     =============================================================================
%     =   Routine: passive.m                                                      =
%     =   Version 1.0                                                             =
%     =   Last revised: 02.09.2004                                                = 
%     =   Programmed by: Bjorn Gustavsen,                                         =
%     =   SINTEF Energy Research, N-7465 Trondheim, NORWAY                        =
%     =   This file is part of the "matrixfitter-package":                        =
%     =   B. Gustavsen, "Rational approximation of frequency dependent admittance =
%     =   matrices", IEEE Trans. PWRD, vol. 17, no. 4, Oct. 2002, pp. 1093-1098.  =
%     =                                                                           =
%     =   A more powerful routine based on quadratic programming is availabe      =
%     =   in QPpassive.zip                                                        = 
%     =============================================================================

% PURPOSE : Enforce passivity for realization given on the form 
%                   N   SERCijm
%           Yij(s)=SUM(---------  ) +SERDij +s*SEREij ("ij" denotes element i,j)
%                  m=1 (s-SERAm)     
%
%
% APPROACH: Modifying elements of SERD
 
%Revisions:
%  -02.08.2004:  Added a sentence to header text above

Nc=length(bigY(:,1,1)); NsPR=length(sPR); N=length(SERA);
oldSERA=SERA; oldSERC=SERC;oldSERD=SERD;oldSERE=SERE;

%=========================================
%Enforcing passivity by modifying SERD: 
%=========================================
clear Y;
EE=zeros(Nc,NsPR);
Dcorr=zeros(Nc);
for k=1:NsPR
  sk=sPR(k);
  for row=1:Nc
    for col=1:Nc
      Yfit=SERD(row,col)+sk*SERE(row,col);
      Yfit=Yfit+sum(squeeze(SERC(row,col,1:N))./(sk-SERA(1:N)));
      Y(row,col)=Yfit;
    end
  end
  G=real(Y);
  [V,E]=eig(G);
  Edum=E;
  for row=1:Nc
    if Edum(row,row)>0 Edum(row,row)=0;end
  end
  Dcorr = -V*Edum*inv(V);
  SERD=SERD+Dcorr;
end


%=================================================
%Plotting eig(G), before and after passivity enf.:
for k=1:NsPR
  sk=sPR(k);
  for row=1:Nc
    for col=1:Nc
      Yfit=SERD(row,col)+sk*SERE(row,col);
      Yfit=Yfit+sum(squeeze(SERC(row,col,1:N))./(sk-SERA(1:N)));
      Y(row,col)=Yfit;
      Yfit=oldSERD(row,col)+sk*oldSERE(row,col);
      Yfit=Yfit+sum(squeeze(oldSERC(row,col,1:N))./(sk-oldSERA(1:N)));
      oldY(row,col)=Yfit;
    end
  end
  G=real(Y);
  E=eig(G);
  EE(:,k)=E;
  G=real(oldY);
  E=eig(G);
  oldEE(:,k)=E;
end
figure(3);
if logx==1
  semilogx(sPR/(2*pi*i),real(oldEE.'),'b');hold on
  semilogx(sPR/(2*pi*i),real(EE.'),'r--');
else
  plot(sPR/(2*pi*i),real(oldEE.'),'b');hold on
  plot(sPR/(2*pi*i),real(EE.'),'r--');
end
dum1=sPR(1)/(2*pi*i);
dum2=oldEE(1,1);
h1=plot([dum1 dum1],[dum2 dum2],'b');
h2=plot([dum1 dum1],[dum2 dum2],'r--');

xlabel('Frequency [Hz]'); ylabel('Eigenvalues of G');
legend([h1 h2],'Before pass. enf.','After pass. enf.',2);
hold off


