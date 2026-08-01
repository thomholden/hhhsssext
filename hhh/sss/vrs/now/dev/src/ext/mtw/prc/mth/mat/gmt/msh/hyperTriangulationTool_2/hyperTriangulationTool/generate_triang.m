% generates a triangulated surface with genus g 
% N is teh number of resulting vertices
% edg is a Nx4 matrix containing in each row [i j k1 k2] conventionally i<j 
% i j is an edge and k1 k2 are the two vertices of the 2 incident triangles 
% placed respectivelly k1 right and k2 left with respect to i->j 
function [edg,N] = generate_triang(g)
% builds a tetrahedron
%             3
%            / \
%           / | \
%          /  |  \
%         /  /4\  \
%        / /     \ \
%      1 -----------2
%
% the edges are oriented, with the first two indices indicating the 
% edge and its direction, the third index is the vertex on the right the 
% the fourth index is the vertex on the left.
%
edg(1,1:4) = [ 1 2 3 4];
%            2 
%           /|\
%         4/ | \3
%          \ ^ /
%           \|/
%            1
edg(2,1:4) = [ 2 3 1 4];
%            3 
%           /|\
%         4/ | \1
%          \ ^ /
%           \|/
%            2
edg(3,1:4) = [ 1 3 4 2];
%            3 
%           /|\
%         2/ | \4
%          \ ^ /
%           \|/
%            1
edg(4,1:4) = [ 1 4 2 3];
%            4 
%           /|\
%         3/ | \2
%          \ ^ /
%           \|/
%            1
edg(5,1:4) = [ 2 4 3 1];
%            4 
%           /|\
%         1/ | \3
%          \ ^ /
%           \|/
%            2
edg(6,1:4) = [ 3 4 1 2];
%            4 
%           /|\
%         2/ | \1
%          \ ^ /
%           \|/
%            3
N = 4; % number of vertices
for t=1:g
    [edg,N]=g1move(edg,N,floor(rand*N+1),floor(rand+3.5));
end