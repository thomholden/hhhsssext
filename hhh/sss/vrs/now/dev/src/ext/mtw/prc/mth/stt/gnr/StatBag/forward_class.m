function [tn,tp,yp,ym,yt,alpha,beta] = forward_class(c0, c1, t0, t1)

%function [tn,tp,yp,ym,yt,alpha,beta] = forward_class(c0, c1, t0, t1)

n0=size(c0,1);
n1=size(c1,1);
nt0=size(t0,1);
nt1=size(t1,1);

p=0.05;
vars=forward(c0,c1,p)
if vars(1)==0
	disp('No Variables selected');
	% No variables selected
	tn=nt0/2;
	tp=nt1/2;
	yp=0.5*ones(1,nt0+nt1);
	ym=0.5*ones(1,nt0+nt1);
	yt=[zeros(1,nt0),ones(1,nt1)];
	d=size(c0,2);
	alpha=zeros(1,d);
	beta=0;
	return
end

class0=c0(:,vars);
class1=c1(:,vars);
test0=t0(:,vars);
test1=t1(:,vars);


[tn,tp,yp,ym,yt,alpha,beta] = mlindisc(class0, class1, test0, test1);

% Return selected features as vector of 1's (selected) and 0's
d=size(c0,2);
alpha=zeros(1,d);
alpha(vars)=ones(size(vars));