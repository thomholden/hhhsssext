function [omega psi u v stat X Y] = solveNS_ABBD2(N,f,gleft,gtop,gright, ...
    gbottom,hleft,htop,hright,hbottom,u0,v0,Dt,nu,maxIter,reltol)
%SOLVENS_ABBD2  Solve the unsteady Navier-Stokes-problem on [-1,1]x[-1,1] 
%with semi-implicit second order Adams-Bashforth/Backward Differentiation
%temporal discretization and Chebyshev spectral collocation in space.
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
%            u0, v0  - initial condition for the field of velocity components
%            Dt      - time-step
%            nu      - kinematic viscosity
%            maxIter - maximum number of time iterations
%            reltol  - relative difference between the n-th and the n-1-th
%                      u function values in L2 norm
%
%   Outputs: X,Y   - meshgrid from the Chebyshev-Gauss-Lobatto points
%            omega - solution of omega(x,y) at (X,Y) at t=k*Dt
%            psi   - solution of psi(x,y) at (X,Y) at t=k*Dt
%            u, v  - solution of u(x,y) and v(x,y) at (X,Y) at t=k*Dt,
%                    k = 1,...,min(maxIter,stop) and stop is an appropriate
%                    termination criterium
%            stat   - statistics about the cause of termination, the number
%                     of iterations and the relative error
%
%   See also   SOLVENS_SIBE, SOLVESTOKES, PL_PROBLEM, PTILDE_PROBLEM, 
%              PBAR_PROBLEM, INFLUENCEMATRIX, DETERMINE_XI, DERMATRIX, 
%              PARTIALDER, DIAGONALIZATION

%   Zoltán Csáti
%   2014/10/19


%% Preprocessing
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
% Diagonalize the Helmholtz-operator
[P invP Q invQ LambdaX_i LambdaY_j] = diagonalization(N,D2(2:N,2:N),D2(2:N,2:N));
diagMatrices = {P,invP,Q,invQ,LambdaX_i,LambdaY_j};
% Solve the Pl-problem
sigma = 3/(2*nu*Dt);
[omega_l psi_l] = Pl_problem(N,sigma,D2,grid,diagMatrices);
% Invert the influence matrix
[invM L_red] = influencematrix(N,psi_l,grid,D1);


%% Solve at each time-cycle
% Import results from the first time-step using SIBE
[omega psi u v stat X Y f omega0 B0] = solveNS_SIBE(N,f,gleft,gtop,gright,...
    gbottom,hleft,htop,hright,hbottom,u0,v0,Dt,nu,1,1e-9);
% Preallocate arrays
omega{maxIter} = [];
psi{maxIter} = [];
u{maxIter} = [];
v{maxIter} = [];
omega_bar = omega;
psi_bar = omega;
omega_tilde = omega;
psi_tilde = omega;
B = cell(2,1); % convective term
B{2} = B0;
% Temporal discretization
for k = 2:maxIter
    B{1} = B{2};
    B{2} = convective(u{k-1},v{k-1},omega{k-1},grid,D1);
    B{2} = B{2}(2:N,2:N);
    if k == 2
        F = ABBD2(Dt,f,B,omega{k-1}(2:N,2:N),omega0(2:N,2:N),nu);
    else
        F = ABBD2(Dt,f,B,omega{k-1}(2:N,2:N),omega{k-2}(2:N,2:N),nu);
    end
    % Solve the P_tilde-problem
    [omega_tilde{k} psi_tilde{k}] = Ptilde_problem(N,F,gleft,gtop,gright, ...
                                     gbottom,sigma,D2,grid,diagMatrices);
    % Solve the influence matrix equation
    xi = determine_xi(N,invM,psi_tilde{k},hleft,htop,hright,hbottom,grid,D1);
    % Use the above result to construct the P_bar-solution
    [omega_bar{k} psi_bar{k}] = Pbar_problem(N,L_red,xi,omega_l,psi_l);
    % Add the P_tilde solution and the P_bar solution which solves the P-problem
    omega{k} = omega_tilde{k} + omega_bar{k};
    psi{k} = psi_tilde{k} + psi_bar{k};
    % Determine omega uniquely on the boundary using the definition of vorticity
    omega{k} = -(psi{k}*D2' + D2*psi{k});
    % Determine the velocity coordinates using the definition of stream function
    [xder yder] = partialder(psi{k},grid,D1);
    u{k} = yder; v{k} = -xder;
    if k > 2
        if isnan(norm(u{k}-u{k-1},Inf))
            difference = NaN;
            % Return statistics
            stat.terminationCause = 'Did not converge.';
            stat.iter = k;
            stat.error = difference;
            break
        else
            % Maximum difference in the horizontal velocity between the 
            % k-1-th and k-th timestep
            difference = norm(u{k}-u{k-1},2)/norm(u{k},2);
            if difference < reltol
                % Return statistics
                stat.terminationCause = 'Desired error tolerance reached.';
                stat.iter = k;
                stat.error = difference;
                break
            end
        end
    end
end

% Delete empty cells (a very fast method based on http://www.mathworks.com/
% matlabcentral/answers/27042-how-to-remove-empty-cell-array-contents
notEmpty = ~cellfun('isempty',omega);
omega = omega(notEmpty);
psi = psi(notEmpty);
u = u(notEmpty);
v = v(notEmpty);
if k == maxIter
    stat.terminationCause = 'Maximum iteration number reached.';
    stat.iter = k;
    stat.error = difference;
end