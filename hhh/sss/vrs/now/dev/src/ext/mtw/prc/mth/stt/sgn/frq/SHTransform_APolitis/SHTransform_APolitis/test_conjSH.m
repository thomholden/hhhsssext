%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Test that the SH coefficients of a function G, conjugate of F, are given 
%   correctly directly from the SH coefficients of F.

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

% construct a complex sph. function with omnidirectional magnitude and a
% dipole phase
F = exp(1i*1*pi*X);
G = conj(F);

% get harmonic coefficients of F
F_N = weightedLeastSquaresSHT(2, F, dirs, 'complex', []);

% get harmonic coefficients of G
G_N = weightedLeastSquaresSHT(2, G, dirs, 'complex', [])

% get harmonic coefficients of G directly from the coeffs of F
G_N2 = conjCoeffs(F_N)
