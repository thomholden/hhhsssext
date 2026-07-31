Re = out(1);
Im = out(2);
Rad = out(3);
Ang = out(4);
ReZ = out(7);
ImZ = out(8);
ReY = out(9);
ImY = out(10);

set(hRe, 'String', num2str(out(1)) );
set(hIm, 'String', num2str(out(2)) );
set(hRad, 'String', num2str(out(3)) );
set(hAng, 'String', [num2str(out(4)) ]);
set(hReZ, 'String', [num2str(out(7)) ]);
set(hImZ, 'String', [num2str(out(8)) ]);
set(hReY, 'String', [num2str(out(9)*mS_factor)] );
set(hImY, 'String', [num2str(out(10)*mS_factor)] );
set(hRL, 'String', num2str(out(11)) );
set(hVSWR, 'String', num2str(out(12),4) );

polar(.01, .99, 'k');
hold on;
polar(Ang*pi/180, Rad, 'bo');
hold on;
polar(Ang*pi/180, Rad, 'b+');
hold off;