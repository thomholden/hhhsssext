function[Index]=PropSelection(SelCant,FunVal)
   partialsum=FunVal/sum(FunVal);
   partialsum=cumsum(partialsum);
   Index=sus(SelCant,partialsum);

 return