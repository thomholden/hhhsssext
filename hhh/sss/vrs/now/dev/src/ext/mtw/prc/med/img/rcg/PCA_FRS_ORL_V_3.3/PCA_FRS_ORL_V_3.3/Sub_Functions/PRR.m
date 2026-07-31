function [Precision,Recall]= PRR(ns,TsNum,outd,recd);
TI=zeros(1,ns);
for i=1:ns
    TI(i)=length(find(recd==i));
    if (TI(i)==0)
        TI(i)=Inf;
    end
end
k=0;
CI=zeros(1,ns);
for i=1:ns
for j=1:TsNum
    k=k+1;
    if (recd(k)==outd(k))
    CI(i)=CI(i)+1;
    end
end
end

TA=TsNum*ones(1,ns);

CM=[TA' TI' CI'];   % [Total Absolute;; Total Identified;; Correctly Identified]
Precision=CI./TI;   % [Correctly Identified/Total Identified]
Recall=CI./TA;      % [Correctly Identified/Total Identified]
% plot(Precision)
% hold on
% plot(Recall,'r')