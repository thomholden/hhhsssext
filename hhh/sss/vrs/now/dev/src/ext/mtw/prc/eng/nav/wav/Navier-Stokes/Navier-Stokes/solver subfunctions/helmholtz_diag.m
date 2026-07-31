function [sol X Y] = helmholtz_diag(N,RHS,leftBC,topBC,rightBC,bottomBC, ...
                                    sigma,D,grid,diagMatrices)
%HELMHOLTZ_DIAG   Solution of the Helmholtz equation on [-1,1]x[-1,1] with 
%Dirichlet boundary conditions using Chebyshev collocation method with
%full diagonalization.
%
%   Helmholtz equation: u_xx + u_yy - sigma*u = f(x,y)
%
%   Inputs:  N            - polynomial degree in x and y direction
%            RHS          - function of the right-hand side
%            leftBC       - boundary condition on the left edge
%            topBC        - boundary condition on the top edge
%            rightBC      - boundary condition on the right edge
%            bottomBC     - boundary condition on the bottom edge
%            sigma        - constant
%            D            - second order Chebyshev differentiation matrix
%            grid         - meshgrid from the CGL points
%            diagMatrices - must contain the eigenvectors, their inverses
%                           and the eigenvalues as a cell array
%
%   Outputs: sol - solution at (X,Y)
%            X, Y  - meshgrid from the Chebyshev-Gauss-Lobatto (CGL) points
%
%   The boundary conditions should be given so that the values at the corners
%   are the same for the neighbouring boundaries to maintain continuity.
%
%   Used for time-dependent solvers. Examples are provided in the standalone
%   version.
%
%   See also   HELMHOLTZ_DIAG_STANDALONE

%   The algorithm is based on 
%      Roger Peyret.: Spectral Methods for Incompressible Viscous Flow, 
%      Springer, 2002
%
%   Zoltán Csáti
%   2014/09/08


%% Construct the coefficient matrix
% Import the computational grid
X = grid{1};
Y = grid{2};

%% Construct the right hand side
% Evaluate the known function on the right at the nodes
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
    error('MATLAB:helmholtz_diag:wrongClass', ...
          'Input must be either a function handle or a numeric matrix.');
end
% Form the internal values of the discretized boundary conditions
leftint = leftBC(2:end-1);
rightint = rightBC(2:end-1);
bottomint = bottomBC(2:end-1);
topint = topBC(2:end-1);
% Extract the first and last rows and columns from the derivative matrix
leftD = D(:,1); leftD = leftD(2:N);
rightD = D(:,N+1); rightD = rightD(2:N);
% Create the discrete values of the right hand side matrix
b2 = repmat(leftD,1,N-1).*repmat(bottomint',N-1,1);
b3 = repmat(rightD,1,N-1).*repmat(topint',N-1,1);
b4 = repmat(leftD',N-1,1).*repmat(leftint,1,N-1);
b5 = repmat(rightD',N-1,1).*repmat(rightint,1,N-1);
H = b1-b2-b3-b4-b5;

%% Perform full diagonalization
% Import the required eigenvectors, their inverses and the eigenvalues
P = diagMatrices{1};
invP = diagMatrices{2};
Q = diagMatrices{3};
invQ = diagMatrices{4};
LambdaX_i = diagMatrices{5};
LambdaY_j = diagMatrices{6};
% Calculate the inner values 
H_hat = invP*H*invQ.';
U_hat = H_hat./(LambdaX_i+LambdaY_j-sigma);
U = P*U_hat*Q.';

%% Insert the boundary conditions
sol = zeros(N+1);
sol(2:N,2:N) = U;
sol(:,1) = leftBC;
sol(:,end) = rightBC;
sol(1,:) = bottomBC;
sol(end,:) = topBC;