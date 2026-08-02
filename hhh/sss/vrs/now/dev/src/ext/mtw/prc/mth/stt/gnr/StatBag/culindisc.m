function [class] = culindisc(class0, class1, pattern,vars)

% function [class] = culindisc(class0, class1, pattern,vars)

[c0,c1,vars]=unifeat(class0,class1,vars);

class=clindisc(c0,c1,pattern(vars));

