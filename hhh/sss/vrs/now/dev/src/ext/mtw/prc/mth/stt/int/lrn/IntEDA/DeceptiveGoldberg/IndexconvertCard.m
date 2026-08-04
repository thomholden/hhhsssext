function [num] = IndexconvertCard(valindex,length,AccCard)
% This function converts the index valindex to the vector of variables num, where the accumulative cardinality of each variable is in AccCard,
% AccCard is the product of cardinalities of previous  variables, where the first variable is  the one to left.
 aux = valindex;
 for i=1:length
   remainder = rem(aux, AccCard(i));
   num(i)= (aux - remainder) / AccCard(i);
   aux = remainder;
 end
