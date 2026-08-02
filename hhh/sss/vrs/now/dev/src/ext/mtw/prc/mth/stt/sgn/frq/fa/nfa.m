function F = nfa(N,a)
%NFA    Normalized Discrete Fractional Fourier Transform Matrix.
%   NFA(N,A) returns the N by N Discrete Fractional Fourier Transform
%   Matrix for order A transform. N must be a positive integer and A must
%   be real. Both N and A must be scalar. 
%
%   NFA(N,A) implements the algorithm explained in "The Discrete Fractional
%   Fourier Transform" by Candan, Kutay, Ozaktas published in IEEE
%   Transactions on Signal Processing, vol. 48, no. 5, may 2000. It
%   approximates the Continuous Fractional Fourier Transform. Properties
%   are:
%       INV(NFA(N,A)) == NFA(N,-A)
%       NFA(N,A1+A2) == NFA(N,A1)*NFA(N,A2)
%       NFA(NUMEL(f),1)*f*SQRT(NUMEL(f)) == FFT(f) , f is a column vector
%   
%   NFA(N,A) is normalized in such way that NORM(FA(N,A)) == 1. For a
%   scaled version in which NORM(FA(N,A)) == SQRT(N)^A see FA.
%
%   Example
%      n = 64;
%      x = (-n/2:n/2-1)';
%      f = fftshift(exp(-(x-2).^2/2));
%      F = fftshift(nfa(n,pi)*nfa(n,1-pi)*f)*sqrt(n);
%      Ffft = fftshift(fft(f));
%      plot(x,real(F),x,imag(F))
%      figure
%      plot(x,real(Ffft),x,imag(Ffft))
%
%   See also FA, FFT.

%   Vicente Parot, 2008

% construct V & H and calculate V*H*V matrix
[ii jj] = meshgrid(0:N-1,0:N-1);

H = (diag(2*cos(2*pi*(0:(N-1))/N)) + ...
    ~(1-abs(mod(ii-jj+N/2,N)-N/2)) ) * ...
    pi/((i*2*pi)^2);

if mod(N,2)
    V = (double(~(ii(2:end,2:end)+jj(2:end,2:end)-N)) + diag(sign(N-(N-2)/2-(2:N))))/sqrt(2);
    V = [1 zeros(1,N-1); zeros(N-1,1) V];
else
    V = (double(~(ii+jj-N-1)) + diag(sign(N-(N-3)/2-(1:N))))/sqrt(2);
    V(1:2,1:2) = eye(2);
    perm = [[1;2] reshape(3:N,N/2-1,2)']';
    V = V(perm(:),perm(:));
end

VHV = V*H*V;

% construct Eev & Eod
nev = floor(N/2)+1; % number of even eigenvectors

Eev = zeros(N);
Ev = VHV(1:nev,1:nev);
[ve,ee] = eig(Ev); %#ok<NASGU>
Eev(1:nev,1:nev) = ve;

Eod = zeros(N);
Od = VHV(nev+1:N,nev+1:N);
[vo,eo] = eig(Od);  %#ok<NASGU>
Eod(nev+1:N,nev+1:N) = vo;

% sort eigenvectors
if mod(N,2)
    ind = reshape(1:N+1,(N+1)/2,2)'; % new sorting order indexes
    ind = ind(1:end-1);
    ind = ind(:);
else
    ind = reshape(1:N,N/2,2)';
    ind(2,:) = ind(2,[2:N/2 1]);
    ind = ind(:);
end
orthE = V*(Eev + Eod);
orthE = orthE(:,ind);

% construct matrix from orthogonal eigenvectors
F = orthE*diag(exp(-i*mod(a,4)*[0:N-2 N-1+(1-mod(N,2))]*pi/2))*orthE';