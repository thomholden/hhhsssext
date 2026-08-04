function[NewPop]=IntFDA(Cliques,SelPop,NumbVar,N,Card)


% IntFDA contains the learning and sampling steps of the RunFDA 
% The structure of the probabilistic model is given       

% INPUTS
% Cliques: Structure of the model in a list of cliques that defines the junction graph. 
%---Each row of Cliques is a clique. The first value is the number of overlapping variables. 
%---The second, is the number of new variables.
%---Then, overlapping variables are listed and  finally new variables are listed.
% SelPop: Selected population 
% NumbVar: Number of variables
% N: Size of the new population
% Card: Vector with the dimension of all the variables. 


% OUTPUTS
% NewPop: New population with N individuals
 
NewPop=0;
NumberCliques = size(Cliques,1);


%%%%%%%%%%%%%%%%%%%%%%  First step  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The tables of all the cliques are filled  


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
     aux(j,:) = (aux(j,:)+1)/(sum(aux(j,:))+dimOther); % Laplace Estimator
  end
 %aux=aux/sum(sum(aux)); % Normalization
 
 
 % En Table i se guardan las probabilidades del clique i

 eval(['Table',num2str(i),'=aux;']);
         
end


%%%%%%%%%%%%%%%%%%%%%%  Second step  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % From the tables, the new population is generated

  NewPop=zeros(N,NumbVar);

 for i=1:NumberCliques
   eval(['aux=Table',num2str(i),';']);    
   

  sizeCliqOther = Cliques(i,2);
  sizeCliqSolap = Cliques(i,1);
 

  if(sizeCliqSolap > 0)
    CliqSolap = Cliques(i,3:Cliques(i,1)+2);
    AccCardSolap = FindAccCard(sizeCliqSolap,Card(CliqSolap));
    dimSolap =   NumconvertCard(Card(CliqSolap)-1,sizeCliqSolap,AccCardSolap)+1;
  else 
    CliqSolap = [];
    AccCardSolap = [];
    dimSolap = 1;
  end
   
  CliqOther = Cliques(i,Cliques(i,1)+3:Cliques(i,1)+Cliques(i,2)+2);
  AccCardOther = FindAccCard(sizeCliqOther,Card(CliqOther));
  dimOther =   NumconvertCard(Card(CliqOther)-1,sizeCliqOther,AccCardOther)+1;

  AllVars = [CliqSolap,CliqOther];

  if sizeCliqSolap==0          % Si es un nodo raiz  
     index=SUS(N,cumsum(aux)); % Se escogen utilizando muestreo estocastico
     for j=1:N
       allvarvalues = IndexconvertCard(index(j)-1,sizeCliqOther,AccCardOther);
       NewPop(j,CliqOther) = allvarvalues;
     end
  else

	  auxNewPop=NewPop(:,CliqSolap);

	  % Lo que se hace a continuacion es para cada uno de los valores
	  % de los solapamientos se escogen las variables no solapadas
	  % utilizando el muestreo estocastico

	  for k=1:dimSolap
                solapval = IndexconvertCard(k-1,sizeCliqSolap,AccCardSolap);
	        % which almacena todas los individuos en los cuales el solapamiento
		% tiene el mismo valor k-1
              
               
                if sizeCliqSolap==1
		 which=find( (auxNewPop==repmat(solapval,N,1)) == sizeCliqSolap);
		else
		 which=find(sum((auxNewPop==repmat(solapval,N,1))') == sizeCliqSolap)';
		end

		% En index se guardan los valores que tendran las variables no
		% solapadas cuyo solapamiento vale k

		 if size(which,1)>0
		  % Se normaliza antes de generar
		  %aux(k,:)=aux(k,:)/sum(aux(k,:));
		  index=SUS(size(which,1),cumsum(aux(k,:)));
		  for j=1:size(which,1)
                          solapval = IndexconvertCard(index(j)-1,sizeCliqOther,AccCardOther);
			  NewPop(which(j),CliqOther)=solapval;
		  end
                 end    
     end         % End del for de la variabla k
    end          % End del Else


  end            % End del for de la variable i

   
  
 
% Last version 10/05/2005. Roberto Santana (rsantana@si.ehu.es) 
