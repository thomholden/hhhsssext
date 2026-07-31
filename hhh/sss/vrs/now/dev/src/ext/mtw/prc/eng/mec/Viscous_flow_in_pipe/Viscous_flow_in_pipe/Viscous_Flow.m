%function [V,Vmax,Vmean,Q] = ViscousFlow (Pa,Pb,R,mu,l)
%
%Function : [Vmax,Vmean,Q] = ViscousFlow (Pa,Pb,R,u,l)
%
%%This program simulates the velocity profile across the radius of the tube with the following
%%inputs
%%Pa  :  Pressure in point a in Pascal .
%%Pb  :  Pressure in the other extermity b in Pascal.
%%mu  :  Viscosity of the fluid in Pascal.second
%%R   :  Radius of the tube in meter.
%%l   :  length of the tube  in meter.


%%We assume that the environment is  ambient(AT=298.15 K) and the viscosity
%%is static .

%%The outputs of the program are :

%%Vmax:  Maximum velocity in m/s.
%%Vmea:  Mean Velocity in the whole tube in m/s.
%%Q   :  Volumic flow in meter^3 /second .
%%The Unit of the viscosity is also: Kg.second^-1.meter^-1.

%%The table below gives some numerical values of various fluids in ambiant Temperature[1] :

%%Liquid ||Viscosity (Pas.s)

%%water     :8.94e-4.
%%olive oil :0.081.
%%mercury   :1.526e-3.
%%ethanol   :1.074e-3.
%%castor oil:0.985.
%%propanol  :1.945e-3.
%%pitch     :2.3e+8.
%%motor oil :0.065.
%%ketchup   :50-100.
%%honey     :2-10.
%%Blood(37°):(3-4)e-3.

%%Some of the materials above have variable viscosity.
%%References :
%%-----------
%%[1]: http://en.wikipedia.org/wiki/Viscosity#cite_note-23.
%%[2]: Viscosity of liquids and Gazs :
%    http://hyperphysics.phy-astr.gsu.edu/Hbase/tables/viscosity.html.

% (c)  KHMOU Youssef,  Applied Physics May 2013    
     
dbstop if error
Pa=10;
Pb=50;
mu=8.94e-4;
R=0.10;
l=1.00;





if Pa==Pb
    disp(' Warning : No flow because the pressure is the whole same in the pipe');
    exit;
end
N=150;
r=linspace(-R,R,N);
S=pi*R^2;
Vmax=(abs(Pa-Pb))*(R^2)/(4*mu*l);
Vmean=Vmax/2;
V=Vmax*(1-(r.^2)/R^2);
Q=Vmean*S;
xc=0;
yc=0;
zc=0;
[X,Y,Z]=ellipsoid(xc,yc,zc,R,R,Vmax,N);
Z(Z<0)=0;

% FIGURE(1) : 
figure(1),
stem(V,r,'r.');
grid on, xlabel(' Velocity (m/s)'), ylabel(' Radius (m)'), title(' Velocity profile');


% FIGURE(2)
figure(3)
contourf(X,Y,Z),
colormap autumn,
colorbar,
grid on,
xlabel(' X(m)');
ylabel(' Y(m)');
title(' Velocity Profile (m/s),Equipotential layers');
info1=strcat('\mu =',num2str(mu),' P.s');
info2=strcat('V_{max}=',num2str(Vmax),' m/s');
hold on,
text(0.02,0.01,info1);
text(0.02,0.00,info2);
hold off



    