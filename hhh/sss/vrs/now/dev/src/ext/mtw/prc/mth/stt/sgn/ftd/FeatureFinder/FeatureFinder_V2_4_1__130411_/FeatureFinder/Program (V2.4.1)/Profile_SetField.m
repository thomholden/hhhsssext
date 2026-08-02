% Profile_SetField(FIELDNAME,FIELD,[CHANNEL])
%   This function sets the field value(s) specified by FIELDNAME to the 
%   value(s) FIELD for the current profile.  The FIELDNAME parameter can 
%   be a cell of multiple strings, providing that the FIELD parameter is
%   either a single string or a cell of strings with the same length
%   as FIELDNAME.
%   
%   Input arguments:
%       FIELDNAME - The name of the field(s) from which values are to be
%           set.  This can be a cell of any size, e.g., {'Lucy'} or
%           {'Gabe','Lisa','Alex'}
%       FIELD - The field value(s) to be put in the field(s) specified by
%           FIELDNAME.  This must either be a single string, in which case
%           all fields in FIELD are set to that value, or a cell of strings
%           of the same length as FIELD.
%       CHANNEL - The channel for which the field will be set.  (Default is
%           currently loaded file.)
%
%   Output values:
%       none
%
% Written by Alex Andrews, 2011, 2013.

function Profile_SetField(cFieldname,cField,nChannel)

% ------------------------
% -- 1.0 Function setup --
% ------------------------


sPaths=vPaths();
thisProfile=vCurrentProfile();
Profile_Settings=thisProfile.propertyList;
if ~isempty(thisProfile.chanInfo)&&~isempty(thisProfile.chanInfo.numChan)
    nNumChans=thisProfile.chanInfo.numChan;
else
    nNumChans=[];
end

% Check input arguments
if nargin==2
    if ~isempty(thisProfile.getChannel)
        nChannel=thisProfile.getChannel;
    else
        nChannel=[];
    end
elseif nargin~=3
    fprintf('ERROR:  Wrong number of inputs to Profile_SetField\n\n');
    return
end

if ~isempty(nChannel)&&(isempty(nNumChans)||nChannel<1||nChannel>nNumChans)
    fprintf('ERROR:  Bad channel information. (Profile_GetField)');
    return
end

if ~isempty(nChannel)
    Data_Settings=thisProfile.dataSettings{nChannel};
else
    Data_Settings={'',''};
end

% 1.1 If cFilename is a string, convert to cell
if ~iscell(cFieldname)
    cFieldname={cFieldname};
end

% 1.2 If cField isn't a cell, convert to cell
if ~iscell(cField)
    if ischar(cField)
        cField={cField};
    else
        fprintf('ERROR:  Non-string input as field value to Profile_SetField. New value not saved.\n\n')
        return
    end
% Otherwise, verify that all elements are strings    
elseif ~all(cellfun(@ischar,cField))
    fprintf('Non-string input as field value to Profile_SetField.  New value not saved.\n\n')
    return
end

% 1.3 Check that cField length is either the same as cFieldname or one
if length(cField)~=length(cFieldname)&&length(cField)~=1
    fprintf('Bad dimension of field argument passed to Profile_SetField.  New value not saved.\n\n');
    return
end

% 1.4 If cField is length 1, multiply it to be the same size as cFieldname
if length(cField)==1
    cField(1:length(cFieldname))=cField(1);
end


% ----------------------------------------
% -- 2.0 Find fields and set new values --
% ----------------------------------------

% 2.1 Loop through all given field names
for i=1:length(cFieldname)
    % Find row with given field name
    iInPS=strcmpi(Profile_Settings(:,1),cFieldname{i});  
    iInDS=strcmpi(Data_Settings(:,1),cFieldname{i});  
    if any(iInPS)&&any(iInDS)
        fprintf('WARNING:  Redundancy found in settings\n\n');
        % Set new field
        Profile_Settings{iInPS,2}=cField{i};    
    elseif any(iInPS)
        % Set new field
        Profile_Settings{iInPS,2}=cField{i};    
    elseif any(iInDS)&&~isempty(nChannel)
        % Set new field
        Data_Settings{iInDS,2}=cField{i};    
    else
        fprintf(['ERROR:  Field name not found! (',cFieldname{i},')\n\n']);
        return        
    end    
    
end


% -----------------------------
% -- 3.0 Resave profile file --
% -----------------------------

if ~isempty(nChannel)
    thisProfile.dataSettings{nChannel}=Data_Settings;
end
thisProfile.propertyList=Profile_Settings;
vCurrentProfile('set_value',thisProfile);
