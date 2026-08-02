function [class] = nn (class0, class1, pattern, p0, p1)

% function [class] = nn (class0, class1, pattern, p0, p1)
% Nearest-neighbour classifier for two-class problems
% If there are two equally close patterns as the nearest neighbour from
% different classes - use the class prior to assign class
% Then, If priors are equal make random decision
% class0	matrix
% class1	matrix
% pattern	vector to be classified
% p0,p1		class priors

dp=size(pattern,2);
if ~(size(class0,2)==size(class1,2)) | ~(dp==size(class0,2))
	disp('Error in nn: patterns are unequal dimension');
	return
end

n=size(class0,1);
mpattern=ones(n,1)*pattern;
d=dmeuclid(class0,mpattern);
d0=min(d);

n=size(class1,1);
mpattern=ones(n,1)*pattern;
d=dmeuclid(class1,mpattern);
d1=min(d);

if d0 < d1
	class=0;
elseif d1 < d0
	class=1;
else
	if (p0 > p1)
		class=0;
	elseif (p1 > p0)
		class=1;
	else
		if randn(1,1)<0
			class=0;
		else
			class=1;
		end
	end
end

