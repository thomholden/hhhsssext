%shunL_seriesL.m
%John Wetters
function [z]=shuntL_seriesL(L1,L2,w,Zo)

j=sqrt(-1);
w=j*w;
R=Zo;


Y=1/R+1/(w*L1);
Z=1/Y;
Zt=Z+(w*L2)
z=Zt/R

end_diary