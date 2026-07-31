function btestPar
%% a 3 parameter version of lead/lag backtest
% we look intraday to see if we can improve.

%% load data from the database
% dates range from 37879 to 39162 (15/9/02 to 21/03/07)
%data = getdatafromdb('Bund');
d = load('bund1min');
data=d.data;
lenData = length(data);
tic
%% backtest over the period, and N,M
p=[1,2,5,10,15,20,25,30,45,60:10:180,240,480];
N=5:5:95;
M= N+5;
SH = zeros(length(p),length(N),length(N));
tic
parfor ( j=1:length(N) )
    ShRowPage=zeros(length(N),length(N));
    for i=1:length(p)
        xsamp = data(1:p(i):lenData,4);
        SHrow = zeros(1,length(N));
        for k=j:length(M)
            % run the model
            [pos,pnl,sh] = leadlag(xsamp,N(j),M(k));
            % update the sharpes ratio
            SHrow(k) = sh*sqrt(60*11/p(i));
            %SH(i,j,k) = sh*sqrt(60*11/p(i));
        end
        ShRowPage(i,:)=SHrow;
    end
    SH(:,j,:)=ShRowPage;
end
toc
%% now plot using isosurface
[PP,NN,MM] = ndgrid(p,N,N);
macross3DFig(PP,NN,MM,SH);
save macross3ddata PP NN MM SH