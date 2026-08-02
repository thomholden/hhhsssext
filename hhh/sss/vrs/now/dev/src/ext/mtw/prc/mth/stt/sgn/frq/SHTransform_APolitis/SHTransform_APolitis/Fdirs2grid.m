function Wgrid = Fdirs2grid(W, aziRes, polarRes, CLOSED)
%FDIRS2GRID The opposite of dirs2grid
%
%   Fdirs2grid takes a vector of values of function evaluated at a 
%   spherical grid with the grid2dirs function, and convert it back to a 
%   2D grid. Useful for plotting or integrating numerically spherical 
%   functions.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phi = (0:aziRes:360-aziRes)*pi/180;
theta = (0:polarRes:180)*pi/180;
Nphi = length(phi);
Ntheta = length(theta);
Nf = size(W, 2);
Wgrid = zeros(Nphi, Ntheta, Nf);
for i = 1:Nf
    
    Wgrid(:, 2:end-1, i) = reshape(W(2:end-1, i), Nphi, Ntheta-2);
    Wgrid(:, 1, i) = ones(Nphi, 1) * W(1, i);
    Wgrid(:, end, i) = ones(Nphi, 1) * W(end, i);
end

if Nf==1
    Wgrid = permute(Wgrid, [2 1 3]);
else
    Wgrid = Wgrid.';
end

if CLOSED
    Wgrid = horzcat(Wgrid, Wgrid(:,1,:));
end
