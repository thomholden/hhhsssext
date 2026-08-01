a= diag(ones(8,1),0);

%Predat.
a(3,1)= 1; a(5,1)= 1;
a(5,2)= 1; a(5,3)= 1;
a(4,3)= 1;
a(6,4)= 1; a(7,4)= 1;
a(7,5)= 1; a(8,5)= 1;

%Reciprc.
a(1,3)= 1; a(1,5)= 1;
a(2,5)= 1; a(3,5)= 1;
a(3,4)= 1;
a(4,6)= 1; a(4,7)= 1;
a(5,7)= 1; a(5,8)= 1;

asize= 0.1;  arrcol= [0. 0.5 1.];
csize= 0.08; circol= [0.8 0. 0.];
bckcol= [0 0 0];
fdcgraph(a,'trofic',asize,arrcol,csize,circol,bckcol)
