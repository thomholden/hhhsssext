AdvancedTIA()

% rand('state',0); -- In case you want to fix the seed; for testing purposes

NumS=100,000;
NumE=3;
NumY=2;

TMaxMx=xlsread('Time_Max_Impact.xls');
MaxImpMx=xlsread('Max_Impact.xls');
TSSMx=xlsread('Time_SteadyState_Impact.xls');
SSImpMx=xlsread('Steady_State_Impact.xls');

ProbOccMx=[];
ProbOccMx(:,:,1)=xlsread('High_Sev.xls');
ProbOccMx(:,:,2)=xlsread('Medium_Sev.xls');
ProbOccMx(:,:,3)=xlsread('Low_Sev.xls');

TMax=[];
MaxImp=[];
TSS=[];
SSIMP=[];
SrMx=[];

SrMx=ones(NumY*12, NumS);

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
                
                SrMx(:,s)=SrMx(:,s).*FracChgVect';
                
            end
     
        end 
    end 
end

load TData % The data we used in the illustrated example (paper)

[net,eTrn,eTst] = NN(timeSeries,numInput,numOutput,hL,lFs,lR,errorGoal,epochs,momentum);
SrMx=GenSrMx(SrMx,net,NumS,NumY);

DrawTIA(NumY,SrMx,timeSeries);