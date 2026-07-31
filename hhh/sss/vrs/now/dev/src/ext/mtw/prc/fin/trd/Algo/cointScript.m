% backtest example to look for a pairs trade.
load Portfolio_Data.mat
X = P(:,9);
Y= P(:,23);
N=25:25:500;
M=5:5:50;
sh=zeros(length(N),length(M));
for i=1:length(N)
    for j=1:length(M)
        sh(i,j)=cointStrat(X,Y,N(i),M(j));
    end
    N(i)
end
figure
imagesc(M,N,sh); colorbar

[I,J]=find(sh==max(max(sh)));
[shbest,pnl,pos]=cointStrat(X,Y,N(I),M(J));
figure
plot(cumsum(pnl)), title(['Best sh = ',num2str(shbest),' N=',num2str(N(I)),', M=',num2str(M(J))]);

