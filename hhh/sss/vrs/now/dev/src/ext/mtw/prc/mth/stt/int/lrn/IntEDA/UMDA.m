function [Max,k,vector,Stat]=UMDA(PopSize,NumbVar,T,CantGen,MaximumFunction,Card,InitConf,dimsol) 
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
Pop=fix(repmat(Card,PopSize,1).*[rand(PopSize,NumbVar)]); % Poblacion inicial aleatoria
NewPop = Pop;
Cliques = TreeProtein(NumbVar,dimsol); 
 
sizeChain = size(InitConf,2);
%FunVal =  EvalPopChains(Pop,InitConf);

while(k<=CantGen & Max<MaximumFunction) 

   betthan = 0;
   realbest =0;
 Pop=NewPop;
 FunVal =  EvalPopChains(Pop,InitConf);
    %Stat(k+1,:) = FunVal;

%  if(k>0)   
   %    FunValNew =  EvalPopChains(NewPop,InitConf);
  %     for i=1:PopSize
  %      if(FunValNew(i) >= FunVal(i))
  %          eq = (sum(Pop(i,:) == NewPop(i,:)) ==(sizeChain)  || sum(Pop(i,:) == SelPop(1,:)) ==(sizeChain));
   %         if( (FunValNew(i) > FunVal(i)) || ((FunValNew(i) ==   FunVal(i)) & ~eq)) 
   %          [NewPop(i,:),FunValNew(i)] = ProteinLocalOptimizer(InitConf,NewPop(i,:));
   %         betthan = betthan + 1;
    %        realbest = realbest + (FunValNew(i) > FunVal(i));
   %         Pop(i,:) = NewPop(i,:);
    %        FunVal(i) = FunValNew(i);
   %       end     
          
   %     end       
    %   end
  %  end
  %     betthan
  %     realbest
  %     figure 
   %    hist(FunVal,50)
       meanPop = mean(FunVal)     
      
       % Ordering for truncation
       %[Val,Ind]= sort(FunVal);
       %i = PopSize-10;
       i = 1;
  %     while(i<5)         % Val(i)>=10)
       %   [Pop(Ind(i),:),FunVal(Ind(i))] =    ProteinLocalOptimizer(InitConf,Pop(Ind(i),:));
      %    i
        % [Pop(i,:),FunVal(i)] =  ProteinLocalOptimizer(InitConf,Pop(i,:));
      %   i = i+1;     
  %     end


   
      [Val,Ind]= sort(FunVal);

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
     %NewPop(1:10,:)
     auxPop  = IntFDA(Cliques,SelPop,NumbVar,PopSize,Card);
     %NewPop(1:SelPopSize,:) = SelPop;
     %NewPop(1,:) = SelPop(1,:);
     NewPop = Pop;

     cross = fix(NumbVar*rand(1,2))+1;
     cross(1,1:2) = [1,1];
     if cross(1,2) > cross(1,1)
       NewPop(:,cross(1,1):cross(1:2)) =  auxPop(:,cross(1,1):cross(1:2)); 
     elseif cross(1,2) < cross(1,1)
       NewPop(:,cross(1,2):cross(1:1)) =  auxPop(:,cross(1,2):cross(1:1)); 
     else
       NewPop = auxPop;
     end
    % NewPop(1:10,:) = SelPop(1:10,:);
      NewPop(1:SelPopSize,:) = SelPop;
     k=k+1
 end


return
    