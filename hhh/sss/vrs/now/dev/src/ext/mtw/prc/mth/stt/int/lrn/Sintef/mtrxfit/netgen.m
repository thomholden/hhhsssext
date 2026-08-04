function []=netgen(SERA,SERC,SERD,SERE);

%     =============================================================================
%     =   Routine: netgen.m                                                       =
%     =   Version 1.0                                                             =
%     =   Last revised: 19.03.2002                                                = 
%     =   Programmed by: Bjorn Gustavsen,                                         =
%     =   SINTEF Energy Research, N-7465 Trondheim, NORWAY                        =
%     =   This file is part of the "matrixfitter-package":                        =
%     =   B. Gustavsen, "Rational approximation of frequency dependent admittance =
%     =   matrices", IEEE Trans. PWRD, vol. 17, no. 4, Oct. 2002, pp. 1093-1098.  =
%     =============================================================================
%
% PURPOSE:
% The program generates electrical network for a matrix Y whose 
% elements have been fitted with an identical set of poles.
% The electrical network is written to file RLC.out in a 
% format which can be read by ATP.
%
% Node names:  A____1, A____2, A____3,...
%


%The following tolerances are used for removing branches with 
%extremely high impedances. Has not been subject to extensive testing... 
TOLD =1e-12;
TOLE =1e-12;
TOLCA=1e-12;


Nc=length(SERD);
N =length(SERA);

cindex=zeros(1,N);
for m=1:N 
  if imag(SERA(m))~=0  
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

%=================================

fid1=fopen('RLC.out','w');
fprintf(fid1,'$VINTAGE,1\n');
  
fprintf(fid1,'C <BUS1><BUS2><BUS3><BUS4><   OHM        ><   milliH     ><   microF     >\n');
fprintf(fid1,'C \n');

