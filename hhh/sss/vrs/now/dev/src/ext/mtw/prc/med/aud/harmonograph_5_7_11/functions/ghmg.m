%ghmg
% Generalised Harmonograph equations. (From Wikipedia). These are two pairs
% of damped sinusoids for each x and y Cartesian coordinates.
%
% LAST UPDATED by Andy French 10th January 2009
%
% Syntax [x,y] = ghmg( t, A, W, P, T )
%
% t is a vector of times /s
% A is a four component vector of oscillating function amplitudes
% W is a four component vector of oscillating function angular frequencies / rad/s
% P is a four component vector of oscillating function initial phases /rad
% T is a four component vector of oscillating function damping factor /s

function [x,y] = ghmg( t, A, W, P, T )

x = zeros(size(t));
y = zeros(size(t));
for n=1:2
    x = x + A(n) * sin( t*W(n) + P(n) ) .* exp( -t/T(n) );
end
for n=3:4
    y = y + A(n) * sin( t*W(n) + P(n) ) .* exp( -t/T(n) );
end

%End of code