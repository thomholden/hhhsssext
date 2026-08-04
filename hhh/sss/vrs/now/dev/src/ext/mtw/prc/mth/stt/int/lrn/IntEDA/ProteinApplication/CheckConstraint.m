function[Overlappings,Pos] =  CheckConstraint(Pos,pos,vector)
% Given the configuration of residues, calculates the number of 
% Overlappings  that the  addition of move mov at position pos provokesn



global InitConf;


Overlappings = 0;
if(pos < 3)
 return;
end

 [Pos] = PutMoveAtPos(Pos,pos,vector(pos));
  
   for j=1:pos-2,   % Check for Overlappings and Collissions in all the    molecules except the previous one
    if(Pos(pos,1)==Pos(j,1) & Pos(pos,2)==Pos(j,2))
      Overlappings = Overlappings + 1;
    end
   end
  
% Last version 10/09/2005. Roberto Santana (rsantana@si.ehu.es) 