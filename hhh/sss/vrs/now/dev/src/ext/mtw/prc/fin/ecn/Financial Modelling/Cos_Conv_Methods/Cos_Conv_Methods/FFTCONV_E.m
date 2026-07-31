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



function price = FFTCONV_E(n, L, alpha, cp, model, S0, t, r, q, ...
    strike, varargin)

Ngrid = 2^n;                                    % N gridpoints    
rdt = r * t;                                    % riskfree times t

Delta_y = L/Ngrid;                              % Delta_y
Delta_x = Delta_y;                              % Delta_x = Delta_y
Delta_u = 2 * pi / L;                           % Delta_u

% Grids
Grid_i = (0:Ngrid-1)';                          % Gridindex
Grid_m = (-1).^Grid_i;                          % (-1)^Grid_i

x = (Grid_i .* Delta_x) - (Ngrid/2 * Delta_x);  % adjusted x-grid
y = log(strike / S0) + (Grid_i .* Delta_y) ...
    - (Ngrid/2 * Delta_y);                      % adjusted y-grid
u = (Grid_i .* Delta_u) - (Ngrid/2 * Delta_u);  % u-grid

V = max(cp .* (S0*exp(y) - strike), 0);         % payoff
v = V .* exp(alpha .* y);                       % dampened option value

w = ones(Ngrid,1); w(1) = 0.5; w(Ngrid) = 0.5;  % coefficients

FT_Vec = ifft( (Grid_m) .* w .* v );            % inner transform
FT_Vec_tbt = exp( 1i .* Grid_i .* (y(1) - x(1)) .* Delta_u ) ...
    .* exp(feval(@CF, model,-(u - (1i*alpha)), t,r,q,varargin{:})) ...
    .* FT_Vec;                                  % vector to be transf.

C = abs(exp( -rdt - (alpha .* x) + (1i .* u .* (y(1) - x(1))) ) ...
    .* (Grid_m) .* fft(FT_Vec_tbt));            % final value
price = double(C(Ngrid/2 + 1, 1));              % return price
end