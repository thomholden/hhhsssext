function installCSVReader
% installs opencsv JAR into matlab java library and adds it to the static
% java classpath in matlab
%
% run this function from the working directory that contains the opencsv
% JAR file
%
% There is no "uninstall" function, but the following can be done manually
% to reverse this script:
%   1) delete the opencsv JAR that was copied to the first directory of the
%   MATLAB user directory (type 'userpath' at the command window)
%   2) Remove the entry in MATLAB's static jaj class path.
%		a) In MATLAB 2012b and newer: 
%			find the text file 'javaclasspath.txt' in your MATLAB preferences
%   		directory (type 'predir' at the command window) and delete the line
%   		hat lists the JAR in (1).
%		b) In MATLAB 2012a and older:
%			Find the 'classpath.txt' file by typing the following in the command
%			line:
%				which classpath.txt
%			Open the file in an editor and find and remove the line that has the
%			file location created in (1).
%
% Copyright Kristofer D. Kusano 9/13/2013
%
% This project uses the opencsv java library. The opencsv project
% website is http://opencsv.sourceforge.net.

%% did we already run this?
cp = javaclasspath('-all');
open_jar = 'opencsv-2.3.jar'; % name of jar
if (~all(cellfun(@isempty, strfind(cp, open_jar))))
    error('installCSVReader:AlreadyOnJavaPath',...
        '%s is already on the java class path. You CSVReader is probably already properly configured',...
        open_jar)
end
%% check JAR exists
open_jar = fullfile(pwd, 'opencsv-2.3.jar');
if (exist(open_jar, 'file') ~= 2)
    error('installCSVReader:JarNotOnPath',...
        'The opencsv JAR was not found (%s)', open_jar)
end
%% copy JAR to matlab root directory
[~,jn,je] = fileparts(open_jar);
up = userpath;
up = regexp(up, ';', 'split');
if (~isempty(up))
    up = up{1};
    mvpath = fullfile(up, [jn, je]);
    fprintf('Copying the file\n %s\n  to\n %s\n\n', open_jar, mvpath);
    movefile(open_jar, mvpath); % move
else
    error('installCSVReader:NoUserPath', 'User path is empty?!?')
end
%% Check version
verstr = version;
verstr = strtrim(regexprep(verstr, '\(.*\)', ''));
vercell = regexp(verstr, '\.', 'split');
v = cellfun(@str2num, vercell);
%% Edit static Class path, depending on version
if (v(1) >= 7 && v(2) < 14)
    % 2012a and before - still uses classpath.txt
    a = which('classpath.txt'); % location of current
    if (~isempty(a))
        fid = fopen(a, 'a');
        fprintf(fid, '%s\n', mvpath);
        fclose(fid);
    else
        error('installCSVReader:NoClassPath',...
            'No java class path on pre 2012a version')
    end
elseif (v(1) >= 7 && v(2) >= 15 || v(1) >= 8)
    % add to static java class path
    jcp_txt = fullfile(prefdir, 'javaclasspath.txt');
    if (exist(jcp_txt, 'file'))
        fid = fopen(jcp_txt, 'a'); % append current
    else
        fid = fopen(jcp_txt, 'w'); % doesn't yet exist
    end
    fprintf(fid, '%s\n', mvpath);
    fclose(fid);
end
%% for current session, add to dynamic class path (avoid restart)
javaaddpath(mvpath);

disp('Done')