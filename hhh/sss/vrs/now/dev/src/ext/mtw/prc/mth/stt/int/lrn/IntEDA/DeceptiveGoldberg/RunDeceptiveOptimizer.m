function [Max,k,BestSolutions]=RunDeceptiveOptimizer(m,PopSize,T,CantGen,Elitism) 

% RunDeceptiveOptimizer  Calls the  FDA algorithm to optimize the deceptive function with m definition sets. 
% The deceptive function: f(x) = f_d(x_1,x_2,x_3) + f_d(x_4,x_5,x_6) + ...+  f_d(x_{3m-2},x_{3m-1},x_{3m})

% For reference on the  FDA see:
%--- H. Muehlenbein, T. Mahnig, A. Ochoa-Rodríguez (1999) Schemata, Distributions and Graphical Models in Evolutionary Optimization. 
%--- J. Heuristics 5(2): 215-247. 


% INPUTS
% m: Number of definition sets (NumbVar = 3*m)
% PopSize: Population size
% T: Truncation parameter (when T=0, proportional selection is used)
% CantGen: Maximum number of generations
% Elitism: Number of the current population individuals that pass to the next one.  
%---Elistism=-1: The whole selected population (only for truncation) passes to the next generation  



% OUTPUTS
% Max: Maximum value found by the algorithm at each generation
% k: Generation where the maximum was found, case it were known in advance
% BestSolutions: Matrix with the best solution at each generation

% EXAMPLE
% [Max,k,BestSolutions] = RunDeceptiveOptimizer(10,200,0.2,50,1);


NumbVar = 3*m;
Card = 2*ones(1,NumbVar);    
MaximumFunction = m;


% The set of cliques is constructed.  C_1 = (x_1,x_2,x_3), C_2 = (x_4,x_5,x_6),  ..., C_m = (x_{3m-2},x_{3m-1},x_{3m})

for i=1:m
  Cliques(i,1) = 0;  % No overlapping
  Cliques(i,2) = 3;  % Three new variable in each clique
  Cliques(i,3:5) = [i*3-2,i*3-1,i*3]; % These are the variables
end


[Max,k,BestSolutions]=RunFDA(PopSize,NumbVar,T,'evalfuncdec3',CantGen,MaximumFunction,Card,Cliques,Elitism);


    

% Last version 10/10/2005. Roberto Santana (rsantana@si.ehu.es) 

