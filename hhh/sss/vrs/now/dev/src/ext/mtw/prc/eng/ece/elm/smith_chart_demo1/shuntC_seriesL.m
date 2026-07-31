%shuntC_seriesL.m
%John Wetters
function [z]=shuntC_seriesL(C1,L2,w,Zo)

j=sqrt(-1);
w=j*w;
R=Zo;


Y=1/R+(w*C1);
Z=1/Y;
Zt=Z+(w*L2)
z=Zt/R

end_diary