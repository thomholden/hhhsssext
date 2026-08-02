%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Rotation of general spherical functions directly by manipulation of their
% SH coefficients is fairly complicated, apart from the case of an
% axisymmetric function, which can be expressed as a weighted sum of
% Legendre polynomials (or a weighted sum of spherical harmonics of degree
% m=0). Such a funciton has N+1 non-zero SH coefficients. By rotating it to
% some arbitrary direction, all the SH coefficients are populated.

aziRes = 10;
polarRes = 10;
phi = (0:aziRes:360)*pi/180;
theta = (0:polarRes:180)*pi/180;
[Phi, Theta] = meshgrid(phi, theta);
Wg = ones(size(Phi));
Xg = cos(Phi).*sin(Theta);
Yg = sin(Phi).*sin(Theta);
Zg = cos(Theta);

dirs = grid2dirs(aziRes, polarRes);
X = cos(dirs(:,1)).*sin(dirs(:,2));
Y = sin(dirs(:,1)).*sin(dirs(:,2));
Z = cos(dirs(:,2));

% desired orientation of the rotated function
theta0 = pi/2;
phi0 = pi/4;
% 3-rd order cardioid function, looking towards z+ (unrotated)
N = 3;
C = (1/2)^N * (1+Z).^N;
Cg = Fdirs2grid(C, aziRes, polarRes, 1);

% get harmonic coefficients
C_N = weightedLeastSquaresSHT(N, C, dirs, 'complex', []);
C_nm0 = C_N([1 3 7 13]);

% rotate coefficients
C_Nrot = rotateCoeffs(C_nm0, theta0, phi0);

% reconstruct at grid
C_rot = inverseSHT(C_Nrot, dirs, 'complex');
Cg_rot = Fdirs2grid(real(C_rot), aziRes, polarRes, 1);

% plot
figure
subplot(121)
surf(Xg.*Cg, Yg.*Cg, Zg.*Cg, Cg)
line([0 1.5],[0 0],[0 0],'color',[1 0 0])
line([0 0],[0 1.5],[0 0],'color',[0 1 0])
line([0 0],[0 0],[0 1.5],'color',[0 0 1])
axis equal
colorbar
grid on
shading flat
subplot(122)
surf(Xg.*Cg_rot, Yg.*Cg_rot, Zg.*Cg_rot, Cg_rot)
line([0 1.5],[0 0],[0 0],'color',[1 0 0])
line([0 0],[0 1.5],[0 0],'color',[0 1 0])
line([0 0],[0 0],[0 1.5],'color',[0 0 1])
axis equal
colorbar
grid on
shading flat
