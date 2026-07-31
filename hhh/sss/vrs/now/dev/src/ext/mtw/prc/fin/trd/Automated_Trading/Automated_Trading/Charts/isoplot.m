function isoplot(xyz,u)

% Copyright 2010-2012, The MathWorks, Inc.

% Parse coordinate grid
xx = xyz{3};
yy = xyz{1};
zz = xyz{2};

% Set color scale
redvals = 1.35:0.05:1.55;
yellowvals = 1.05:0.05:1.35;
greenvals = 0.5:0.05:1;
bluevals= 0:0.1:0.4;

% Red
red=[0.5 0 0];
for i=1:length(redvals)
    pH = patch(isosurface(xx,yy,zz,u,redvals(i)));
    set(pH,'facecolor',red,'edgecolor','none','facealpha',0.7);
end

% Yellow
yellow=[0.7 0.7 0];
for i=1:length(yellowvals)
    pH = patch(isosurface(xx,yy,zz,u,yellowvals(i)));
    set(pH,'facecolor',yellow,'edgecolor','none','facealpha',0.3);
end

% Green
green=[0 0.3 0];
for i=1:length(greenvals)
    pH= patch(isosurface(xx,yy,zz,u,greenvals(i)));
    set(pH,'facecolor',green,'edgecolor','none','facealpha',0.2)
end

% Blue
blue = [0 0 0.5];
for i=1:length(bluevals)
    pH= patch(isosurface(xx,yy,zz,u,bluevals(i)));
    set(pH,'facecolor',blue,'edgecolor','none','facealpha',0.3);
end

% Lighting
light('pos',[-100,50,100]); 
light('pos',[50,-100,100]); 
light('pos',[-100,-100,1]); 
light('pos',[1,0,1]);
lighting phong

% View
set(gca,'view',[-21, 18],'dataaspectratio',[2 1 1])
grid on, box on

% Labels
title('Iso-surface of Sharpes ratios')
zlabel('Lag Mov. Avg.');
ylabel('Lead Mov. Avg.');
xlabel('Frequency (minutes)');
