%% Fourier Based Field-shift Calculation for MRI
% A test file to demonstrate the feasibility of low resolution 
% aliasing subtraction.
%% Written 06-07-2012 by Job Bouwman (jgbouwman@hotmail.com)
% Updated 14-06-13
clear all; close all; clc;

%% creating a numerical phantom:  
% - an eccentric sphere (radius of 97.3)
% - with tissue-like (-9 ppm) susceptibility (dChi)
% - within an FOV of (256 x 256 x 256)
N = 192; 
radius = round(0.38*N);
dChiTissue = -9e-6;
voxelSize = [1 1 1];

% for visualization the sphere is placed off center
M = round(0.4*N);
Nx =  N; Ny = N; Nz = N;
Mx =  M; My = M; Mz = M;

FOV = [Ny Nx Nz].*voxelSize;

% creating the susceptibility distribution
dChi_3D = zeros(Ny, Nx, Nz); 
dChi_3D(My,Mx,Mz) = 1;
dChi_3D = bwdist(dChi_3D); 
dChi_3D(dChi_3D<=radius) = dChiTissue;
dChi_3D(dChi_3D>radius)  = 0;

%% The kernel in k-space:
kx_squared = ifftshift((-Nx/2:Nx/2-1)/FOV(2)).^2;
ky_squared = ifftshift((-Ny/2:Ny/2-1)/FOV(1)).^2;
kz_squared = ifftshift((-Nz/2:Nz/2-1)/FOV(3)).^2;
[kx2_3D,ky2_3D,kz2_3D] = meshgrid(kx_squared,ky_squared,kz_squared);
kernel = 1/3 - kz2_3D./(kx2_3D + ky2_3D + kz2_3D);    
kernel(1,1,1) = 0;

%% Field shift calculations:
% without zero-padding the result would be: 
dField_3D = ifftn(fftn(dChi_3D).*kernel);

% with virtual zero-padding the result is: 
dField_3D_noAliasing = calculateFieldShift(dChi_3D, voxelSize);

% thus the aliasing removed is: 
Aliasing_3D = dField_3D - dField_3D_noAliasing;


%% Displaying the results:
% setting a fixed intensity window, for good visual validation:
intensityWindow = [min(dField_3D_noAliasing(:)), max(dField_3D_noAliasing(:))];

scrsz = get(0,'ScreenSize'); % full screen looks better
figure('Position', scrsz, 'Units', 'normalized');
axes('Position',[0 0 1 1], 'Units','normalized');

% the result without zero-padding
subplot(1,3,1);
imagesc(squeeze(dField_3D(My, :, :))',intensityWindow);axis equal tight
text(Nz*0.95,My,'\rightarrow','HorizontalAlignment','right','fontsize',35)
text(Nz*0.65,My*1.1,'corrupted with aliasing','HorizontalAlignment',...
    'right', 'fontsize', 12)
title('Result without aliasing prevention',...
    'fontsize', 12);
xlabel('axis perpendicular to B_0 \rightarrow');
ylabel('B_0 direction \rightarrow');
axis equal tight; 


% the estimated aliasing distribution
subplot(1,3,2);
imagesc(squeeze(Aliasing_3D(My, :, :))',intensityWindow);axis equal tight
text(Nz*0.95,My,'\rightarrow','HorizontalAlignment','right','fontsize',35)
text(Nz*0.65,My*1.1,'pure aliasing','HorizontalAlignment',...
    'right', 'fontsize', 12)
title(strcat('Estimated aliasing distribution', ...
    ' (calculated in low-res)'),'fontsize', 12);
xlabel('axis perpendicular to B_0 \rightarrow');
ylabel('B_0 direction \rightarrow');
 axis equal tight;

    
% the final result of using virtual zero-padding:
subplot(1,3,3);
imagesc(squeeze(dField_3D_noAliasing(My, :, :))',intensityWindow);axis equal tight
text(Nz*0.95,My,'\rightarrow','HorizontalAlignment','right','fontsize',35)
text(Nz*0.65,My*1.1,'cleared result','HorizontalAlignment',...
    'right', 'fontsize', 12)
title('Final result of virtual zero-padding','fontsize', 12);
xlabel('axis perpendicular to B_0 \rightarrow');
ylabel('B_0 direction \rightarrow');
 axis equal tight;
   