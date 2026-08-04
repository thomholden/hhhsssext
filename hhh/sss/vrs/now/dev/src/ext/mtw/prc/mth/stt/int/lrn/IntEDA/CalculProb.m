function[prob]=CalculProb(Table,Cliques,vector,NumbVar,Card,InitConf)

% Cliques contiene todos los conjuntos de dependencias
% que utilizara el FDA en el paso i-esimo
% Cada fila es un clique, la primera columna es la cant.
% de solapamientos, la segunda es la cantidad de variables
% que no estan solapadas
% Depues vienen las correspondientes variables de los 
% solapamientos y las no solapadas

% Cliques tiene una cantidad de columnas igual a la
% dimension del mayor clique +2, y una cantidad de columnas 
% igual a la cantidad de cliques


% SelPop es la poblacion seleccionada
% NewPop es la nueva poblacion
 
NewPop=0;
NumberCliques = size(Cliques,1);

%%%%%%%%%%%%%%%%%%%%%%  Primer paso  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Se llenan las tablas para todos los cliques 


prob = 1;

for i=1:size(Cliques,1)
  
  aux = Table{i};
  sizeCliqOther = Cliques(i,2);
  sizeCliqSolap = Cliques(i,1);
 
  CliqOther = Cliques(i,Cliques(i,1)+3:Cliques(i,1)+Cliques(i,2)+2);
  AccCardOther = FindAccCard(sizeCliqOther,Card(CliqOther));
  dimOther =   NumconvertCard(Card(CliqOther)-1,sizeCliqOther,AccCardOther)+1;
   k =   NumconvertCard(vector(CliqOther),sizeCliqOther,AccCardOther)+1;
  if(sizeCliqSolap > 0)
    CliqSolap = Cliques(i,3:(Cliques(i,1)+2));
    AccCardSolap = FindAccCard(sizeCliqSolap,Card(CliqSolap));
    dimSolap = 	NumconvertCard(Card(CliqSolap)-1,sizeCliqSolap,AccCardSolap)+1;
    j =   NumconvertCard(vector(CliqSolap),sizeCliqSolap,AccCardSolap)+1;
  else 
    AccCardSolap = [];
    CliqSolap = [];
    dimSolap = 1;
    j = 1;
  end
 
  AllVars = [CliqSolap,CliqOther];
  %vector(AllVars)
  %aux(j,k)
  if aux(j,k)==0
   i
   AllVars
  end
  prob = prob * aux(j,k);
end
