% We create data shown in Duda and Hart p. 212



N=1000;
hold off
%  (a) Gaussian blob

rot=0;
truecov=[-1, 1; 1, -1];

x=gaussian2D(N,[1,1],truecov);
plot(x(:,1),x(:,2),'x');
hold on

scovx=cov(x)
[v,s] = eig(scovx)
x1min=min(x(:,1));
x1max=max(x(:,1));

[u,ss,vv]=svd(x');
u
plot([0, u(1,1)],[0, u(2,1)],'r');
plot([0, u(1,2)],[0, u(2,2)],'r');