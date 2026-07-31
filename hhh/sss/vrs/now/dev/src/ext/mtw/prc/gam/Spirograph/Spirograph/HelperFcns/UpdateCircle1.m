function [s x t] = UpdateCircle1(theta,r)
% s = arc length over angular range [0,theta]
% x = [x(1) x(2)] = xy-coordinates of point on circle @ angle theta
% t = [t(1) t(2)] = tangent vector @ x

n = floor(theta / pi);
thetax = rem(theta,pi);

sx = -r * cos(thetax);
s = theta * r;

x = (-1)^n * [(-r * cos(thetax));
              ( r * sin(thetax))];

t = (-1)^n * [     1     ;
              dfdx(sx,r)];
t = t / norm(t);
t(isnan(t)) = (-1)^n;
end

function df = dfdx(x,r)
df = (-x / r) .* (1 - (x / r).^2).^(-0.5);
end

function df = dfdx_safe(x,r)
M = 1e6;
df = (-x / r) .* (1 - (x / r).^2).^(-0.5);
df(isinf(df)) = M;
end
