clc
clearvars
close all
dbstop error

%UNCOMMENT ONE OF THE FOLLOWING LINES AND RUN

% load TubularCuboidSurface.mat
% load SphereSurface.mat
% load CylinderSurface.mat
% load StubAxleSurface.mat
load Cube_Surface.mat
% load Block_Surface.mat

V=SurfaceVolume(p,t,tnorm)


close all
figure(1)


hold on
axis equal
title(['Volume= ',num2str(V)],'Fontsize',14)
% set(gcf,'position',[100 100 1000 600])
trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c','edgecolor','b')

% cc=(p(t(:,1),:)+p(t(:,2),:)+p(t(:,3),:))/3;
% quiver3(cc(:,1),cc(:,2),cc(:,3),tnorm(:,1),tnorm(:,2),tnorm(:,3))
