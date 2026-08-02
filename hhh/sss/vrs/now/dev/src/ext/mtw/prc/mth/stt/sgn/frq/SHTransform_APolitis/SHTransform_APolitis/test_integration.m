%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A test of the spectral theorem that states that the integral of the 
% product of two functions is equal to the dot product sum of their 
% respective spectral coefficients.

aziRes = 10;
polarRes = 10;
phi = (0:aziRes:360)*pi/180;
theta = (0:polarRes:180)*pi/180;
[Phi, Theta] = meshgrid(phi, theta);

dirs = grid2dirs(10, 10);
W = ones(length(dirs),1);
X = cos(dirs(:,1)).*sin(dirs(:,2));
Y = sin(dirs(:,1)).*sin(dirs(:,2));
Z = cos(dirs(:,2));

% function 1 - a 1st-order cardioid function looking at phi=0
F = 0.5*W + 0.5*X;
Fgrid = Fdirs2grid(F, aziRes, polarRes, 1);

% function 2 - a 1st-order cardioid function looking at phi=90
G = 0.5*W + 0.5*Y;
Ggrid = Fdirs2grid(G, aziRes, polarRes, 1);

% get harmonic coefficients
F_N = weightedLeastSquaresSHT(1, F, dirs, 'complex', []);
G_N = weightedLeastSquaresSHT(1, G, dirs, 'complex', []);

% evaluate the integral of the product of the functions numerically
FG = Fgrid .* Ggrid .* sin(Theta);
intFG1 = trapz(phi, FG, 2);
intFG1 = trapz(theta, intFG1)

% evaluate the integral through the harmonic coefficients
intFG2 = dot(F_N, G_N)
