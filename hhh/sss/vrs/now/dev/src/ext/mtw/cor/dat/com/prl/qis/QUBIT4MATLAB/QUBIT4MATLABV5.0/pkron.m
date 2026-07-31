% pkron   Repeats kron several times. That is, pkron(m,4)=mkron(m,m,m,m).

function m=pkron(matrix,no_of_repeatations)
   if no_of_repeatations==0,
      [sy,sx]=size(matrix);
      m=eye(sy,sx);
   else
      m=matrix;
      for n=2:no_of_repeatations
         m=kron(m,matrix);
      end %for
   end %if
