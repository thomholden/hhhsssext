function [s x t] = UpdateEllipse1(theta,r1,r2)
% s = arc length over angular range [0,theta]
% x = [x(1) x(2)] = xy-coordinates of point on ellipse @ angle theta
% t = [t(1) t(2)] = tangent vector @ x

% Knobs
tol = 1e-6;

n = floor(theta / pi);
thetax = rem(theta,pi);

sx = -r1 * cos(thetax);
dsdx = @(x) sqrt(1+dfdx_safe(x,r1,r2).^2);

%s = n * quad(dsdx,-r1,r1,tol) + quad(dsdx,-r1,sx,tol);
%s = n * quadl(dsdx,-r1,r1,tol) + quadl(dsdx,-r1,sx,tol);
s = n * quadgk(dsdx,-r1,r1) + quadgk(dsdx,-r1,sx);

x = (-1)^n * [(-r1 * cos(thetax));
              ( r2 * sin(thetax))];

t = (-1)^n * [      1        ;
              dfdx(sx,r1,r2)];
t = t / norm(t);
t(isnan(t)) = (-1)^n;
end

function df = dfdx(x,r1,r2)
df = (-r2 * x / r1^2) .* (1 - (x / r1).^2).^(-0.5);
end

function df = dfdx_safe(x,r1,r2)
M = 1e6;
df = (-r2 * x / r1^2) .* (1 - (x / r1).^2).^(-0.5);
df(isinf(df)) = M;
end
