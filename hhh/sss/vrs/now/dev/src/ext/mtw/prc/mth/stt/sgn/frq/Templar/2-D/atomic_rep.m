function y = atomic_rep(x,B)
%
% x - signal to be decomposed
% B - boolean variable: 1 for inverse, 0 for forward transform
%
% uncomment the one you want
%       
% Part of the TEMPLAR Software Package, Copyright © 2001, Rice University
% Author: Clay Scott (cscott@rice.edu).  See License.txt

if nargin < 2
  B = 0;
end

h=daubcqf(2);	% scaling filter

if ~B	% forward transform

  % wavelet
  y=mdwt(x,h);

  %fourier
  %y = fft2(x);

  %DCT
  %y = dct2(x);

  % nothing (spatial domain)
  %y = x;

else	% inverse transform

  % wavelet
  y=midwt(x,h);

  %fourier 
  %y = ifft2(x);

  %DCT
  %y = idct2(x);

  % nothing (spatial domain)
  %y = x;

end
