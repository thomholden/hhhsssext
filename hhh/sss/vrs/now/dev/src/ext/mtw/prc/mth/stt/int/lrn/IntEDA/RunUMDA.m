function [Max,k,BestSolutions]=RunUMDA(PopSize,NumbVar,T,F,CantGen,MaximumFunction,Card,Elitism) 

% UMDA implementation for discrete values.
       

% INPUTS
% PopSize: Population size
% NumbVar: Number of variables
% T: Truncation parameter (when T=0, proportional selection is used)
% F: Name of the function that has as an argument a vector or NumbVar variables
% CantGen: Maximum number of generations 
% MaximumFunction:  Maximum of the function that can be used as stop condition when it is known 
% Card: Vector with the dimension of all the variables. 
% Cliques: Structure of the model in a list of cliques that defines the junction graph
% Elitism: Number of the current population that pass to the next.  Elistism=-1: The whole selected population (only for truncation) passes to the next generation  


% OUTPUTS
% Max: Maximum value found by the algorithm at each generation
% k: Generation where the maximum was found, case it were known in advance
% BestSolutions: Matrix with the best solution at each generation

% EXAMPLE
%[Max,k,BestSolutions]=RunUMDA(300,20,0.5,'sum',30,20,2*ones(NumbVar,1),-1);


% The independent structure of the model is stored in Cliques
Cliques = [zeros(NumbVar,1),ones(NumbVar,1),[1:NumbVar]'];

% FDA is invoked
[Max,k,BestSolutions]=RunFDA(PopSize,NumbVar,T,F,CantGen,MaximumFunction,Card,Cliques,Elitism); 

return
    

% Last version 9/26/2005. Roberto Santana (rsantana@si.ehu.es) 