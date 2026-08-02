function TS=fileSelector(basename,extension,ND,NFFirst,NFLast,badTrials,varargin)
% fileSelector   merges data stored in files along the first dimension, putting a 
%                NaN as separator among data stored in different files.
%
%   TS=fileSelector(basename,extension,ND,NFFirst,NFLast,badTrials)
%   loads data files and merge data along the first dimension, putting NaNs 
%   among data stored in different files. The data files has the following syntax: 
%   basename is their common base name (it can include the path where 
%   you have stored the files), extension is the format of the files (two formats are supported
%   'mat' and 'txt'), ND is the number of digits used to enumerate the
%   files (e.g. ND=3 for files spanning from 00 to 99). NFFirst is the
%   number of the first file to load, NFLast the last. badTrials is a
%   vector of the number of files that are not to be loaded ([] if none).
%   Data of these files badTrials have the Inf values in TS. 
%   It is supposed that the name of the data is the same in all the file
%   and is equal to basenameNN (where NN is the number of the file to load).
%
%   TS=fileSelector(basename,extension,ND,NFFirst,NFLast,badTrials,dataname)
%   where dataname specifies the name of the data in all the files to load.
%     
%     
%  Example
%  % We use the data stored in DataTest. These data files have ND=2.
%  % We load files from 10 to 20. No bad trials. The name of the data is 'EEG'.
%  TS=fileSelector('DataTest/Test_','mat',2,10,20,[],'EEG');
%  
%  See also composeData, computeS.

% Copyright (c) 2005
% Olivier Neal / Cristian Carmeli, Swiss Federal Institute of Technology
% Lausanne (EPFL), Switzerland
% http://lanoswww.epfl.ch/
%

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.


% Check number of inputs
if nargin<6
    error('Input missing, at least 6 inputs required, check help fileSelector');
elseif nargin>7
    error('Too many inputs, at max 7 inputs required, check help fileSelector');
end

% Handle wrong input
if NFFirst > NFLast
    error('NFFirst > NFLast. Try to permute input 4 and 5');
end

% ND has to be large enough to write file NFLast
lim=10^ND-1;
if NFLast>lim
    msg=strcat('ND=',num2str(ND),'.','Not enough digits to write file:',basename,num2str(NFLast));
    error(msg);
end

% Only .mat and .txt data files can be processed
if (strcmp(extension,'mat') + strcmp(extension,'txt'))<1
    error('Extension should be either "txt" or "mat"');
end

% check about string inputs
% 1
if isnumeric(basename) 
   error(['basename should be a string!']); 
end
% 2
if isnumeric(extension) 
   error(['extension should be a string!']); 
end


% 7 inputs necessary only for .mat  data files
if strcmp(extension,'mat'),
   if nargin~=7
       error(['For .mat files 8 inputs are required!']);
   elseif isnumeric(varargin{1}) 
      error(['dataname should be a string!']); 
   end
end
% end 

% warning if you use 
if strcmp(extension,'txt'),
    if nargin==7
        warning('For .txt files only 6 inputs are required');
    end
end

% check if every file is in the directory and the dataname are correct
for i=NFFirst:NFLast
    
    % name of the file to load
    FILE = strcat(basename,num2str(i,['%0' num2str(ND) 'i']),'.',extension);
    D = dir(FILE);
    
    % check if file exists
    if isempty(D),
        error(strcat('the file :', FILE , ' does not exist'));
    end
    
    % check dataname
    switch extension 
        
        % .mat  
        case 'mat'
           % dataname
           dataname=varargin{1};
           % structure-name
           E=load(FILE); 
           % check field name 
           if ~isfield(E,dataname),
              error([dataname ' is not the correct name for the data in ' FILE]);
           end
           
    end
    % end switch
        
end

% Initializing TS:
switch extension
    
    %%%%%%%
    % mat %
    %%%%%%%    
    case 'mat'
    % In each data file there is a structure in which element "data_XX" is a matrix containing
    % measurements from a given trial. All trials contain the same number
    % of measurements
    % FILE contains the name of the last data file previously checked
    
    % dataname
    dataname=varargin{1};
    
    % Load file number NFLast to get data size
    % FILE is basenameNFLast.extension 
    load(FILE);
    % data matrix
    DATA=eval(dataname);
    
    %%%%%%%
    % txt %
    %%%%%%%
    case 'txt'
        % When a .txt file is loaded, the result is a matrix, not a
        % structure
        % FILE contains the name of the last data file previously checked
        % Load file number NFLast to get data size
        % FILE is basename_NFLast.extension
        DATA=load(FILE);
        
end

% Size of data
[NP NCHS]=size(DATA);

% Size of the matrix that will be concatenated
TSSize=(NP+1)*ones(1,NFLast-NFFirst+1);
BI=cumsum([1 TSSize(1:end)]);

% Initializing TS
% Rows: measurements or NaN (separation of trials)
% Columns: sites
TS=zeros((NP+1)*(NFLast-NFFirst+1),NCHS);
        
            
% GO with all the files
switch extension 
    case 'mat'
        for i=0:(NFLast-NFFirst),

            % bad trials 
            if ismember(i+NFFirst,badTrials),

                % Bad trials
                TS(BI(i+1):BI(i+2)-2,:)=Inf([NP NCHS]);

                % Separation between trials
                TS(BI(i+2)-1,:)=NaN(1,NCHS);

            else

            % Separation between trials
            TS(BI(i+2)-1,:)=NaN(1,NCHS);

            % Name of the file to load
            FILE=strcat(basename,num2str(i+NFFirst,['%0' num2str(ND) 'i']),'.', extension);
           
            % FILE is basenameNFFirst+1.extension 
            load(FILE);

            % Fill TS (Time Series) trial by trial
            TS(BI(i+1):BI(i+2)-2,:)=eval(dataname);

            end
        end
    case 'txt'
        for i=0:(NFLast-NFFirst),
    
        % bad trials 
        if ismember(i+NFFirst,badTrials),
        
            % Bad trials
            TS(BI(i+1):BI(i+2)-2,:)=Inf([NP NCHS]);
        
            % Separation between trials
            TS(BI(i+2)-1,:)=NaN(1,NCHS);
        
        else
    
        % Separation between trials
        TS(BI(i+2)-1,:)=NaN(1,NCHS);

        % Name of the file to load
        FILE=strcat(basename,num2str(i+NFFirst,['%0' num2str(ND) 'i']),'.', extension);
    
        % Load file
        DATA=load(FILE);

        % Fill TS (Time Series) trial by trial
        TS(BI(i+1):BI(i+2)-2,:)=DATA;
    
        end
    end
        
end
% end