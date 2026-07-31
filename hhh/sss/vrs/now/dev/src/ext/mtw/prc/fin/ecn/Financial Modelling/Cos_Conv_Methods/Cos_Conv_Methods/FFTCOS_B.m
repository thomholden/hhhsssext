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



function price = FFTCOS_B(n, Nex, L, c, cp, type, S0, t, r, q, ...
    strike, varargin)

dt = t / Nex;                    % time interval
Ngrid = 2 ^ n;                   % Grid points
Grid_i = (0:Ngrid-1)';           % Grid index

x = double(log(S0/strike));   % moneyness

a = double(c(1) + x - L * sqrt(c(2) + sqrt(c(3))));   % lower trunc
b = double(c(1) + x + L * sqrt(c(2) + sqrt(c(3))));   % upper trunc

xstark = (1:Nex-1)';

% Set up function handles
if cp == 1
    vk = @(x) calcv(Grid_i, x, b, a, b, cp, strike);
    cv = @(x,y) cvalue(a, x, a, b, Ngrid, y, type, dt, r, q, varargin{:});
else
    vk = @(x) calcv(Grid_i, a, x, a, b, cp, strike);
    cv = @(x,y) cvalue(x, b, a, b, Ngrid, y, type, dt, r, q, varargin{:});
end
    
V = vk(0);                      % coeff V in t_Nex-1
initialGuess = 0;               % guess for x^*(t_Nex-1)

xstark(Nex-1) = xstar(initialGuess, cp, a, b, 5, ...
    Grid_i, type, V, dt, r, q, strike, varargin{:});
C = cv(xstark(Nex-1),V);        % cont value at t_Nex-1

for m = Nex-2:-1:1              % backward induction
    V = vk(xstark(m+1)) + C;    % Coeff V in t_m
    xstark(m) = xstar(xstark(m+1),cp, a, b, 10, Grid_i, type, ...
        V, dt, r, q, strike, varargin{:}); % early exercise point
    C = cv(xstark(m),V);        % Cont value at t_m
end

V = vk(xstark(1))+C;            % Coeff V in t_0

cfval = exp(feval(@CF, type,Grid_i.*pi./(b-a), dt,r,q,varargin{:}));

F = real(cfval .* exp( 1i .* Grid_i .* pi .* (x - a) ./ (b - a) ));
F(1) = 0.5*F(1);
    
price = exp(-r * dt) * (F' * V) ;  % Option value at t_0
end