function [Max,k,BestSolutions]=RunFDA(PopSize,NumbVar,T,F,CantGen,MaximumFunction,Card,Cliques,Elitism) 

% FDA implementation for discrete values.
% The structure of the probabilistic model is given       

% INPUTS
% PopSize: Population size
% NumbVar: Number of variables
% T: Truncation parameter (when T=0, proportional selection is used)
% F: Name of the function that has as an argument a vector or NumbVar variables
% CantGen: Maximum number of generations 
% MaximumFunction:  Maximum of the function that can be used as stop condition when it is known 
% Card: Vector with the dimension of all the variables. 
% Cliques: Structure of the model in a list of cliques that defines the junction graph. 
%---Each row of Cliques is a clique. The first value is the number of overlapping variables. 
%---The second, is the number of new variables.
%---Then, overlapping variables are listed and  finally new variables are listed.
% Elitism: Number of the current population individuals that pass to the next one.  
%---Elistism=-1: The whole selected population (only for truncation) passes to the next generation  


% OUTPUTS
% Max: Maximum value found by the algorithm at each generation
% k: Generation where the maximum was found, case it were known in advance
% BestSolutions: Matrix with the best solution at each generation

% EXAMPLE

% For examples see functions RunUMDA and RunMarkovFDA



Max=0;
k = 1;

% Random initial population 
Pop=fix(repmat(Card,PopSize,1).*[rand(PopSize,NumbVar)]);  


NewPop = Pop;


while( (k==1) | (k<=CantGen & Max(k-1)<MaximumFunction) ) 
      
       Pop=NewPop;
       
       % Population is evaluated using function F 
       for i=1:PopSize
        FunVal(i) = feval(F,Pop(i,:));
       end
       
       % Solutions are sorted according to the function value 
       [Val,Ind]= sort(FunVal);
  
       Max(k) = Val(PopSize);   %Maximum value of the population
       BestSolutions(k,:) = Pop(Ind(PopSize),:); % Best solution 

       
       if T==0   
         %Proportional selection is applied
         [Index]=PropSelection(PopSize,FunVal);
         SelPop=Pop(Index,:);       
       else 
         % Truncation selection is applied
         SelPopSize = floor(T*PopSize);
         SelPop=Pop(Ind(PopSize:-1:PopSize-SelPopSize+1),:);       
       end   

  
       % At the same step the parameters of the model are learned and the new population is sampled from the model   
        NewPop  = IntFDA(Cliques,SelPop,NumbVar,PopSize,Card);
 
      % The best solutions of the selected populations pass to the new population 
      if(Elitism==-1 & T>0)
        NewPop(1:SelPopSize,:) = SelPop;
      elseif(Elitism>0)    
        NewPop(1:Elitism,:) = SelPop(1:Elitism,:);
      end,   
     k=k+1;
 end


return
    

% Last version 9/26/2005. Roberto Santana (rsantana@si.ehu.es) 