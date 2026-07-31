%smith3.m
%This Matlab function is to generate the smith chart.
%John Wetters
%Smith chart equations
%(u-(r/r+1))^2+v^2=(1/r+1)^2
%(u-1)^2+(v-1/x)^2=(1/x)^2

function[]=smith3()
clf

hold on
for a=1:4;
rho=[0 .5 1 3];
r=rho(a);
r1=r+1;
r2=(1/r1)^2;
r3=r/r1;
u=-1:.01:1;
u1=u-r3;
u2=u1.^2;
v=real(sqrt(r2-u2));

plot(u,v,u,-v,'k')
clear u
end
grid on
zoom on
text(-1,0,'0')
text(-.34,0,'.5')
text(0,0,'1')
text(.5,0,'3')

hold on

x=[ .5 1 3 ];
for a=1:3

x1=1/(x(a)^2);
if(x(a)==.5)
u=-.6:.01:1;
end
if(x(a)==1)
u=0:.01:1;
end
if(x(a)==3)
u=.665:.01:1;
end
u1=u-1;
u2=u1.^2;
v=abs(-1*(sqrt(x1-u2))+(1/x(a)));
v1=abs((sqrt(x1-u2))+(1/x(a)));
plot(u,v,u,-v)
if(x(a)==3)
plot(u(1:15),v1(1:15),u(1:15),-v1(1:15))
end
clear u
end
grid on
text(-.63,.83,'.5')
text(0,1.05,'1')
text(.81,.61,'3')
text(0,0,'1')

hold on
a=1;
rho=[1 ];
r=rho(a);
r1=r+1;
r2=(1/r1)^2;
r3=r/r1;
u=-1:.005:1;
u1=u+r3;
u2=u1.^2;
v=real(sqrt(r2-u2));

plot(u,v,'r',u,-v,'r')
clear u x
grid on
zoom on






