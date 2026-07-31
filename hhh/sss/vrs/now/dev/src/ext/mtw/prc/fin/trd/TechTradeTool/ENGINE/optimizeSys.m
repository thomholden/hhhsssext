function [bestPerf, opt1, opt2]=optimizeSys(st, tsIn, lobIdays1, upbIdays1, lobIdays2, upbIdays2);

% tsIn=st.close;

% , lobIdays3, upbIdays3, lobIdays4, upbIdays4

% lobIdays1=10;
% upbIdays1=40;
% 
% lobIdays2=10;
% upbIdays2=40;

i=0;
col=(upbIdays1-lobIdays1+1)*(upbIdays2-lobIdays2+1);
perf_mtx=zeros(1,col);
opt1_mtx=zeros(1,col);
opt2_mtx=zeros(1,col);
       
for idays1=lobIdays1:upbIdays1
    for idays2=lobIdays2:upbIdays2
        [tsSysOut] = sysDimbeta (st, tsIn, idays1, idays2);
%          [tsSysOut, validFromOut] = sysDimbeta (st.close,100, 50);
         [performance,plCalcTable] = sysPerfOpt (tsSysOut);
       i=i+1;
       disp(i);
       perf_mtx(i)=performance;
       opt1_mtx(i)=idays1;
       opt2_mtx(i)=idays2;
   end
end

% bestPerf=zeros(1);
% [r c]=size(perf_mtx);
% bestPerf=max(perf_mtx);
% bestLine=0;
% 
% for j=1:c
%     if perf_mtx(j)==bestPerf
%         bestLine=j;
%     end
% end
% 
% opt1=opt1_mtx(bestLine);
% opt2=opt2_mtx(bestLine);
% disp(bestLine);
% 
[bestPerf, i]=max(perf_mtx);

opt1=opt1_mtx(i);
opt2=opt2_mtx(i);
% disp(i);