function [d] = dmeuclid (a,b)

% function [d] = dmeuclid (a,b)
% Return euclidian distance between rows of the matrices a and b


if ~(nargin==2)
	disp('Error in deuclid: function requires two arguments');
	return
end
d=sqrt(sum(((a-b).^2)'))';