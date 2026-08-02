function[out]=MaxUpdate(Idx,MaxImp,TMax,NumY)

FracChgVectMax=[];
NumM=NumY*12;

if TMax==0
    
    FracChgVectMax=MaxImp;
    
else 

    for i=1:min(NumM,Idx+TMax)-Idx+1
        
        FracChgVectMax(i)=MaxImp/TMax*i;
        
    end
    
end
    
out=FracChgVectMax;



