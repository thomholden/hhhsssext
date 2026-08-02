function Idx=getSpots(A,k,intsite)
% getSpots  Given the topology of an ensemble of sites, it computes a cluster 
%           for each site specified in input. For a given site, a cluster is defined 
%           by its neighbors.   
%
%    Idx=getSpots(A,k,intsite) computes a cluster for each site in intsite 
%    given the topology of an ensemble of sites in A. For a given site in intsite, 
%    a cluster is defined as its k-step neighbors sites. The result, Idx, is a matrix
%    where each column represents a cluster and contains the indexes of the sites belonging 
%    to that cluster. If the size of clusters is not uniform, columns are 
%    padded with NaN in order to get the same number of lines for every column.
%
%    Example
%    % a randomly generated incidence matrix
%    A=randint(100);
%    % get the cluster of site 12 and 90
%    Idx=getSpots(A,1,[12 90]);
%
%    See also  getClusters, getRegionEEG, getClustersEEG, IncidenceMatrix.

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
if nargin < 3,
  error ('Input missing. Specify incidence matrix and order and set of sites');
end
% If too many inputs specified
if nargin > 3,
    error ('Too many input arguments, you only need to specify the incidence matrix A, the order k and a vector of sites');
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

% Topological connectivity k-order incidence matrix 
B=A^k;
B(find(B))=1;
    
% Number of sites
nsite=length(intsite);
    
% Size if the biggest cluster
clusSize = max(sum(B(intsite,:),2));
    
% Initialization
Idx=NaN(clusSize,nsite);
    
% finding the index
for n=1:nsite,
    
    % Neighbors cluster
    itnn=find(B(intsite(n),:));
    Idx(1:length(itnn),n) = itnn;
      
end;
    

return,
%end
                
                  