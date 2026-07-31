function loadJavaCustomizations()
% loadJavaCustomizations - Load the custom java files
% -------------------------------------------------------------------------
% Abstract: Loads the custom Java .jar file required for the uiextras.jTree
%
% Syntax:
%           loadJavaCustomizations()
%
% Inputs:
%           none
%
% Outputs:
%           none
%
% Examples:
%           none
%
% Notes: none
%

%   Copyright 2012-2014 The MathWorks, Inc.
%
% Auth/Revision:
%   MathWorks Consulting
%   $Author: rjackey $
%   $Revision: 1018 $  $Date: 2014-11-04 15:48:56 -0500 (Tue, 04 Nov 2014) $
% ---------------------------------------------------------------------

% Define the jar file
JarFile = 'UIExtrasTree.jar';
JarPath = fullfile(fileparts(mfilename('fullpath')), JarFile);

% Check if the jar is loaded
JavaInMem = javaclasspath('-dynamic');
PathIsLoaded = any(strcmp(JavaInMem,JarPath));

% Load the .jar file
if ~PathIsLoaded
    fprintf('Loading customizations in %s\n', JarFile);
    javaaddpath(JarPath);
end
