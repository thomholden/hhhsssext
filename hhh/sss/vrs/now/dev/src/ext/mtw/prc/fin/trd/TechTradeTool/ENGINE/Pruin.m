function [XLB,p] = pruin(NT,XWO,XPL,Xra,XRF,NR);
% [XLB,p] = pruin(XWO,XW,XPL,Xra,XRF,NR);

%     CALCULATES Lower Bound of Worst Drawdown and parameters for plot Probability of Ruin
%
%     NT: Number of trades
%     XW(N),XAF(N)
%     XMP: AVG GAIN OF THE PROFIT SERIES
%     XSP:STDEV OF THE PROFIT SERIES
%     XWO: iNITIAL WEALTH 
%     XRF: RISK FREE INTEREST RATES 
%     Xra: MAX % LOSS
%     BOITHITIKES VBLS: Xmf1,Xsf1,Xm1,XmT,XsT,XmaT,XsaT2,XsaT,XLB,Xra1,XZ,
%     NT=Number of trades 
%     NR= Number of future Contracts
%     Xs1,XZA
      
   
      XMP=mean(XPL);
      XSP=std(XPL);


%Initialization
for i=1:NT
XW(i)=0;
end

%XW Calculation
XW(1)=XPL(1)+XWO;
for i=2:NT
   XW(i)=XPL(i)+XW(i-1);
end
           
%     Calculate weight series
   XAF(1)=1;
   for i=2:NT
   XAF(i)=XW(i-1)./XWO;
   end
                      
%Calculate weight series
      Xmf1=XAF(NT-1).*(XMP./XW(NT-1));
      Xsf1=XAF(NT-1).*(XSP./XW(NT-1));
      Xm1=NR.*Xmf1+XRF;
      Xs1=NR.*Xsf1;
      XmT=((1+Xm1).^NT)-1;
      XsT=(((((1+Xm1).^2)+(Xs1.^2)).^NT)-((1+Xm1).^(2.*NT))).^0.5;

% Normalize XmT,XsT
      XmaT=2*log(1+XmT)-0.5*log((XsT.^2)+((1-XmT).^2));
      XsaT2=log(1+XsT.^2./(1+XmT).^2);
 %'Lower Bound'        
     XsaT=sqrt(XsaT2);
     XLB=XmaT-1.645.*XsaT;
%'Normalize risk'
    Xra1=log(1+Xra);
%Calculate Z      
    XZ=(Xra1-XmaT)./XsaT;
    XZA=-1.645-XZ;
%'Probability of Ruin is=
    p = normcdf([XZA]);
         
