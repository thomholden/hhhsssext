function [x t] = UpdateCircle2(s,r)
% x = [x(1) x(2)] = xy-coordinates of point on circle @ arc length s
% t = [t(1) t(2)] = tangent vector @ x

spi = pi * r;
n = floor(s / spi);
sx = rem(s,spi);

thetax = sx / r;

x = (-1)^n * [(-r * cos(thetax));
              ( r * sin(thetax))];

t = (-1)^n * [  1                        ;
              dfdx((-r * cos(thetax)),r)];
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