for row=1:Nc
  for col=row:Nc

    fprintf(fid1,'C (%1.0f,%1.0f)\n',[row col]);

    if row==col %diagonal element
      dum=SERD(row,:);dum(col)=0;
      D=SERD(row,col)+sum(dum);
      if D>TOLD
        R0=1/D;
        fprintf(fid1,'  A____');fprintf(fid1,'%1.0f',row');
        fprintf(fid1,'                   ');
        fprintf(fid1,' %14.6e\n',R0);
      end
      dum=SERE(row,:);dum(col)=0;
      C0=SERE(row,col)+sum(dum);
      if C0>TOLE
        fprintf(fid1,'  A____');fprintf(fid1,'%1.0f',row');
        fprintf(fid1,'                                                  ');
        fprintf(fid1,'  %14.6e\n',1e6*C0);
      end

      for m=1:N
        M=m+(m<0)*2^32; %Convert to hex
        if cindex(m)==0 %real pole
          a1=SERA(m);
          dum=squeeze(SERC(row,:,m));dum(col)=0;
          c1=SERC(row,col,m)+sum(dum);
          L1=1/c1;
          R1=-a1/c1;

          if (abs(c1/a1))>TOLCA
            fprintf(fid1,'  A____');fprintf(fid1,'%1.0f',row');
            fprintf(fid1,'                   ');
            fprintf(fid1,' %14.6e',R1);
            fprintf(fid1,'  %14.6e\n',1000*L1);
          end
        elseif cindex(m)==1 %complex pole, 1st part
          a1=real(squeeze(SERA(m)));
          a2=imag(squeeze(SERA(m)));  
          dum=squeeze(SERC(row,:,m));dum(col)=0;
          dum=SERC(row,col,m)+sum(dum);
          c1=real(dum);
          c2=imag(dum);
          L=1/(2*c1);
          dum=c1*a1+c2*a2;
          R=(-2*a1+2*dum*L)*L;
          C=(a1^2+a2^2+2*dum*R)*L; C=1/C;
          G=-2*dum*C*L;
          if (abs(c1/a1))>TOLCA
            fprintf(fid1,'  A____');fprintf(fid1,'%1.0f',row');
            fprintf(fid1,'A'); fprintf(fid1,'%2X',M);fprintf(fid1,'__');fprintf(fid1,'%1.0f',row');


            fprintf(fid1,'             ');
            fprintf(fid1,' %14.6e',R);
            fprintf(fid1,'  %14.6e\n',1000*L);

            fprintf(fid1,'  A'); fprintf(fid1,'%2X',M);fprintf(fid1,'__');fprintf(fid1,'%1.0f',row');

            fprintf(fid1,'                   ');
            fprintf(fid1,' %14.6e\n',1/G);
            fprintf(fid1,'  A'); fprintf(fid1,'%2X',M);fprintf(fid1,'__');fprintf(fid1,'%1.0f',row');

            fprintf(fid1,'                                                  ');
            fprintf(fid1,'  %14.6e\n',1e6*C);
          end        
   
        end %if cindex(m)==

       end %for m=1:N


     else %row~=col (off-diagonal element)

      C0=-SERE(row,col);
      if abs(SERD(row,col))>TOLD
        R0=-1/SERD(row,col); 
        fprintf(fid1,'  A____');fprintf(fid1,'%1.0f',row');
        fprintf(fid1,'A____');fprintf(fid1,'%1.0f',col');
        fprintf(fid1,'            ');
        fprintf(fid1,'  %14.6e\n',R0);
      end 
      if abs(C0)>TOLE
        fprintf(fid1,'  A____');fprintf(fid1,'%1.0f',row');
        fprintf(fid1,'A____');fprintf(fid1,'%1.0f',col');
        fprintf(fid1,'                                            ');
        fprintf(fid1,'  %14.6e\n',1e6*C0);
      end

      for m=1:N
        M=m+(m<0)*2^32; %Convert to hex
        if cindex(m)==0 %real pole
          a1=SERA(m);
          c1=-SERC(row,col,m);
          L1=1/c1;
          R1=-a1/c1;
          if (abs(c1/a1))>TOLCA
            fprintf(fid1,'  A____');fprintf(fid1,'%1.0f',row');
            fprintf(fid1,'A____');fprintf(fid1,'%1.0f',col');
            fprintf(fid1,'            ');
            fprintf(fid1,'  %14.6e',R1);
            fprintf(fid1,'  %14.6e\n',1000*L1);
          end
        elseif cindex(m)==1 %complex pole, 1st part

          a1=real(squeeze(SERA(m)));
          a2=imag(squeeze(SERA(m)));  
          c1=-real(SERC(row,col,m));
          c2=-imag(SERC(row,col,m));
          L=2*c1; L=1/L;
          dum=c1*a1+c2*a2;
          R=(-2*a1+2*dum*L)*L;
          C=(a1^2+a2^2+2*dum*R)*L; C=1/C;
          G=-2*dum*C*L;
          if (abs(c1/a1))>TOLCA
            fprintf(fid1,'  A____');fprintf(fid1,'%1.0f',row');
            fprintf(fid1,'A'); fprintf(fid1,'%2X',M);fprintf(fid1,'_');fprintf(fid1,'%1.0f',row,col');

            fprintf(fid1,'            '); 
            fprintf(fid1,'  %14.6e',R);
            fprintf(fid1,'  %14.6e\n',1000*L);

            fprintf(fid1,'  A'); fprintf(fid1,'%2X',M);fprintf(fid1,'_');fprintf(fid1,'%1.0f',row,col');

            fprintf(fid1,'A____');fprintf(fid1,'%1.0f',col');

            fprintf(fid1,'            ');
            fprintf(fid1,'  %14.6e\n',1/G);
            fprintf(fid1,'  A'); fprintf(fid1,'%2X',M);fprintf(fid1,'_');fprintf(fid1,'%1.0f',row,col');
            fprintf(fid1,'A____');fprintf(fid1,'%1.0f',col');
            fprintf(fid1,'                                            ');
            fprintf(fid1,'  %14.6e\n',1e6*C);
          end 




       
        end %if cindex(m)==



       end %for m=1:N

     end 
       

  end %for col=
end %for row=


fprintf(fid1,'$VINTAGE,0\n');
fclose(fid1);


 