function [F_N, Y_N] = leastSquaresSHT(N, F, dirs, basisType)
%LEASTSQUARESSHT Spherical harmonic transform of F using least-squares
%
%   N:  maximum order of harmonics
%   F: the spherical function evaluated at directions 'dirs'
%   dirs:   [azimuth inclination] angles in rads for each evaluation point,
%           where inclination is the polar angle from zenith
%           theta = pi/2-elevation
%   basisType:  'complex' or 'real' spherical harmonics
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % compute the harmonic coefficients
    Y_N = getSH(N, dirs, basisType);

    % perform transform in the least squares sense
    F_N = pinv(Y_N)*F;

end
