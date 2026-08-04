function[Table] = CreateProbTables(totcliq,ListCliqAccCard)
% Create the probability tables for all cliques  
      for i=1:totcliq,
       sizecliq = ListCliqAccCard(i,1);
       aux=zeros(sizecliq,1);
       Table{i} = aux;     
      end

% Last version 10/05/2005. Roberto Santana (rsantana@si.ehu.es) 