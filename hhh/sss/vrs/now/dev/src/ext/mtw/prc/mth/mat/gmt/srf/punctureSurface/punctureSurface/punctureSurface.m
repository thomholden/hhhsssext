function result = punctureSurface(manifold, boundVert, holeSize, shellThickness)
% PUNCTURESURFACE. Puncture a surface defined by faces and vertices.
% 
% INPUT.
%  manifold - structure with fields describing a surface.
%    manifold.faces
%    manifold.vertices
%
%  boundVert - vector of indices into manifold.vertices that
%              specify the boundary vertices. The first and last components
%              of the vector must be equal, representing a closed circuit.
%
%  holeSize - scalar in the range [0,1] determining the size of holes.
%
%  shellThickness - thickness of the shell created from the original
%                   manifold.
%
%
% OUTPUT.
%  result - structure with fields describing the punctured surface. 
%           Every face is a triangle to facilitate its STL-file 
%           description for computer aided manufacturing.
%    result.faces
%    result.vertices
%
%
% EXAMPLE USE CASE.
% n = 15;
% x = linspace(-1,1,n);
% thickness = 0.05*max(x);
% holeSize = 0.5;
% [x,y] = meshgrid(x);
% z = abs(cos(complex(x,y)));
% figure;
% h = surf(x,y,z);
% set(h,'visible','off');
% p = surf2patch(h);
% sub = [1:n-1,repmat(n,1,n-1),n:-1:2,ones(1,n-1)];
% boundVert = sub2ind(size(z),...
%   sub,...
%   circshift(sub,[0 n-1]));
% boundVert = [boundVert,boundVert(1)];
% s = punctureSurface(p, boundVert, holeSize, thickness);
% zeta = complex(s.vertices(:,1),s.vertices(:,2));
% w = sin(zeta);
% u = real(w);
% v = imag(w);
% s.vertices = [u,v,s.vertices(:,3)];
% ps = patch(s);
% axis vis3d;
% axis equal;
% set(gca,'visible','off');
% set(ps, ...
%     'EdgeColor','none', ...
%     'FaceColor',[0.9 0.2 0.2], ...
%     'FaceLighting','phong', ...
%     'AmbientStrength',0.3, ...
%     'DiffuseStrength',0.6, ... 
%     'Clipping','off',...
%     'BackFaceLighting','lit', ...
%     'SpecularStrength',1, ...
%     'SpecularColorReflectance',1, ...
%     'SpecularExponent',7);
% l1 = light('Position',[40 100 20], ...
%     'Style','local', ...
%     'Color',[0 0.8 0.8]);
% l2 = light('Position',[.5 -1 .4], ...
%     'Color',[0.8 0.8 0]);

% Copyright 2013 The MathWorks, Inc.


% Initialization
holeSize = holeSize*(-0.5) + 0.5; % rescale for convenient input.
puncturedManifold.faces = [];
puncturedManifold.vertices = [];
hole.vertices = [];
hole.faces = {};
verticesAddedSoFar = 0;

% Determine how many edges are on each face
uniformNumberOfEdges = ~iscell(manifold.faces);
if ~uniformNumberOfEdges
  numEdges = zeros(size(manifold.faces,1),1);
  for j = 1:size(numEdges,1)
    numEdges(j) = length(manifold.faces{j});
  end
else
  numEdges = repmat(size(manifold.faces,2),size(manifold.faces,1),1);
  manifold.faces = num2cell(manifold.faces,2);
end

