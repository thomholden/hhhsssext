function[NewPop] = SampleBN(bnet,PopSize)  
% Creates the structure of a junction tree where each variable
% depends on its dim previous variables 

% INPUTS
% NumbVar: Number of variables
% dim: Number of previous variables each variables depends on 

% OUTPUTS
% Cliques: Structure of the model in a list of cliques that defines the (chain shaped)  junction tree. 
%---Each row of Cliques is a clique. The first value is the number of overlapping variables. 
%---The second, is the number of new variables.
%---Then, overlapping variables are listed and  finally new variables are listed.

for i=1:PopSize
 NewPop(i,:) = sample_bnet(bnet);
end
 
% Last version 9/27/2005. Roberto Santana (rsantana@si.ehu.es) 