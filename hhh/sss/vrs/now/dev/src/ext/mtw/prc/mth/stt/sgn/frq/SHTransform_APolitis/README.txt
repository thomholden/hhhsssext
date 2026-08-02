%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 10/10/2013
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

This is a collection of MATLAB routines for the Spherical Harmonic 
Transform (SHT) of spherical functions, and some manipulations on the 
spherical harmonic (SH) domain.

Both real and complex SH are supported. The orthonormalised versions of SH 
are used. More specifically, the complex SHs are given by:

Y_{nm}(\theta,\phi) = 
\sqrt{\frac{2n+1}{4\pi}\frac{(n-m)!}{(n+m)!}}P_l^m(\cos\theta)e^{im\phi}

and the real ones as in:
http://en.wikipedia.org/wiki/Spherical_harmonics#Real_form

The Condon-Shortley phase of (-1)^m is not used in the definition of the 
complex SH since it is included in the definition of the associated 
Legendre functions in MAtlab.

For the complex SH, Matlab Legendre's function should be extended for 
negative orders m<0. This is done in Legendre2 function.

For the calculation of the Wigner3j symbols, the function by J. Pritchard
was used. It can be downloaded at:
http://massey.dur.ac.uk/jdp/code/w3j.m
Note that line 20&21 should be removed, I guess they are there for some 
specific calculation with this extra condition.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

For more details on the functions, check their help output in Matlab.
--- List of MATLAB files ---
getSH.m		-	Get SHs up to order N
legendre2.m	-	Same as matlab Legendre extended for negative orders m<0
leastSquaresSHT.m -	SHT of function using least-squares
weightedLeastSquaresSHT.m - SHT using weighted least-squares
inverseSHT.m	-	Perform the inverse SHT

complex2realCoeffs.m	-  Convert SH coeffs from the complex to real basis
real2complexCoeffs.m	-  Convert SH coeffs from the real to complex basis
rotateCoeffs.m	-	Get SH coefficients for a rotated axisymmetric pattern
conjCoeffs.m    -   Get the complex SH coefficients of a conjugate function
gaunt_mtx.m	-	Construct a matrix of Gaunt coefficients up to some order
sphConvolution.m    -   Perform spherical convolution between a function 
                        and a filter, in the SH domain

Fdirs2grid.m	-	Helper function, used with grid2dirs2
grid2dirs.m     -	Construct a vector of regular grid points
sphDelaunay.m	-	Computes the Delaunay triangulation on the unit sphere
sphVoronoi.m	-	Computes the a Voronoi diagram on the unit sphere
sphVoronoiAreas.m       - Computes the areas of a voronoi diagram on the
                          unit sphere
checkOrthogonality.m    - Computes the condition number for a least-squares 
                          SHT

--- Some test scripts ---
test_Parceval.m
test_gaunt.m
test_integration.m
test_multiplication.m
test_reconstruction.m
test_rotation.m
test_conjSH.m
test_convolution.m

