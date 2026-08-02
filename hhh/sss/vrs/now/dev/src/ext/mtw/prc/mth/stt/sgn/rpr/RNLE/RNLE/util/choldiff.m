%CHOLDIFF   Differentiation of the Cholesky factor
%   
%   [Y,dY]=CHOLDIFF(X,dX) returns the lower Cholesky factor of and its
%   derivatives.
%   
%   Inputs X must be a symmetric positive-definite matrix. Input Y may be
%   either a symmetric matrix or an array of symmetric matrices. Both
%   inputs must be real.
%   
%   This function uses only the diagonal and lower triangle of X. The upper
%   triangle is assumed to be the transpose of the lower triangle.
%   
%   This function is a direct implementation of the algorithm presented in
%   the paper "Differentiation of the Cholesky Algorithm" by S. P. Smith,
%   published in the Journal of Computational and Graphical Statistics,
%   Vol. 4 (2), pages 134-147, June 1995.
%   
%   See also CHOL.
%   
%   Copyright (c) 2012 Gabriel Agamennoni.