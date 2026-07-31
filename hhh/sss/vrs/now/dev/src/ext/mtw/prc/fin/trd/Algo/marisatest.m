% marisa test script
X=data(:,5);
modelDataLength = round(length(X)/2);
X(isnan(X(:,1)),:)=[];
x2=X(1:modelDataLength,1);
x3=X(modelDataLength:end,1);
N=250:250:2000;
M=250:250:2000;
n=length(N);
m=length(M);
SH=zeros(n,m);
SHb=zeros(n,m);
shThres=1;
numAboveThres=0;

for i=1:n
    for j=1:m
        [SH(i,j),pnl,pos]=marisa(x2,N(i),M(j));
        [SHb(i,j),pnlb,posb]=marisa(x3,N(i),M(j));
        if SH(i,j) > shThres
            numAboveThres = numAboveThres+1; %marisa(x2,N(i),M(j),1,1,folderName,0);
        end
        
        if SH(i,j) > shThres & SHb(i,j) > shThres
            subplot(2,1,1);
            plot([cumsum(pnl),pos(1:end-1)/20]), title(['1st Half - Coord ',num2str(N(i)),':',num2str(M(j)),' Sharpe= ',num2str(SH(i,j))]);
            subplot(2,1,2);
            plot([cumsum(pnlb),posb(1:end-1)/20]), title(['2nd Half - Coord ',num2str(N(i)),':',num2str(M(j)),' Sharpe= ',num2str(SHb(i,j))]);
        end
    end
    N(i)
end

% for BUND data[s
% mov avg, N= 125, rsi, M = 5, thresh=55
figure
imagesc(M,N,SH);colorbar
figure
imagesc(M,N,SHb);colorbar

if numAboveThres > 10
    numToTest = round(numAboveThres*0.1)+1;
else
    numToTest = round(n*m*0.005);
end;

highestSHval = [0 0 0 0];
for i=1:numToTest
    [I,J]=find(SH==max(max(SH))); 
    I = I(1);
    J = J(1);
    [tempSH,pnl,pos]=marisa(x2,N(I),M(J));
    [tempSHb,pnlb,posb]=marisa(x3,N(I),M(J));
    
    subplot(2,1,1);
    plot([cumsum(pnl),pos(1:end-1)/20]), title(['1st Half - Coord ',num2str(N(I)),':',num2str(M(J)),' Sharpe= ',num2str(SH(I,J))]);
    subplot(2,1,2);
    plot([cumsum(pnlb),posb(1:end-1)/20]), title(['2nd Half - Coord ',num2str(N(I)),':',num2str(M(J)),' Sharpe= ',num2str(SHb(I,J))]);
    highestSHval = [highestSHval ; N(I) M(J) SH(I,J) SHb(I,J)];
    SH(I,J) = -99;
end