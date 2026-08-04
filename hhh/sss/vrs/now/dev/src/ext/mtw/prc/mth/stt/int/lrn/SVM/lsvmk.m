function [iter, optCond, time, u] = ...
    lsvmk(KM,D,nu,tol,maxIter,alpha);
  
% LSVMK Langrangian Support Vector Machine algorithm
%   LSVMK solves a support vector machine problem using an iterative
%   algorithm inspired by an augmented Lagrangian formulation.
%
%   iters = lsvmk(KM,D)
%
%   where KM is the kernel matrix, D is a diagonal matrix of 1s and -1s
%   indicating which class the points are in, and 'iters' is the number of
%   iterations the algorithm used.
%
%   All the following additional arguments are optional:
%
%   [iters, optCond, time, u] = ...
%     lsvmk(KM,D,nu,tol,maxIter,alpha)
%
%   optCond is the value of the optimality condition at termination.
%   time is the amount of time the algorithm took to terminate.
%   u is the vector of dual variables.
%
%   On the right hand side, KM and D are required. If the rest are not
%   specified, the following defaults will be used:
%     nu = 1/size(KM,1), tol = 1e-5, maxIter = 100, alpha = 1.9/nu
%
%   The value -1 can be used for any of the entries (except A and D) to
%   specify that default values should be used.
%
%   Copyright (C) 2000 Olvi L. Mangasarian and David R. Musicant.
%   Version 1.0 Beta 1
%   This software is free for academic and research use only.
%   For commercial use, contact musicant@cs.wisc.edu.

  % If D is a vector, convert it to a diagonal matrix.
  [k,n] = size(D);
  if k==1 | n==1
    D=diag(D);
  end;

  % Check all components of D and verify that they are +-1
  checkall = diag(D)==1 | diag(D)==-1;
  if any(checkall==0)
    error('Error in D: classes must be all 1 or -1.');
  end;

  m = size(KM,1);

  if ~exist('nu') | nu==-1
    nu = 1/m;
  end;
  if ~exist('tol') | tol==-1
    tol = 1e-5;
  end;
  if ~exist('maxIter') | maxIter==-1
    maxIter = 100;
  end;
  if ~exist('alpha') | alpha==-1
    alpha = 1.9/nu;
  end;
  
  % Do a sanity check on alpha
  if alpha > 2/nu,
    disp(sprintf('Alpha is larger than 2/nu. Algorithm may not converge.'));
  end;

  % Create matrix H
  [m,n] = size(KM);
  e = ones(m,1);
  I = speye(m);
  iter = 0;
  time = cputime;

  % Generate Q matrix and inverse
  Q = I/nu + D*KM*D;
  P = inv(Q);
  
  % Choose initial value for x
  u = P*e;

  % uold is the old value for u, used to check for termination
  oldu = u + 1;
  while iter < maxIter & norm(oldu-u)>tol
    oldu = u;
    u = P*(1+pl(Q*u-1-alpha*u));
    iter = iter + 1;
  end;

  % Determine outputs
  time = cputime - time;
  optCond = norm(u-oldu);
  disp(sprintf('Running time (CPU secs) = %g',time));
  disp(sprintf('Number of iterations = %d',iter));
  disp(sprintf('Training accuracy = %g',sum(D*KM*D*u>0)/m));
  
  return;
  
function pl = pl(x);
  %PLUS function : max{x,0}
  pl = (x+abs(x))/2;
  return;
  
