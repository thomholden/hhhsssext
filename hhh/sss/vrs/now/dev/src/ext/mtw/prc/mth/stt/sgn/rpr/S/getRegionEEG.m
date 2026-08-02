function Idx=getRegionEEG(region,varargin)
% getRegionEEG   returns indexes of sites belonging to predefined brain regions, according
%                to the specific experimental EEG setup.
%
%    Idx=getRegionEEG(region) returns a vector Idx of EEG
%    electrodes corresponding to the predefined brain area region.
%    The available areas are:
%        'OL' : occipital left 
%        (i.e. [74 75 70 71 72 65 66 69 76 82])
%        
%        'OR' : occipital right 
%        (i.e. [76 77 82 83 84 85 89 90 91 95])
%
%        'FL' : frontal left  
%        (i.e. [39 35 29 25 20 12 34 128 21 28 33 6 24 26 27 11 19 23 127 16 18 22 17])
%        
%        'FR' : frontal right 
%        (i.e. [1 2 3 4 5 6 8 9 10 11 14 15 16 17 117 118 121 122 123 124 125 126])
%        
%        'TL' : temporal left  
%        (i.e. [40 41 44 45 46 47 49 50 51 56 57 58 59 63 64])
%        
%        'TR' : temporal right 
%        (i.e. [92 96 97 98 99 100 101 102 103 108 109 110 114 115 116 120])
%
%        'PL' : parietal left  
%        (i.e. [52 53 54 60 61 62 67 68 73])
%
%        'PR' : parietal right 
%        (i.e. [62 68  73 78 79 80 86 87 93])
%
%        'CL' : central left
%        (i.e. [7 13 30 31 32 36 37 38 42 43 48 55])
%        
%        'CR' : central right
%        (i.e. [55 81 88 94 99 104 105 106 107 111 112 113])
%
%    The electrodes correspond to a specific EEG setup, a 128
%    (electrodes) EEG/ERP Geodesic setup.
%               
%    Idx=getRegionEEG(region,setup) where setup specifies which
%    experimental EEG setup you are using. Default value is 'Geod' (128 EEG/ERP Geodesic setup).
%    Only this setup is supported in this version of the toolbox.
% 
%    Example
%    Idx=getRegionEEG('OL');
%    or
%    Idx=getRegionEEG('OL','Geod');
%
%    See also getSpots, getClusters, getClustersEEG, IncidenceMatrix.
%

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
      'You must specify a brain area: \n OL, OR, FL, FR, TL, TR, PL, PR, CL, CR. \n Please check help UsersGuide for details about these zones.')
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

% switch on the setup
switch setup
    case 'Geod'
            disp('Geodesic 128 ERP/EEG setup');
            
            % switch on the region
            switch region
                case 'OL'
                    disp('Brain area of interest: Occipital left');
                    Idx = [74 75 70 71 72 65 66 69 76 82]';
                    
                case 'OR'
                    disp('Brain area of interest: Occipital right');
                    Idx = [76 77 82 83 84 85 89 90 91 95]';
                
                case 'FL'
                    disp('Brain area of interest: Frontal left');
                    Idx = [39 35 29 25 20 12 34 128 21 28 33 6 24 26 27 11 19 23 127 16 18 22 17]';
                                        
                case 'FR'
                    disp('Brain area of interest: Frontal right');
                    Idx = [1 2 3 4 5 6 8 9 10 11 14 15 16 17 117 118 121 122 123 124 125 126]';
                                        
                case 'TL'
                    disp('Brain area of interest: Temporal left');
                    Idx = [40 41 44 45 46 47 49 50 51 56 57 58 59 63 64]';
                                        
                case 'TR'
                    disp('Brain area of interest: Temporal right');
                    Idx = [92 96 97 98 99 100 101 102 103 108 109 110 114 115 116 120]';
                       
                case 'PL'
                    disp('Brain area of interest: Parietal left');
                    Idx = [52 53 54 60 61 62 67 68 73]';
                    
                case 'PR'
                    disp('Brain area of interest: Parietal right');
                    Idx = [62 68  73 78 79 80 86 87 93]';
                                             
                case 'CL'
                    disp('Brain area of interest: Central left');
                    Idx = [7 13 30 31 32 36 37 38 42 43 48 55]';
                    
                case 'CR'
                    disp('Brain area of interest: Central right');
                    Idx = [55 81 88 94 99 104 105 106 107 111 112 113]';
                
                % not valid EEG region    
                otherwise
                    error ('ErrorZone:Zone', 'First argument should be OL, OR, FL, FR, TL, TR, PL, PR, CL, CR \n Please check help UsersGuide for details about these zones.');
            end
    % not yet supported EEG setup        
    otherwise
        error ('Invalid EEG setup');
end

return,
%end
                
                  