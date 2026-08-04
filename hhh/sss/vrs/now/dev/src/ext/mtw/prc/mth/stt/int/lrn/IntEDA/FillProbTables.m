function[Table] = FillProbTables(totcliq,ListCliques,ListCliqAccCard,D,P,Table)
% Fill  the probability tables for all cliques from the data in D and probability in P  
   NPoints = size(D,1)

   for i=1:totcliq,
      sizecliq = ListCliques(i,1);
      cliq = ListCliques(i,3:sizecliq+2);
      cardcliq = ListCliqAccCard(i,2:sizecliq+1);
        for j=1:NPoints,
         subvector = D(j,cliq);
         valindex = NumconvertCard(subvector,sizecliq,cardcliq)+1;
         Table{i}(valindex) =  Table{i}(valindex) + P(j);       
        end
     end
  
% D = fix (rand(NumberCases,vars) .* repmat(Card,1,NumberCases));
% P = rand(1,vars); P = P/sum(P);  
