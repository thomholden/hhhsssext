function[Pos] =  PrintProtein(vector)
% PrintProtein prints the configuration encoded by vector


% INPUTS
% vector: Sequence of residues ( (H)ydrophobic or (P)olar, respectively represented by zero and one)

% OUTPUTS
% Pos:    Position of the residues 


global InitConf;

[Collisions,Overlappings,Pos] =  EvalChain(vector);

sizeChain = size(InitConf,2);

figure
hold on
for i=1:sizeChain
 if(InitConf(i) == 0)
   plot(Pos(i,1),Pos(i,2),'*');
 else
   plot(Pos(i,1),Pos(i,2),'o');
 end  
end
 plot(Pos(:,1),Pos(:,2),'b-');


% Last version 10/09/2005. Roberto Santana (rsantana@si.ehu.es) 