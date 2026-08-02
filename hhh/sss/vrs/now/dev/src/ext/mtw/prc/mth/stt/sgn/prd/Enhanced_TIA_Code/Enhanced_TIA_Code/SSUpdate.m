function[out]=SSUpdate(Idx,MaxImp,TMax,SSImp,TSS,NumY)

FracChgVectSS=[];
NumM=NumY*12;

if MaxImp==SSImp
    
    FracChgVectSS(1:min(NumM,Idx+TSS)-(Idx+TMax)+1)=SSImp;
    
else 

    for i=1:min(NumM,Idx+TSS)-(Idx+TMax)+1
        
        FracChgVectSS(i)=MaxImp-SSImp/TSS*i;
        
    end
    
end
    
out=FracChgVectSS;




