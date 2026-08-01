function EI = vertexAttachments(obj,VI)
%vertexAttachments
%
%   This mimics the analogous MATLAB:TriRep method.  This routine is slightly
%   limited, because it assumes that every vertex has, at most, 2 edges
%   attached to it.
%
%   EI = obj.vertexAttachments(VI);
%
%   VI = column vector (length M) of vertex indices in the mesh; optional
%        argument.  If absent, then all vertices in the mesh are considered.
%
%   EI = Mx2 matrix of edge (cell) indices in the mesh.  EI(i) contains the
%        edge indices that are attached to vertex VI(i).  An entry of 0
%        indicates no edge.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if nargin < 2
    VI = (1:1:size(obj.X,1))';
end

EI = zeros(length(VI),2);

[TF, LOC] = ismember(VI,obj.Triangulation(:,1));
EI(TF,1) = LOC(TF);

[TF, LOC] = ismember(VI,obj.Triangulation(:,2));
EI(TF,2) = LOC(TF);

end