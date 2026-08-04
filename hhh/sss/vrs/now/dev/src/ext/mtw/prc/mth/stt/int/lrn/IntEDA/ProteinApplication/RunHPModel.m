function [Max,k,BestSolutions]=RunHPModel(PopSize,T,CantGen,Elitism,dim) 


% RunHPModel  Calls the  Markov EDA to find the HP model with minimum energy in 2-d lattice
% The sequence is in InitConf and can be modified by the user      

% For reference on the  HP model see:
%--- R. Santana, P. Larrañaga, and J. A. Lozano (2004) Protein folding in 2-dimensional lattices with estimation of distribution algorithms. 
%--- In Proceedings of the First International Symposium on Biological and Medical Data Analysis, 
%--- Volume 3337 of Lecture Notes in Computer Science, pages 388-398, Barcelona, Spain, 2004. Springer Verlag. 


% INPUTS
% PopSize: Population size
% T: Truncation parameter (when T=0, proportional selection is used)
% CantGen: Maximum number of generations
% Elitism: Number of the current population individuals that pass to the next one.  
%---Elistism=-1: The whole selected population (only for truncation) passes to the next generation  
% dim: Number of previous variables each variable depends on 
%----For dim=0 we have the UMDA case 


% OUTPUTS
% Max: Maximum value found by the algorithm at each generation
% k: Generation where the maximum was found, case it were known in advance
% BestSolutions: Matrix with the best solution at each generation

% EXAMPLE
% [Max,k,BestSolutions] = RunHPModel(300,0.2,50,1,1);

global InitConf;

% This is the protein sequence to be embedded in the lattice. It must be changed
InitConf =  [zeros(1,12),1,0,1,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,1,1,0,0,1,1,0,0,1,1,0,1,0,1,zeros(1,12)]; 


NumbVar = size(InitConf,2);
Card = 3*ones(1,NumbVar);    
MaximumFunction = 2*NumbVar;

[Max,k,BestSolutions]=RunMarkovFDA(PopSize,NumbVar,T,'EvaluateEnergy',CantGen,MaximumFunction,Card,Elitism,dim) 


[Pos] =  PrintProtein(BestSolutions(k-1,:));
    

% Last version 10/09/2005. Roberto Santana (rsantana@si.ehu.es) 

