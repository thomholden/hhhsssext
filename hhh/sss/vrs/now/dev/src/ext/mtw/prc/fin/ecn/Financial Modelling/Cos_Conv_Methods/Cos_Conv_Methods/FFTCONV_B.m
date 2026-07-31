% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function price = FFTCONV_B(n, L, alpha, cp, model, S0, t, r, q, ...
    strike, Nex, varargin)
% n           -> points used for the grid construction, 2^n
% L           -> width of the interval approx the density
% alpha       -> dampening factor
% cp          -> call cp=1; put cp=-1;
% model       -> string for finding model from CF lib
% t           -> maturity
% r           -> riskfree rate
% q           -> dividend
% strike      -> strike of the option
% parameters  -> model parameters
% Nex         -> number of exercise dates

Ngrid = 2^n;                    % num grid points
dt = t / Nex;                   % time step
rdt = r * dt;                   % riskfree times dt

Delta_y = L/Ngrid;              % discrete y
Delta_x = Delta_y;              % discrete x
Delta_u = 2 * pi / L;           % discrete u

adj_y = log(strike/S0) ...
    - (ceil(log(strike/S0)/Delta_y) * Delta_y); % adjustment y-grid

% Construct the Grids
Grid_i = (0:Ngrid-1)';          % index nums for grids

y = adj_y + (Grid_i .* Delta_y) ...
    - (Ngrid/2 * Delta_y);      % Adjusted y-grid
x = y;                          % x-grid from y-grid

u = zeros(Ngrid, 1);            % the base u-grid 
u = u + (Grid_i .* Delta_u) ...
    - (Ngrid/2 * Delta_u);      % Set u-grid
% coefficients
w = ones(Ngrid,1); w(1) = 0.5; w(Ngrid) = 0.5;  

V = max(cp .* (S0*exp(y) - strike), 0); % option value at t_Nex
v = V .* exp(alpha .* y);               % dampened option value

cval = @(v,x,y) cv(Grid_i, rdt, w, v, Delta_u, model, u, x, y, alpha, ...
    dt, r, q, varargin{:});               % calc continuation val

for m = Nex-1:-1:1                         % backward induction                             
    C = cval(v,x,y);                       % continuation value
    h = max(cp .* (S0*exp(x) - strike), 0);% payoff at t_m
    V = max(C, h);                         % option value at t_m    
  
    l = find(V==h,1,'last');               % find exercise boundary
    if isempty(l)
        if cp == 1
            l = size(h,1)-1;
        else
            l = 1;
        end
    end
    if cp == 1                             % case of a call           
        l = l-1;
    end
    % x^star
    xstar = ( x(l+1)*(C(l) - h(l)) - x(l)*(C(l+1) - h(l+1)) ) ...
        / ( (C(l) - h(l)) - (C(l+1) - h(l+1)) );
    % adjust x-grid
    adj_x = xstar-(ceil(xstar/Delta_x)*Delta_x);
    x = adj_x + (Grid_i .* Delta_x) ...
        - (Ngrid/2 * Delta_x);              % new x-grid
                              
    C = cval(v,x,y);                        % continuation value
    V = max(C,max(cp .* (S0*exp(x) - strike), 0));    
    y = x;                                  % y-grid = x-grid    
    v = V .* exp(alpha .* y);               % dampened option value   
end
% Last Step
x = (Grid_i .* Delta_x) ...
    - (Ngrid/2 * Delta_x);                  % final x-grid
                            
C = cval(v,x,y);                            % final value
price = C(Ngrid/2 + 1, 1);                  % return price
end

function y = cv(Grid_i, rdt, w, v, Delta_u, model, u, x, y, alpha, ...
    dt, r, q, varargin)
% calculate continuation value
    % inner transform
    FT_Vec = ifft( ((-1) .^ Grid_i) .* w .* v ); 
    % outer transform
    FT_Vec_tbt = exp( 1i .* Grid_i .* (y(1) - x(1)) .* Delta_u ) ...
        .* exp(feval(@CF, model,-(u - (1i*alpha)), dt,r,q,varargin{:})) ...
        .* FT_Vec;
    % calculation of value using above transforms
    y = abs(exp(-rdt-(alpha .* x) + (1i .* u .* (y(1) - x(1))) ) ...
        .* ((-1).^Grid_i) .* fft(FT_Vec_tbt));
end