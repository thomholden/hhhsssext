function [omega psi u v X Y] = solvestokes(N,f,gleft,gtop,gright, ...
    gbottom,hleft,htop,hright,hbottom)
%SOLVESTOKES  Solve the steady-state Stokes-problem on [-1,1]x[-1,1].
%
%   Inputs:  N       - polynomial degree in x and y direction
%            f       - external force
%            gleft   - normal boundary condition on the left edge
%            gtop    - normal boundary condition on the top edge
%            gright  - normal boundary condition on the right edge
%            gbottom - normal boundary condition on the bottom edge
%            hleft   - tangential boundary condition on the left edge
%            htop    - tangential boundary condition on the top edge
%            hright  - tangential boundary condition on the right edge
%            hbottom - tangential boundary condition on the bottom edge
%
%   Outputs: X,Y   - meshgrid from the Chebyshev-Gauss-Lobatto points
%            omega - solution of omega(x,y) at (X,Y)
%            psi   - solution of psi(x,y) at (X,Y)
%            u, v  - solution of u(x,y) and v(x,y) at (X,Y)
%
%   See also   SOLVENS_SIBE, SOLVENS_ABBD2, PL_PROBLEM, PTILDE_PROBLEM, 
%              PBAR_PROBLEM, INFLUENCEMATRIX, DETERMINE_XI, DERMATRIX, 
%              PARTIALDER, DIAGONALIZATION

%   Zoltán Csáti
%   2014/10/19


%% Preprocessing
% Time-independent solution
sigma = 0;
% Create the Chebyshev-nodes (ascending order)
x = -cos(pi*(0:N)/N);
% Create the tensor product mesh
[X Y] = meshgrid(x);
grid = {X,Y};
% Build the differentiation matrices
D = dermatrix(x,2);
D1 = D{1};
D2 = D{2};
% Interpret and evaluate boundary values
[gleft gtop gright gbottom] = correctinput(x,'all', ...
                                            gleft,gtop,gright,gbottom);
[hleft htop hright hbottom] = correctinput(x,'inner', ...
                                            hleft,htop,hright,hbottom);
% Evaluate the external force function
X_red = X(2:N,2:N);
Y_red = Y(2:N,2:N);
if isa(f,'function_handle')
    f = f(X_red,Y_red);
    if numel(f) == 1 % perhaps RHS is a constant
        f = f(ones(N-1));
    end
elseif isa(f,'numeric')
    if numel(f) == 1 % perhaps RHS is a constant
        f = f(ones(N-1));
    end
end
% Diagonalize the Helmholtz-operator
[P invP Q invQ LambdaX_i LambdaY_j] = diagonalization(N,D2(2:N,2:N),D2(2:N,2:N));
diagMatrices = {P,invP,Q,invQ,LambdaX_i,LambdaY_j};
% Solve the Pl-problem
[omega_l psi_l] = Pl_problem(N,sigma,D2,grid,diagMatrices);
% Invert the influence matrix
[invM L_red] = influencematrix(N,psi_l,grid,D1);


%% Solve at each time-cycle
% Solve the P_tilde-problem
[omega_tilde psi_tilde] = Ptilde_problem(N,f,gleft,gtop,gright,gbottom, ...
                                               sigma,D2,grid,diagMatrices);
% Solve the influence matrix equation
xi = determine_xi(N,invM,psi_tilde,hleft,htop,hright,hbottom,grid,D1);
% Use the above result to construct the P_bar-solution
[omega_bar psi_bar] = Pbar_problem(N,L_red,xi,omega_l,psi_l);
% Add the P_tilde solution and the P_bar solution which solves the P-problem
omega = omega_tilde + omega_bar;
psi = psi_tilde + psi_bar;
% Determine omega uniquely on the boundary using the definition of vorticity
omega = -(psi*D2' + D2*psi);
% Determine the velocity coordinates using the definition of stream function
[xder yder] = partialder(psi,grid,D1);
u = yder; v = -xder;