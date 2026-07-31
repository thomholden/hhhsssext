%shuntC_seriesC.m
%John Wetters
function [z]=shuntC_seriesC(C1,C2,w,Zo)

j=sqrt(-1);
w=j*w;
R=Zo;


Y=1/R+(w*C1);
Z=1/Y;
Zt=Z+1/(w*C2)
z=Zt/R

end_diary