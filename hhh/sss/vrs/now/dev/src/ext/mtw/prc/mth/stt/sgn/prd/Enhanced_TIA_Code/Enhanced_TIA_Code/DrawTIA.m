function[out]=DrawTIA(NumY,SrMx,BaseFr)

history=xlsread('Historical_Values.xls')';

med=[];
p5=[];
p95=[];

for i=1:(NumY*12) 
    
    med(i)=median(SrMx(i,:));
    p95(i)=prctile(SrMx(i,:),95);
    p5(i)=prctile(SrMx(i,:),5);
    
end

generalmat=[];

generalmat(1,:)=[history BaseFr'];
generalmat(2,:)=[history med];
generalmat(3,:)=[history p5];
generalmat(4,:)=[history p95];

plot(generalmat') 
