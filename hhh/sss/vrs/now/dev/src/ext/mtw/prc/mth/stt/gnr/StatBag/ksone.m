function [prob] = ksone (x,funcname)

% function [prob] = ksone (x,funcname)
% Get Kolmogorov-Smirnoff distance between measure and ideal distribution 
% See page 625 Press et.al.
% x		measured data normalised to UNIT variance and ZERO mean
% funcname	ideal distribution eg. cdf_norm
% Example: p=ksone(z,'cdf_norm');

n=length(x);
en=n;
data=sort(x);

evalstr=[funcname,'(data(j))'];
%disp(evalstr);

fo=0;
d=0;
for j=1:n,
	fn=j/en;
	ff=eval(evalstr);
	dt=max([abs(fo-ff),abs(fn-ff)]);
	if (dt > d)
		d=dt;
	end
	fo=fn;
end

en=sqrt(en);
prob=probks((en+0.12+0.11/en)*d);




	




