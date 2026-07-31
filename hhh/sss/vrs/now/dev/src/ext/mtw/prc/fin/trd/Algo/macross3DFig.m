function macross3DFig(PP,NN,MM,SH)
% script to reproduce the MACROSS 3D figure
figure('pos',[420,447,784,501]);
% divide up the sharpe's ratio into 3
redvals = 1.2:0.1:1.9;
yelvals= 0.3:0.1:1;
bluevals=0.1:0.1:0.4;
isoplot(PP,NN,MM,SH,redvals,yelvals,bluevals);
title('Iso-surface of Sharpes ratios.','fontweight','bold')
set(gca,'view',[-21, 18],'dataaspectratio',[3 1 3])
grid on, box on
% labels
xl = get(gca,'xlabel');
set(xl,'pos',[-776.47,-838.62,830.56],...
    'string','Frequency (minutes)',...
    'Fontweight','bold');

yl = get(gca,'ylabel');
set(yl,'pos',[ -993.33,-805.8,874.29],...
    'string','Fast Mov. Avg.',...
    'Fontweight','bold');

zl = get(gca,'zlabel');
set(zl,'pos',[-1055.6,-785.21,983.16],...
    'string','Slow Mov. Avg.',...
    'Fontweight','bold');
