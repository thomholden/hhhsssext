function [Max,k,BestSolutions]=RunMarkovFDA(PopSize,NumbVar,T,F,CantGen,MaximumFunction,Card,Elitism,dim) 

% Markov (chain-shaped model) FDA where each variable depends on the previous dim variables       

% INPUTS
% PopSize: Population size
% NumbVar: Number of variables
% T: Truncation parameter (when T=0, proportional selection is used)
% F: Name of the function that has as an argument a vector or NumbVar variables
% CantGen: Maximum number of generations 
% MaximumFunction:  Maximum of the function that can be used as stop condition when it is known 
% Card: Vector with the dimension of all the variables. 
% Elitism: Number of the current population that pass to the next.  
%----Elistism=-1: The whole selected population (only for truncation) passes to the next generation  
% dim: Number of previous variables each variable depends on 
%----For dim=0 we have the UMDA case

% OUTPUTS
% Max: Maximum value found by the algorithm at each generation
% k: Generation where the maximum was found, case it were known in advance
% BestSolutions: Matrix with the best solution at each generation

% EXAMPLE
% [Max,k,BestSolutions]=RunMarkovFDA(300,20,0.5,'sum',30,20,2*ones(1,20),-1,2);


% The markovian structure of the model is stored in Cliques
Cliques = CreateMarkovModel(NumbVar,dim);

% FDA is invoked
[Max,k,BestSolutions]=RunFDA(PopSize,NumbVar,T,F,CantGen,MaximumFunction,Card,Cliques,Elitism); 

return
    

% Last version 9/26/2005. Roberto Santana (rsantana@si.ehu.es) 