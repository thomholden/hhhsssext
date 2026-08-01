function A=compute_adjacency_matrix(edg,N)
A=sparse(edg(:,1),edg(:,2),ones(size(edg,1),1),N,N); 
A = (A+A')~=0;