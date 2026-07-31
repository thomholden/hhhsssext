% NEWTON   Computes root of function via Newton's Method with backstepping
% USAGE
%   [x,fval] = newton(f,x,varargin);
% INPUTS
%   f        : name of function of form:
%               [fval,fjac]=f(x,optional additional parameters)
%   x        : initial guess for root
%   varargin : additional arguments for f (optional)
% OUTPUTS
%   x        : root of f
%   fval     : function value estimate
%
% Setable options (use OPTSET):
%   tol       : convergence tolerance
%   maxit     : maximum number of iterations
%   maxsteps  : maximum number of backsteps
%   showiters : display results of each iteration

% Copyright (c) 1997-2000, Paul L. Fackler & Mario J. Miranda
% paul_fackler@ncsu.edu, miranda.4@osu.edu

function [x,fval] = newton(f,x,varargin)

maxit     = optget('newton','maxit',100);
tol       = optget('newton','tol',sqrt(eps));
maxsteps  = optget('newton','maxsteps',25);
showiters = optget('newton','showiters',0);

for it=1:maxit
   [fval,fjac] = feval(f,x,varargin{:});
   fnorm = norm(fval,inf);
   if fnorm<tol, return, end
   dx = -(fjac\fval);
   fnormold = inf;  
   for backstep=1:maxsteps 
      fvalnew = feval(f,x+dx,varargin{:});
      fnormnew = norm(fvalnew,inf);
      if fnormnew<fnorm, break, end
      if fnormold<fnormnew, dx=2*dx; break, end
      fnormold = fnormnew;
      dx = dx/2;          
   end
   x = x+dx;
   if showiters, fprintf('%4i %4i %6.2e\n',[it backstep fnormnew]); end
end
warning('Failure to converge in newton');
