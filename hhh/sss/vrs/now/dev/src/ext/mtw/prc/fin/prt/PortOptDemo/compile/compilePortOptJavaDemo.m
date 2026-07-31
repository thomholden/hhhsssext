function compilePortOptJavaDemo
% Function to compile all of the relevant parts of the Portfolio
% Optimisation Builder for Java demo.  
%


% Test the architecture first
arch = computer;
if ( strcmp(arch,'PCWIN64')) % || ismac)
    error('MATLAB Builder for JAVA cannot be run on Win64 and Mac machines');
end

% get the settings
params = getPortOptJavaDemoSettings;

% Do the compiling
setPathForJava;
doMcc(params);
doJavac(params);
buildJar(params);

fprintf('Run the PortOpt Demo now?  [Y/N] ');
reply = input('', 's');

runDemoCmd = ['java -jar ' params.FinalJarName];

if strcmpi(reply, 'y')
    disp('Loading demo.  Please wait.....')
    % change to the output directory
    currDir = cd(params.FinalOutputRoot);
    % run the demo
    [status, runDemoOut] = system(runDemoCmd);
    
    if (status ~= 0)
        error('Error running demo.\nCommand was:\n%s\n\nOutput of the command:%s\n\n',runDemoCmd,runDemoOut);
    end
    
    % change back to the original directory
    cd(currDir)
else
    fprintf('\nRun this demo later using the command: \n\t %s\n', runDemoCmd);
end




%%
function setPathForJava
% Ensure that the system path has been set up for Java compilation.

%see if JAVA_HOME has been set as an environment variable.  If not set it.
jdkDirName = getenv('JAVA_HOME');
if(isempty(jdkDirName))
    % get the JDK location from the user
    jdkDirName = uigetdir(matlabroot, 'Please select JDK Location:');

    if(jdkDirName == 0)
        error('Cannot compile PortOptDemo without the JDK installed');
    end

    %strip off '\bin' if it is there
    if(strcmpi(jdkDirName(end-3:end), '\bin'))
        jdkDirName = jdkDirName(1:end-4);
    end

    %set the JAVA_HOME environment variable
    disp('Setting the JAVA_HOME environment variable');
    setenv('JAVA_HOME', jdkDirName);
end

% see if JAVA_HOME\bin is on the path - if not, add it.
syspath = getenv('PATH');
if isempty(strfind(lower(syspath), lower(fullfile(jdkDirName, 'bin'))))
    disp('Adding JAVA_HOME\bin to the system path')
    setenv('PATH', [syspath, ';' fullfile(jdkDirName, 'bin')]);
end

%%
function doMcc(buildParams)
% Use Builder for Java to compile up the Matlab code into a jar

%check if the output directory exists
if(exist(buildParams.MLOutputRoot, 'dir') ~= 7)
    mkdir(buildParams.MLOutputRoot);
end

% generate the mcc command
mcccmd     = ['mcc -v -d ' buildParams.MLOutputRoot, ' ' ...
    '-W "java:' buildParams.MLGeneratedComponentName ',' ...
    buildParams.MLGeneratedClassName '" ' buildParams.mfileList];

% Do the mcc to compile the Matlab code into a jar
disp('Compiling Matlab Code...');
[status mccout] = system(mcccmd);

if ( (status ~= 0) || (exist(fullfile(buildParams.MLOutputRoot, 'portOptDemoJava.jar'),'file') ~= 2) )
    error('System and MCC command:\n%s\n\nOutput of the command:%s\n\n',mcccmd,mccout);
else
    disp(sprintf('\tDone'));
end

%%
function doJavac(buildParams)
% Compile the java code

%check if the output directory exists
if(exist(buildParams.compiledJavaPath, 'dir') ~=7)
    mkdir(buildParams.compiledJavaPath);
end

%set up the classpath
if ispc
    delim = ';';
else
    delim = ':';
end

classStr = { '.' delim, ...
    '"', fullfile(matlabroot,'toolbox','javabuilder','jar','javabuilder.jar'), '"', delim, ...
    '"', fullfile(buildParams.MLOutputRoot, [buildParams.MLGeneratedComponentName '.jar']), '"'};
if ~isempty(buildParams.demoJavaAdditionalJars)
    classStr = [classStr, delim, '"', fullfile(buildParams.demoJavaLibRoot, ...
     buildParams.demoJavaAdditionalJars), '"'];
end

classpath = strcat(classStr{:});

% Don't put quotes around the file list because javac doesn't like it.
javaCodeFileList = [fullfile(buildParams.demoJavaPackagePath, '*.java')];
if ~isempty(buildParams.demoJavaAdditionalPath)
    javaCodeFileList = [fullfile(buildParams.demoJavaAdditionalPath, '*.java'), ' ' , javaCodeFileList];
end

% copy the properties files from the source to the compiled classes
% directory
copyfile(fullfile(buildParams.PropertiesLocation, '*.properties'), ...
    buildParams.compiledJavaPath);

% form the javac command for compiling the code
javaccmd = ['javac -classpath ' classpath , ' -d "', buildParams.compiledJavaPath, '" ', javaCodeFileList];

% do the javac command
disp('Compiling Java Code...');
[status javacout] = system(javaccmd);

if ( (status~=0))
    error('JAVAC command used to compile the client application :\n%s\n\nOutput of javac command :\n%s\n',javaccmd,javacout);
else
    disp(sprintf('\tDone'));
end

%%
function buildJar(buildParams)
%Build the jar

%check if the output directory exists
if(exist(buildParams.FinalOutputRoot, 'dir') ~=7)
    mkdir(buildParams.FinalOutputRoot);
end

%first copy javabuilder.jar and the ML-generated .jar and .ctf into the
%final output folder so that everything can be bundled into a final jar
javaBuilderFilename = 'javabuilder.jar';
jarFilename = [buildParams.MLGeneratedComponentName '.jar'];
ctfFilename = [buildParams.MLGeneratedComponentName '.ctf'];

copyfile(fullfile(matlabroot,'toolbox','javabuilder','jar',javaBuilderFilename), ...
    fullfile(buildParams.FinalOutputRoot, javaBuilderFilename));
copyfile(fullfile(buildParams.MLOutputRoot, jarFilename), fullfile(buildParams.FinalOutputRoot, jarFilename));

% From R2007b onwards, the .ctf is included in the .jar file, so only copy
% the .ctf if it exists
tmpfilename = fullfile(buildParams.MLOutputRoot, ctfFilename);
if exist(tmpfilename, 'file')
    copyfile(tmpfilename, fullfile(buildParams.FinalOutputRoot, ctfFilename));
end

% form the jar command
jarcmd = ['jar cmf ', fullfile(buildParams.demoJavaCodeRoot, 'manifest.mf '), ...
    fullfile(buildParams.FinalOutputRoot, buildParams.FinalJarName) ' -C ', buildParams.compiledJavaPath, ' .'];

% do the jar command
disp('Creating JAR...');
[status, jarout] = system(jarcmd);

if( (status ~= 0) || (exist(fullfile(buildParams.FinalOutputRoot, buildParams.FinalJarName), 'file') ~= 2))
    error('JAR command:\n%s\n\nOutput of the command:%s\n\n', jarcmd, jarout);
else
    disp(sprintf('\tDone'));
end
