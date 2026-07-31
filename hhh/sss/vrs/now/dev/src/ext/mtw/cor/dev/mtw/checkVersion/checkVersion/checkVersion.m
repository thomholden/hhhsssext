% checkVersion Check for existence of a newer version of a file on Matlab's File Exchange
%
% Syntax:
%    [status,message] = checkVersion(filename,fexId,mode)
%
% Description:
%    checkVersion implements an auto-update background mechanism to check for
%    a newer version of a file on the Matlab File Exchange (FEX). This enables
%    FEX authors to easily embed an non-intrusive update mechanism in their
%    utilities, enabling its users to automatically update whenever a new
%    version is uploaded to FEX.
%
%    checkVersion(filename,fexId) checks on FILENAME's File Exchange webpage
%    whether any newer version of this utility has been uploaded. If so, a
%    popup notice is presented with the date and description of the latest
%    version. The popup enables users to download the newer version into the
%    current folder, or skip. There is also an option to skip the update and
%    not to remind ever again.
%
%    checkVersion is typically used after an applications has completed its
%    main task or has presented its GUI, in order to silently check for an
%    available update with minimal impact on the user. This could also be
%    done by using a background single-shot timer (see example below).
%
%    checkVersion(...,'silent') runs checkVersion in silent mode, without
%    prompting the user in case a newer version is detected. Newer file
%    versions will automatically be downloaded and installed.
%
%    [status,message] = checkVersion(...) returns a string with the update
%    check's status, along with an optional descriptive message
%       'ignored'    (message=empty)       - user requested not to be reminded
%       'unknown'    (message=webpage URL) - no newer version was ever uploaded to FEX, or FEX changed webpage format
%       'up-to-date' (message=upload date) - no newer version exists on FEX
%       'available'  (message=upload date) - newer version exists but not downloaded
%       'downloaded' (message=upload date) - newer version exists and downloaded
%       'error'      (message=error text)  - FEX download or parsing error
%
% Examples:
%    checkVersion('uiinspect',17935);
%    checkVersion('uiinspect',17935,'silent');
%    status = checkVersion('uiinspect',17935);
%    [status,message] = checkVersion('noSuchFile',1234);
%
%    % run checkVersion in a background single-shot timer
%    start(timer('TimerFcn',@(h,e)checkVersion('uiinspect',17935), 'StartDelay',5));
%
% Known issues/limitations:
%    This utility will silently fail if and when mathworks will ever modify the
%    File Exchange webpage format. In such case, download the latest version of
%    the utility, which hopefully solves the problem, or send me an email.
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Change log:
%    2013-02-21: Ensure file is writable before updating (Thierry Dalon); increased FEX grace period 2=>3 days
%    2013-01-24: First version posted on <a href="http://www.mathworks.com/matlabcentral/fileexchange/authors/27420">MathWorks File Exchange</a>
%
% See also:
%    urlread; UIInspect & FindJObj (both on the File Exchange)

% License to use and modify this code is granted freely to all interested, as long as the original author is
% referenced and attributed as such. The original author maintains the right to be solely associated with this work.

