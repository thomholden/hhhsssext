function mInc = incidence(mAdj)
% mInc = incidence(mAdj) - conversion from adjacency matrix to incidence matrix
%
% INPUT:    mAdj - adjacency matrix of a graph; if
%                  directed    - elements from {-1,0,1}
%                  undirected  - elements from {0,1}
% OUTPUT:   mInc - incidence matrix; rows = edges, columns = vertices
%
% example: Graph:   __(v1)<--
%                  /         \_e2/e4_
%               e1|                  |  
%                 \->(v2)-e3->(v3)<-/
%
%           mAdj = [0 1 1
%                  0 0 1
%                  1 0 0];
%                  
%                 v1  v2 v3  <- vertices 
%                  |  |  |
%          mInc = [1 -1  0   <- e1   |
%                  1  0 -1   <- e2   | edges
%                  0  1 -1   <- e3   |
%                 -1  0  1]; <- e4   |

% 08 Jul 2009   - created   Ondrej Sluciak <ondrej.sluciak@nt.tuwien.ac.at>
% 08 Jul 2009   - major speed-up thanks to Wolfgang Schwanghart
% 10 Jul 2009   - Self-loop check added + example
%%%


if (~(issparse(mAdj)&& islogical(mAdj)))
    warning('Adjacency matrix should be sparse and contain only {0,1}');
    mAdj = sparse(mAdj)>0;  
end

vM = size(mAdj);

iN_nodes  = vM(1);

if (iN_nodes < 2)
    error('Graph must contain at least 2 nodes (and one edge)!');
end

if (iN_nodes ~= vM(2))
    error('Input matrix must be square!');
end

if (nnz(diag(mAdj)))
    error('No self-loops are allowed!');
end

bDir = nnz((mAdj-mAdj'));   %if the matrix is symmetric, graph is undirected

if (bDir>0)
    [vNodes1,vNodes2] = find(mAdj');     
    iN_edges = length(vNodes1);

    vOnes = ones(iN_edges,1); 
    vEdgesidx = (1:iN_edges)';
    
    mInc = sparse([vEdgesidx; vEdgesidx],... 
               [vNodes1; vNodes2],... 
               [-vOnes; vOnes],... 
               iN_edges,iN_nodes); 
else
    [vNodes1,vNodes2] = find(triu(mAdj));     
    iN_edges = length(vNodes1);

    vOnes = ones(iN_edges,2)>0;     %logical
    vEdgesidx = (1:iN_edges)';

    mInc = sparse([vEdgesidx; vEdgesidx],... 
               [vNodes1(1:iN_edges); vNodes2(1:iN_edges)],... 
               vOnes,...
               iN_edges,iN_nodes); 
    
end

end
