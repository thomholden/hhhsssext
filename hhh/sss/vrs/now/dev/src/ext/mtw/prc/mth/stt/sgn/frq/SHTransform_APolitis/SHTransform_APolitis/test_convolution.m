%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   This test script shows the result of the convolution of a spherical 
%   function x of order N=8 by a spherical filter h of lower order N=4. 
%   The original, filter and output functions are plotted. It's evident
%   that the result is of the lower order of the filter, which act as a
%   lowpass and eliminates the higher harmonics.

aziRes = 5;
polarRes = 5;
phi = (0:aziRes:360)*pi/180;
theta = (0:polarRes:180)*pi/180;
[Phi, Theta] = meshgrid(phi, theta);
Xg = cos(Phi).*sin(Theta);
Yg = sin(Phi).*sin(Theta);
Zg = cos(Theta);

dirs = grid2dirs(aziRes, polarRes);
X = cos(dirs(:,1)).*sin(dirs(:,2));
Y = sin(dirs(:,1)).*sin(dirs(:,2));
Z = cos(dirs(:,2));

% generate a random real 8th-order function
Nx = 8;
X_Nr = randn((Nx+1)^2,1);
X_N = real2complexCoeffs(X_Nr);
% generate a random real 4th-order kernel
Nh = 4;
H_N = randn((Nh+1),1);

% reconstruct X at grid
X = inverseSHT(X_N, dirs, 'complex');
Xgr = Fdirs2grid(real(X), aziRes, polarRes, 1);

% reconstruct H at grid
H_N2 = zeros((Nh+1)^2,1);
H_N2([1 3 7 13 21]) = H_N;
H = inverseSHT(H_N2, dirs, 'complex');
Hgr = Fdirs2grid(H, aziRes, polarRes, 1);

% perform convolution
Y_N = sphConvolution(X_N, H_N);

% reconstruct Y at grid
Y = inverseSHT(Y_N, dirs, 'complex');
Ygr = Fdirs2grid(real(Y), aziRes, polarRes, 1);

% plot function, kernel and convolution product
figure
subplot(131)
surf(Xg.*Xgr, Yg.*Xgr, Zg.*Xgr, Xgr)
line([0 1.5],[0 0],[0 0],'color',[1 0 0])
line([0 0],[0 1.5],[0 0],'color',[0 1 0])
line([0 0],[0 0],[0 1.5],'color',[0 0 1])
axis equal
colorbar
grid on
shading flat
title('Function X(\Omega)')
subplot(132)
surf(Xg.*Hgr, Yg.*Hgr, Zg.*Hgr, Hgr)
line([0 1.5],[0 0],[0 0],'color',[1 0 0])
line([0 0],[0 1.5],[0 0],'color',[0 1 0])
line([0 0],[0 0],[0 1.5],'color',[0 0 1])
axis equal
colorbar
grid on
shading flat
title('Kernel H(\Omega)')
subplot(133)
surf(Xg.*Ygr, Yg.*Ygr, Zg.*Ygr, Ygr)
line([0 1.5],[0 0],[0 0],'color',[1 0 0])
line([0 0],[0 1.5],[0 0],'color',[0 1 0])
line([0 0],[0 0],[0 1.5],'color',[0 0 1])
axis equal
colorbar
grid on
shading flat
title('Output Y(\Omega)')
