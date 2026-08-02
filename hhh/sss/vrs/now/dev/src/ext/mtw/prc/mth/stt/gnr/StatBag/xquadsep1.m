
%[c0,c1]=linsep;
N=100

cov0=[1,0;0,1];
cov1=[1,0.5;0.5,1];
[c0,c1]=quadsep(N,cov0,cov1,1);
[t0,t1]=quadsep(N,cov0,cov1,1);

[tn,tp,yp,ym,yt,alpha,beta] = mlindisc(c0, c1, t0, t1);
c=(tn+tp)/N

[tn,tp,yp,ym,yt,alpha,beta] = mquaddisc(c0, c1, t0, t1);
c=(tn+tp)/N



%hold on
%x1min=-2;x1max=6;
%pquaddisc(w,x1min,x1max);