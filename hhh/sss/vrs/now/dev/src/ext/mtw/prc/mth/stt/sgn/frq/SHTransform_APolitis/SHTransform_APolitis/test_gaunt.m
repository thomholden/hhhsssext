%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The Gaunt coefficient gives the integral of the product of three
% spherical harmonics and it is used in obtaining the coefficients of the
% product of two spherical functions directly from their respective
% coefficients

aziRes = 2;
polarRes = 2;
phi = (0:aziRes:360)*pi/180;
theta = (0:polarRes:180)*pi/180;
[Phi, Theta] = meshgrid(phi, theta);

dirs = grid2dirs(aziRes, polarRes);

n3 = 4;
m3 = -3;
n1 = 1;
m1 = -1;
n2 = 3;
m2 = -2;

q3 = n3*(n3 + 1) + m3;
q1 = n1*(n1 + 1) + m1;
q2 = n2*(n2 + 1) + m2;

Y3 = getSH(n3, dirs, 'complex');
Y1 = getSH(n1, dirs, 'complex');
Y2 = getSH(n2, dirs, 'complex');
Y3 = Fdirs2grid(Y3(:,q3+1), aziRes, polarRes, 1);
Y1 = Fdirs2grid(Y1(:,q1+1), aziRes, polarRes, 1);
Y2 = Fdirs2grid(Y2(:,q2+1), aziRes, polarRes, 1);

% evaluate the integral of the product of the functions numerically
Y123 = Y1 .* Y2 .* conj(Y3) .* sin(Theta);
intY1 = trapz(phi, Y123, 2);
intY1 = trapz(theta, intY1);
Gaunt1 = intY1

% evaluate the integral through explicit relation
wigner3jm = w3j(n1, m1, n2, m2, n3, -m3);
wigner3j0 = w3j(n1, 0, n2, 0, n3, 0);
Gaunt2 = (-1)^m3 * sqrt((2*n1+1)*(2*n2+1)*(2*n3+1)/(4*pi)) * wigner3jm * wigner3j0
