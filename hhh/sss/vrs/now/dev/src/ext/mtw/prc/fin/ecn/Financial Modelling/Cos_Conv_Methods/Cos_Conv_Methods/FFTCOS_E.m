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



function y = FFTCOS_E(n, L, c, cp, model, S0, t, r, q, strike, varargin)

Ngrid = 2 ^ n;                      % number of grid points
Nstrike = size(strike,1);           % number of strikes

x = repmat(double(log(S0 ./ strike))',Ngrid,1);       % center

a = double(c(1) + x - L * sqrt(c(2) + sqrt(c(3))));   % low bound
b = double(c(1) + x + L * sqrt(c(2) + sqrt(c(3))));   % up bound

Grid_i = repmat((0:Ngrid-1)',1,Nstrike);    % Grid index

vk_p = @(x) calcvkp(x,b,a,strike);          % coefficients for put

fk_i = exp(feval(@CF, model,Grid_i.*pi./(b-a), t,r,q,varargin{:}));
fk_i = double(2./(b - a) .* real( fk_i ...
    .* exp(1i .* pi .* Grid_i .* x ./ (b - a)) ...
    .* exp(-1i .* (pi .* Grid_i .* a ./ (b - a))) ));

% fk_0 = exp(feval(@CF, model,0.*pi ./ (b-a), t,r,q,varargin{:}));
% fk_0 = double(2 ./ (b - a) .* real( fk_0 ...
%     .* exp(1i .* 0 .* pi .* x ./ (b - a)) ...
%     .* exp(-1i .* (0 .* a .* pi ./ (b - a))) ));
        
%if cp == 1 & c ~=1     % plain European call pricing
%vk_c = @(x) vkCallTermEuCOS(x,b,a,strike);
%    y = double(exp(-r .* t) ...
%    .* (fk_i' * vk_c(Grid_i) ...
%    - 0.5 * (fk_0 * vk_c(0)) ));

Vk = vk_p(Grid_i);
y = double(exp(-r .* t) ...
        .* (sum(fk_i .* Vk) - 0.5 * (fk_i(1,:) .* Vk(1,:)) ))';
%end

if cp  == 1    % European call price using pu-call-parity
    y = y + S0 * exp(-q * t) - strike * exp(-r * t);
end


end

