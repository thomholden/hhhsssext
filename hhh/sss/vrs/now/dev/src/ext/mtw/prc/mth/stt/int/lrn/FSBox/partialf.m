function [f,p] = partialf (ssexp,sse,ssexpold,n,k)

% function [f,p] = partialf (ssexp,sse,ssexpold,n,k)
% Calculate partial f statistic 
% see p.128 Kleinbaum and p.229 Press
% ssexp		sum of squares explained by model (ssy - sse)
% sse		sum of squared errors from model
% ssexpold	sum of squares explained by old model (ssy-sseold)
% n		number of data points
% k		number of variables in old model
%
% f		partial f statistic
% p		significance of partial f statistic
  
if ((ssexp-ssexpold)==0 | sse==0)
        f=0;
	p=1;
else
        f = ((ssexp-ssexpold)*(n-k-2))/sse;
	p=ppartialf(f,n,k);
end

