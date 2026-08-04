function[Pos] =  OffFindPos(vector)

%OffFindPos translates the vector of angles to the  positions into the lattice.


% INPUTS
% vector: Sequence of residues ( (H)ydrophobic or (P)olar, respectively represented by zero and one)


% OUTPUTS
% Pos: Matrix of positions Pos(sizechain,2) calculated from the angles

sizeChain = size(vector,2);
Pos = zeros(sizeChain,2);

Pos(1,1) = 0;  %Position for the initial molecule 
Pos(1,2) = 0;
 
Pos(2,1) = 1;  %Position for the second molecule 
Pos(2,2) = 0;

for i=3:sizeChain
 Pos(i,1) = Pos(i-1,1)+cos(vector(i));
 Pos(i,2) = Pos(i-1,2)+sin(vector(i));
end


% Last version 10/09/2005. Roberto Santana (rsantana@si.ehu.es)    