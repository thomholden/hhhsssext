function varargout=IncidenceMatrix(CO,varargin)
% IncidenceMatrix  computes the incidence matrix for the sites in input. The
%                  computation is based on Delaunay triangulation. 
% 
%    A=IncidenceMatrix(CO) computes the incidence matrix A for the ensemble of sites
%    whose coordinates are in CO. CO should be organized as follow: column 1 & 2 the
%    planar coordinates; column 3 the site' number. For euclidean coordinates, first
%    planar coordinate is x and second is y, for polar, first is the
%    radius r and second is the phase theta. By default, coordinates are
%    assumed to be polar.
%
%    A=IncidenceMatrix(CO,coord_system) where coord_system specifies which
%    kind of coordinates are in CO. coord_system can be either 'polar' or
%    'eucl'.
%
%    [tri,x,y,A]=IncidenceMatrix(...) computes the triangulation matrix for trimesh tri,
%    the euclidean x and y sites coordinates, the incidence matrix.
%
%    Example 
%    % fake coordinates
%    CO=zeros(128,3);
%    CO(:,1:2)=rand(128,2);
%    CO(:,3)=1:128;
%    % get the incidence matrix 
%    A=IncidenceMatrix(CO,'eucl');
%
%    See also  getClusters, plotS.

% Copyright (c) 2005
% Olivier Neal / Oscar De Feo / Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.

% basic input checks
if nargin>2
    error('Too many input arguments');
elseif nargin==0
    error('Missing input: sites coordinates matrix');
end

% output check
if nargout>4, 
   error('Too many output arguments');
end

    
% Order EL components
  [a,idx]=unique(CO(:,3));
  CO=CO(idx,:);
% site tag
  ne=CO(:,3);
  
% Euclidean coordinates are used. If "CO" contains polar coordinates,
% these coordinates have to be transformed into Euclidean
% the optional input is 'polar' or 'eucl'. Default value is 'polar'

if nargin==2
    % euclidean coordinates
    if strcmp(varargin(1),'eucl')
        
        x=(CO(:,1)/max(CO(:,1)))';
        y=(CO(:,2)/max(CO(:,2)))';
    
    % polar coordinates    
    elseif strcmp(varargin(1),'polar')
         
        % normalize coordinates
        CO(:,1)=CO(:,1)/max(CO(:,1));
        CO(:,2)=rem(CO(:,2),2*pi); 
        % Get the Euclidean coordinates
        x=(CO(:,1).*cos(CO(:,2)))'; 
        y=(CO(:,1).*sin(CO(:,2)))';
        
    else
        error('2nd argument should be either "eucl" for euclidean coordinates or "polar" for polar coordinates');
    end
    % end second if
    
% default case    
else
    
    % normalize coordinates
    CO(:,1)=CO(:,1)/max(CO(:,1));
    CO(:,2)=rem(CO(:,2),2*pi); 
    % default case
    x=(CO(:,1).*cos(CO(:,2)))'; 
    y=(CO(:,1).*sin(CO(:,2)))';
end
% end first if
    
% Delaunay triangulation
  tri=delaunay(x,y);
  
% Sites triangles
  elt=ne(tri);
  
% Allocate result
  A=zeros(length(ne));
    
for n=1:length(ne),
    % search nearest neighborhood
      [r,c]=ind2sub(size(elt),find(elt==ne(n)));
      tnn=unique(elt(r,:));
      itnn=find(ismember(ne,tnn));
      A(n,itnn)=1;
end;

% incidence matrix
A=(A+A')/2;

% output assignment
if nargout==1
   varargout={A};
else
   varargout(1)={tri};
   varargout(2)={x};
   varargout(3)={y}; 
   varargout(4)={A};
end

return,
% end