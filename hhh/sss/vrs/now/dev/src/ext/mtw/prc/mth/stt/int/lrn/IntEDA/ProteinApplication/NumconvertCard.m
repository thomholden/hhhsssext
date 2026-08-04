function [valindex] = NumconvertCard(num,length,AccCard)
% This function converts a vector of variables num, where the accumulative cardinality of each variable is in AccCard,
% to the index valindex corresponding to the vector.
% AccCard is the product of cardinalities of previous  variables, where the first variable is  the one to left.

  valindex = num(length);
     for i=1:length-1,
   valindex =  valindex +  num(i)*AccCard(i);
 end
