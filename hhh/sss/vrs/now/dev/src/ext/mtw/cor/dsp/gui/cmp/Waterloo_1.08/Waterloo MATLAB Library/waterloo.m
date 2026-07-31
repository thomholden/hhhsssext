function varargout=waterloo(option)
% WATERLOO adds Project Waterloo folders to the MATLAB path
% (and Java class paths with the full project installed)
%
% Example:
%       waterloo()
%           Loads all of Project waterloo
%
% To add components individually, or incrementally, supply an input argument
% which is the sum of the following
%      1 for the Graphics Library
%      2 for the Swing Library
%      4 for the Utilities functions
%      8 for the platform specific features
%     16 Dev only
% Thus, waterloo(15) would be equivalent to waterloo() with no arguments
%
% If present, the relevant jar files will be added to the MATLAB dynamic
% Java class path (not available e.g. on the TMW FEX distribution - visit
% the full project page at the URL below).
%
% ---------------------------------------------------------------------
% Part of the sigTOOL Project and Project Waterloo from King's College
% London.
% http://sigtool.sourceforge.net/
% http://sourceforge.net/projects/waterloo/
%
% Contact: ($$)sigtool(at)kcl($$).ac($$).uk($$)
%
% Author: Malcolm Lidierth 12/10
% Copyright The Author & King's College London 2011-
% ---------------------------------------------------------------------

% Use the Java System Property to store a flag - avoids use of persistent
% variable (which will be reset on clear classes - a pain when developing
% code).

wversion=1.08;

if nargin==1 && ischar(option) && strcmpi(option, 'version')
    d=dir(which('waterloo.m'));
    fprintf('Project Waterloo [Version=%g Dated:%s]\n', wversion, d.date);
    if nargout>0;varargout{1}=wversion;end
    return
end

if nargin==0
    option=15;
end
option=uint16(option);

loaded=java.lang.System.getProperty('Waterloo.MCODELoaded');
if ~isempty(loaded)
    loaded=uint16(str2double(loaded));
    and=bitxor(loaded,option);
    option=bitand(and, option);
end

% Option selection
Graphics=bitget(option,1);
Swing=bitget(option,2);
Utilities=bitget(option,3);
Platform=bitget(option,4);

d=dir(which('waterloo.m'));

% Get the main waterloo folder path
thisFolder=fileparts(which('waterloo.m'));

if option
    
    % Note that with incremental additions, addpath may be called for
    % folders that are already added, but this is harmless
    
    % Now install those components that are present
    folder=fullfile(thisFolder, 'Waterloo Graphics Library');
    if isdir(folder) && Graphics
        addpath(genpath(folder));
        fprintf('\nProject Waterloo Graphics Library loaded\n');
    end
    
    folder=fullfile(thisFolder, 'Waterloo Swing Library');
    if isdir(folder) && Swing
        addpath(genpath(folder));
        fprintf('\nProject Waterloo Swing Library loaded\n');
    end
    
    folder=fullfile(thisFolder, 'Utilities');
    if isdir(folder) && Utilities
        addpath(genpath(folder));
        fprintf('\nProject Waterloo Utilities loaded\n');
    end
    
    folder=fullfile(thisFolder, 'platform', computer());
    if isdir(folder) && Platform
        addpath(genpath(folder));
        fprintf('\nProject Waterloo Platform Library loaded [%s]\n', computer());
    end
end


% Set the Loaded flag
java.lang.System.setProperty('Waterloo.MCODELoaded',...
    num2str(bitor(option,uint16(str2double(java.lang.System.getProperty('Waterloo.MCODELoaded'))))));

fprintf('\nProject Waterloo [Version=%g Dated:%s]\n', wversion, d.date);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add jars to the dynamic java class path if it's not there already
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Move up in folder tree using '..'
thisFolder=fullfile(thisFolder, '..');
folder=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-base', 'dist');

