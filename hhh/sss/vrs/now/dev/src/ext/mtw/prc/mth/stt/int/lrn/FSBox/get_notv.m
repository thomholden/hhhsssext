function [notv] = get_notv (v,nvars)

% function [notv] = get_notv (v,nvars)
% Get list of variables not selected
% v		list of variables selected
% nvars		total number of variables
  
nv=length(v);

notv=[];
for i=1:nvars,
	selected=0;
	for j=1:nv,
	  if v(j)==i
	    selected=1;
	    break;
	  end
	end
	if ~(selected)
	  notv=[notv, i];
	end
end