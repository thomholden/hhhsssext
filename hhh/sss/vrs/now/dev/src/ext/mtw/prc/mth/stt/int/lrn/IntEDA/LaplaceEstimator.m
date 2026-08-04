function[Table] = LaplaceEstimator(totcliq,NPoints,Table)
% Modify the probability tables using Laplace estimator  
   for i=1:totcliq,
      cardcliq = size(Table{i},1);      
      Table{i} =  (Table{i} * NPoints + 1) / (NPoints+ cardcliq);
    end
  

