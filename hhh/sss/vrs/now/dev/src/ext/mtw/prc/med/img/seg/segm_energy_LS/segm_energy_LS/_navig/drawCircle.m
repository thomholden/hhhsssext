function mask = drawCircle(R, ForceOdd)
% mask = drawCircle(R, ForceOdd)
% 
% nice circle drawing, R - circle RADIUS
%
% returns a boolean mask of size Ro x Ro
% 
% Ro    | ForceOdd  | center
% ------+-----------+-----------------
% 2R    |   0       | (R,R)-half pixel
% 2R+1  |   1       | (R+1,R+1)
% 
% when ForceOdd ==0 the mask is centered at (R,R), i.e.
% "half a pixel" lower than the actual geometrical center 
% else, it will naturally be centered on the (R+1,R+1) pixel
%
% tudor dima, 07.07.2008

if nargin < 1, R = 10; end;

if ForceOdd
    R = R+1;
end

% draw a quarter of a circle
v = 0.5 + (0:R-1); % centers of pixels
v = v.^2; % square once only
xc = repmat(v, R,1);
yc = repmat(v', 1,R);
dsq = xc + yc;
d = sqrt(dsq);
mask = d<R;

% flip it twice : Up/Dw, then L/R
mask = [flipud(mask); mask];
mask = [fliplr(mask) mask];

if ForceOdd % delete the (R+1)-th row&col, to get (R+1)th in the 'middle'
    mask = mask(([(1:R),(R+2:end)]), :);
    mask = mask(:, ([(1:R),(R+2:end)]));
end
