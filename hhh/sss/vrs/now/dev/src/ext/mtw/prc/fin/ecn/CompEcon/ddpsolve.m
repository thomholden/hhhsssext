% DDPSOLVE  Solves discrete-state/action dynamic program
% USAGE
%   [v,x,pstar] = ddpsolve(model,v);
% INPUTS
%   model   : model structure variable (see below)
%   v       : initial guess for value function (optional)
% OUTPUTS
%   v       : value function (nx1 or nxT+1)
%   x       : optimal controls (nx1 or nxT)
%   pstar   : optimal transition probability matrix (nxn or nxnxT+1)
%
% The possible fields of the model structure variable are:
%   discount  : a scalar on (0,1]
%   reward    : nxm matrix of reward values
%   transfunc : for deterministic problems 
%                  an nxm matrix of values on {1,...,m}
%   transprob : for stochastic problems
%                  mxnxn a set of m nxn probability matrices
%   horizon   : number of time periods 
%                  (omit or set to inf for infinite horizon problems)
%   vterm     : terminal (time T+1) value function
% discount and reward must be specified. Either transfunc or transprob must
% be specified. If T is omitted, an infinite horizon problem is assumed. 
% If vterm is omitted, the terminal value if assumed to be 0.
% NOTE: model.T can be used instead of model.horizon
%   
% USER OPTIONS (SET WITH OPSET)
%   tol       : convergence tolerance
%   maxit     : maximum number of iterations
%   prtiters  : 0/1 print each iteration
%   algorithm : 'newton' or 'funcit' 
%               for infinite horizon problems (default: 'newton')

% Copyright (c) 1997-2002, Paul L. Fackler & Mario J. Miranda
% paul_fackler@ncsu.edu, miranda.4@osu.edu

function [v,x,pstar] = ddpsolve(model,v)
% SET CONVERGENCE PARAMETER DEFAULTS
  maxit     = optget('ddpsolve','maxit',100);
  tol       = optget('ddpsolve','tol',sqrt(eps));
  prtiters  = optget('ddpsolve','prtiters',1);
    
% EXTRACT MODEL STRUCTURE
  delta = model.discount;
  f     = model.reward;
  [n,m]=size(f);
  if isfield(model,'horizon')
    T = model.horizon;
  elseif isfield(model,'T')
    T = model.T;
  else
    T = inf;
  end
  if isfield(model,'transfunc')
    P = expandg(model.transfunc);
  else
    P = model.transprob;
    if ndims(P)==3
      P = permute(P,[2 1 3]);
      P = reshape(P,m*n,n);
    end
  end
  
  if T <inf, algorithm = 'back';
  else,      algorithm = optget('ddpsolve','algorithm','newton');
  end

  if T<inf
    if isfield(model,'vterm') 
      v = model.vterm;
      if size(v,1)~=n
        error('model.vterm has improper size')
      end
    else v=zeros(n,1);
    end
  else
    if nargin<3, v=zeros(n,1); end
  end

% PERFORM NEWTON OR FUNCTION ITERATIONS OR BACKWARD RECURSION
  switch algorithm
  case 'newton'
    if prtiters, disp('Solve Bellman equation via Newton method'); end
    for it=1:maxit
      vold = v;                             % store old value
      [v,x] = valmax(v,f,P,delta);          % update policy  
      [pstar,fstar] = valpol(x,f,P);        % induced P and f 
      v = (speye(n)-delta*pstar)\fstar;     % update value
      change = norm(v-vold);                % compute change
      if prtiters
        fprintf ('%5i %10.1e\n',it,change)  % print progress
      end
      if change<tol, break, end;            % convergence check
    end
    if change>tol, warning('Failure to converge in ddpsolve'), end;
  case 'funcit'
    if prtiters, disp('Solve Bellman equation via function iteration'); end
    for it=1:maxit
      vold = v;                             % store old value
      [v,x] = valmax(v,f,P,delta);          % update policy
      change = norm(v-vold);                % compute change
      if prtiters 
         fprintf ('%5i %10.1e\n',it,change) % print progress
      end
      if change<tol, break, end;            % convergence check
    end
    if nargin>=3, pstar = valpol(x,f,P); end
    if change>tol, warning('Failure to converge in ddpsolve'), end;
  case 'back'
    if prtiters, disp('Solve Bellman equation via backward recursion'); end
    x = zeros(n,T);
    v = [zeros(n,T) v];
    if nargin>=3
      pstar = zeros(n,n,T);
      for t=T:-1:1                                   % backward recursion
        [v(:,t),x(:,t)] = valmax(v(:,t+1),f,P,delta);  % Bellman equation
        pstar(:,:,t) = valpol(x(:,t),f,P);
      end
    else
      for t=T:-1:1                                   % backward recursion
        [v(:,t),x(:,t)] = valmax(v(:,t+1),f,P,delta);  % Bellman equation
      end
    end
  otherwise
    error('algorithm must be newton or funcit')
  end


function [v,x] = valmax(v,f,P,delta)
[v,x]=max(f+delta*reshape(P*v,size(f)),[],2);


function [pstar,fstar] = valpol(x,f,P)
[n,m]=size(f);
i=n*(x-1)+(1:n)';
fstar = f(i);
pstar = P(i,:);

function P = expandg(g);
[n,m] = size(g);
P = sparse(1:n*m,g(:),1,n*m,n);