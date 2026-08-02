function [data_out] = normal(n,u,s)

% function [data_out] = normal(n,u,s)
% RETURN N ELEMENTS of NORMAL DIST with mean u dev s
% [data_out] = normal(n,u,s)

[data_out]=s*randn(n,1)+u;



 

