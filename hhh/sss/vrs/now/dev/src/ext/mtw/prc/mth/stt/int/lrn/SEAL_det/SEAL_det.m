function [zHat,wHat,nv,nf] = SEAL_det(mPhy,y,G,u,D,H,L);
%
% [zHat,wHat,nv,nf] = SEAL_det(mPhy,y,G,u,D,H,L)
%
% Given inputs -
% 
% mPhy : the physical/spatial problem dimension, i.e., the number of transmit
%        antennas, the effective problem dimension is then m = 2*mPhy*L,
% y    : a real target signal (column) vector,
% G    : a real lattice generator matrix,                 \  LAST
% u    : a real lattice translation vector,                > code
% D    : a real spherical shaping region squared radius,  /  
% H    : a real linear transform matrix, e.g., a block diagonal matrix of L
%        converted/stacked real MIMO channel matrices, and
% L    : the temporal problem dimension, i.e., the number of transmit periods
%        spanned by a codeword,
% 
% SEAL_det returns -
% 
% zHat : a possibly suboptimal solution to   argmin    |y - H*G*z|^2,
%                                          z \in Z_*^m 
%        where Z_*^m is the set of integer vectors such that G*z is a valid
%        spherical LAST codeword,
% wHat : the squared distance |y - H*G*zHat|^2, i.e., the solution node weight,
% nv   : the number of nodes expanded by the detector,
% nf   : the (approximate) number of floating points operations performed
%        (excluding pre-processing, e.g., QR factorization, and sorting),
%   
% This real-valued depth-first stack-based sequential decoding algorithm uses a
% decoding tree of m+1 levels where each node has an arbitrary and unknown
% number of children.  At each stage, the node under consideration is expanded
% if its weight is less than the squared distance to nearest currently known
% lattice point.  This distance threshold is initially set to infinity.
%
% Because it is a depth-first traversal, we expand a node by computing its
% first child.  If it is a leaf node, clearly it cannot be further expanded.
% In this case, we will have found a closer lattice point than that previously
% known. Therefore we can adaptively reduce the distance threshold to reflect
% this new discovery.
%
% If the weight of the node under consideration is larger than this distance
% threshold, then the current search path is terminated because it cannot
% possibly lead to a closest lattice point. Upon path termination, the next
% node to be considered is the next sibling of its parent.
%
% Note that it is possible for a node to have no children, and also for the
% next sibling to be invalidated by means of boundary control.
% 
% Complex to real conversion by stacking should be done prior to calling
% SEAL_det. In addition, if either lattice reduction assistance or MMSE
% pre-processing are desired, these operations should also be applied in
% advance.
%
% Notes:
%
% - Size(H,1) is expected to be equal to length(y).
% - Size(H,1) is expected to be greater than or equal to size(H,2).
% - Size(H,2) is expected to be equal to m.
% - The solution zHat is an integer vector; be sure to apply any necessary
%   scaling prior to calling SEAL_det so that this solution is appropriate.
%
% Example:
%
%   mPhy  = 2;                   % 2x2 MIMO system
%   L     = 2;                   % code spans 2 time periods
%   m     = 2*mPhy*L;            % code matrix size is governed by the 
%                                % number of real space-time dimensions
%   y     = randn(m,1);          % generate random target vector
%   HPhyC = randn(mPhy,mPhy)+i*randn(mPhy,mPhy);
%   HPhyR = [real(HPhyC) -imag(HPhyC); imag(HPhyC) real(HPhyC)];
%   H     = kron(eye(L),HPhyR);  % construct space-time x space-time channel
%
%   load optimizedLASTcode;      % get LAST code specification: G,u,D
%   [zHat,wHat,nv,nf] = SEAL_det(mPhy,y,G,u,D,H,L)
%
% Version 1.0, copyright 2006 by Karen Su.
%
% Please send comments and bug reports to karen.su@utoronto.ca.
%

global w;
global z;
global cn;
global zp;
global d;
global lb;
global ub;
global nf;

zHat = [];
wHat = Inf;
nv   = 0;
nf   = 0;

%
% A small number
%
EPS = 0.001;

%   
% Basic error checking
%   
[n,mChk] = size(H);
m        = 2*mPhy*L;                      % size of the channel matrix is 2*mPhy*L x 2*nPhy*L
if n ~= length(y) | mChk ~= m
  fprintf('Error: Decoding failed, invalid dimensions for H.\n');
  return;
