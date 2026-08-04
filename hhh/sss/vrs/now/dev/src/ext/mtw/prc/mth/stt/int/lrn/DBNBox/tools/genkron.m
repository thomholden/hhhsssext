function K = genkron(A,B,operator)
%KRON   Kronecker tensor operation.
%   KRON(X,Y,OP) is the Kronecker tensor operation of X and Y.
%   The result is a large matrix formed by taking all possible
%   operations <OP> between the elements of X and those of Y.   For
%   example, if X is 2 by 3, then KRON(X,Y) is
%
%      [ X(1,1)*Y  X(1,2)*Y  X(1,3)*Y
%        X(2,1)*Y  X(2,2)*Y  X(2,3)*Y ]
%
%   If either X or Y is sparse, only nonzero elements are multiplied
%   in the computation, and the result is sparse.

[ma,na] = size(A);
[mb,nb] = size(B);


   % Both inputs full, result is full.

   t = 0:(ma*mb-1);
   ia = fix(t/mb)+1;
   ib = rem(t,mb)+1;
   t = 0:(na*nb-1);
   ja = fix(t/nb)+1;
   jb = rem(t,nb)+1;
   switch operator
     case '+'
	K = A(ia,ja)+B(ib,jb);
     case '-'
	K = A(ia,ja)-B(ib,jb);
     case '/'
	K = A(ia,ja)/B(ib,jb);
   otherwise
	K = A(ia,ja).*B(ib,jb);
   end
