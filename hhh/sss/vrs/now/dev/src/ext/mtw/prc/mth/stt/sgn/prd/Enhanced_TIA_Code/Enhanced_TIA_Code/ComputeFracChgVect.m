function[out]=ComputeFracChgVect(m,y,NumY,MaxImp,SSImp,TMax,TSS)

FracChgVect=[];
NumM=NumY*12;
Idx=(y-1)*12+m;
FracChgVect(1:Idx)=0;

FracChgVect(Idx:min(NumM,Idx+TMax))=MaxUpdate(Idx,MaxImp,TMax,NumY);

if NumM>Idx+TMax

    FracChgVect(Idx+TMax:min(NumM,Idx+TSS))=SSUpdate(Idx,MaxImp,TMax,SSImp,TSS,NumY);
    
end

if NumM>Idx+TSS

    FracChgVect(Idx+TSS:NumM)=SSImp;
    
end

out=FracChgVect;








