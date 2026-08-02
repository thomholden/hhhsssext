function TS=composeData(basename,ND,NFFirst,NFLast,varargin);
% composeData   merges data matrices along the first dimension, putting a 
%               NaN between the different matrices.
%
%    TS=composeData(basename,ND,NFFirst,NFLast) merges along the first dimension
%    the data matrices which have a base name as basename, and are numbered
%    with ND digits. NFFirst is the first matrix to merge, MFLast is the number of the last. 
%    TS is the matrix of the merged data matrices, with NaN as element separator between matrices. 
%
%    TS=composeData(basename,ND,NFFirst,NFLast,badTrials) it merges data
%    matrices with the exception of those numbered in badTrials. Data
%    of these matrices badTrials have the Inf values in TS.
%
%    Example
%    % prepare fake data matrices
%    data_01=randn(500,25);
%    data_02=randn(500,25);
%    data_03=randn(500,25); 
%    % now data are in the workspace, we merge them
%    TS=composeData('data_',2,1,3);
% 
%    See also fileSelector, computeS.

% Copyright (c) 2005
% Olivier Neal / Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.


% Check inputs - act 1
if nargin < 4
    error('Input missing');
elseif nargin > 5
    error('Too many inputs');
end                                                                                                                                                                                                    
    
if nargin == 5
    badTrials = varargin{1};
else
    badTrials = [];
end

% Check inputs - act 2
if NFFirst > NFLast
    error('NFFirst should be less than NFLast. Try to permute input 4 and 5');
end

% ND has to be large enough to write file NFLast
% if ND=2, lim=99, if ND=3, lim=999 ...
lim=10^ND-1;
if NFLast>lim
    msg=strcat('ND=',num2str(ND),'.','Not enough digits to write file:',basename,num2str(NFLast));
    error(msg);
end

% Check if every variable is in the directory
try 

for i=NFFirst:NFLast
    
    % name of the data to load
    VAR = strcat(basename,num2str(i,['%0' num2str(ND) 'i']));
    
    % check if data exists
    DAT = evalin('base',VAR);
    
end

catch
    
      % Error message
      msg=strcat('Data: ', VAR, ' does not exist');
      error(msg);
    
end
% end try

% Name of the double containing the first set of values.
DATNAME = strcat(basename,num2str(NFFirst,['%0' num2str(ND) 'i']));

% Actual value of the matrix
DATA = evalin('base',DATNAME);

% Size of each trial's data
[NP NCHS] = size(DATA);

% base index
BI=cumsum([1 (NP+1)*ones(1,NFLast-NFFirst+1)]);

% initializing TS (easier with NaN)
TS=NaN((NP+1)*(NFLast-NFFirst+1),NCHS);

% loop over the trials
for i=0:(NFLast-NFFirst),
    
        % bad trials 
        if ismember(i+NFFirst,badTrials),
        
            % Fill bad trials
            TS(BI(i+1):BI(i+2)-2,:)=Inf([NP NCHS]);
        
        % good trials    
        else
            
            % Name of file corresponding to trial i
            DATNAME = strcat(basename,num2str(i+NFFirst,['%0' num2str(ND) 'i']));
            
            % Actual value of the matrix
            DATA = evalin('base',DATNAME);

            % Fill TS (Time Series) trial by trial
            TS(BI(i+1):BI(i+2)-2,:)=DATA;
    
        end
        % end if
end
% end for

return,
% end compose