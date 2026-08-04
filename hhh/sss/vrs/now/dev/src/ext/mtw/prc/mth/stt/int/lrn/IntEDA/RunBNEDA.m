function[Max,k,BestSolutions]=RunBNEDA(PopSize,NumbVar,T,F,CantGen,MaximumFunction,Card,Elitism,TypeLearning,MaxParent,epsilon,mwst,star,SCORE) 

% EDA that uses as a probabilistic model a Bayesian network
% Different BN structure learning algorithms are used 
% See BNT structure learning  package for explanation (http://bnt.insa-rouen.fr/ajouts.html)

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
% Elitism: Number of the current population that pass to the next.  
%--- Elistism = -1: The whole selected population (only for truncation) passes to the next generation  
% TypeLearning: Type of method used for learning the Bayesian network
%--- TypeLearning = {'pc','ic','pc_cheng','tree','k2t','greedyt'}; 
%--- [Only methods k2t and tree work at the moment]
%--- pc:  PC algorithm
%--- ic:  IC* latent structure algorithm
%--- pc_cheng:  PC algorithm as improved by Cheng
%--- tree:  MWST based tree algorithm
%--- k2t: K2 algorithm initialized from a tree dag
%--- greedyt: Greedy based search initialized from a tree dag
% MaxParent: Maximum number of parents for the Bayesian Networks or maximum size of the conditioning set for PC
%---MaxParent = 5;
% epsilon: Epsilon value for the probabilistic independence tests 
%--- epsilon=0.05
% mwst: Parameters for the improved PC algorithm (see BNT structure learning package)
%--- mswt = 1;
% star: Parameters for the improved PC algorithm (see BNT structure learning package)
%--- star = 1;
% SCORE: Type of score used by K2 and greedy BN structure learning algorithms.
%--- SCORE = 'bic', SCORE = 'bayesian', SCORE = 'mutual_info'

%PARAMETERS
% cache_size: Size of the cache for optimizing BN learning 
%--- cachesize = 1000; 
%P = genpath('/home/rsantana/Centro/Matlab/BNetwork/FullBNT/');
%path(path,P);
% path(path,'/home/rsantana/Centro/Matlab/WebPage/Depend/IntEDA');


% OUTPUTS
% Max: Maximum value found by the algorithm at each generation
% k: Generation where the maximum was found, case it were known in advance
% BestSolutions: Matrix with the best solution at each generation


% EXAMPLE
% For examples see functions RunUMDA and RunMarkovFDA
% [Max,k,BestSolutions]=RunBNEDA(300,20,0.5,'sum',30,20,2*ones(1,20),-1,'greedyt',5,0.05,1,1,'bic') 

cachesize = 1000;
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



       [bnet] = LearnBN(NumbVar,Card,SelPop',TypeLearning,MaxParent,epsilon,mwst,star,SCORE,cachesize);        
        % At the same step the parameters of the model are learned and the new population is sampled from the model   
        NewPop  = cell2num(SampleBN(bnet,PopSize));
        
 
      % The best solutions of the selected populations pass to the new population 
      if(Elitism==-1 & T>0)
        NewPop(1:SelPopSize,:) = SelPop;
      elseif(Elitism>0)    
        NewPop(1:Elitism,:) = SelPop(1:Elitism,:);
      end,   
     k=k+1
 end


return
    

% Last version 9/26/2005. Roberto Santana (rsantana@si.ehu.es) 