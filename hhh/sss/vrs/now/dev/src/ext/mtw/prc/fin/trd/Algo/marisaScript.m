function marisaScript
% script to run over marisa
%clear all
d=load('bund1min');
data=d.data;
N= 10:10:500;
M= 10:5:200;
step=30; %30 minutes intervals
x=data(1:step:end,4);
SH=zeros(length(N),length(M));
SHrow=zeros(1,length(M));
tic
% loop over N,M
parfor ( i=1:length(N) )
    for j = 1:length(M)
        SHrow(j) = sqrt(60*11/step)*marisa(x,N(i),M(j));
    end
    SH(i,:)=SHrow;
    N(i)
end
toc
imagesc(M,N,SH); colorbar
[I,J] = find(SH==max(max(SH)));
figure
sh = sqrt(60*11/step)*marisa(x,N(I),M(J),1);
title(['Sharpe = ',num2str(sh),', N=',num2str(N(I)),', M=',num2str(M(J))])
figure
surf(M,N,SH), shading interp, lighting phong, light