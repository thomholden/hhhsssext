function [node weight] = LegGaussLobNodeWeight(N,tol,maxiter)
%LEGGAUSSLOBNODEWEIGHT   Legendre-Gauss-Lobatto nodes and weights.
%   [NODE WEIGHT] = LEGGAUSSLOBNODEWEIGHT(N) calculates the N-th degree 
%   L-G-L nodes and weights with error tolerance TOL=1e-15 using MAXITER=10
%   number of iterations.
%   [NODE WEIGHT] = LEGGAUSSLOBNODEWEIGHT(N,TOL) calculates the N-th degree
%   L-G-L nodes and weights with error tolerance TOL using MAXITER=10 
%   number of iterations.
%   [NODE WEIGHT] = LEGGAUSSLOBNODEWEIGHT(N,TOL,MAXITER) calculates the 
%   N-th degree L-G-L nodes and weights with error tolerance TOL using 
%   MAXITER number of iterations.
%
%   See also   LEGPOLY, DERMATRIX

%   The algorithm is based on 
%      Kopriva D. A.: Implementing Spectral Methods for Partial Differential
%      Equations, Springer, 2009
%   Note: a simpler but (for larger N) less stable method uses eigenvalues
%   instead of the Newton-iteration.
%
%   Zoltán Csáti
%   2014/05/30

% Default termination criteria
if nargin < 2
    tol = 1e-15;
    maxiter = 10;
elseif nargin < 3
    maxiter = 10;
end

if N==1
    node = [-1 1];
    weight = [1 1];
else
    % node(0)=-1 and node(N)=1 and the roots are symmetric to the origin
    k = (1:(N+1)/2-1)';
    % Use an initial approximation for the roots
    node = - cos((k+0.25)*pi/N - 3/(8*N*pi)*1./(k+0.25));
    % Perform Newton iteration
    newtonIter = 1;
    Delta = 1;
    while newtonIter <= maxiter && norm(Delta,Inf) > tol*norm(node,Inf)
        L = legpoly(N,node);
        q = (2*N+1)/(N+1)*node.*L(:,end) - (2*N+1)/(N+1)*L(:,end-1);
        qp = (2*N+1)*L(:,end);
        Delta = -q./qp;
        node = node + Delta;
        newtonIter = newtonIter + 1;
    end
    isConverged = newtonIter-1<=maxiter && norm(Delta,Inf) <= tol*norm(node,Inf);
    if ~isConverged
        error(['MATLAB:LegGaussLobNodeWeight:Newton iteration did not ',...
        'converge with the given tolerance or iteration.']);
    end
    % Compute all the N+1 nodes and weights
    L = legpoly(N,node);
    weight = 2./(N*(N+1)*L(:,end).^2);
    node_all = zeros(N+1,1);
    node_all(1) = -1;
    node_all(N+1) = 1;
    node_all(k+1) = node;
    node_all(N+1-k) = -node;
    node = node_all;
    weight_all = zeros(N+1,1);
    weight_all(1) = 2/(N*(N+1));
    weight_all(N+1) = 2/(N*(N+1));
    weight_all(k+1) = weight;
    weight_all(N+1-k) = weight;
    weight = weight_all;
    if mod(N,2) == 0
        L = legpoly(N,0);
        weight(N/2+1) = 2./(N*(N+1)*L(:,end).^2);
        % If N is even, node_N/2 must be zero. However it is automatically
        % fulfilled as we preallocated node_all to be zeros.
    end
end