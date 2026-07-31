%_____________________________________________ TWO IMAGES INTERSECTION ________________________________________
% the mathematical model is based on the collinearity equations in Photogrammetry and machine vision topics. 
% Input: 1-Orienation of the stereo cameras "three angles [rad] and three coordinates[m] for each camera"
%        2- focal length f [mm] - assume xo=yo=lens distortion=0
%        3- measured photo coordinates in [mm] in both photos
% Note: for pixel coordinates: transform to p.p. system by knowing the pixel size and image dimensions       
% Output: 
% 3D metric coordinates of the image points by least square adjustment
% code prepared by [Bashar S. Alsadik] 2013.  ITC faculty - Twente University- Netherlands
% ____________________________________________________________________________________________________________

function[xx,yy,zz]=intersectionlinear(exterior1,exterior2,f,xy1,xy2)
  
  omega(1,1)=exterior1(1,1);phi(1,1)=exterior1(1,2);kappa(1,1)=exterior1(1,3);xo(1,1)=exterior1(1,4);yo(1,1)=exterior1(1,5);zo(1,1)=exterior1(1,6);
  omega(2,1)=exterior2(1,1);phi(2,1)=exterior2(1,2);kappa(2,1)=exterior2(1,3);xo(2,1)=exterior2(1,4);yo(2,1)=exterior2(1,5);zo(2,1)=exterior2(1,6);
 format short g 

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rotation Matrix M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mw1=[1 0 0;0 cos(omega(1,1)) sin(omega(1,1)) ;0 -sin(omega(1,1)) cos(omega(1,1))];
mp1=[cos(phi(1,1)) 0 -sin(phi(1,1));0 1 0;sin(phi(1,1)) 0 cos(phi(1,1))];
mk1=[cos(kappa(1,1)) sin(kappa(1,1)) 0;-sin(kappa(1,1)) cos(kappa(1,1)) 0;0 0 1];
m=mw1*mp1*mk1;  
mw2=[1 0 0;0 cos(omega(2,1)) sin(omega(2,1)) ;0 -sin(omega(2,1)) cos(omega(2,1))];
mp2=[cos(phi(2,1)) 0 -sin(phi(2,1));0 1 0;sin(phi(2,1)) 0 cos(phi(2,1))];
mk2=[cos(kappa(2,1)) sin(kappa(2,1)) 0;-sin(kappa(2,1)) cos(kappa(2,1)) 0;0 0 1];
M=mw2*mp2*mk2; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xr=xy2(:,1);yr=xy2(:,2);
xl=xy1(:,1);yl=xy1(:,2);
%%%%%%%%%%%%%%%%%%%%%%%%%% B MATRIX & F MATRIX  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    fx1   =-((-f*m(1,1)-xl(:,1)*m(3,1))*xo(1,1)+(f*m(1,3)+xl(:,1)*m(3,3))*yo(1,1)-(f*m(1,2)+xl(:,1)*m(3,2))*zo(1,1)) ;
    fy1   =-((-f*m(2,1)-yl(:,1)*m(3,1))*xo(1,1)+(f*m(2,3)+yl(:,1)*m(3,3))*yo(1,1)-(f*m(2,2)+yl(:,1)*m(3,2))*zo(1,1)) ;
    fx2 =-((-f*M(1,1)-xr(:,1)*M(3,1))*xo(2,1)+(f*M(1,3)+xr(:,1)*M(3,3))*yo(2,1)-(f*M(1,2)+xr(:,1)*M(3,2))*zo(2,1)) ;
    fy2 =-((-f*M(2,1)-yr(:,1)*M(3,1))*xo(2,1)+(f*M(2,3)+yr(:,1)*M(3,3))*yo(2,1)-(f*M(2,2)+yr(:,1)*M(3,2))*zo(2,1)) ;
       
    b11  =(xl(:,1)*m(3,1)+(f*m(1,1)));
    b12  =(xl(:,1)*m(3,2)+(f*m(1,2)));
    b13  =-(xl(:,1)*m(3,3)+(f*m(1,3)));
    b21=(yl(:,1)*m(3,1)+(f*m(2,1)));
    b22=(yl(:,1)*m(3,2)+(f*m(2,2)));
    b23=-(yl(:,1)*m(3,3)+(f*m(2,3)));
   
    b31=(xr(:,1)*M(3,1)+(f*M(1,1)));
    b32=(xr(:,1)*M(3,2)+(f*M(1,2)));
    b33=-(xr(:,1)*M(3,3)+(f*M(1,3)));
    b41=(yr(:,1)*M(3,1)+(f*M(2,1)));
    b42=(yr(:,1)*M(3,2)+(f*M(2,2)));
    b43=-(yr(:,1)*M(3,3)+(f*M(2,3)));
for i=1:size(xl,1)
ff=[fx1(i,1);fy1(i,1);fx2(i,1);fy2(i,1)];
b=[b11(i,1) b12(i,1) b13(i,1);b21(i,1) b22(i,1) b23(i,1);b31(i,1) b32(i,1) b33(i,1);b41(i,1) b42(i,1) b43(i,1)];
 %%%%%%%%%%%%%%%%%%%%%   least square     %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   btb=inv(b'*b); 
  btf=b'* ff;
delta=btb*btf  ;

j=1;
xx(i,1)= delta(j,1);
yy(i,1)= delta(j+2,1);
zz(i,1)= delta(j+1,1);
end

    
 