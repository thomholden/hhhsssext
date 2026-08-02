function c_nm = rotateCoeffs(c_n, theta_0, phi_0)
%ROTATECOEFFS Get spherical coefficients for a rotated axisymmetric pattern
%
%   c_n: N+1 coefficients describing a rotationally symmetric pattern of
%        order N, expressed as a sum of spherical harmonics of degree m=0
%        (sum of Legendre polynomials)
%   theta_0: polar rotation for the pattern
%   phi_0: azimuthal rotation for the pattern
%
%   c_nm: (N+1)^2 coefficients of rotated pattern expressed as a sum of
%         spherical harmonics
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = length(c_n)-1;

c_nm = zeros((N+1)^2, 1);
for n=0:N
    temp_legendre = legendre2(n, cos(theta_0));
    for m=-n:n
        q = n*(n+1)+m;
        c_nm(q+1) = c_n(n+1) * sqrt(factorial(n-m)/factorial(n+m)) * temp_legendre(n+m+1) * exp(-1i*m*phi_0);
    end
end
