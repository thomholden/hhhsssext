function [] = plot_mlp_map (w,x,Ni,Nh,nettype,d)

% function [] = plot_mlp_map (w,x,Ni,Nh,nettype,d)
% Plot mlp network response as a function of input
% d 	number of divisions per input dimension

x1min=min(x(:,1));
x1max=max(x(:,1));
x2min=min(x(:,2));
x2max=max(x(:,2));

dx1=(x1max-x1min)/d;
dx2=(x2max-x2min)/d;

x1=[x1min:dx1:x1max];
x2=[x2min:dx2:x2max];
[g1,g2]=meshgrid(x1,x2);

xplot = [reshape(g1,(d+1)^2,1), reshape(g2,(d+1)^2,1)];
if Nh<=1
	y = lognode(xplot,w);
else
	y = mlp(xplot,w,Ni,Nh,nettype);
end
yplot = reshape(y,d+1,d+1);

pcolor(g1,g2,yplot);
colormap gray
shading interp
hold on
%contour(g1,g2,yplot,[0,0.5,1]);
contour(g1,g2,yplot,[-0.1,0.5,1.1]);
caxis([-0.3,1.3]);