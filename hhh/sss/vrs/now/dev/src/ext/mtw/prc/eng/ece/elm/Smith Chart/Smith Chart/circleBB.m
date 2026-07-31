function circleBB(x0,y0,r)
x=linspace(x0-r,x0+r,500);
y=sqrt(r^2-(x-x0).^2)+y0;
plot(x,real(y),'black','linewidth',2);
hold on
plot(x,-real(y),'black','linewidth',2);
axis equal
end