function Idx=getClustersEEG(region,varargin)
% getClustersEEG   returns indexes of clusters computed over predefined brain regions, 
%                  according to the specific experimental EEG setup. For a given site 
%                  of a region, a cluster is defined by its 1st step neighbors.   
%
%    Idx=getClustersEEG(region) computes a cluster for each site of the predefined
%    brain area region, following the topology given by the 128 EEG Geodesic setup.
%    For each site of region, a cluster is defined by its 1st step neighbors.
%    The available values for region are:
%        'OL' : occipital left
%        'OR' : occipital right
%        'O'  : occipital
%        'FL' : frontal left
%        'FR' : frontal right
%        'F'  : frontal
%        'TL' : temporal left
%        'TR' : temporal right
%        'PL' : parietal left
%        'PR' : parietal right
%        'P'  : parietal
%        'CR' : central right
%        'CL' : central left
%        'C'  : central
%
%    Idx=getClustersEEG(region,setup) where setup specifies which
%    experimental EEG setup you are using. Default value is 'Geod' (128 EEG/ERP Geodesic setup).
%    Only this setup is supported in this version of the toolbox.
%         
%    Example
%    [Idx]=getClustersEEG('OL');
%    or
%    [Idx]=getClustersEEG('OL','Geod');
%
%    See also getSpots, getClusters, getRegionEEG, IncidenceMatrix.

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
if nargin < 1,
error('ErrorZone:Zone', ...
      'You must specify a brain area: \n OL, OR, O, FL, FR, F, TL, TR, PL, PR, P, CR, CL, C. \n Please check help UsersGuide for details about these zones.')
end
% If too many inputs specified
if nargin > 2,
    error ('Too many input arguments, you only need to specify the brain area and the EEG setup');
end
% If no setup specified, default value = Geod
if nargin == 2,
    setup = varargin{1};
else
    setup='Geod';
end

switch setup
    case 'Geod'
            disp('Geodesic 128 ERP/EEG setup');
            load('CoordInterp.mat');
            % incidence matrix of a geodesic setup
            [tri,x,y,A]=IncidenceMatrix(CO);
            
            switch region
                case 'OL'
                    disp('Brain area of interest: Occipital left');
                    area = [74 75 70 71 72 65 66 69 76 82];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'OR'
                    disp('Brain area of interest: Occipital right');
                    area = [76 77 82 83 84 85 89 90 91 95];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'O'
                    disp('Brain area of interest: Occipital');
                    area = [65 66 69 70 71 72 74 75 76 77 82 83 84 85 89 90 91 95];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                
                case 'FL'
                    disp('Brain area of interest: Frontal left');
                    area = [39 35 29 25 20 12 34 128 21 28 33 6 24 26 27 11 19 23 127 16 18 22 17];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                                        
                case 'FR'
                    disp('Brain area of interest: Frontal right');
                    area = [1 2 3 4 5 6 8 9 10 11 14 15 16 17 117 118 121 122 123 124 125 126];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'F'
                    disp('Brain area of interest: Frontal');
                    area = [1 2 3 4 5 6 8 9 10 11 12 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 33 34 35 39 117 118 121 122 123 124 125 126 127 128];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'TL'
                    disp('Brain area of interest: Temporal left');
                    area = [40 41 44 45 46 47 49 50 51 56 57 58 59 63 64];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'TR'
                    disp('Brain area of interest: Temporal right');
                    area = [92 96 97 98 99 100 101 102 103 108 109 110 114 115 116 120];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'PL'
                    disp('Brain area of interest: Parietal left');
                    area = [52 53 54 60 61 62 67 68 73];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'PR'
                    disp('Brain area of interest: Parietal right');
                    area = [62 68  73 78 79 80 86 87 93];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'P'
                    disp('Brain area of interest: Parietal');
                    area = [52 53 54 60 61 62 67 68 73 78 79 80 86 87 93];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'CL'
                    disp('Brain area of interest: Central left');
                    area = [7 13 30 31 32 36 37 38 42 43 48 55];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                case 'CR'
                    disp('Brain area of interest: Central right');
                    area = [55 81 88 94 99 104 105 106 107 111 112 113];
                    
                    % first step neighbours clusters
                    Idx = getClusters(A,1,area);
                    
                otherwise
                    error ('ErrorZone:Zone', 'First argument should be OL, OR, O, FL, FR, F, TL, TR, PL, PR, P, CL, CR. \n Please check help UsersGuide for details about these zones.');
            end
    otherwise
        error ('Invalid EEG setup');
end

return,
%end
                
                  