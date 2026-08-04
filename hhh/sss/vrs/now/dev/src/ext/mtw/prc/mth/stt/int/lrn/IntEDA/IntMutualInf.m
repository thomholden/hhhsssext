function[MI]=MutInf1(NumbVar,Prob,f)

% NumbVar: Cantidad de variables
% Prob: Probabilidad conjunta

BivProb=zeros(NumbVar,NumbVar,4);
MI=zeros(NumbVar,NumbVar);

%Se Calculan las probabilidades bivariadas
% La suma de dos probabilidades bivariadas es la univariada p(x,0)+p(x,1)


 for a=1:size(f,1)
  i=f(a);
      bin=binconvert(i-1,NumbVar);
      for j=1:NumbVar
       for k=j+1:NumbVar
        BivProb(j,k,2*bin(j)+bin(k)+1)=BivProb(j,k,2*bin(j)+bin(k)+1)+Prob(i); 
       end
      end
 end
for j=1:NumbVar
  for k=j+1:NumbVar
   for a=0:1
     for b=0:1
      Univ1=BivProb(j,k,2*a+1)+BivProb(j,k,2*a+2);
      Univ2=BivProb(j,k,b+1)+BivProb(j,k,b+2);

      if Univ1>0 & Univ2>0
        MI(j,k)=MI(j,k)+BivProb(j,k,2*a+b+1)*log(BivProb(j,k,2*a+b+1)/Univ1*Univ2);
      end              

     end 
   end
    MI(k,j)=MI(j,k);
  end
end
   