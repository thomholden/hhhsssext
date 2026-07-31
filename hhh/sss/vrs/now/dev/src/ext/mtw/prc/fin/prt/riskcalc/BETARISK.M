function beta=BetaRisk(stock,index)
% Calculates beta of stock
N=size(stock,1);
r=log(stock(2:N)./stock(1:N-1));
N=size(index,1);
Rm=log(index(2:N)./index(1:N-1));
beta=cov(r,Rm)/var(Rm)
