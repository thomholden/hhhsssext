function showgrid(N)
%SHOWCHEBNODES   Displays the tensor product grid formed by the extrema of 
%the Chebyshev polynomials of the first kind.
%
%   See also   SHOWCHEBNODES, CHEB

%   Zoltán Csáti
%   2014/08/06

if nargin == 0
    N=10;
end
x = cos(pi*(0:N)/N);
[X Y] = meshgrid(x);
figure;
plot(X,Y,'ro','MarkerFaceColor','red');