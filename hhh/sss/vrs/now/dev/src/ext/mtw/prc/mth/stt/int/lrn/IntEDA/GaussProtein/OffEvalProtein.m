function[eval] =  OffEvalProtein(vector)

% OffEvalProtein evaluates calculate the energy corresponding to the sequence lattice configuration determined by the lattice in vector.
% Fixing the lengths of the edges, each angle defines the position of the next residue respective the two previous ones.  
% From the residues positions, the interaction energies are calculated by the energy function    
% For reference on the Offline HP model see:
%-- H. P. Hsu, V. Mehra and  P. Grassberger (2003)  Structure optimization in an off-lattice protein model.
%-- Phys Rev E Stat Nonlin Soft Matter Phys. 2003 Sep;68(3 Pt 2):037703. Epub 2003 Sep 30. 
%-- http://scitation.aip.org/getabs/servlet/GetabsServlet?prog=normal&id=PLEEE8000068000003037703000001&idtype=cvips&gifs=yes   
   

% INPUTS
% vector: Sequence of residues ( (H)ydrophobic or (P)olar, respectively represented by zero and one)


% OUTPUTS
% eval: Energy evaluation.


% InitConf has been initialized with a Fibbonacci sequence by the RunOffLineProtein.m routine 

global InitConf;


% The position of the sequence in the latticce are calculated

[Pos] =  OffFindPos(vector);  

sizeChain = size(InitConf,2);


% See reference for the calculation of the energy function

totcos = 0;

% Cosine part of the evaluation
for i=1:sizeChain-1,
 totcos = totcos + (1-cos(vector(i)));
end


% Distance part of the evaluation

totAB = 0;

for i=1:sizeChain-2,
 for j=i+2:sizeChain,
  dist = sqrt ((Pos(i,1) - Pos(j,1))^2 +  (Pos(i,2) - Pos(j,2))^2);
  if (InitConf(i)==1 & InitConf(j)==1) 
       ABeffect = 1;
  elseif (InitConf(i)==0 & InitConf(j)==0) 
       ABeffect = 0.5;
  else
       ABeffect = -0.5;
  end
  totAB = totAB + (1/(dist^12) - ABeffect/(dist^6));
 end
end

eval = -1.0*(totcos*0.25 + totAB*4); 


% Last version 10/09/2005. Roberto Santana (rsantana@si.ehu.es)   