%seriesL_shuntC.m
%John Wetters
function [z]=seriesL_shuntC(L1,C2,w,Zo)

j=sqrt(-1);
w=j*w;
R=Zo;


Z=R+(w*L1);
Y=1/Z;
Yt=Y+(w*C2);
Zt=1/Yt;
z=Zt/R;

end_diary