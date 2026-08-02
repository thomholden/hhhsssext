function [p] = pchisq (chisq,df)

% function [p] = pchisq (chisq,df)
% Return probability of c > chisq if c is distributed as chisq(df) 
% See Numerical recipes and Mendenhall book

p=1-gammainc(chisq/2,df/2);