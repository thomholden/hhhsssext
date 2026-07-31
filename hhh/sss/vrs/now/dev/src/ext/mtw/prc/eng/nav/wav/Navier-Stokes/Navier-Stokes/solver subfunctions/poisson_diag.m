function [sol X Y H] = poisson_diag(N,RHS,leftBC,topBC,rightBC,bottomBC,sigma)
%POISSON_DIAG   Solution of the Helmholtz equation on [-1,1]x[-1,1] with 
%Dirichlet boundary conditions using Chebyshev collocation method with
%full diagonalization.
%
%   Helmholtz equation: u_xx + u_yy - sigma*u = f(x,y)
%
%   Inputs:  N        - polynomial degree in x and y direction
%            RHS      - function of the right-hand side
%            leftBC   - boundary condition on the left edge
%            bottomBC - boundary condition on the bottom edge
%            rightBC  - boundary condition on the right edge
%            topBC    - boundary condition on the top edge
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
%               [u X Y]  = poisson_diag(30,fcn,leftBC,topBC,rightBC,bottomBC,0);
%               mesh(X,Y,u);
%            Compare it with the exact solution u(x,y) = cos(2*pi*x)*sin(2*pi*y)
%               u_exact = cos(2*pi*X).*sin(2*pi*Y);
%               maxDifference = norm(u-u_exact,Inf);  % 9.2953e-14
%
%   See also   HELMHOLTZ_KRON, DERMATRIX

%   The algorithm is based on 
%      Roger Peyret.: Spectral Methods for Incompressible Viscous Flow, 
%      Springer, 2002
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
    error('MATLAB:poisson_diag:wrongClass', ...
          'Input must be either a function handle or a numeric matrix.');
end
% Evaluate the boundary conditions at the nodes and handle the case when
% the given BC is constant
if isa(leftBC,'function_handle')
    leftBC = leftBC(x);
    if numel(leftBC) == 1
        leftBC = leftBC*ones(N+1,1);
    end
end

if isa(bottomBC,'function_handle')
    bottomBC = bottomBC(x);
    if numel(bottomBC) == 1
        bottomBC = bottomBC*ones(N+1,1);
    end
end

if isa(rightBC,'function_handle')
    rightBC = rightBC(x);
    if numel(rightBC) == 1
        rightBC = rightBC*ones(N+1,1);
    end
end

if isa(topBC,'function_handle')
    topBC = topBC(x);
    if numel(topBC) == 1
        topBC = topBC*ones(N+1,1);
    end
end

% Form the internal values of the discretized boundary conditions
leftint = leftBC(2:end-1);
rightint = rightBC(2:end-1);
bottomint = bottomBC(2:end-1);
topint = topBC(2:end-1);
% Extract the first and last and columns from the derivative matrix
leftD = D(:,1); leftD = leftD(2:N);
rightD = D(:,N+1); rightD = rightD(2:N);
% Create the discrete values of the right hand side matrix
b2 = repmat(leftD,1,N-1).*repmat(bottomint',N-1,1);
b3 = repmat(rightD,1,N-1).*repmat(topint',N-1,1);
b4 = repmat(leftD',N-1,1).*repmat(leftint,1,N-1);
b5 = repmat(rightD',N-1,1).*repmat(rightint,1,N-1);
H = b1-b2-b3-b4-b5;


% Perform full diagonalization
[P Lambda] = eig(D_red);
invP = inv(P);
H_hat = invP*H*invP.';
U_hat = zeros(N-1);
% Calculate the inner values 
for i = 1:N-1
    for j = 1:N-1
        U_hat(i,j) = H_hat(i,j)/(Lambda(i,i)+Lambda(j,j)-sigma);
    end
end
U = P*U_hat*P.';
% TODO: Change the nested for-loops to a vectorized code.

% Insert the boundary conditions
sol = zeros(N+1);
sol(2:N,2:N) = U;
sol(:,1) = leftBC;
sol(:,end) = rightBC;
sol(1,:) = bottomBC;
sol(end,:) = topBC;