function [x t] = UpdateEllipse2(s,r1,r2)
% x = [x(1) x(2)] = xy-coordinates of point on ellipse @ arc length s
% t = [t(1) t(2)] = tangent vector @ x

% Knobs
width = 1e-6;
tol = 1e-6;

dsdx = @(x) sqrt(1+dfdx_safe(x,r1,r2).^2);

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
              f(xb,r1,r2)];

t = (-1)^n * [         1          ;
              dfdx_safe(xb,r1,r2)];
t = t / norm(t);
t(isnan(t)) = (-1)^n;
end

function df = dfdx_safe(x,r1,r2)
M = 1e6;
df = (-r2 * x / r1^2) .* (1 - (x / r1).^2).^(-0.5);
df(isinf(df)) = M;
end

function fx = f(x,r1,r2)
fx = r2 * sqrt(1 - (x./r1).^2);
end
