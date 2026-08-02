NumS=10000;
NumE=3;
NumY=3;

BaseFr=xlsread('Surprise_Free_Values.xls');
TMaxMx=xlsread('Time_Max_Impact.xls');
MaxImpMx=xlsread('Max_Impact.xls');
TSSMx=xlsread('Time_SteadyState_Impact.xls');
SSImpMx=xlsread('Steady_State_Impact.xls');

ProbOccMx(:,:,1)=xlsread('High_Sev.xls');
ProbOccMx(:,:,2)=xlsread('Medium_Sev.xls');
ProbOccMx(:,:,3)=xlsread('Low_Sev.xls');

for i=1:NumS

    SrMx(:,i)=BaseFr;
    
end

for s=1:NumS

    for e=1:NumE
    
        for y=1:NumY
    
            d=GenerateDegreeSeverity(e,y,ProbOccMx);
            
            if d>0
                
                TMax=TMaxMx(e,d);
                MaxImp=MaxImpMx(e,d);
                TSS=TSSMx(e,d);
                SSImp=SSImpMx(e,d);
               
                m=randint(1,1,[1,12]);
                FracChgVect=ComputeFracChgVect(m,y,NumY,MaxImp,SSImp,TMax,TSS);
                
                SrMx(:,s)=SrMx(:,s)+SrMx(:,s).*FracChgVect';
                
            end
                
        end
        
    end
    
end

DrawTIA(NumY,SrMx,BaseFr);
