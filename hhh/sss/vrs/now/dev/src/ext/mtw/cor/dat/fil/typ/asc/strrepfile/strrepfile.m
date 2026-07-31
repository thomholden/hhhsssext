function strrepfile(fileinfo,str1,str2)
% STRREPFILE Apply the STRREP function to the file content.
%    STRREPFILE Scan the whole file(s) to replace strings with another.
%
%    STRREPFILE(PATH,S1,S2) applys to all Mfiles present in the PATH directory.
%
%    STRREPFILE(FILE,S1,S2) applys to FILE; if FILE has no path specifications,
%        it is searched in the current directory.
%
%    Use of wildcards is allowed. For example:
%
%        strrepfile('*.txt','Europe','Africa') applys to all .txt files in the current directory
%
%    If no replace is performed, the file remains unchanged.
%
%    NOTE: when rewriting the file, a '\n' is used at the end of each line,
%    even if the original line had a '\r\n' line separator.
%
%    See also STRREP.
	

%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 23-Apr-2004 12:11:00 $


% handle fileinfo
if exist(fileinfo,'dir'),
	filepath = fileinfo;
	content = what(filepath);
	files = cellstr(content.m);
elseif exist(fileinfo,'file'),
	[filepath,files,ext] = fileparts(fileinfo);
	if isempty(filepath),
		filepath = cd;
	end
	files = cellstr([files ext]);
else, % try to use dir command to get files names (maybe user used wildcards!)
	try,
		[filepath,files,ext] = fileparts(fileinfo);
		if isempty(filepath),
			filepath = cd;
		end
		content = dir(fileinfo);
		if isempty(content),
			files = [];
		else,
			isdir = [content.isdir];
			files = {content(~isdir).name};
		end
	catch,
		error('Argument must be a filepath name, a fullpath file name, or a file name! Wildcards can be used')
	end
end

% handle str1 and str2
str1 = cellstr(str1);
str2 = cellstr(str2);
n1 = numel(str1);
n2 = numel(str2);
if n1~=n2,
	if n1>1 & n2==1,
		str2 = repmat(str2,n1);
	else,
		error('Arguments 2 and 3 must have the same number of elements, or argument3 may be a scalar cell of string.')
	end
else,
	% n1==n2, that is OK!
end

% change current directory
olddir = cd;
cd(filepath);

% preset counter
counter.read = 0;
counter.write = 0;
counter.error = 0;

% update file
Nfiles = length(files);
% reset byte counter
% bytes_old = zeros(Nfiles,1);
% bytes_new = bytes_old;
% loop each file
for index = 1:Nfiles,
	filename = files{index};
	changed = 0; % changed flag
	fprintf(['File ' filename ' ... ']);

	try,
		% log "read file"
		fprintf('reading ... ');
		% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% 1. read the full file
		% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		str = textread(fullfile(filepath,filename),'%s','delimiter','\n','whitespace','');
		str_new = str;
		
		% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% 2. scan all lines to replace the strings
		% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		for s=1:n1,
			str_new = strrep(str_new,str1(s),str2(s));
		end
		
		% check if a change has been made
		if ~isempty(str) & ~isempty(str_new),
			if ~isequal(str,str_new),
				changed=1;
			end
		elseif isempty(str) & isempty(str_new),
			% changed=0;
		else, % one is empty while the other is not!
			changed=1;
		end
		
		counter.read = counter.read + 1;

		if changed,
			% log "write file"
			fprintf('writing ... ');
			% 2. overwrite it
			try,
				fid = fopen(filename,'w');
				fprintf(fid,'%s\n',str_new{:});
				fclose(fid);
				counter.write = counter.write + 1;
			catch,
				counter.error = counter.error + 1;
			end
		else,
			% log "unchanged"
			fprintf('unchanged ... ');
		end

		% log "done"
		fprintf('done\n');

	catch,
		% log "error"
		fprintf('\nerror\n');
		counter.error = counter.error + 1;
	end
end

% restore current directory
cd(olddir);

% termination log
fprintf('\n');
fprintf('%5g  file red\n',counter.read);
fprintf('%5g  file written\n',counter.write);
fprintf('%5g  errors\n',counter.error);
fprintf('\n');
