%% Strip C++ Comments
% This strips all the C++ Comments from the Application and stores all the
% files in a subdirectory |NoCCOmments|.
%
% Copyright 2008-2009 The MathWorks, Inc

if ~(exist('NoCComments','dir')==7)
    mkdir('NoCComments'); % Create directory
end

%% Get M files
files=dir('*.m');

%% For each M file
for k=1:length(files)
    fileName=files(k).name;
    if ~strcmp(fileName,'stripCComments.m') % Skip this file
        fidIn=fopen(fileName,'rt');
        fidOut=fopen(['NoCComments\' files(k).name],'wt');
        strIn=fscanf(fidIn,'%c'); % Read
        strOut=regexprep(strIn,'(\s+)% C\++ Code(.*?)%{(.*?)%}',''); % Remove
        strOut=regexprep(strOut,'\n\n','\n'); % Remove double new lines
        %strOut=regexprep(strOut,'\n(.*)','$1'); % Remove double new lines
        fprintf(fidOut,'%s', strOut); % Write
        fclose(fidIn);
        fclose(fidOut);
    end
end

%% Finish
fprintf('\nRemoved C++ Comments and stored files in subdirectory NoCCOmments.\n')