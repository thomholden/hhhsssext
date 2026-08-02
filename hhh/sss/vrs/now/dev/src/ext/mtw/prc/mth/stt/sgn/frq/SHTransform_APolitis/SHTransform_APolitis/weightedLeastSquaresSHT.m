function [F_N, W] = weightedLeastSquaresSHT(N, F, dirs, basisType, W)
%WEIGHTEDLEASTSQUARESSHT Spherical harmonic transform of F using weighted 
%                        least squares solution
%
%   N: maximum order of harmonics
%   F: the spherical function evaluated at directions 'dirs', size
%      [Ndirsx1]
%   W: weights for each measurement point to condition the inversion, if
%      empty then the spherical voronoi areas around each point are used,
%      size [Ndirsx1]
%   dirs:   [azimuth inclination] angles in rads for each evaluation point,
%           where inclination is the polar angle from zenith
%           theta = pi/2-elevation, size [Ndirsx2]
%   basisType:  complex or real spherical harmonics, argument 'complex' or
%               'real'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % coordinates of the evaluation points on the unit sphere
    dirs_x = cos(dirs(:,1)).*sin(dirs(:,2));
    dirs_y = sin(dirs(:,1)).*sin(dirs(:,2));
    dirs_z = cos(dirs(:,2));

    % change to elevation from inclination for matlab spherical system
    dirs_elev = dirs;
    dirs_elev(:,2) = pi/2 - dirs_elev(:,2);
    if isempty(W)
        % perform delaunay triangulation
        delaunay.vert = [dirs_x, dirs_y, dirs_z];
        delaunay.face = sphDelaunay(dirs_elev);
        % get voronoi cells from delaunay
        voronoi = sphVoronoi(dirs_elev, delaunay.face);
        % get areas of spherical voronoi polygons
        voronoi = sphVoronoiAreas(voronoi);
        W = voronoi.area;
    end

    % compute the harmonic coefficients
    Y_N = getSH(N, dirs, basisType);

    % perform transform in the least squares sense, weighted
    F_N = inv(Y_N'*diag(W)*Y_N)*(Y_N'*diag(W)) * F;
%    F_N = (Y_N'*diag(W)*Y_N) \ (Y_N'*diag(W) * F);      

end
