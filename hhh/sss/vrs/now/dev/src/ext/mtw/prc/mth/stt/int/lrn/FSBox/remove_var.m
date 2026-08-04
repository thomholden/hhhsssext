function [vars] = remove_var (j,v)

% function [vars] = remove_var (j,v)
% Remove jth entry from list
% j		variable to remove
% v		list of variables 
  
nv=length(v);

vars=[];
for i=1:nv,
	if ~(i==j)
	  vars=[vars, v(i)];
	end
end