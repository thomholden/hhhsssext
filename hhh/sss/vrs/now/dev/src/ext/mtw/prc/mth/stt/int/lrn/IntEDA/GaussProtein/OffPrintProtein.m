function[] =  OffPrintProtein(vector)

% OffPrintProtein prints the configuration encoded by vector
% Fixing the lengths of the edges, each angle defines the position of the next residue respective the two previous ones.    
% For reference on the Offline HP model see:
%-- H. P. Hsu, V. Mehra and  P. Grassberger (2003)  Structure optimization in an off-lattice protein model.
%-- Phys Rev E Stat Nonlin Soft Matter Phys. 2003 Sep;68(3 Pt 2):037703. Epub 2003 Sep 30. 
%-- http://scitation.aip.org/getabs/servlet/GetabsServlet?prog=normal&id=PLEEE8000068000003037703000001&idtype=cvips&gifs=yes   

% INPUTS
% vector: Sequence of residues ( (H)ydrophobic or (P)olar, respectively represented by zero and one)


% InitConf has been initialized with a Fibbonacci sequence by the RunOffLineProtein.m routine 
global InitConf;


% OffFindPos translates the vector of angles to the  positions into the lattice.
[Pos] =  OffFindPos(vector);

sizeChain = size(InitConf,2)

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
