function [SERA,SERB,SERC,SERD,SERE,rmserr]=spavectfit(f,s,SERAstart,weight,poleflag,kill,...
                                                  asympflag,spy,logx,logy,errplot,skip);


%     =============================================================================
%     =   Routine: spavectfit.m                                                   =
%     =   Version 1.0                                                             =
%     =   Last revised: 19.03.2002                                                = 
%     =   Programmed by: Bjorn Gustavsen,                                         =
%     =   SINTEF Energy Research, N-7465 Trondheim, NORWAY                        =
%     =   This file is part of the "matrixfitter-package":                        =
%     =   B. Gustavsen, "Rational approximation of frequency dependent admittance =
%     =   matrices", IEEE Trans. PWRD, vol. 17, no. 4, Oct. 2002, pp. 1093-1098.  =
%     =============================================================================
%
% PURPOSE : Calculate the rational least squares approximation of a vector f(s) 
%              f(s)=SERC*(s*I-SERA)^(-1)*SERB +SERD +s*SERE
%
% APPROACH: Sparse implementation of "Vector Fitting". See reference at "NOTE". 
%             
% INPUT :
%
% f(Nc,Ns) : function (vector) to be fitted. 
%                 Nc : dimension of f(s), i.e. length of vector
%                 Ns : number of frequency samples 
%
% s(Ns,1) : vector of frequency points [rad/sec] 
%
% SERAstart(N,1): starting poles
%
% weight(Ns,Nc):the rows in the system matrix are weighted using this array. Can be used for
%               achieving high accuracy at given frequency samples. Each element f(i,:) is
%               multiplied by weight(:,i). 
%               If no weighting desired, use: weight=ones(Ns,Nc) --> Same weight for all samples
%
%
% poleflag=0 --> The fitting is done using the starting poles as final poles:
%                  ( Y(s)=SERC*(s*I-SERAstart)^(-1)*SERB +SERD +s*SERE )   
% poleflag=1 --> SERA is included in the optimization
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
% skip=1 --> Skips the second part in Vector Fitting (calculation of SERC, SERD, SERE) 
%
% spy=1 -->  Plotting of results to screen: (not applicable with skip=1)
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
%
% errplot=1--> Will include fitting error in the magnitude plot 
%
% OUTPUT :
% 
% f(s)=SERC*(s*I-diag(SERA))^(-1)*SERB +SERD +s.*SERE
%
% SERA(N,1)    : matrix A (diagonal)
% SERB(Nc*N,1) : matrix B
% SERC(Nc,Nc*N): matrix C
% SERD(Nc,1)   : matrix D (is produced if asympflag=2 or 3)
% SERE(Nc,1)   : matrix E (is produced if asympflag=3)
% rmserr       : root-mean-square error of approximation for f(s)
%
%%******************************************************************************* 
% NOTE: This program is in the public domain and may be used by anyone. If the  *
%       program code (or a mofified version) is used in a scientific work, or   *
%       in a commercial program, then reference must be made to the following:  *
%       B. Gustavsen and A. Semlyen, "Rational approximation of frequency domain*
%       responses by Vector Fitting", IEEE Trans. PWRD, vol. 14, no. 3,         *
%       July 1999, pp. 1052-1061"                                               *  
%********************************************************************************
%
% Bug-fixes :
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if (s(1)==0 & SERAstart(1)==0) SERAstart(1)=1; end
if length(SERAstart)>1 
  if (s(1)==0 & SERAstart(2)==0) SERAstart(2)=1; end
end

rmserr=[];SERC=[];
[a,b]=size(s);
if a<b s=s.'; end % Ensuring that s is a column vector
[a,b]=size(f);
if a>b f=f.'; end % Ensuring that the columns represent frequency 

set(0,'DefaultLineLineWidth',0.5) ; set(0,'DefaultLineMarkerSize',4) ;
clear b; clear C; 
LAMBD=diag(SERAstart);
Nw=length(s); N=length(LAMBD); Nc=min(size(f));
B=ones(N,1); I=diag(ones(1,N));                
SERD=zeros(Nc,1);SERE=zeros(Nc,1);

if poleflag==1


if asympflag==1
  offs=0; 