% Programmed by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.02 $  $Date: 2013/02/21 21:87:12 $
function [status,message] = checkVersion(filename,fexId,mode)
    try
        % Initialization (not really needed - just in case I forget somewhere below...)
        statusStr  = ''; %#ok<NASGU>
        messageStr = ''; %#ok<NASGU>

        % Sanity checks
        error(nargchk(2,3,nargin,'struct')); %#ok<NCHKN>
        if nargin < 3
            silentMode = false;
        elseif ~ischar(mode) || ~strcmpi(mode,'silent')
            error('invalid mode specified - only ''silent'' is supported.')
        else
            silentMode = true;
        end

        % Normalize the specified filename (strip path, extension)
        [fpath,filename,fext] = fileparts(filename); %#ok<ASGLU,NASGU>
        
        % If the user has not indicated NOT to be informed
        if ~ispref(filename,'dontCheckNewerVersion')

            % Download the relevant FEX webpage
            baseUrl = 'http://www.mathworks.com/matlabcentral/fileexchange/';  % old URL format: '/loadFile.do?objectId='
            fexId = num2str(fexId);  % accepts both 123 and '123' formats
            webUrl = [baseUrl fexId];
            webPage = urlread(webUrl);

            % Check whether the specified filename is mentioned in the webpage
            if ~silentMode && isempty(strfind(lower(webPage),lower(filename)))
                msg = {['The term "' filename '" is not mentioned anywhere on ' webUrl], '', ...
                        'Are you sure you wish to continue checking?'};
                answer = questdlg(msg,[filename ' update'],'Yes','No','No');
                switch answer
                    case 'Yes'  % => Yes: continue normally
                        % ignore
                    otherwise   % => No or cancel
                        error('Mismatched filename, fexId were specified');
                end
            end

            % Get the latest version date from the File Exchange webpage
            modIdx = strfind(webPage,'>Updates<');
            if ~isempty(modIdx)
                webPage = webPage(modIdx:end);
                % Note: regexp hangs if substr not found, so use strfind instead...
                %latestWebVersion = regexprep(webPage,'.*?>(20[\d-]+)</td>.*','$1');
                dateIdx = strfind(webPage,'class="date">');
                if ~isempty(dateIdx)
                    latestDate = webPage(dateIdx(end)+13 : dateIdx(end)+23);
                    messageStr = latestDate;
                    try
                        startIdx = dateIdx(end)+27;
                        descStartIdx = startIdx + strfind(webPage(startIdx:startIdx+999),'<td>');
                        descEndIdx   = startIdx + strfind(webPage(startIdx:startIdx+999),'</td>');
                        descStr = webPage(descStartIdx(1)+3 : descEndIdx(1)-2);
                        descStr = regexprep(descStr,'</?[pP]>','');
                    catch
                        descStr = '';
                    end

                    % Get this file's latest date
                    thisFileName = which(filename);  %#ok
                    if isempty(thisFileName)
                        thisFileDatenum = 0;
                    else
                        try
                            % Try to get the file's date from the file-system
                            thisFileData = dir(thisFileName);
                            try
                                thisFileDatenum = thisFileData.datenum;
                            catch  % old ML versions...
                                thisFileDatenum = datenum(thisFileData.date);
                            end
                        catch
                            % Failed for some reason - check whether an internal change-log can be found in the file
                            thisFileText = evalc('type(thisFileName)');
                            thisFileLatestDate = regexprep(thisFileText,'.*Change log:[\s%]+([\d-]+).*','$1');
                            thisFileDatenum = datenum(thisFileLatestDate,'yyyy-mm-dd');
                        end
                    end

                    % If there's a newer version on the File Exchange webpage (allow 3 days grace period)
                    if (thisFileDatenum < datenum(latestDate,'dd mmm yyyy')-3)
                        if silentMode
                            % silent mode - download & install without prompting
                            answer = 'Yes';
                        else
                            % interactive (default) mode - prompt the user
                            % Ask the user whether to download the newer version (YES, no, no & don't ask again)
                            if isempty(thisFileName)
                                msg = {[filename ' is apparently not installed in your Matlab path.'], '', ...
                                        'Download & install this utility from the Matlab File Exchange in current folder?'};
                            else
                                msg = {['A newer version (' latestDate ') of ' filename ' is available on the MathWorks File Exchange:'], '', ...
                                       ['\color{blue}' descStr '\color{black}'], '', ...
                                        'Download & install the new version in current folder?'};
                            end
                            createStruct.Interpreter = 'tex';
                            createStruct.Default = 'Yes';
                            answer = questdlg(msg,[filename ' update'],'Yes','No','No & never ask again',createStruct);
                        end
                        switch answer
                            case 'Yes'  % => Yes: download & install newer file
                                try
                                    %fileUrl = [baseUrl '/download.do?objectId=' fexId '&fn=' filename '&fe=.m'];
                                    fileUrl = [baseUrl '/' fexId '?controller=file_infos&download=true'];
                                    %contents = urlread(fileUrl);
                                    %contents = regexprep(contents,[char(13),char(10)],'\n');  %convert to OS-dependent EOL
                                    %fid = fopen(thisFileName,'wt');
                                    %fprintf(fid,'%s',contents);
                                    %fclose(fid);
                                    if isempty(thisFileName)
                                        thisFileName = filename;
                                    end
                                    [fpath,fname,fext] = fileparts(thisFileName); %#ok<NASGU>
                                    try fileattrib(thisFileName,'+w'); catch, end  % make file writable (Thierry Dalon 21/2/2013)
                                    zipFileName = fullfile(fpath,[fname '.zip']);
                                    urlwrite(fileUrl,zipFileName);
                                    unzip(zipFileName,fpath);
                                    try delete(zipFileName); catch, end  %#ok delete zip file after installation
                                    rehash;  % make the downloaded file(s) visible to Matlab's path
                                    statusStr = 'downloaded';
                                catch
                                    % Error downloading: inform the user
                                    statusStr = 'error';
                                    messageStr = lasterr;  %#ok<LERR>
                                    msgbox(['Error in downloading: ' lasterr], filename, 'warn'); %#ok<LERR>
                                    web(webUrl);
                                end

                            case 'No & never ask again'   % => No & don't ask again
                                setpref(filename,'dontCheckNewerVersion',1);
                                statusStr = 'ignored';  % return the upload date in messageStr

                            otherwise  % => No or cancel
                                % ignore (this time only)...
                                statusStr = 'available';
                        end
                    else
                        statusStr = 'up-to-date';  % hurray!...
                    end
                else
                    % FEX webpage has probably changed its format once again...
                    statusStr = 'unknown';
                    messageStr = webUrl;
                end
            elseif ~isempty(strfind(lower(webPage),'</html>'))
                % Maybe webpage changed format or no updates were uploaded - bail out...
                statusStr = 'unknown';
                messageStr = webUrl;
            else
                % Maybe webpage not fully loaded - bail out...
                statusStr = 'error';
                messageStr = [webUrl ' was not fully loaded for some reason'];
            end
        else
            % user requested never to be reminded about updating this utility
            statusStr = 'ignored';
            messageStr = '';
        end
    catch
        % Never mind...
        statusStr = 'error';
        messageStr = lasterr;  %#ok<LERR>
    end

    % Return the status & message, if requested
    if nargout > 0,  status  = statusStr;   end
    if nargout > 1,  message = messageStr;  end

%end  % checkVersion
