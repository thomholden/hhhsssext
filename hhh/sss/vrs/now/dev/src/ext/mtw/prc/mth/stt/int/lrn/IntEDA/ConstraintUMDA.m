function [Max,k,vector,Stat]=ConstraintUMDA(PopSize,NumbVar,T,CantGen,MaximumFunction,Card,InitConf,dimsol) 
% PopSize: Population size
% NumbVar: Number of variables
% T: Truncation value (cuando T=0, entonces es seleccion proporcional)
% CantGen: Number of generations
% MaximumFunction: Maximum value of the function, to be used as stop criterion
% Max: Maximum found by the algorithm
% k: Generation where the optimum was found
% Allunivar: Univariate prob. matrix until generation k.

close all
Max=0;
k = 0
%Pop=fix(repmat(Card,PopSize,1).*[rand(PopSize,NumbVar)]); % Poblacion inicial aleatoria

for i=1:PopSize,
 [Pop(i,:)] = CallBackTracking(InitConf);
end
 
NewPop = Pop;

Cliques = TreeProtein(NumbVar,dimsol); 
 
sizeChain = size(InitConf,2);

FunVal =  EvalPopChains(Pop,InitConf);

Stat = zeros(CantGen+1,PopSize);
toteval = 0;
while(k<=CantGen & Max<MaximumFunction) 

   betthan = 0;
   realbest =0;
Pop=NewPop;
%FunVal =  EvalPopChains(Pop,InitConf);

    Stat(k+1,:) = FunVal;

%  if(k>0)   
%       FunValNew =  EvalPopChains(NewPop,InitConf);
%       for i=1:PopSize
%        if(FunValNew(i) >= FunVal(i))
%            eq = (sum(Pop(i,:) == NewPop(i,:)) ==(sizeChain)  || sum(Pop(i,:) == SelPop(1,:)) ==(sizeChain));
%            if( (FunValNew(i) > FunVal(i)) || ((FunValNew(i) ==   FunVal(i)) & ~eq)) 
%            [NewPop(i,:),FunValNew(i)] = ProteinLocalOptimizer(InitConf,NewPop(i,:));
%            betthan = betthan + 1;
%            realbest = realbest + (FunValNew(i) > FunVal(i));
%            Pop(i,:) = NewPop(i,:);
%            FunVal(i) = FunValNew(i);
%          end     
          
%        end       
%      end
%    end
%       betthan
%       realbest
     %  figure 
     %  hist(FunVal,50)
           
      
       % Ordering for truncation
       [Val,Ind]= sort(FunVal);
       if(k==0) Est = 0;
       else Est = SelPopSize;
       end
       i = 1;
          while(i<=PopSize-Est) 
          %eval_local = 1;
          [Pop(Ind(i),:),FunVal(Ind(i)),eval_local] =   ProteinLocalOptimizer(InitConf,Pop(Ind(i),:));
    
           toteval = toteval + eval_local;
          %[Pop(i,:),FunVal(i)] =  ProteinLocalOptimizer(InitConf,Pop(i,:));
           i = i+1;
          end
   
      [Val,Ind]= sort(FunVal);
      meanPop = mean(FunVal) 

      Val(PopSize:-1:PopSize-10)
       %PrintProtein(InitConf,Pop(Ind(PopSize),:));       
       Max=Val(PopSize)
       vector = Pop(Ind(PopSize),:);
     if T==0   
       %The new population is selected according proportional selection
       [Index]=PropSelection(PopSize,FunVal);
       SelPop=Pop(Index,:);
     else 
       %The new population is selected according truncation  selection
       SelPopSize = floor(T*PopSize);
       SelPop=Pop(Ind(PopSize:-1:PopSize-SelPopSize+1),:);
     end   

   % Marginal probabilities are found
     P = (1/size(SelPop,1))* ones(size(SelPop,1),1);
    
     %[Table] = CreateUnivProbModel(NumbVar,SelPop,P,Card);
     %auxPop = SampleUnivProbModel(NumbVar,Table,PopSize);
     %perm = randperm(NumbVar);
     %NewPop = Pop;
     %NewPop(:,perm(1:16)) = auxPop(:,perm(1:16)); 
     %NewPop = SampleUnivProbModel(NumbVar,Table,PopSize);
     %NewPop(1:SelPopSize,:) = SelPop;
     %NewPop(1,:) = SelPop(1,:);
     %auxPop  = IntFDA(Cliques,SelPop,NumbVar,PopSize,Card);
     %auxPop  = IntFDAConstraint(Cliques,SelPop,NumbVar,PopSize,Card,InitConf);
     %NewPop(1:SelPopSize,:) = SelPop;
     %NewPop(1,:) = SelPop(1,:);
     %NewPop = Pop;
   
     %NewPop  = IntFDAConstraint(Cliques,SelPop,NumbVar,PopSize,Card,InitConf);
     %for i=SelPopSize+1:PopSize,
     % [NewPop(i,:)] = CallRepair(InitConf,auxPop(i,:));
     %end
 
    % NewPop(1:10,:) = SelPop(1:10,:);

     FunVal(1,(PopSize-SelPopSize)+1:PopSize) = Val(1,(PopSize-SelPopSize)+1:PopSize);
     NewPop((PopSize-SelPopSize)+1:PopSize,:) = SelPop;
     NewPop(1:(PopSize-SelPopSize),:)  = IntFDAConstraint(Cliques,SelPop,NumbVar,PopSize-SelPopSize,Card,InitConf); 	 
     FunVal(1,1:(PopSize-SelPopSize)) =  EvalPopChains(NewPop(1:(PopSize-SelPopSize),:),InitConf);
     k=k+1
 end

Stat(CantGen+1,PopSize) = toteval;

return
    

%vector = [0,0,1,2,1,2,0,2,1,0,1,1,0,0,1,0,1,1,1,2];
