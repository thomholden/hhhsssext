function [p] = pdiff (x,y)

% Are two distributions different ?
% Look at significance of Kolmogorov-Smirnoff statistic
% See p.623 Press et. al.

k=ks(x,y);
Nx=length(x);
Ny=length(y);
Ne=Nx*Ny/(Nx+Ny);

disp('Routine not yet written');
% UNFINISHED