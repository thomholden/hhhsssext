function xi = determine_xi(N,invM,psi_tilde,hleft,htop,hright,hbottom,grid,D1)
%DETEMINE_XI   Determines the vector of xi needed for the P_bar-problem.
%
%   Inputs:  N         - polynomial degree in x and y direction
%            invM      - inverse of the influence matrix
%            psi_tilde - stream function solution of the P_tilde-problem
%            hleft     - tangential boundary condition on the left edge
%            htop      - tangential boundary condition on the top edge
%            hright    - tangential boundary condition on the right edge
%            hbottom   - tangential boundary condition on the bottom edge
%            grid      - meshgrid from the CGL points
%            D1        - first differentiation matrix
%
%   Output:  xi - coefficients obtained from the influence matrix equation
%
%   See also   PBAR_PROBLEM, PTILDE_PROBLEM, INFLUENCEMATRIX, PARTIALDER

%   Zoltán Csáti
%   2014/07/05

%% Construct the right hand side
% x = x(:);
% 
% if isa(hleft,'function_handle')
%     hleft = hleft(x);
% end
% if numel(hleft) == 1
%     hleft = hleft*ones(N+1,1);
% end
% 
% if isa(htop,'function_handle')
%     htop = htop(x);
% end
% if numel(htop) == 1
%     htop = htop*ones(N+1,1);
% end
% 
% if isa(hright,'function_handle')
%     hright = hright(x);
% end
% if numel(hright) == 1
%     hright = hright*ones(N+1,1);
% end
% 
% if isa(hbottom,'function_handle')
%     hbottom = hbottom(x);
% end
% if numel(hbottom) == 1
%     hbottom = hbottom*ones(N+1,1);
% end

[derx dery] = partialder(psi_tilde,grid,D1);
gderleft= -derx(2:N,1);
gdertop = dery(end,3:N-1)';
gderright = derx(2:N,end);
gderbottom = -dery(1,3:N-1)';

% Form the internal values of the discretized boundary conditions
% hleft = hleft(2:N);
% htop = htop(2:N);
% hright = hright(2:N);
% hbottom = hbottom(2:N);
% Discard the four nodes
htop(1) = []; htop(end) = [];
hbottom(1) = []; hbottom(end) = [];
% Change the numbering on the right and on the bottom side
hright = hright(end:-1:1);
hbottom = hbottom(end:-1:1);
% Construct the right hand side vector from the side values
RHS = [hleft-gderleft; htop-gdertop; hright-gderright; hbottom-gderbottom];
%% Solve the system for xi
xi = invM*RHS;