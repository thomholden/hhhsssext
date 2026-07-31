%
% cj_compile_script
%

%% Directories copied from OpenNIDevEnvironment
OPENNI2_INCLUDE = '/Users/cjt/Projects/OpenNI-MacOSX-x64-2.2/Include';
OPENNI2_REDIST  = '/Users/cjt/Projects/OpenNI-MacOSX-x64-2.2/Redist';

%% Compile call

mex(['-L' OPENNI2_REDIST],'-lOpenNI2',['-I' OPENNI2_INCLUDE],'mxNI.cpp');