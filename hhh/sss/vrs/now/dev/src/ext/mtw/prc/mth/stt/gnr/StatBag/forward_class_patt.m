function [class] = forward_class_patt(c0, c1, pattern)

% function [class] = forward_class_patt(c0, c1, pattern)

n0=size(c0,1);
n1=size(c1,1);

p=0.05;
vars=forward(c0,c1,p);
if vars(1)==0
	%disp('No Variables selected');
	% No variables selected
	class=0;
	return
end

class0=c0(:,vars);
class1=c1(:,vars);
patt=pattern(vars);

class = clindisc(class0, class1, patt);



