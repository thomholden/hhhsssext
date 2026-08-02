%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A test of Parceval's theorem that states that the energy of the function
% is equal to the sum of its squared spectral coefficients

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

% a 1st-order cardioid function
C = 0.5*W + 0.5*X;
Cgrid = Fdirs2grid(C, aziRes, polarRes, 1);

% get harmonic coefficients
C_N = weightedLeastSquaresSHT(1, C, dirs, 'complex', []);

% evaluate the integral for the directivity factor numerically
% (trapezoidal integration)
CC = Cgrid .* Cgrid .* sin(Theta);
intCC1 = trapz(phi, CC, 2);
intCC1 = trapz(theta, intCC1)

% evaluate the dir. factor through the harmonic coefficients
intCC2 = sum(C_N.^2)
