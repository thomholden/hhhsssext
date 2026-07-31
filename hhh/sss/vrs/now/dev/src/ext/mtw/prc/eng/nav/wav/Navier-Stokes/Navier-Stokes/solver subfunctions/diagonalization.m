function [P invP Q invQ LambdaX_i LambdaY_j] = diagonalization(N,Dx,Dy)
%DIAGONALIZATION   Full diagonalization of the Helmholtz-operator.
%
%   Inputs:   N  - polynomial degree in x and y direction
%             Dx - differentiation matrix with respect to x
%             Dy - differentiation matrix with respect to y
%
%   Outputs:  P         - matrix of the eigenvectors of Dx
%             Q         - matrix of the eigenvectors of Dy
%             invP      - inverse of P
%             invQ      - inverse of Q
%             LambdaX_i - matrix from the eigenvalues of Dx
%             LambdaY_j - matrix from the eigenvalues of Dy

%   Zoltán Csáti
%   2014/09/20

[P LambdaX] = eig(Dx);
[Q LambdaY] = eig(Dy);
invP = inv(P);
invQ = inv(Q);
LambdaX_i = diag(LambdaX);
LambdaX_i = repmat(LambdaX_i,1,N-1);
LambdaY_j = diag(LambdaY).';
LambdaY_j = repmat(LambdaY_j,N-1,1);