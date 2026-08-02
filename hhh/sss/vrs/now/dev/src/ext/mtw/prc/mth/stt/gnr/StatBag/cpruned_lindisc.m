function [class] = cpruned_lindisc(c0, c1, pattern, plevel)

% function [class] = cpruned_lindisc(c0, c1, pattern, plevel)


[w,vars] = pruned_lindisc (c0,c1,plevel);
x_input=[pattern(vars),1];
nvars=length(vars);
disp(sprintf('Number of variables selected: %d',nvars));
disp(' ');
if nvars==0
	y=rand(1);
else
	y=x_input*w;
end

if y > 0.5
	class=1;
else
	class=0;
end
