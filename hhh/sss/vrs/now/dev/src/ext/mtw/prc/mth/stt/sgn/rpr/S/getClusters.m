function Idx=getClusters(A,k,varargin)
% getClusters   computes indexes of clusters of sites distributed according
%               to a known topology.
%
%    Idx=getClusters(A,k)  computes clusters for all sites, whose topology
%    is encoded in the incidence matrix A. For a given site, a cluster 
%    is defined as its k-step neighbors sites. The result, Idx, is a matrix
%    where each column represents a cluster and contains the indexes of the sites belonging 
%    to that cluster. If the size of clusters is not uniform, columns are 
%    padded with NaN in order to get the same number of lines for
%    every column.
%
%    Idx=getClusters(A,k,area) computes a cluster for each site defined in area, 
%    following the topology given by the incidence matrix A, restricted to area.
%
%    Example
%    % a randomly generated incidence matrix
%    A=randint(100);
%    % get 100 clusters, 1st step neighbors
%    Idx=getClusters(A,1);
%    % for a region of sites from 70 to 100
%    Idx1=getclusters(A,1,[70:100]);
%
%    See also getSpots, getRegionEEG, getClustersEEG, IncidenceMatrix.

% Copyright (c) 2005
% Olivier Neal / Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.



% Check some basic requirements of the inputs
% If no input specified
if nargin < 2,
  error ('Input missing. Specify incidence matrix and order');
end
% If too many inputs specified
if nargin > 3,
    error ('Too many input arguments, you only need to specify the incidence matrix A, the order k and possibly a vector of electrodes');
end

% Check input k
% Positivity
if k < 1
    error('k must be positive');
end

% Check if k is an integer
if ~isinteger(int8(k))
    error('k must be an integer');
end


if nargin == 3,
    % If sites of interest have been specified:
    area = varargin{1};
    
    if max(area)>size(A,2)
        error('Index(es) in the specified region is(are) out of topology');
    end
    
    % number of sites (= maximum number of neighbors)
    nsite=size(area,2);
    
    % Topological connectivity k-order incidence matrix 
    B=A(area,area)^k;
    B(find(B))=1;
    
    % Size if the biggest cluster
    clusSize = max(sum(B));
    
    % Initialization
    Idx=NaN(clusSize,nsite);
    
    % finding the index
    for n=1:nsite,
    
        % Neighbors cluster
        itnn=find(B(n,:));
        Idx(1:length(itnn),n) = itnn;
      
    end;
    
    % Correct index
    Idf = find(isfinite(Idx));
    Idx(Idf) = area(Idx(Idf));
    
else
    
    % Topological connectivity k-order incidence matrix 
    B=A^k;
    B(find(B))=1;
    
    % Number of sites
    nsite=size(A,1);
    
    % Size if the biggest cluster
    clusSize = max(sum(B));
    
    % Initialization
    Idx=NaN(clusSize,nsite);
    
    % finding the index
    for n=1:nsite,
    
        % Neighbors cluster
        itnn=find(B(n,:));
        Idx(1:length(itnn),n) = itnn;
      
    end;
    
end;

return,
%end
                
                  