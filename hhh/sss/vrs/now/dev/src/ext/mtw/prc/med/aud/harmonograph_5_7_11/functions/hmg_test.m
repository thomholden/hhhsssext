%hmg_test

f_Hz = 440;
N = 70;
A = 2/3;
F = 3/2-0.3;
phi = 0.2;
D = 1;
M=100;

%Lateral Harmonograph
[x_lat,y_lat,t] = lat_hmg( N,M, f_Hz, F, A, D, phi );

%Rotary Harmonograph
[x_rot,y_rot,t] = rot_hmg( N,M, f_Hz, F, A, D, phi );

%Construct title string
title_string = ...
    ['N=',num2str(N),', A=',num2str(A),', F=',num2str(F),...
    ', phi=',num2str(phi*180/pi),'^o, D=',num2str(D)] ;

clf
set(gcf,'position',[189 149 1080 668])
subplot(1,2,1);
plot(x_lat,y_lat,'r');
axis off
axis equal;
title({'Lateral',title_string})
subplot(1,2,2);
plot(x_rot,y_rot,'b');
axis off
axis equal;
title({'Rotary',title_string})
saveas(gcf,['harmonograph ',...
    strrep( strrep(title_string,',',''),'^o',''),'.png'],'png')

%End of code