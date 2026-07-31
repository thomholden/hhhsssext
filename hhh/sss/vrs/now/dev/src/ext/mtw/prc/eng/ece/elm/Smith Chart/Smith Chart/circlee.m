function [r1 r2 r3]=circlee(x0,y0,r)
x=linspace(x0-r,x0+r,200);
r1=x;
y=sqrt(r^2-(x-x0).^2)+y0;
plot(x,real(y),'g')
hold on
plot(x,-real(y),'g')
axis equal
r2=y;
y2=sqrt(r^2-(x-x0).^2)-y0;
plot(x,real(y2),'g')
hold on
plot(x,-real(y2),'g')
axis equal
r3=y2;
end