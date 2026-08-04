function[s] =  CallRepair(vector)
% CallRepair modify a sequence configuration to avoid self-intersections

% INPUTS
% vector: Sequence of residues ( (H)ydrophobic or (P)olar, respectively represented by zero and one)

% OUTPUTS
%  s:  Sequence of residues repaired (without self-intersections) 

global InitConf;

sizeChain = size(vector,2);

Pos = zeros(sizeChain,2);

Pos(1,1) = 0;  %Position for the initial molecule 
Pos(1,2) = 0;
 
Pos(2,1) = 1;  %Position for the second molecule 
Pos(2,2) = 0;

  for i=1:sizeChain
   moves(i,:) = randperm(3)-1;
  end
 
 moves = [vector',moves];
 s = [];

[solutionFound,s] = NewRepair(sizeChain,Pos,1,moves,s,vector);

% Last version 10/09/2005. Roberto Santana (rsantana@si.ehu.es) 