%shunL_seriesC.m
%John Wetters
function [z]=shuntL_seriesC(L1,C2,w,Zo)

j=sqrt(-1);
w=j*w;
R=Zo;


Y=1/R+1/(w*L1);
Z=1/Y;
Zt=Z+1/(w*C2)
z=Zt/R

end_diary