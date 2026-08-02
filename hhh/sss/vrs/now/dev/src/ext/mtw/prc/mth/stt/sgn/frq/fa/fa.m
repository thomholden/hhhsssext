function F = fa(N,a)
%FA     Discrete Fractional Fourier Transform Matrix.
%   FA(N,A) returns the N by N Discrete Fractional Fourier Transform Matrix
%   for order A transform. N must be a positive integer and A must be real.
%   Both N and A must be scalar.
%
%   FA(N,A) implements a scaled version of the algorithm explained in "The
%   Discrete Fractional Fourier Transform" by Candan, Kutay, Ozaktas
%   published in IEEE Transactions on Signal Processing, vol. 48, no. 5,
%   may 2000. It approximates the Continuous Fractional Fourier Transform.
%   Properties are: 
%       INV(FA(N,A)) == FA(N,-A)
%       FA(N,A1+A2) == FA(N,A1)*FA(N,A2)
%       FA(NUMEL(f),1)*f == FFT(f) , f is a column vector
%   
%   FA(N,A) is scaled the same way as the MATLAB FFT implementation.
%   This means taking FFT is the same as multiplying by FA(N,1). In
%   general, NORM(FA(N,A)) == SQRT(N)^A. For a normalized version in which
%   NORM(FA(N,A)) == 1 see NFA.
%
%   Example
%      n = 64;
%      x = (-n/2:n/2-1)';
%      f = fftshift(exp(-(x-2).^2/2));
%      F = fftshift(fa(n,pi)*fa(n,1-pi)*f);
%      Ffft = fftshift(fft(f));
%      plot(x,real(F),x,imag(F))
%      figure
%      plot(x,real(Ffft),x,imag(Ffft))
%
%   See also NFA, FFT.

%   Vicente Parot, 2008

% scale normalized matrix
F = nfa(N,a)*sqrt(N)^a;