end
if n < m
  fprintf('Error: Cannot solve under-determined problem, n (%i) < m (%i).\n', n, m);
  return;
end

%
% Composite (effective) linear transform matrix for LAST decoding is
% formed by taking the product of the MIMO channel matrix and the LAST
% code generator matrix
%
F = H*G;

%
% Reduce problem to square if H is overdetermined; also factorize code
% generator
%
[Fq,Fr] = qr(F);
[Gq,Gr] = qr(G);
wRoot   = 0;
yR      = Fq'*(y-H*u);
if m < n
  wRoot = norm(yR(m+1:n))^2;
  yR = yR(1:m);
end

%
% A basic node data structure consists of
%   w   : node weight
%   pyR : parent's residual target vector, elements 1:dim  == py(1:dim,dim)
%   zA  : accumulated symbol decision vector, length m-dim == z(dim+1:dim)
%   dim : node/residual dimension, root (m+1) to leaf (1)
%   cn  : sibling ordinal
%   pw  : parent node weight                               == w(dim+1)
%   ut  : (scalar) target for siblings at this level       == py(dim+1,dim)
%   zp  : symbol decision of previous sibling             
%
% In addition the following components are needed to perform boundary control
% for spherical LAST decoding
%   paR : parent's shaping region residual offset vector, elements 1:dim == pa(1:dim,dim)
%   pd  : parent's shaping region residual squared radius                == d(dim+1)
%   lb  : lower bound of admissible range for siblings at this level     == lb(dim)
%   ub  : upper bound of admissible range for siblings at this level     == ub(dim)
%   uo  : (scalar) offset for siblings at this level                     == pa(dim+1,dim)
%
% The algorithm requires only a fixed-size block of memory; we initialize it
% with the root node.  
%
w   = zeros(1,m+1);
py  = zeros(m,m);
z   = zeros(1,m);
dim = m;
cn  = zeros(1,m);
zp  = zeros(1,m);

pa  = zeros(m,m);
d   = zeros(1,m+1);
lb  = zeros(1,m);
ub  = zeros(1,m);

dimp    = dim+1;
w(dimp) = wRoot;
d(dimp) = D+EPS;

%
% Compute first child of root node 
%
aR            = -Gq'*u;
pa(1:dim,dim) = aR;                              % Store parent (root) residual offset vector;
tmp1          = pa(dim,dim)/Gr(dim,dim);         % compute and store lower and upper bounds
tmp2          = sqrt(d(dimp))/abs(Gr(dim,dim));  % for the range of admissible symbol decisions
lb(dim)       = ceil(tmp1-tmp2);                 % for siblings at this level.
ub(dim)       = floor(tmp1+tmp2);
nf            = nf + 9;

py(1:dim,dim) = yR;                              % Store parent (root) residual target.
compFirstChild(dim,dimp,lb(dim),ub(dim),Fr(dim,dim),Gr(dim,dim),py(dim,dim),pa(dim,dim));

