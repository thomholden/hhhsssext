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



function result = cvalue(x1, x2, a, b, N, V, ...
    model, t, r, q, varargin)

exp2 = exp( 1i .* (1:N)' .* (x2 - a) ./ (b - a) .* pi );    % init
exp1 = exp( 1i .* (1:N)' .* (x1 - a) ./ (b - a) .* pi );    % init

m = zeros(3*N-1, 1);                                        % init base

m(N, 1) = 1i * pi * (x2 - x1) / (b - a);
m(N+1:2*N, 1) = 1 ./ (1:N)' .* ( exp2 - exp1 );
m(1:N-1, 1) = - conj(flipud(m(N+1:2*N-1, 1)));
m(2*N+1:3*N-1, 1) = ( exp2(1:N-1, 1) .* exp2(N,1) - exp1(1:N-1, 1) ...
    .* exp1(N, 1) ) ./ ( (N+1:2*N-1)' );

Grid_j = (0:N-1)';                                          % fix grid

% compute u values
u = exp(feval(@CF, model,Grid_j.*pi./(b-a), t,r,q,varargin{:})) .* V;
u(1) = 0.5*u(1);

m_s = [m(N:-1:1, 1); 0; m(2*N-1:-1:N+1, 1)];
u_s = [u; zeros(N, 1)];
m_c = m(3*N-1:-1:N, 1);

shortCut = 1;

% apply fft five times
if shortCut == 1
    zeta = -ones(2*N, 1);
    zeta(2 .* (1:N)' - 1) = 1;

    fft_u_s = fft(u_s);
    xi_s = ifft((fft(m_s)) .* fft_u_s);
    xi_c = ifft((fft(m_c)) .* (zeta .* fft_u_s));

    result = exp(-r * t) / pi .* imag( xi_s(1:N) + flipud(xi_c(1:N)) );
else   
    M_c = zeros(N, N);
    M_s = zeros(N, N);
    
    for n = 0:N-1
        M_c(:, n+1) = m(N+n:2*N-1+n);
        M_s(:, n+1) = m(N+n:-1:1+n);
    end
    
    result = exp(-r*t) / pi .* imag((M_c + M_s) * u);

end