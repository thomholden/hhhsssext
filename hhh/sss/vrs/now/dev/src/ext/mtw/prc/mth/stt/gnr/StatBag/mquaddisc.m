function [tn,tp,yp,ym,yt,alpha,beta] = mquaddisc(c0, c1, test0, test1)

% function [tn,tp,yp,ym,yt,alpha,beta] = mquaddisc(c0, c1, test0, test1)


w=quaddisc(c0,c1);

t0=size(test0,1);
t1=size(test1,1);
Ntest=t0+t1;
xtest=[test0;test1];
yt=[zeros(t0,1);ones(t1,1)];

x_input=[xtest,xtest(:,1).^2,xtest(:,2).^2,xtest(:,1).*xtest(:,2),ones(Ntest,1)];
yp=x_input*w;

[c,tp,tn,fp,fn] = lclassify (yt,yp,0.5);

% Set dummy variables
alpha=0;
beta=0;
yt=yt';
yp=yp';
ym=yp;