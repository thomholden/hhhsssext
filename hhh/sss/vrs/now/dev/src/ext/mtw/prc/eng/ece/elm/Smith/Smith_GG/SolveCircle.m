function [ind, S1, S2] = SolveCircle(C1, C2)

% ind          = 0 for no solution
%                1 for one solution
%                2 for two solutions
S1 = {0}; S2 = {0}; ind = 0;
if isequal(C1, C2), return;end
x1 = C1(1);y1 = C1(2); r1 = C1(3);
x2 = C2(1);y2 = C2(2); r2 = C2(3);

dx = x2 - x1; dy = y2 - y1;
sr = r2 + r1; dr = r2 - r1;
d2 = dx^2 + dy^2;
t = (sr^2 - d2) * (d2 - dr^2);
epsilon = 10^-9; %a comfortable choice
if abs(t) < epsilon, t=0;end
if t < 0
%     disp('Circles cannot be solved');
    ind = 0;
    return
end
t = sqrt(t)/(2*d2);
dx0 = -dy * t; dy0 = dx * t;
t = -dr * sr / d2;
x0 = (x1 + x2 + dx*t)/2;
y0 = (y1 + y2 + dy*t)/2;
x3 = x0 + dx0; y3 = y0 + dy0;
x4 = x0 - dx0; y4 = y0 - dy0;
if isequal([x3,y3], [x4, y4])
    ind = 1;
else
    ind = 2;
end
if abs(x3-1) < epsilon && abs(y3) < epsilon % to account for [1,0] solution
    if ind == 1
        ind = 0;
    elseif ind == 2
        x3 = x4;y3 = y4;
        ind = 1;
    end
elseif abs(x4-1)<epsilon && abs(y4) < epsilon && ind ==2
    ind = 1;
end
S1 = {[x3,y3]};
S2 = {[x4,y4]};