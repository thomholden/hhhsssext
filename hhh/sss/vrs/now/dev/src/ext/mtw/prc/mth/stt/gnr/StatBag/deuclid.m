function [d] = deuclid (a,b)

% function [d] = deuclid (a,b)
% Return euclidian distance between vectors a and b

if ~(nargin==2)
	disp('Error in deuclid: function requires two arguments');
	return
end
d=sqrt(sum((a-b).^2));