uniqueNumEdges = unique(numEdges);
% for each family of ngons with uniqueNumEdges(i) edges.
% A family of ngons all have the same number of edges.
for i = 1:length(uniqueNumEdges) 
  cellBoundary.faces = reshape(...
    [manifold.faces{numEdges == uniqueNumEdges(i)}],...
    uniqueNumEdges(i), [])';
  
  cellBoundaryFacet = manifold.vertices';
  cellBoundaryFacet = reshape(cellBoundaryFacet(:,cellBoundary.faces'),...
    3, uniqueNumEdges(i), []);
  
  % Create vertices that define each hole for faces
  if mod(uniqueNumEdges(i),2) % ngons with odd number of edges
    % Hole vertex lies on line connecting a cellBoundary vertex and the
    % center of its opposite edge.
    intermediateHoleVertices = cellBoundaryFacet ...
    +(...
      (...
         circshift(cellBoundaryFacet,[0 floor(uniqueNumEdges(i)/2) 0]) ...
       - circshift(cellBoundaryFacet,[0 ceil( uniqueNumEdges(i)/2) 0]) ...
      )./2 ...
      + circshift(cellBoundaryFacet,[0 ceil( uniqueNumEdges(i)/2) 0]) ...
      - cellBoundaryFacet ...
     ).*holeSize;
  else % ngons with even number of edges
    % Hole vertex lies on line connecting a cellBoundary vertex and its
    % opposite cellBoundary vertex.
    intermediateHoleVertices  = cellBoundaryFacet ...
      +(circshift(cellBoundaryFacet,[0 uniqueNumEdges(i)/2 0])...
      -cellBoundaryFacet).*holeSize;
  end
  
  intermediateHoleVertices = reshape(intermediateHoleVertices,3,[])';
  % Collect ngon hole vertices for all n
  hole.vertices = [hole.vertices; intermediateHoleVertices];

  
  intermediateHoleFaces = reshape(1:size(intermediateHoleVertices,1),...
    uniqueNumEdges(i),[])';
  % Account for all hole vertices defined so far from previous ngon
  % families and the original manifold.
  intermediateHoleFaces = intermediateHoleFaces ...
    + verticesAddedSoFar + size(manifold.vertices,1);
  
  % Create triangular faces that connect the cellBoundary vertices to the
  % hole vertices.
  for j = 1:uniqueNumEdges(i)-1
    puncturedManifold.faces = [puncturedManifold.faces;
      cellBoundary.faces(:,j),...
      cellBoundary.faces(:,j+1),...
      intermediateHoleFaces(:,j);...
      ...
      intermediateHoleFaces(:,j),...
      cellBoundary.faces(:,j+1),...
      intermediateHoleFaces(:,j+1)...
      ];
  end
  puncturedManifold.faces = [puncturedManifold.faces;
    cellBoundary.faces(:,uniqueNumEdges(i)), ...
    cellBoundary.faces(:,1), ...
    intermediateHoleFaces(:,uniqueNumEdges(i));...
    ...
    intermediateHoleFaces(:,uniqueNumEdges(i)),...
    cellBoundary.faces(:,1),...
    intermediateHoleFaces(:,1)...
    ];
  
  % Collect ngon faces for all families
  hole.faces = [hole.faces; num2cell(intermediateHoleFaces,2)];
  
  % Keep track of how many vertices were created for this ngon family
  verticesAddedSoFar = verticesAddedSoFar + size(intermediateHoleVertices,1);
end

% Collect all of the vertices defined for each family of ngon.
puncturedManifold.vertices = [...
    manifold.vertices;...
    hole.vertices];

% Bottom layer to add thickness
facets = puncturedManifold.vertices';
facets = reshape(facets(:,puncturedManifold.faces'),...
  3, 3, []);
V1 = squeeze(facets(:,2,:) - facets(:,1,:));
V2 = squeeze(facets(:,3,:) - facets(:,1,:));
normals = V1([2 3 1],:) .* V2([3 1 2],:) - V2([2 3 1],:) .* V1([3 1 2],:);
normals = bsxfun(@times, normals, 1 ./ sqrt(sum(normals .* normals, 1)));
% Compute mean normals of faces shared by each vertex
meanNormal = zeros(3,length(puncturedManifold.vertices));
for k = 1:length(puncturedManifold.vertices)
  % Find all faces shared by a vertex
  [sharedFaces,~] = find(puncturedManifold.faces == k);
  % Compute the mean normal of all faces shared by a vertex
  meanNormal(:,k) = mean(normals(:,sharedFaces),2);
end
meanNormal = bsxfun(@times, meanNormal,...
  shellThickness ./ sqrt(sum(meanNormal .* meanNormal, 1)));
bottom.vertices = puncturedManifold.vertices - meanNormal';
bottom.faces = puncturedManifold.faces;

% Walls of holes
numEdges = zeros(size(hole.faces,1),1);
for j = 1:size(numEdges,1)
  numEdges(j) = length(hole.faces{j});
end
uniqueNumEdges = unique(numEdges);
% for each family of ngons with uniqueNumEdges(i) edges.
% A family of ngons all have the same number of edges.
wall.faces = [];
for i = 1:length(uniqueNumEdges) 
  cellBoundary.faces = reshape(...
    [hole.faces{numEdges == uniqueNumEdges(i)}],...
    uniqueNumEdges(i), [])';
  numVerticesPerLayer = length(puncturedManifold.vertices);
  for j = 1:uniqueNumEdges(i)-1
    wall.faces = [wall.faces;...
      cellBoundary.faces(:,j),...
      cellBoundary.faces(:,j+1),...
      cellBoundary.faces(:,j)+numVerticesPerLayer;...
      ...
      cellBoundary.faces(:,j)+numVerticesPerLayer,...
      cellBoundary.faces(:,j+1),...
      cellBoundary.faces(:,j+1)+numVerticesPerLayer...
      ];
  end
  wall.faces = [wall.faces;...
    cellBoundary.faces(:,uniqueNumEdges(i)), ...
    cellBoundary.faces(:,1), ...
    cellBoundary.faces(:,uniqueNumEdges(i))+numVerticesPerLayer;...
    ...
    cellBoundary.faces( :,uniqueNumEdges(i))+numVerticesPerLayer,...
    cellBoundary.faces(:,1),...
    cellBoundary.faces(:,1)+numVerticesPerLayer...
    ];
end % walls of holes

boundary.vertices = [...
  manifold.vertices(boundVert,:);
  bottom.vertices(boundVert,:)];
% Number of wall vertices on each surface (nwv).
nwv = length(boundary.vertices)/2;
% Allocate memory for wallFaces.
boundary.faces = zeros(2*(nwv-1),3);
% Define the faces.
for k = 1:nwv-1
    boundary.faces(k      ,:) = [k+1  ,k      ,k+nwv];
    boundary.faces(k+nwv-1,:) = [k+nwv,k+1+nwv,k+1];
end

% All together now!
result.vertices = [...
  puncturedManifold.vertices; 
  bottom.vertices; 
  boundary.vertices];
result.faces = [...
  fliplr(puncturedManifold.faces); 
  bottom.faces+numVerticesPerLayer; 
  wall.faces; 
  boundary.faces + 2*numVerticesPerLayer];

end