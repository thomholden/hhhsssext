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
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [call_price_fft, call_delta_fft,call_gamma_fft] = ConvolutionMethodCallPricingFFT(N,L,model,S,K,T,r,d)

% dampening parameter
alfa = 0.0;  % Where is the dampening? 
% % Is it meaningful to choose alfa as the optimal payoff independent alfa 
% % of the Black Scholes model?
% %alfa_opt =  (log(S0/K)+(r-.5*sigma^2)*T)/sigma/sqrt(T);

% N # grid points
% L from formula (42)

M = length(K);

% stepsize / Nyquist relation
du = 2*pi/L;
dy = L/N;
% u grid
u1 = -N*pi/L;
uN = (N-2)*pi/L;
u = (u1:du:uN)';

% Discretisation II
% discontinuity shift for european options 
eps_y = log(K/S);
eps_x = 0;

matN = repmat((0:N-1)',1,M);

% formula (43) x-/y-grid
x = eps_x + (matN-N/2)*dy;
y = repmat(eps_y',N,1) + (matN-N/2)*dy;

% damped payoff function call
payoff_call = repmat(K',N,1).*exp(alfa*y).*max(exp(y)-1,zeros(N,M));
% weights of trapezodial rule
w = [0.5;ones(N-2,1);0.5];
% (-1)^p, p = 0,...,N-1
Ivec = ones(N,M);
ind = mod(matN,2)~=0;
Ivec(ind) = -1;

% characteristic function evaluation
phi = exp(repmat((-1i*u-alfa),1,M)*diag(-eps_y') + repmat(feval(@CharacteristicFunctionLib,model,-(u-1i*alfa),T,r,d,model.params),1,M));

% fourier transformation of damped payoff as defined in (26)
FFT = ifft(Ivec.*repmat(w,1,M).*payoff_call);
% inverse fourier transformation of (27)
invFFT = fft(exp(1i*matN*diag(y(1,:)-x(1,:))*du).*phi.*FFT);
% price vector conv method
price_conv = exp(-r*T)*real(repmat(exp(1i*u(1)*(y(1,:)-x(1,:))),N,1).*Ivec.*invFFT);

invFFT_delta = fft(repmat(-1i*u,1,M).*exp(1i*matN*diag(y(1,:)-x(1,:))*du).*phi.*FFT);
% delta vector conv method
delta_conv = exp(-r*T)*real(repmat(exp(1i*u(1)*(y(1,:)-x(1,:))),N,1).*Ivec.*invFFT_delta)/S;

invFFT_gamma = fft(repmat((-1i*u).^2,1,M).*exp(1i*matN*diag(y(1,:)-x(1,:))*du).*phi.*FFT);
% gamma vector conv method
gamma_conv = exp(-r*T)*real(repmat(exp(1i*u(1)*(y(1,:)-x(1,:))),N,1).*Ivec.*(invFFT_gamma-invFFT_delta))/S^2;

call_price_fft = price_conv(N/2+1,:)';
call_delta_fft = delta_conv(N/2+1,:)';
call_gamma_fft = gamma_conv(N/2+1,:)';