elseif asympflag==2
  offs=1;  
else
  offs=2; 
end
SS=zeros(2*Nc*Nw*(N+offs) + 2*Nc*Nw*N,1);
II=zeros(2*Nc*Nw*(N+offs) + 2*Nc*Nw*N,1);
JJ=zeros(2*Nc*Nw*(N+offs) + 2*Nc*Nw*N,1);
Escale=sparse(ones(1,Nc*(N+offs)+N));
%=======================================================
% Finding out which starting poles are complex :
%=======================================================
cindex=zeros(1,N);
for m=1:N 
  if imag(LAMBD(m,m))~=0  
    if m==1 
      cindex(m)=1;
    else
      if cindex(m-1)==0 | cindex(m-1)==2
        cindex(m)=1; cindex(m+1)=2; 
      else
        cindex(m)=2;
      end
    end 
  end
end


%=======================================================
% Building system - matrix :
%=======================================================
 I3=diag(ones(1,Nc));I3(:,Nc)=[]; 
 Dk=zeros(Nw,N+offs); 
 for m=1:N
   if cindex(m)==0      %real pole
     Dk(:,m)=1./(s-LAMBD(m,m));
   elseif cindex(m)==1  %complex pole, 1st part
     Dk(:,m)  =1./(s-LAMBD(m,m)) + 1./(s-LAMBD(m,m)');
     Dk(:,m+1)=i./(s-LAMBD(m,m)) - i./(s-LAMBD(m,m)');
   end
 end 
 if asympflag==2    
   Dk(:,N+1)=1; 
 elseif asympflag==3   
   Dk(:,N+1)=1; 
   Dk(:,N+2)=s;
 end
 
 DDk=[real(Dk);imag(Dk)];

 
%First we fill in the left blocks (block diagonal part of A) : 
 koko1=linspace(1,2*Nw,2*Nw).';
 for n=1:Nc
   indblokki=(n-1)*2*Nw*(N+offs); %offset for hver "blokk" (2Nw*(N+offs))
   indblokkj=(n-1)*(N+offs);  
   dum1=2*Nw*(n-1);
   for m=1:N+offs
     DDkm=[weight(:,n); weight(:,n)].*DDk(:,m); 
     ind1=indblokki+(m-1)*2*Nw;
     ind1=indblokki+(m-1)*2*Nw;
     II(ind1+1:ind1+2*Nw)=dum1+koko1;
     JJ(ind1+1:ind1+2*Nw)=indblokkj+m;
     SS(ind1+1:ind1+2*Nw)=DDkm/Escale(indblokkj+m);
   end
 end  
 
 %Then we fill in the last N columns :
 indblokkleft=2*Nw*Nc*(N+offs);
 for n=1:Nc
   indblokki=(n-1)*2*Nw*N;
   indblokkj=Nc*(N+offs);
   dum1=2*Nw*(n-1);
   for m=1:N
     ind1=indblokki+(m-1)*2*Nw;
     ind11=ind1+indblokkleft;
     II(ind11+1:ind11+2*Nw)=dum1+koko1;
     JJ(ind11+1:ind11+2*Nw)=indblokkj+m;
     dust=weight(:,n).*Dk(:,m).*f(n,:).';
     superdust=[real(dust);imag(dust)];
     SS(ind11+1:ind11+2*Nw)=-superdust;
   end  
 end    


 SSSS=sparse(II,JJ,SS,2*Nw*Nc,Nc*(N+offs)+N); 
 for m=1:Nc*(N+offs)+N
   Escale(m)=norm(SSSS(:,m),2);
   SSSS(:,m)=SSSS(:,m)./Escale(m);
 end  
 
 
 
b=[];
for n=1:Nc  
  %%Bblokk=weight.*f(n,:).';
  Bblokk=weight(:,n).*f(n,:).';
  Bblokk=[real(Bblokk);imag(Bblokk)]; 
  b=[b;Bblokk];
end


x=SSSS\b;       % Solving system. x is the solution vector                                   
x=x./Escale.';

clear A;
if asympflag==1
  for j=1:Nc
    C(:,j)=x((j-1)*(N)+1:j*(N));
  end
  C(:,Nc+1)=x(Nc*(N)+1:Nc*(N)+N);
  C=C.';
elseif asympflag==2
  for j=1:Nc
    C(:,j)=x((j-1)*(N+1)+1:j*(N+1)-1);
    SERD(j,1)=x(j*(N+1));
  end
  C(:,Nc+1)=x(Nc*(N+1)+1:Nc*(N+1)+N);
  C=C.';
else
  for j=1:Nc
    C(:,j)=x((j-1)*(N+2)+1:j*(N+2)-2);
    SERD(j,1)=x(j*(N+2)-2+1);
    SERE(j,1) =x(j*(N+2)-2+2);
  end
  C(:,Nc+1)=x(Nc*(N+2)+1:Nc*(N+2)+N);
  C=C.';
end


%We now change back to make C complex : 
% **************
for m=1:N
  if cindex(m)==1
    for n=1:Nc+1
      r1=C(n,m); r2=C(n,m+1);
      C(n,m)=r1+i*r2; C(n,m+1)=r1-i*r2;
    end
  end
end
% **************  




%=============================================================================
% We now calculate the zeros for sigma :
%=============================================================================
oldLAMBD=LAMBD;oldB=B;oldC=C;
m=0;
for n=1:N
  m=m+1;
  if m<N  
    if( abs(LAMBD(m,m))>abs(real(LAMBD(m,m))) ) %complex number?
      LAMBD(m+1,m)=-imag(LAMBD(m,m)); LAMBD(m,m+1)=imag(LAMBD(m,m));
      LAMBD(m,m)=real(LAMBD(m,m));LAMBD(m+1,m+1)=LAMBD(m,m);
      B(m,1)=2; B(m+1,1)=0; 
      koko=C(Nc+1,m); C(Nc+1,m)=real(koko); C(Nc+1,m+1)=imag(koko);
      m=m+1;
    end
  end
end

ZER=LAMBD-B*C(Nc+1,:)/1;
roetter=eig(ZER).'; 

unstables=real(roetter)>0;  
if kill==1
  roetter(unstables)=[]; %Deleting unstable zeros (they become poles later...)
elseif kill==2
  roetter(unstables)=roetter(unstables)-2*real(roetter(unstables)); %Forcing unstable poles to be stable...
end
roetter=sort(roetter); N=length(roetter);


%=============================================
%Sorterer polene s.a. de reelle kommer først:
for n=1:N
  for m=n+1:N
    if imag(roetter(m))==0 & imag(roetter(n))~=0
      trans=roetter(n); roetter(n)=roetter(m); roetter(m)=trans;
    end
  end
end
N1=0;
for m=1:N
  if imag(roetter(m))==0 N1=m; end
end
if N1<N roetter(N1+1:N)=sort(roetter(N1+1:N)); end   % N1: n.o. real poles
N2=N-N1;                                             % N2: n.o. imag.poles

roetter=roetter-2*i*imag(roetter); %10.11.97 !!!
SERA=roetter.';

else %poleflag==0;
  roetter=diag(diag(SERAstart)).'; 
  SERA=roetter;
end %if poleflag==1


if skip~=1

%=============================================================================
% We now calculate SER for f, using the modified zeros of sigma as new poles :
%========================================================================================

clear LAMBD A A1 xA1 xxA1 A2 xA2 xxA2 b xb xxb C RES1 RES2;

LAMBD=roetter; 
B=ones(N,1); 

% Finding out which poles are complex :
cindex=zeros(1,N);
for m=1:N 
  if imag(LAMBD(m))~=0  
    if m==1 
      cindex(m)=1;
    else
      if cindex(m-1)==0 | cindex(m-1)==2
        cindex(m)=1; cindex(m+1)=2; 
      else
        cindex(m)=2;
      end
    end 
  end
end



%===============================================================================
% We now calculate the SER for f (new fitting), using the above calculated 
% zeros as known poles :
%=============================================================================== 
if asympflag==1
  A=zeros(2*Nw,N); BB=zeros(2*Nw,Nc);
elseif asympflag==2
  A=zeros(2*Nw,N+1); BB=zeros(2*Nw,Nc);
else
  A=zeros(2*Nw,N+2); BB=zeros(2*Nw,Nc);
end

 I3=diag(ones(1,Nc));I3(:,Nc)=[]; 
  Dk=zeros(Nw,N); 
    for m=1:N
      if cindex(m)==0      %real pole
        Dk(:,m)=1./(s-LAMBD(m));
      elseif cindex(m)==1  %complex pole, 1st part
        Dk(:,m)  =1./(s-LAMBD(m)) + 1./(s-LAMBD(m)');
        Dk(:,m+1)=i./(s-LAMBD(m)) - i./(s-LAMBD(m)');
      end
    end 

%=========================================
if max(max(weight))==min(min(weight)) %same weight for all elements
                                      %(solve for all elements simultaneously)

if asympflag==1
  A(1:Nw,1:N)=Dk; 
elseif asympflag==2
  A(1:Nw,1:N)=Dk; A(1:Nw,N+1)=1;
else
  A(1:Nw,1:N)=Dk; A(1:Nw,N+1)=1; A(1:Nw,N+2)=s;
end
for m=1:Nc
  BB(1:Nw,m)=f(m,:).';
end
A(Nw+1:2*Nw,:)=imag(A(1:Nw,:));
A(1:Nw,:)=real(A(1:Nw,:));
BB(Nw+1:2*Nw,:)=imag(BB(1:Nw,:));
BB(1:Nw,:)=real(BB(1:Nw,:));

if asympflag==2
  A(1:Nw,N+1)=A(1:Nw,N+1);             
elseif asympflag==3
  A(1:Nw,N+1)=A(1:Nw,N+1);             
  A(Nw+1:2*Nw,N+2)=A(Nw+1:2*Nw,N+2);  
end

clear Escale;
for col=1:length(A(1,:));
  Escale(col)=norm(A(:,col),2);
  A(:,col)=A(:,col)./Escale(col);
end
X=A\BB;
for n=1:Nc
  X(:,n)=X(:,n)./Escale.';
end

clear A;
X=X.';
C=X(:,1:N); 
SERD=zeros(Nc,1); %23.09.01
SERE=zeros(Nc,1); %23.09.01
if asympflag==2
  SERD=X(:,N+1);
elseif asympflag==3
  SERE=X(:,N+2); 
  SERD=X(:,N+1);
end


else %different weights for different elements (solve for each element independently)

  SERD=zeros(Nc,1); 
  SERE=zeros(Nc,1); 
  C=zeros(Nc,N);
  for n=1:Nc

    if asympflag==1
      A=zeros(2*Nw,N); BB=zeros(2*Nw,Nc);
    elseif asympflag==2
      A=zeros(2*Nw,N+1); BB=zeros(2*Nw,Nc);
    else
      A=zeros(2*Nw,N+2); BB=zeros(2*Nw,Nc);
    end

    if asympflag==1
      A(1:Nw,1:N)=Dk; 
    elseif asympflag==2
      A(1:Nw,1:N)=Dk; A(1:Nw,N+1)=1;
    else
      A(1:Nw,1:N)=Dk; A(1:Nw,N+1)=1; A(1:Nw,N+2)=s;
    end

    for m=1:length(A(1,:))
      A(:,m)=[weight(:,n);weight(:,n)].*A(:,m);
    end
 
    BB=weight(:,n).*f(n,:).';
    A(Nw+1:2*Nw,:)=imag(A(1:Nw,:));
    A(1:Nw,:)=real(A(1:Nw,:));
    BB(Nw+1:2*Nw)=imag(BB(1:Nw));
    BB(1:Nw)=real(BB(1:Nw));

    if asympflag==2
      A(1:Nw,N+1)=A(1:Nw,N+1);             
    elseif asympflag==3
      A(1:Nw,N+1)=A(1:Nw,N+1);             
      A(Nw+1:2*Nw,N+2)=A(Nw+1:2*Nw,N+2);  
    end

    clear Escale;
    for col=1:length(A(1,:));
      Escale(col)=norm(A(:,col),2);
      A(:,col)=A(:,col)./Escale(col);
    end
    x=A\BB;
    x=x./Escale.';

    clear A;
    C(n,1:N)=x(1:N).'; 

    if asympflag==2
      SERD(n)=x(N+1);
    elseif asympflag==3
      SERE(n)=x(N+2); 
      SERD(n)=x(N+1);
    end


  end %for n=1:Nc

end %same weight for all elements





%=========================================================================

%We now change back to make C complex. 
for m=1:N
  if cindex(m)==1
    for n=1:Nc
      r1=C(n,m); r2=C(n,m+1);
      C(n,m)=r1+i*r2; C(n,m+1)=r1-i*r2;
   end
  end
end
% **************  


B=ones(N,1);
I=ones(N,1);
%====================================================

SERA  = LAMBD.';
SERB  = B;
SERC  = C.';
order = N;


  Dk=zeros(Nw,N); 
  for m=1:N
    Dk(:,m)=1./(s-SERA(m));
  end 
  for n=1:Nc
    RES1(:,n)=Dk*SERC(:,n);
    if asympflag==2
      RES1(:,n)=RES1(:,n)+SERD(n);
    elseif asympflag==3
      RES1(:,n)=RES1(:,n)+SERD(n)+s.*SERE(n);
    end
  end 
  diff=RES1-f.'; rmserr=norm(diff,'fro')/sqrt(Nc*Nw);


if spy==1
  if logx==1     
    if logy==1
      figure(1),loglog(s./(2*pi*i),abs(f.'),'c');hold on
      figure(1),loglog(s./(2*pi*i),abs(RES1),'m--');hold off
      if errplot== 1
        hold on,loglog(s./(2*pi*i),abs(f.'-RES1),'g');hold off; 
      end
    else %logy=0 
      figure(1),semilogx(s./(2*pi*i),abs(f.'),'c');hold on
      figure(1),semilogx(s./(2*pi*i),abs(RES1),'m--');
      figure(1),semilogx(s./(2*pi*i),abs(f.'-RES1),'g');hold off; 
    end
    figure(2),semilogx(s./(2*pi*i),180*unwrap(angle(f.'))/pi,'c');hold on
    figure(2),semilogx(s./(2*pi*i),180*unwrap(angle(RES1))/pi,'m--');hold off
  else %logx=0
    if logy==1
      figure(1),semilogy(s./(2*pi*i),abs(f.'),'c');hold on
      figure(1),semilogy(s./(2*pi*i),abs(RES1),'m--'); hold off
      if errplot==1 
        figure(1),semilogy(s./(2*pi*i),abs(f.'-RES1),'g');hold off; 
      end
    else %logy=0 
      figure(1),plot(s./(2*pi*i),abs(f.'),'c');hold on
      figure(1),plot(s./(2*pi*i),abs(RES1),'m--');
      hold off; %figure(1),plot(s./(2*pi*i),abs(f.'-RES1),'g');hold off; 
    end
    figure(2),plot(s./(2*pi*i),180*unwrap(angle(f.'))/pi,'c');hold on
    figure(2),plot(s./(2*pi*i),180*unwrap(angle(RES1))/pi,'m--');hold off
  end %logy=0
  figure(1),xlabel('Frequency [Hz]'); ylabel('Magnitude [p.u.]');
  %figure(1), title('Approximation of f')
  figure(1),hold on
  dum1=s(1)/(2*pi*i);
  dum2=abs(f(1,1));
  if errplot==1 
    h1=plot([dum1 dum1],[dum2 dum2],'c');
    h2=plot([dum1 dum1],[dum2 dum2],'m--');
    h3=plot([dum1 dum1],[dum2 dum2],'g'); 
    legend([h1 h2 h3],'Original','Approximation','Deviation',3);
  else
    h1=plot([dum1 dum1],[dum2 dum2],'c');
    h2=plot([dum1 dum1],[dum2 dum2],'m--');
    legend([h1 h2],'Original','Approximation',3);
  end
  hold off 
  dum2=180*unwrap(angle(f(1,1))/pi);
  figure(2),hold on
  h1=plot([dum1 dum1],[dum2 dum2],'c');
  h2=plot([dum1 dum1],[dum2 dum2],'m--');
  legend([h1 h2],'Original','Approximation',3);
  hold off 
  figure(2),xlabel('Frequency [Hz]'); ylabel('Phase angle [deg]');
  %figure(2), title('Approximation of f')


  drawnow;
end


end

