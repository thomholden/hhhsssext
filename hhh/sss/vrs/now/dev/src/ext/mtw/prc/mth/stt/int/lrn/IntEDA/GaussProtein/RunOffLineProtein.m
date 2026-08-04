function[Max,k,BestSolutions] = RunOffLineProtein(Fibbonacci_n,PopSize,T,CantGen,Elitism)

% RunOffLineProtein. Calls the  Gaussian UMDA to find the HP model with minimum energy in an offline lattice
% The sequence is the Fibbonacci sequence built from the input parameter      
% For reference on the Offline HP model see:
%-- H. P. Hsu, V. Mehra and  P. Grassberger (2003)  Structure optimization in an off-lattice protein model.
%-- Phys Rev E Stat Nonlin Soft Matter Phys. 2003 Sep;68(3 Pt 2):037703. Epub 2003 Sep 30. 
%-- http://scitation.aip.org/getabs/servlet/GetabsServlet?prog=normal&id=PLEEE8000068000003037703000001&idtype=cvips&gifs=yes   
   
   

% INPUTS
% Fibbonacci_n: Value n for the construction of the Fibbonacci sequence. NumbVar = F(n)
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
% [Max,k,BestSolutions] = RunOffLineProtein(6,100,0.5,500,1); 
% In this example the Gaussian UMDA will search for the optimal  position  of a chain with 13 residues (F(6) = 13).

global InitConf;

% The sequence of residues is initialized
InitConf = CreateFibbInitConf(Fibbonacci_n);
NumbVar = size(InitConf,2);

% Gaussian UMDA search the set of angles that determines the best optimal energetic configuration of the sequence in the lattice
% Each continuous variable takes values in the interval [0,2*pi].
% The MaximumValue for the algorithm is arbitrarily set.

[Max,k,BestSolutions] = RunGaussianEDA(PopSize,NumbVar,T,'OffEvalProtein',CantGen,NumbVar,[zeros(1,NumbVar);2*pi*ones(1,NumbVar)],0,0,Elitism); 

% The best solution found is printed

 OffPrintProtein(BestSolutions(k-1,:));


% Last version 10/09/2005. Roberto Santana (rsantana@si.ehu.es)   