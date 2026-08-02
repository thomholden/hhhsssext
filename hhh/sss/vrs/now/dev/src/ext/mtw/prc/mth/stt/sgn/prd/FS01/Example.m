%Example of the one-step-ahead forecast
%%Predicts the difference between decadal
%average sunspot number, which is mostly a sunspot number derived from tree ring radiocarbon content by Solanki, S. K., Usoskin, I. G., Kromer, B., Sch?ssler, M. and Beer, J.: 2004, Nature, 431, 1084., continued by group sunspot number by Hoyt, D. V. and Schatten, K. H.: 1996, Solar Phys., 165, 181.  
%Volobuev, D.M., Makarenko, N.G. FORECAST OF THE DECADAL AVERAGE SUNSPOT NUMBER. Submitted to Solar Physics,2007.
close all
clear all
load composite.txt
sc=composite(:,2);
tsc=composite(:,1);
sigma_l=std(diff(sc(1:end-102))); %sigma for the learn set (to normalize prediction error)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for j=1:100,
  Y=diff(sc)/sigma_l;%difference removes trend and systematic error in data
  figure;subplot(211);plot(tsc,sc);ylabel('Composite')
  subplot(212);
 plot(tsc(2:end),Y);ylabel('Differences')
 
 w=3;%dimension
  Ft=[];Fe=[]; 
for k=103:-1:0,
      n=0;  
 y0=fs01(Y(1:end-k),w);
     
  
  yy0=((([Y(1:end-k);y0])*sigma_l));%
  try
  yyt=((([Y(1:end-k+1)])*sigma_l));%
catch
    disp('last point')
    yyt=0;
  
end

Ft=[Ft yyt(end)];%
Fe=[Fe yy0(end)];

end%for
disp('Average normalized prediction error')
ET=std(Ft(1:end-1)-Fe(1:end-1))/sigma_l
figure;plot(tsc(end-102:end),Ft(1:end-1),'-k.',[tsc(end-102:end); 2015],Fe,'-bo')
ylabel('Difference');legend('Actual','Predicted')
xlabel('Years')
disp('correlation in differences')
Cd=corrcoef(Ft(1:end-1),Fe(1:end-1))
figure;plot(tsc(end-102:end),sc(end-102:end),'-k.',[tsc(end-102:end); 2015],sc(end-103:end)+Fe(1:end)','-bo')
ylabel('Sunspot Number');legend('Actual','Predicted')
xlabel('Years')
disp('correlation in values')
Cv=corrcoef(sc(end-102:end),sc(end-103:end-1)+Fe(1:end-1)')

