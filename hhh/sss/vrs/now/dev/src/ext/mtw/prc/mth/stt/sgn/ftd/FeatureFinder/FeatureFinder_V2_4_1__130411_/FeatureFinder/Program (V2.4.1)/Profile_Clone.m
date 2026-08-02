% [NEW_PROFILE ERR]=Profile_Clone(THIS_PROFILE)
%   This function is used to create a new profile with identical settings
%   to the currently-loaded profile.
%   
%   Input arguments:
%       THIS_PROFILE - The profile to clone.
%       
%   Output arguments;
%       NEW_PROFILE
%       ERR - error value (true/false) 
%
% Written by Alex Andrews, 2011.

function [newProfile bError]=Profile_Clone(thisProfile)

bError=false;

% Determine the name of all other profiles
sPaths=vPaths();
cProfileNames=Profile.getProfileNames(sPaths.Profiles,'all_versions');

% Create new name
iMax=1000;
for i=0:iMax-1
	sNewName=sprintf('%s%03.0f',thisProfile.name,i);
	if ~any(strcmpi(sNewName,cProfileNames))
		break
	elseif i==iMax-1
		fprintf('ERROR:  No clone name available.\n\n');
		return
	end
end

% Create new profile
newProfile=thisProfile;
newProfile.name=sNewName;
bError=true;