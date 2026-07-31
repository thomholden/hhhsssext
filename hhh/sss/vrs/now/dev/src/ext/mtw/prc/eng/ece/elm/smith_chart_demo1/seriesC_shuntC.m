%seriesC_shuntC.m
%John Wetters
function [z]=seriesC_shuntC(C1,C2,w,Zo)

j=sqrt(-1);
w=j*w;
R=Zo;


Z=R+1/(w*C1);
Y=1/Z;
Yt=Y+(w*C2);
Zt=1/Yt;
z=Zt/R;

end_diary