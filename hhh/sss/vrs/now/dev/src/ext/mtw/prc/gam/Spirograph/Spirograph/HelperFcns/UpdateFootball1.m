function [s x t] = UpdateFootball1(theta,r1,r2,p)
% s = arc length over angular range [0,theta]
% x = [x(1) x(2)] = xy-coordinates of point on football @ angle theta
% t = [t(1) t(2)] = tangent vector @ x

% Knobs
tol = 1e-6;

n = floor(theta / pi);
thetax = rem(theta,pi);

sx = -r1 * cos(thetax);
fun = @(x) abs(f(x,r1,r2,p) + tan(thetax) * x);
sx = fminsearch(fun,sx);

dsdx = @(x) sqrt(1+dfdx_safe(x,r1,r2,p).^2);

%s = n * quad(dsdx,-r1,r1,tol) + quad(dsdx,-r1,sx,tol);
%s = n * quadl(dsdx,-r1,r1,tol) + quadl(dsdx,-r1,sx,tol);
s = n * quadgk(dsdx,-r1,r1) + quadgk(dsdx,-r1,sx);

x = (-1)^n * [      sx      ;
              f(sx,r1,r2,p)];

t = (-1)^n * [          1           ;
              dfdx_safe(sx,r1,r2,p)];
t = t / norm(t);
t(isnan(t)) = (-1)^n;
end

function df = dfdx_safe(x,r1,r2,p)
M = 1e6;
df = (-sign(x) * p * r2 * r1^(-p)) .* abs(x).^(p-1);
df(x == -r1) = M;
df(x == r1) = -M;
end

function fx = f(x,r1,r2,p)
fx = r2 * (1 - (abs(x) ./ r1).^p);
end
