function circlbl(x0,y0,r)
x=linspace(x0-r,x0+r,500);
y=sqrt(r^2-(x-x0).^2)+y0;
plot(x,real(y))
hold on
plot(x,-real(y))
axis equal
y=sqrt(r^2-(x-x0).^2)-y0;
plot(x,real(y))
hold on
plot(x,-real(y))
axis equal
end