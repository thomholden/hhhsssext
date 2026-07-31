
%_____________________________________________ TWO IMAGES INTERSECTION _____________________________________________________________________
% the mathematical model is based on the collinearity equations in
% Photogrammetry and machine vision topics. 
% Input: 1- orienation of the stereo cameras "three angles [deg.] and three coordinates[m]"
%        2- camera calibration parameters (or EXIF data)  [height;width;psize;focal length] 
%        3- measured image coordinates in both images (by image sparse matching technique)
% Note: 
% -for pixel coordinates: transform to p.p. system by knowing the pixel size (psize) and image dimensions (width,height)
% 
% Output: 
% 3D metric coordinates of the image points by least square adjustment
% code prepared by PhD. Bashar S. Alsadik  
% University of Twente  - ITC - Netherlands - 2013
% Earth Observation Science EOS - TOPMAP
%___________________________________________________________________________________________________________________________________________
clc
close all
clear
   %%%%%%%%%% LOAD THE IMAGE COORDINATES  (pt. Sn1 Ln1 pt. Sn2 Ln2) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       load(' .................\image_coordinates.txt');
   %%%%%%%%%% load the camera calibration parameters %%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       load('..................\camera.txt');
   %%%%%%%%%% load the exterior orientation parameters %%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       load('..................\exterior.txt');
   %%%%%%%%%% load the left image for the cloud texture %%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
hIdtc = vision.ImageDataTypeConverter;%% change 'vision' to 'video' in matlab 2010
I= step(hIdtc,imread('..................\left.jpg'));
%______________________________________PHOTO COORDINATES [mm] IN P.P SYSTEM_____________________________________
photo1= image_coordinates(1:1:end,2:3);
photo2= image_coordinates(1:1:end,5:6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% camera interior parameters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
height=camera(1);
width =camera(2);
psize =camera(3);
f=camera(4);% ('focal length in mm:');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 x1 =(photo1(:,1)-(height/2)-.5)*psize;     % TRANSFORMED TO PP.
 y1 =((width/2)-photo1(:,2)-.5)*psize;
 x2 =(photo2(:,1)-(height/2)-.5)*psize;     % TRANSFORMED TO PP.
 y2 =((width/2)-photo2(:,2)-.5)*psize;
xy1=[x1 y1];
xy2=[x2 y2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THE EXTERIOR ORIENTATION PARAMETERS OF THE TWO CAMERAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% % first image
   w1=(pi/180)*(exterior(1,1));p1=(pi/180)*(exterior(1,2));k1=(pi/180)*(exterior(1,3));Tx1=exterior(1,4);Ty1=exterior(1,5);Tz1=exterior(1,6);
  exterior1=[w1,p1,k1,Tx1,Ty1,Tz1];
% % second image
  w2=(pi/180)*(exterior(2,1));p2=(pi/180)*( exterior(2,2) );k2=(pi/180)*(exterior(2,3));Tx2=exterior(2,4);Ty2=exterior(2,5);Tz2=exterior(2,6);
  exterior2=[w2,p2,k2,Tx2,Ty2,Tz2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INTERSECT THE IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

  [xx,yy,zz]=intersectionlinear(exterior1,exterior2,f,xy1,xy2);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% final results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P1=[(1:size(xx,1))',xx,yy,zz];
    
    fprintf('%s\n', '---------------------------------------');
    fprintf('%s\n', '  point      X         Y          Z    ');
    fprintf('%s\n', '---------------------------------------');
    for i=1:size(P1,1)
        fprintf('%5.0f %10.3f %10.3f %10.3f\n', P1(i,:) );
    end
    fprintf('%s\n', '---------------------------------------');
%      plot3(xx1,yy1,zz1,'r.');hold on
%      axis off
%      axis image
         
figure     
 tic
 for i=1:size(P1,1) 
             
    r(i,1) =I( round(photo1(i,2)),round(photo1(i,1)),1)  ;
    g(i,1) =I( round(photo1(i,2)),round(photo1(i,1)),2)  ;
    b(i,1) =I( round(photo1(i,2)),round(photo1(i,1)),3)  ;
   %plot3(xx1(i,1),yy1(i,1),zz1(i,1) ,'.','Color',[r(i,1) g(i,1) b(i,1)]  );hold on
 end    
    scatter3(xx ,yy ,zz  ,10,[r  g  b],'filled'  );hold on
 toc
 axis image 
 axis off
 disp(' THANKS FOR USING MY CODE .............................')
 disp(' CLOSE RANGE PHOTOGRAMMETRY AND MACHINE VISION..........')
 disp(' BASHAR ALSADIK........................................')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

