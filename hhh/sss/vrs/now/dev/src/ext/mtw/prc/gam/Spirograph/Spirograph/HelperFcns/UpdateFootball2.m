function [x t] = UpdateFootball2(s,r1,r2,p)
% x = [x(1) x(2)] = xy-coordinates of point on football @ arc length s
% t = [t(1) t(2)] = tangent vector @ x

% Knobs
width = 1e-6;
tol = 1e-6;

dsdx = @(x) sqrt(1+dfdx_safe(x,r1,r2,p).^2);

%spi = quad(dsdx,-r1,r1,tol);
%spi = quadl(dsdx,-r1,r1,tol);
spi = quadgk(dsdx,-r1,r1);

n = floor(s / spi);
sx = rem(s,spi);

xb = [-r1 r1];
while (diff(xb) > width)
    xt = mean(xb);
    
    %st = quad(dsdx,-r1,xt,tol);
    %st = quadl(dsdx,-r1,xt,tol);
    st = quadgk(dsdx,-r1,xt);
    
    if (st > sx)
        xb(2) = xt;
    elseif (st < sx)
        xb(1) = xt;
    else
        xb = [xt xt];
    end
end
xb = mean(xb);

x = (-1)^n * [     xb     ;
              f(xb,r1,r2,p)];

t = (-1)^n * [          1           ;
              dfdx_safe(xb,r1,r2,p)];
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
