%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Test forward and inverse SH Transform and get the mean square error
% between the reconstructed and original function on a grid of points

aziRes = 10;
polarRes = 10;
phi = (0:aziRes:360)*pi/180;
theta = (0:polarRes:180)*pi/180;
[Phi, Theta] = meshgrid(phi, theta);

dirs = grid2dirs(aziRes, polarRes);
W = ones(length(dirs),1);
X = cos(dirs(:,1)).*sin(dirs(:,2));
Y = sin(dirs(:,1)).*sin(dirs(:,2));
Z = cos(dirs(:,2));
Wgrid = ones(size(Phi));
Xgrid = Fdirs2grid(X, aziRes, polarRes, 1);
Ygrid = Fdirs2grid(Y, aziRes, polarRes, 1);
Zgrid = Fdirs2grid(Z, aziRes, polarRes, 1);

% a 1st-order cardioid function
C = 0.5*W + 0.5*Y;
Cgrid = Fdirs2grid(C, aziRes, polarRes, 1);

% get harmonic coefficients
C_N = weightedLeastSquaresSHT(1, C, dirs, 'complex', []);

% inverse SHT
C_r = inverseSHT(C_N, dirs, 'complex');
Cgrid_r = Fdirs2grid(real(C_r), aziRes, polarRes, 1);

% rms reconstruction error
rmse = sqrt(mean(mean(abs(Cgrid-Cgrid_r).^2)))

% plot
figure
subplot(121)
surf(Xgrid.*Cgrid, Ygrid.*Cgrid, Zgrid.*Cgrid, Cgrid)
axis square
colorbar
grid on
shading flat
subplot(122)
surf(Xgrid.*Cgrid_r, Ygrid.*Cgrid_r, Zgrid.*Cgrid_r, Cgrid_r)
axis square
colorbar
grid on
shading flat