backtrack = 0;
while dim <= m
  if w(dim) < wHat                     % If the node under consideration has a smaller weight
    if dim == 1                        % and it is a leaf node, then update zHat, wHat 
      wHat = w(dim);
      zHat = z;

      backtrack = 1;                   % To backtrack, we have to compute the next sibling
      dim  = dimp;                     % of the current node's parent
      dimp = dimp+1;
      if cn(dim) <= ub(dim)-lb(dim)    % Check that there is at least one more sibling                 
        backtrack = 0;
        compNextSibling(dim,dimp,lb(dim),ub(dim),Fr(dim,dim),Gr(dim,dim),py(dim,dim),pa(dim,dim));
      end
      nf = nf + 1;

    %
    % If the node under consideration has a sufficiently small weight and is
    % not a leaf node:
    % - then either we are backtracking (backtrack == 1, and so compute the
    %   next sibling of its parent)
    %
    elseif backtrack & cn(dim) > ub(dim)-lb(dim) % No more siblings
      %backtrack = 1;
      dim = dimp;
      if dim <= m                      % Check that we have not backtracked to root
        dimp = dimp+1; 
        if cn(dim) <= ub(dim)-lb(dim)  % Check that there is at least one more sibling
          backtrack = 0;
          compNextSibling(dim,dimp,lb(dim),ub(dim),Fr(dim,dim),Gr(dim,dim),py(dim,dim),pa(dim,dim));
        end
        nf = nf + 1;
      end
  
    %
    % - or we are trying an alternate path (backtrack == 0, and so compute
    %   the first child)
    %
    else
      nv = nv + 1;

      dimp = dim;
      dim  = dim-1;

      pa(1:dim,dim) = pa(1:dim,dimp)-Gr(1:dim,dimp)*z(dimp);    % Compute current node shaping region 
      tmp1          = pa(dim,dim)/Gr(dim,dim);                  % residual offset vector, and the 
      tmp2          = sqrt(d(dimp))/abs(Gr(dim,dim));           % lower and upper bounds of the range  
      lb(dim)       = ceil(tmp1-tmp2);                          % of admissible symbol decisions for 
      ub(dim)       = floor(tmp1+tmp2);                         % its children.
      nf            = nf + 2*dim + 9;

      %
      % If there is at least one child, compute first child node
      %
      if ub(dim) >= lb(dim) 
        backtrack     = 0;
        py(1:dim,dim) = py(1:dim,dimp)-Fr(1:dim,dimp)*z(dimp);  % Compute current node residual target.
        nf            = nf + 2*dim;
        compFirstChild(dim,dimp,lb(dim),ub(dim),Fr(dim,dim),Gr(dim,dim),py(dim,dim),pa(dim,dim));

      %
      % Otherwise, if there are no children, (implicitly) backtrack to its own
      % next sibling 
      %
      else
        dim  = dimp;
        dimp = dimp+1;
        if cn(dim) <= ub(dim)-lb(dim)  % Check that there is at least one more sibling
          backtrack = 0;
          compNextSibling(dim,dimp,lb(dim),ub(dim),Fr(dim,dim),Gr(dim,dim),py(dim,dim),pa(dim,dim));
        else
          backtrack = 1;               % Setting backtrack == 1 tells the decoder to backtrack 
                                       % in the next iteration
        end
        nf = nf + 1;
      end
    end

  else                                 % If the node under consideration has too large a weight
    dim       = dimp;                  % then we backtrack (if possible).  To do so, we have to
    backtrack = 1;                     % compute the next sibling of the current node's parent.

    if dim <= m                        % Check that we have not backtracked to root
      dimp = dimp+1;
      if cn(dim) <= ub(dim)-lb(dim)    % Check that there is at least one more sibling
        backtrack = 0;
        compNextSibling(dim,dimp,lb(dim),ub(dim),Fr(dim,dim),Gr(dim,dim),py(dim,dim),pa(dim,dim));
      end
      nf = nf + 1;
    end
  end
  nf = nf + 1;
end

zHat = zHat.';

function compFirstChild(dim,dimp,lbd,ubd,Frdd,Grdd,pydd,padd)
global w;
global z;
global cn;
global zp;
global d;
global nf;

z0 = pydd/Frdd;                              % The first child is found by
z1 = round(z0);                              % quantization and symbol-dependent
z1 = min([z1 ubd]);                          % boundary control.
z1 = max([z1 lbd]);

z(dim)  = z1;                                % Store first child decision
zp(dim) = z0;                                % and pre-quantization data;
w(dim)  = w(dimp)+(pydd-Frdd*z(dim))^2;      % compute its weight/cost and
d(dim)  = d(dimp)-(padd-Grdd*z(dim))^2;      % residual shaping region squared radius;
cn(dim) = 1;                                 % First child ordinal has 1.
nf      = nf + 10;

function compNextSibling(dim,dimp,lbd,ubd,Frdd,Grdd,pydd,padd);
global w;
global z;
global cn;
global zp;
global d;
global nf;

zn   = z(dim)-cn(dim)*sign(z(dim)-zp(dim));  % The next sibling symbol decision can be
if zn > ubd                                  % derived from the current and previous ones,
  zn = ubd-cn(dim);                          % followed by boundary control. This procedure
elseif zn < lbd                              % is dependent on the child ordinal and also the
  zn = lbd+cn(dim);                          % symbol-dependent lower and upper bounds.
end
zp(dim) = z(dim);                            % Save previous sibling's symbol decision and
z(dim)  = zn;                                % store next sibling decision.
cn(dim) = cn(dim)+1;                         % Siblings have one larger child ordinal.

w(dim) = w(dimp)+(pydd-Frdd*zn)^2;           % Compute sibling node weight and
d(dim) = d(dimp)-(padd-Grdd*zn)^2;           % residual shaping region squared radius.
nf     = nf + 14;
