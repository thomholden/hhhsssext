%seriesL_shuntL.m
%John Wetters
function [z]=seriesL_shuntL(L1,L2,w,Zo)

j=sqrt(-1);
w=j*w;
R=Zo;


Z=R+(w*L1);
Y=1/Z;
Yt=Y+1/(w*L2);
Zt=1/Yt;
z=Zt/R;

end_diary