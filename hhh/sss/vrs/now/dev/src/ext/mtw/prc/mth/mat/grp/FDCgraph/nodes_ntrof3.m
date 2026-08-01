%-----------------------------------------------
% Calculates coordinates for nodes in FDCgraph
% Author: Francisco de Castro (fdcastro@tld.net)
% Nodes in a 3 trophic levels.
%-----------------------------------------------
function [xy]= nodes_ntrof3(a)

nsp= size(a,1);
nniv= zeros(4,1);
plant= [];

for i= 1:nsp 
   a(i,i:nsp)= 0;
end

%Sumando filas y columnas
sfil(1:nsp)= sum(a,1);
scol(1:nsp)= sum(a,2);

%Asignando niveles: plantas y Superpred
for i= 1:nsp
	if scol(i) == 0 nivel(i)= 4; end
   if sfil(i) == 0 nivel(i)= 1; [plant]= [plant i]; end   
end

%Asignando niveles: Herbivor.
for i= 1:size(plant,2)
for j= 1:nsp
	if a(plant(i),j) ~= 0 nivel(j)= 2; end
end
end

%Asignando niveles: los que quedan=> carniv.
for i= 1:nsp
	if nivel(i) == 0 nivel(i)= 3; end
end

%Nspp por nivel
for i= 1:nsp
   nniv(nivel(i))= nniv(nivel(i))+ 1;
end

%Coord. Y de cada especie
for i= 1:nsp
   xy(i,2)= nivel(i)+ (0.4*rand -0.2);
end

%Coord. X de cada especie
for i= 1:4
   z= 1;
   for j= 1:nsp
  	if nivel(j) == i 
		xy(j,1)= z;
     	z= z+1;
	end
	end
end

return
