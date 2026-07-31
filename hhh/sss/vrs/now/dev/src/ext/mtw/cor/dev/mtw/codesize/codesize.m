function [files,lines,chars,codeLines,commentLines,codeChars,commentChars] = codesize(dirname,progress,level)
%CodeSize display information about the code size of a given source file or project folder
%
% Syntax:
%    [files,lines,chars,codeLines,commentLines,codeChars,commentChars] = codesize(dirname,progress)
%
% Input parameters:
%    dirname  - Name of source-code file, project parent folder or function handle
%               If not supplied, then the current folder name (pwd) is used
%               Note: all subfolders are recursively searched,
%                     unless dirname is preceeded with '-' (example below)
%    progress - Flag indicating whether to display searched files/folders onscreen
%               If not supplied, display progress only if no outputs requested
%               Note: this flag only affects the onscreen display - not the
%                     actual search
%
% Output parameters:
%    files        - Number of source-code files (*.m, *.c, *.h, *.java)
%    lines        - Number of lines within source-code file(s)
%    chars        - Number of characters within source-code file(s)
%    codeLines    - Number of code (non-comment) lines
%    commentLines - Number of comment lines
%    codeChars    - Approximate number of non-comment code characters
%    commentChars - Approximate number of comment characters
%
%    Note: The last 2 output parameters are only approximation
%    ^^^^  since the extraction heuristic is still imperfect
%
%    If no output argument is supplied, then the results are displayed
%    onscreen, in the Matlab Command Window.
%
% Examples:
%    codesize;  % display total code size of all source files in current dir
%    codesize('-');  % as above, but only for current folder (no sub-folders)
%    codesize('abc.m');  % display total code size of a specific source file
%    codesize('c:\work\',1);  % scan requested folder, displaying progress
%    codesize('-c:\work\',1); % as above, but don't scan sub-folders
%    codesize(@humps);  % scan the selected function's file
%
%    % scan current folder (pwd), returning data into variables (no onscreen display)
%    [files,lines,chars,codeLns,cmtLns,codeChars,cmtChars] = codesize;
%
% Known issues/limitations:
%    - Imperfect algorithm to separate commentChars from actual code
%    - Assumes Windows-format files (EOL=CR+LF). On Macs & Unix files the
%      reported # of chars is therefore incorrect by an amount of #lines
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Change log:
%    2007-07-10: Accepted no-extension filenames & func handles; added no-recursion option; added per-line & per-file info; clarified help
%    2007-07-07: Added sanity checks for input parameters; improved inline comments
%    2007-07-06: Fix for Mac/Unix; improved help
%    2007-07-06: First version posted on the <a href="http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&mfx=1&objectId=1096533">MathWorks file exchange</a>

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.3 $  $Date: 2007/07/10 20:31:28 $

  % If no input file/folder supplied, use current folder
  if nargin && isa(dirname,'function_handle')
      dirname = func2str(dirname);
  elseif nargin<1 || isempty(dirname) || ~ischar(dirname)
      dirname = pwd;
  elseif dirname(1) == '-'  % check for non-recursion indication
      if length(dirname) == 1
          dirname = pwd;
      else
          dirname = dirname(2:end);
      end
      level = -1;
  end

  % If progress flag not supplied, then display progress only if no output args
  if nargin<2 || isempty(progress) || numel(progress)~=1 || ~(islogical(progress) || isnumeric(progress))
      progress = ~nargout;
  end
  whichedDirname = '';
  try
      whichedDirname = which(dirname);
  catch
      % never mind...
  end
  if progress
      if isempty(whichedDirname)
          disp([dirname ' ...']);
      else
          disp([whichedDirname '...']);
      end
  end

  % Internal use only (indicates recursion level)
  if ~exist('level','var') || isempty(level) || numel(level)~=1 || ~isnumeric(level)
      level = 0;
  end

  % Initialize
  [files,lines,chars,codeLines,commentLines,codeChars,commentChars] = deal(0);

  % Check whether the supplied input parameter is a file or folder
  if exist(dirname,'dir')
      % Folder - recursively loop over all contained *.m/*.c/*.java folders/files
      % unless non-recursion was requested
      dr = dir(dirname);
      if length(dr) > 2  % skip the first two entries ('.' & '..')
          dr = dr(3:end);
          fileNames = {dr.name};
          % Loop over all this folder's sub-nodes
          for fileIdx = 1 : length(dr)
              fname = fileNames{fileIdx};
              % If sub-node is a sub-folder or source file
              if (level>=0 && dr(fileIdx).isdir) || ~isempty(regexp(fname,'\.(m|c|h|java)$','once'))
                  % Recursively run CodeSize over this sub-node
                  [a,b,c,d,e,f,g] = codesize([dirname filesep fname], progress, level+1);
                  files = files + a;
                  lines = lines + b;
                  chars = chars + c;
                  codeLines    = codeLines + d;
                  commentLines = commentLines + e;
                  codeChars    = codeChars + f;
                  commentChars = commentChars + g;
              end  % if sub-node is a sub-folder or source file
          end  % loop all sub-nodes
      end  % if not '.' or '..'
  else
      % File: first check for no extension - try to assume default '.m' extension
      if ~isempty(whichedDirname)
          dirname = whichedDirname;
      end
      % Parse built-in Matlab function files
      if strncmp(dirname,'built-in (',10)
          dirname = [dirname(11:end-1) '.m'];
      end

      % Now try to read the supplied file
      % Note: this will crash if filename is missing or unreadable - good!
      [fid,msg] = fopen(dirname,'rt');
      if fid <= 0
          error('YMA:CodeSize:InvalidPath',['Folder or file name ''' strrep(dirname,'\','\\') ''' cannot be read: ' msg]);
      end
      text = textscan(fid,'%s','delimiter','\n');
      fclose(fid);

      % Now parse the file's lines
      text = text{1};
      files = 1;
      lines = length(text);
      chars = length([text{:}]) + 2*lines;  % remember the CR-LF pairs at EOL...
      text = strtrim(text);
      text(cellfun('isempty',text)) = [];

      % Separate comment & code lines
      commentLines = sum(cellfun(@(s)(s(1)=='%'),text));
      codeLines = length(text) - commentLines;

      % Now the imperfect algorithm to separate comments from code...
      numChars = length([text{:}]);  %#ok no CR-LF this time
      commentChars = cellfun(@(s)(length(s)-strfind(s,'%')),text,'UniformOutput',false);
      commentChars = sum([commentChars{:}]);
      text = regexprep(text,'%.*','');  % delete everything from % to EOL - problem: % within strings
      text(cellfun('isempty',text)) = [];
      codeChars = length([text{:}]);  % no CR-LF this time
  end

  % Display the results onscreen if no output args requested
  emptyLines = lines - codeLines - commentLines;
  if ~nargout && (level <= 0)
      if files > 1
          fprintf(['\nTotal files:      %7d\n' ...
                   '\nTotal lines:      %7d  (avg. %d per file)\n' ...
                   '   code:      %7d (%2d%%, avg. %d per file)\n' ...
                   '   comment:   %7d (%2d%%, avg. %d per file)\n' ...
                   '   empty:     %7d (%2d%%, avg. %d per file)\n' ...
                   '\nTotal characters: %7d  (avg. %d per line, %d per file)\n' ...
                   '   code:      %7d (%2d%%, avg. %d per code    line, approx.)\n' ...
                   '   comment:   %7d (%2d%%, avg. %d per comment line, approx.)\n\n'], ...
                   files, ...
                   lines, round(lines/files),...
                      codeLines,    round(100*codeLines/lines),    round(codeLines/files), ...
                      commentLines, round(100*commentLines/lines), round(commentLines/files), ...
                      emptyLines,   round(100*emptyLines/lines),   round(emptyLines/files), ...
                   chars, round(chars/lines), round(chars/files), ...
                      codeChars,    round(100*codeChars/chars),    round(codeChars/codeLines),...
                      commentChars, round(100*commentChars/chars), round(commentChars/commentLines));
      else
          fprintf(['\nTotal files:      %7d\n' ...
                   '\nTotal lines:      %7d\n' ...
                   '   code:      %7d (%2d%%)\n' ...
                   '   comment:   %7d (%2d%%)\n' ...
                   '   empty:     %7d (%2d%%)\n' ...
                   '\nTotal characters: %7d  (avg. %d per line)\n' ...
                   '   code:      %7d (%2d%%, avg. %d per code    line, approx.)\n' ...
                   '   comment:   %7d (%2d%%, avg. %d per comment line, approx.)\n\n'], ...
                   files, ...
                   lines, ...
                      codeLines,    round(100*codeLines/lines), ...
                      commentLines, round(100*commentLines/lines), ...
                      emptyLines,   round(100*emptyLines/lines), ...
                   chars, round(chars/lines), ...
                      codeChars,    round(100*codeChars/chars),    round(codeChars/codeLines),...
                      commentChars, round(100*commentChars/chars), round(commentChars/commentLines));
      end
  end
  