% ERR=Profile_FillMenu(H_MENU,PATHNAME,KEEP_SELECTED)
%   This function searches PATHNAME for profile files, and then enters
%   all profiles into the menu specified by H_MENU.
%   
%   Input arguments:
%       H_MENU - the handle for the profile menu
%       PATHNAME - the path containing profile files.
%       KEEP_SELECTED - a boolean value indicating whether the same menu
%           option should remain selected after the reload. (optional,
%           default is false)
%   
%   Output arguments;
%       ERR - contains information in case of error
%
% Written by Alex Andrews, 2011-2013.

function sErrorInfo=Profile_FillMenu(hdlMenu,sPathname,bKeepSelected)

sErrorInfo='';
if nargin==2
    bKeepSelected=false;
end

% If requested, determine currently selected menu option
iSelected=[];
if bKeepSelected
    iSelected=get(hdlMenu,'Value');
end

% Retrieve list of valid profile files
cProfileNames=Profile.getProfileNames(sPathname,'this_version');
if isempty(cProfileNames)
    cProfileNames={'Select...'};
    % Alert user if no files found
    % Comm_Warn('No profiles found in profile directory!');    
else
    thisProfile=vCurrentProfile();
    if isempty(thisProfile)
        cProfileNames=['Select...',cProfileNames];
    else
        cProfileNames=['Select...',cProfileNames,'--> Clone this profile!'];
    end
end

% Fill menu
if bKeepSelected&&~isempty(iSelected)&&iSelected>=1&&...
        iSelected<=length(cProfileNames)
    set(hdlMenu,'Value',iSelected);
else
    set(hdlMenu,'Value',1);
end

set(hdlMenu,'String',cProfileNames);