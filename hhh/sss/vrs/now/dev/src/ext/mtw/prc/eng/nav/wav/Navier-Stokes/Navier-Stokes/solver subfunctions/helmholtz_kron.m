function [sol X Y] = helmholtz_kron(N,RHS,leftBC,topBC,rightBC,bottomBC,sigma)
%HELMHOLTZ_KRON   Solution of the Helmholtz equation on [-1,1]x[-1,1] with 
%Dirichlet boundary conditions using Chebyshev collocation method with
%Kronecker product.
%
%   Helmholtz equation: u_xx + u_yy - sigma*u = f(x,y)
%
%   Inputs:  N        - polynomial degree in x and y direction
%            RHS      - function of the right-hand side
%            leftBC   - boundary condition on the left edge
%            topBC    - boundary condition on the top edge
%            rightBC  - boundary condition on the right edge
%            bottomBC - boundary condition on the bottom edge
%            sigma    - constant
%   Outputs: sol - solution at (X,Y)
%            X, Y  - meshgrid from the Chebyshev-Gauss-Lobatto points
%   The boundary conditions should be given so that the values at the corners
%   are the same for the neighbouring boundaries to maintain continuity.
%
%   Example: Solve u_xx + u_yy = f(x,y),   (x,y) in (-1,1)x(-1,1) with 
%               f(x,y)= -8*pi^2*cos(2*pi*x)*sin(2*pi*y)
%               u(x,-1) = 0,            -1<=x<=1
%               u(1,y)  = sin(2*pi*y),  -1<=y<=1
%               u(x,1)  = 0,            -1<=x<=1
%               u(-1,y) = sin(2*pi*y),  -1<=y<=1.
%            Solution:
%               topBC = @(x) 0;  bottomBC = @(x) 0;
%               leftBC = @(y) sin(2*pi*y);  rightBC = @(y) sin(2*pi*y);
%               fcn = @(x,y) -8*pi^2*cos(2*pi*x).*sin(2*pi*y);
%               [u X Y] = helmholtz_kron(30,fcn,leftBC,topBC,rightBC,bottomBC,0);
%               mesh(X,Y,u);
%            Compare it with the exact solution u(x,y) = cos(2*pi*x)*sin(2*pi*y)
%               u_exact = cos(2*pi*X).*sin(2*pi*Y);
%               maxDifference = norm(u-u_exact,Inf);  % 4.8621e-14
%
%   See also   HELMHOLTZ_DIAG, DERMATRIX, CORRECTINPUT

%   The example is taken from 
%      Kopriva D. A.: Implementing Spectral Methods for Partial Differential
%      Equations, Springer, 2009
%
%   Zoltán Csáti
%   2014/07/09

% Form the Chebyshev-Gauss-Lobatto nodes using the exact formula
x = -cos(pi*(0:N)/N)';
% Compute the derivative matrix
D = dermatrix(x,2);
D = D{2};
% Reduce the size of the coefficient matrix by deleting the first and last
% rows and columns
D_red = D(2:N,2:N);

% Construct the coefficient matrix from the strong form
I = eye(N-1);
A1 = kron(I,D_red);
A2 = kron(D_red,I);
A3 = sigma*kron(I,I);
A = A1 + A2 - A3;

% Evaluate the known function on the right at the nodes
[X Y] = meshgrid(x);
X_red = X(2:end-1,2:end-1);
Y_red = Y(2:end-1,2:end-1);
if isa(RHS,'function_handle')
    b1 = RHS(X_red,Y_red);
elseif isa(RHS,'numeric')
    b1 = RHS;
    if numel(RHS) == 1 % perhaps RHS is a constant
        b1 = b1(ones(N-1));
    end
else
    error('MATLAB:helmholtz_kron:wrongClass', ...
          'Input must be either a function handle or a numeric matrix.');
end
b1 = b1(:); % collapse to a column vector
% Evaluate the boundary conditions at the nodes and handle the case when
% the given BC is constant
[leftBC topBC rightBC bottomBC] = correctinput(x,'all', ...
                                            leftBC,topBC,rightBC,bottomBC);

% Form the internal values of the discretized boundary conditions
leftint = leftBC(2:end-1);
rightint = rightBC(2:end-1);
bottomint = bottomBC(2:end-1);
topint = topBC(2:end-1);
% Extract the first and last and columns from the derivative matrix
leftD = D(:,1); leftD = leftD(2:N);
rightD = D(:,N+1); rightD = rightD(2:N);
% Create the discrete values of the right hand side vector
b2 = repmat(leftD,1,N-1).*repmat(bottomint',N-1,1);
b2 = b2(:);
b3 = repmat(rightD,1,N-1).*repmat(topint',N-1,1);
b3 = b3(:);
b4 = repmat(leftD',N-1,1).*repmat(leftint,1,N-1);
b4 = b4(:);
b5 = repmat(rightD',N-1,1).*repmat(rightint,1,N-1);
b5 = b5(:);
b = b1-b2-b3-b4-b5;

% Solve the linear system
u = A\b;
% Reshape the solution so as to be the solution matrix
sol = zeros(N+1);
sol(2:N,2:N) = reshape(u,N-1,N-1);
% Insert the boundary conditions
sol(:,1) = leftBC;
sol(:,end) = rightBC;
sol(1,:) = bottomBC;
sol(end,:) = topBC;