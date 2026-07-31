function params = getPortOptJavaDemoSettings
% Defines the settings for all of the files in the Portfolio Optimisation
% Java Demo.


%% Matlab-related Java settings
% m-files to put in jar archive
params.mfileSourceRoot = '..\matlab_src';
params.mfileList = [fullfile(params.mfileSourceRoot, 'readStockDataFromFile.m'), ' ', ...
    fullfile(params.mfileSourceRoot, 'optimisePortfolio.m')];
% component name for jar
params.MLGeneratedComponentName = 'portOptDemoJava';
% class name to generate
params.MLGeneratedClassName = 'portOptDemoJavaClass';
%where to put the generated .jar and .ctf
params.MLOutputRoot = fullfile(params.mfileSourceRoot, params.MLGeneratedComponentName);


%% settings for external Java code
params.demoJavaCodeRoot = '..\JavaCode';
%where the java source files are
params.demoJavaSourceRoot = fullfile(params.demoJavaCodeRoot, 'src');
%where the additional libs are
params.demoJavaLibRoot = fullfile(params.demoJavaCodeRoot, 'lib');
% where to put the compiled Java code
params.compiledJavaPath = fullfile(params.demoJavaCodeRoot, 'build');
% package name for the source code
params.demoJavaPackagePath = fullfile(params.demoJavaSourceRoot, 'com', 'mathworks', 'demos', 'finance', 'portoptdemo');

% additional package names
if (findstr(version, 'R2006b'))
    % additional package names (for com.mathworks.toolbox.javabuilder.Images)
    params.demoJavaAdditionalPath = fullfile(params.demoJavaSourceRoot, 'com', 'mathworks', 'toolbox', 'javabuilder');
else
    params.demoJavaAdditionalPath = [];
end

% additional jar names
params.demoJavaAdditionalJars = [];

%% settings for output 
%where the properties files are
params.PropertiesLocation = params.demoJavaSourceRoot;
% the final jar filename
params.FinalJarName = 'portOptDemo.jar';
% where to put the final jar
params.FinalOutputRoot = '..\distrib';
