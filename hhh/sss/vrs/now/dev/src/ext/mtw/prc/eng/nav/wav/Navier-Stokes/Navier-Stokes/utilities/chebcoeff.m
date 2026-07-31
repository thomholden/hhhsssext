function B = chebcoeff(A)
%CHEBCOEFF   Determine spectral coefficients from the nodal values in 2D.
%   B = CHEBCOEFF(A) determines the spectral coefficients in matrix B 
%   for the 2D Chebyshev expansion using the known nodal values given in 
%   matrix A.
%
%   See also   CHEBCOEFFPLOT

%   The algorithm uses the Fast Chebyshev Transform and the code is
%   identical to Greg von Winckel's "2D Chebyshev Transform" except the
%   first line.
%
%   Zoltán Csáti
%   2014/09/21

% Flip the matrix elements because of reverse ordering
A = rot90(A,2); % same as flipud(fliplr(A));
% From now, use  Greg von Winckel's code available from
% http://www.mathworks.com/matlabcentral/fileexchange/
%                                            4416-2d-chebyshev-transform
[N,M]=size(A);
F=ifft([A(1:N,:);A(N-1:-1:2,:)]);
B=real([F(1,:); 2*F(2:N,:)]);
G=B.';
F=ifft([G(1:M,:);G(M-1:-1:2,:)]);
B=real([F(1,:); 2*F(2:M,:)]).';