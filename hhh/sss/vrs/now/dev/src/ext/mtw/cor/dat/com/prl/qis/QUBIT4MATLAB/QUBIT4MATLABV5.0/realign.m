% realign   Realignment of the bipartite density matrix.
%    realign(M) realigns the matrix M (that can be a density matrix)
%    in a bipartite system where the two parties have equal dimensions.
%    If the trace norm of the realigned density matrix is larger than 1
%    then the state is entangled. For more details see 
%    O. Rudoplh, Phys. Rev. A 67, 032312 (2003).

function rhoR=realign(rho)

[sy,sx]=size(rho);
d=floor(sqrt(sy)+0.5);
rhoR=mrealign(rho,[4 2 3 1],d);