function[Table]=FindProb(Cliques,SelPop,NumbVar,N,Card,InitConf)

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
NumberCliques = size(Cliques,1)

%%%%%%%%%%%%%%%%%%%%%%  Primer paso  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Se llenan las tablas para todos los cliques 



for i=1:size(Cliques,1)

  sizeCliqOther = Cliques(i,2);
  sizeCliqSolap = Cliques(i,1);

  CliqOther = Cliques(i,Cliques(i,1)+3:Cliques(i,1)+Cliques(i,2)+2);
  AccCardOther = FindAccCard(sizeCliqOther,Card(CliqOther));
  dimOther =   NumconvertCard(Card(CliqOther)-1,sizeCliqOther,AccCardOther)+1;

  if(sizeCliqSolap > 0)
    CliqSolap = Cliques(i,3:(Cliques(i,1)+2));
    AccCardSolap = FindAccCard(sizeCliqSolap,Card(CliqSolap));
    dimSolap =   NumconvertCard(Card(CliqSolap)-1,sizeCliqSolap,AccCardSolap)+1;
    aux=zeros(dimSolap,dimOther);
  else 
    AccCardSolap = [];
    CliqSolap = [];
    aux=zeros(1,dimOther);
    dimSolap = 1;
  end
   
  AllVars = [CliqSolap,CliqOther];

 
 for j=1:dimSolap
    if (sizeCliqSolap>0) 
      solapval = IndexconvertCard(j-1,sizeCliqSolap,AccCardSolap);
    else
      solapval=[];
    end

    for k=1:dimOther
     auxSelPop=SelPop(:,[CliqSolap,CliqOther]);
     otherval =  IndexconvertCard(k-1,sizeCliqOther,AccCardOther);
     allvarvalues = [solapval,otherval];
    
     if(size(allvarvalues,2)==1)
       aux(j,k) =  sum((auxSelPop==repmat(allvarvalues,size(SelPop,1),1))');
     else 
       aux(j,k)=sum( sum((auxSelPop==repmat(allvarvalues,size(SelPop,1),1))') == size(allvarvalues,2)); 
     end
    end 
     %aux(j,:) = (aux(j,:)+1)/(sum(aux(j,:))+dimOther); % Laplace     Estimator
     if (sum(aux(j,:))>0)
          aux(j,:) = (aux(j,:))/(sum(aux(j,:))); 
     end
  end
 %aux=aux/sum(sum(aux)); % Normalization
 
 
 % En Table i se guardan las probabilidades del clique i

 Table{i} =aux;
         
end
