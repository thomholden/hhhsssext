function [bestPerf, opt1, opt2, opt3, opt4]=optimizeSys2(menuIn, st, tsIn, lobIdays1, upbIdays1, lobIdays2, upbIdays2, lobIdays3, upbIdays3, lobIdays4, upbIdays4);

global hStat bGoOnOptimizing 

bGoOnOptimizing = 1;


% tsIn=st.close;

% , lobIdays3, upbIdays3, lobIdays4, upbIdays4

% lobIdays1=10;
% upbIdays1=40;
% 
% lobIdays2=10;
% upbIdays2=40;

i=0;
col=(upbIdays1-lobIdays1+1)*(upbIdays2-lobIdays2+1)*(upbIdays3-lobIdays3+1)*(upbIdays4-lobIdays4+1);
perf_mtx=zeros(1,col);
opt1_mtx=zeros(1,col);
opt2_mtx=zeros(1,col);
opt3_mtx=zeros(1,col);
opt4_mtx=zeros(1,col);
      
for idays1=lobIdays1:upbIdays1
    for idays2=lobIdays2:upbIdays2
        for idays3=lobIdays3:upbIdays3
            for idays4=lobIdays4:upbIdays4

        %[tsSysOut] = sysDimbeta (st, tsIn, idays1, idays2);
        
                if (menuIn==1)
                    [tsSysOut] = sysDimbeta(st, tsIn, idays1, idays2);
                end
                if (menuIn==2)
                    [tsSysOut] = sysDimbetaStoh(st, tsIn, idays1, idays2, idays3, idays4);
                end                 
                if (menuIn==3)
                    [tsSysOut] = sysDimbetaStCr(st, tsIn, idays1, idays2, idays3, idays4);
                end                
                if (menuIn==4)
                    [tsSysOut] = sysStDimbetaCr(st, tsIn, idays1, idays2, idays3, idays4);
                end 
                
                i = i+1;
                [performance,plCalcTable] = sysPerfOpt (tsSysOut);
                perf_mtx(i)=performance;
                opt1_mtx(i)=idays1;
                opt2_mtx(i)=idays2;
                opt3_mtx(i)=idays3;
                opt4_mtx(i)=idays4;
           
            
                %display progress bar
                set (hStat, 'String', [num2str(i) ' / ' num2str(col)]); 
                drawnow;    
                if (bGoOnOptimizing == 0)
                    set (hStat, 'String', 'Optimization stopped by the user');
                    return;
                end    
            end
        end
    end
end

[bestPerf, i]=max(perf_mtx);

opt1=opt1_mtx(i);
opt2=opt2_mtx(i);
opt3=opt3_mtx(i);
opt4=opt4_mtx(i);

set (hStat, 'String', 'Optimization completted');            