if isdir(folder)
    % Developer version
    DEVELOPER=true;
    m=methods('kcl.waterloo.graphics.GJGraph');
    % m will be empty if not on class path...
    if isempty(m)
        % so add it
        if exist(fullfile(folder, 'kcl-waterloo-base.jar'),'file')
            
            % BASE DISTRIBUTION
            javaaddpath(fullfile(folder, 'kcl-waterloo-base.jar'));
            
            %                 % MAPS
            %                 folder=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-map', 'dist');
            %                 javaaddpath(fullfile(folder, 'kcl-waterloo-map.jar'));
            %
            %
            %                 % JOGL - use 1 OR 2, not both
            %                 % Use JOGL1 and jzy3d 0.8.4
            %                 folder=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-jogl1', 'dist');
            %                 javaaddpath(fullfile(folder, 'kcl-waterloo-jogl1.jar'));
            %                 %                 % JOGL2 - Dev only. Jogl2 will only work when MATLAB is set-up
            %                 %                 % appropriately. Note that natives are in jar files on
            %                 %                 % recent JOGL RCs
            %                 %                 folder=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-jogl2', 'dist');
            %                 %                 javaaddpath(fullfile(folder, 'kcl-waterloo-jogl2.jar'));
            %
            %
            %                 % I/O
            %                 folder=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-io', 'dist');
            %                 javaaddpath(fullfile(folder, 'kcl-waterloo-io.jar'));
            %
            %                 % R etc
            %                 folder=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-engine', 'dist');
            %                 javaaddpath(fullfile(folder, 'kcl-waterloo-engine.jar'));
            %
            % OLD stuff - will be dropped eventually
            folder=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-matlab', 'dist');
            javaaddpath(fullfile(folder, 'kcl-waterloo-matlab.jar'));
            
        end
        
        jar=fullfile(thisFolder, 'waterlooPlot', 'out', 'artifacts', 'waterlooPlot_jar', 'waterlooPlot.jar');
        if exist(jar,'file')
            javaaddpath(jar);
        end
    end
    
    
    % Synch the dev folders to the distribution folder
    
    if(option>15)

    source=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-base', 'dist');
    target=fullfile(thisFolder, 'Waterloo Java','kcl-waterloo-base', 'dist');
    if(~isdir(target));mkdir(target);end
    copyfile(source,target);
    
    source=fullfile(thisFolder, 'private', 'Java1.6', 'kcl-waterloo-matlab', 'dist');
    target=fullfile(thisFolder, 'Waterloo Java','kcl-waterloo-matlab', 'dist');
    if(~isdir(target));mkdir(target);end
    copyfile(source,target);
    
    source=fullfile(thisFolder, 'waterlooPlot', 'out', 'artifacts', 'waterlooPlot_jar');
    target=fullfile(thisFolder,  'Waterloo Java', 'waterlooPlot', 'waterlooPlot_jar');
    if(~isdir(target));mkdir(target);end
    copyfile(source,target);
    
    end
    
else
    % Compiled distribution
    DEVELOPER=false;
    
    
    folder=fullfile(thisFolder, 'Waterloo Java');
    
    m=methods('kcl.waterloo.graphics.GJGraph');
    % m will be empty if not on class path...
    if isempty(m)
        % so add it
%         if exist(fullfile(folder, 'kcl-waterloo-base', 'dist', 'kcl-waterloo-base.jar'),'file')
%             
%             % BASE DISTRIBUTION
%             javaaddpath(fullfile(folder, 'kcl-waterloo-base', 'dist', 'kcl-waterloo-base.jar'));
%         end
            
            % OLD stuff - will be dropped eventually
            folder=fullfile(thisFolder, 'Waterloo Java', 'kcl-waterloo-matlab', 'dist');
            javaaddpath(fullfile(folder, 'kcl-waterloo-matlab.jar'));
            

        
%         jar=fullfile(thisFolder,  'Waterloo Java', 'waterlooPlot', 'waterlooPlot_jar', 'waterlooPlot.jar');
%         if exist(jar,'file')
%             javaaddpath(jar);
%         end
        
        
    end
    
    java.lang.System.setProperty('Waterloo.JavaLoaded', 'true');
    %fprintf('\nProject Waterloo Java files added to MATLAB Java class path\n');
end

% JavaFX
% If WATERLOO_JAVAFX_HOME is set appropriately, JavaFX colors
% such as 'SEAGREEN' etc can be used. Specify these using
% strings. More support for JavaFX will be added over time.
% if (isempty(java.lang.System.getProperties().get('WATERLOO_JAVAFX_LOADED')));
%     fprintf('\nLooking for JavaFX support...');
%     JavaFX_HOME=java.lang.System.getProperties().get('WATERLOO_JAVAFX_HOME');
%     if isempty(JavaFX_HOME)
%         disp('skipping JavaFX installation - "WATERLOO_JAVAFX_HOME" not set');
%     else
%         jar=fullfile(JavaFX_HOME, 'jfxrt.jar');
%         if exist(jar,'file')
%             fprintf('Found.\nAdding JavaFX support.\n');
%             javaaddpath(jar);
%             if (DEVELOPER)
%                 jar=fullfile(thisFolder, 'waterlooFX', 'out', 'artifacts', 'waterlooFX_jar', 'waterlooFX.jar');
%                 javaaddpath(jar);
%             end
%             prop=java.lang.System.getProperties();
%             prop.put('WATERLOO_JAVAFX_LOADED', 'TRUE');
%         end
%     end
% end

fprintf('\nLooking for sigTOOL support...');
filename=which('sigTOOL.m');
if ~isempty(filename)
    fprintf('Found.\nAdding sigTOOL support.\n');
    jar=fullfile(thisFolder, 'eclipse', 'sigTOOLGUI', 'dist', 'sigTOOLGUI.jar');
    if exist(jar,'file')
        javaaddpath(jar);
    end
end


% Now set options

% Set up compression as the default for XML output
%kcl.waterloo.XMLCoder.GJEncoder.setCompression(true);


fprintf('\nProject Waterloo option(s) loaded [Version=%g Dated:%s]\n', wversion, d.date);


return
end


