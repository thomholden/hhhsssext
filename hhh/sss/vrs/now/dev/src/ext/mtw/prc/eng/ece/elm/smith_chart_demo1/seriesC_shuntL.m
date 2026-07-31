%seriesC_shuntL.m
%John Wetters
function [z]=seriesC_shuntL(C1,L2,w,Zo)

j=sqrt(-1);
w=j*w;
R=Zo;


Z=R+1/(w*C1);
Y=1/Z;
Yt=Y+1/(w*L2);
Zt=1/Yt;
z=Zt/R;

end_diary