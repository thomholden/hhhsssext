%NumbVar = 64;
%InitConf =  [zeros(1,12),1,0,1,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,1,0,1,zeros(1,12)];
%Max = 42;
NumbVar = 20; 
InitConf =  [0,1,0,1,1,0,0,1,0,1,1,0,1,0,0,1,1,0,1,0]; 
Max = 9;  
%NumbVar = 24;
%InitConf =  [0,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,1,1,0,0];   

PopSize = 200;
Card = 3*ones(1,NumbVar);
T = 0.5;
CantGen =1000;
MaximumFunction = 9;
NewB64 = {};
for exp=1:25
 A = [];
 for dimsol=0:5
  %[Max,k,best,Stat]=UMDA(PopSize,NumbVar,T,CantGen,MaximumFunction,Card,InitConf,dimsol);
  [Max,k,best,Stat]=ConstraintUMDA(PopSize,NumbVar,T,CantGen,MaximumFunction,Card,InitConf,dimsol);  
  A = [A,Stat];
 end
 BLocalOpt{exp} = A;
 save NewB64;
end


