function uimenufileexportcb(obj,eventdata) %#ok
% tatool helper function for processing the file export menu callbacks
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);

% read data from all axes
datastruct = getdatastruct(ad.handles.tatoolfig);
% Modify it to take account of indicators such as bollinger that have
% multiple lines associated with them
% Firstly get the number of dates for the price series, which should be the
% first one
ndates = length(datastruct.(ad.axestags{1})(1).dates);
%Then loop through the data sets and split any series that are longer
%than the rest
for idx = 1:length(ad.axestags)
    this_axes = datastruct.(ad.axestags{idx});
    for jdx = length(this_axes):-1:1
        ldates = length(this_axes(jdx).dates);
        if  ldates ~= ndates
            % This series needs to be split up
            nlines = round((ldates+1)/(ndates+1));  % 'round' isn't really needed here
            this_axes(min(jdx+nlines,end+nlines-1):end+nlines-1) = this_axes(min(end,jdx+1):end);
            % set new names
            switch nlines
                case 2
                    this_axes(jdx+1).name = [this_axes(jdx).name,'lower'];
                    this_axes(jdx).name = [this_axes(jdx).name,'upper'];
                case 3
                    this_axes(jdx+2).name = [this_axes(jdx).name,'lower'];
                    this_axes(jdx+1).name = [this_axes(jdx).name,'middle'];
                    this_axes(jdx).name = [this_axes(jdx).name,'upper'];
                otherwise % use generic names
                    for kdx = (nlines-1):-1:0
                        this_axes(jdx+kdx).name = [this_axes(jdx).name,'series',num2str(kdx+1)];
                    end
            end
            % Now do the data and dates
            for kdx = nlines:-1:1
                this_axes(jdx+kdx-1).dates = this_axes(jdx).dates(((ndates+1)*(kdx-1)+1):((ndates+1)*kdx-1));
                this_axes(jdx+kdx-1).data = this_axes(jdx).data(((ndates+1)*(kdx-1)+1):((ndates+1)*kdx-1)); 
            end
        end
    end
    % poke new data into old structure
    datastruct.(ad.axestags{idx}) = this_axes;
end

% getname of variable to save to, using the name of the series as the
% default
defaultname = lower(datastruct.(ad.axestags{1})(1).name);
switch defaultname(1) % Modify name because of TEX interpreter
    case '^'
        defaultname = defaultname(2:end);
    case '_'
        defaultname = defaultname(2:end);
end

% get name of variable to save to
varnamecell  = varnamedlg(...
    'Name','Variable Name Query',...
    'PromptString','Please enter a name to use as a variable...',...
    'OKString','OK',...
    'InputStrings',{'Name:'},...
    'InputDefaults',{defaultname});
if isempty(varnamecell)
    % No period was entered so do nothing
    return
else
    % extract from cell array
    varname = varnamecell{1};
end

tag = get(obj,'Tag');
switch tag
    case 'uimenufileexportstruct'
        assignin('base',varname,datastruct);
    case {'uimenufileexportMATLABts','uimenufileexportfints'}
        % need to extract data and field names
        % We'll assume that all the dates vectors are the same.  This
        % should be true for tatool
        dates = datastruct.(ad.axestags{1})(1).dates;
        dates = dates(:); % ensure it's a column
        fnames = {};
        data = [];
        for idx = 1:length(ad.axestags)
            this_axes = datastruct.(ad.axestags{idx});
            for jdx = 1:length(this_axes)
                fnames{end+1} = strrep(this_axes(jdx).name,':','_'); %#ok colon is illegal in a name so swap with underscore
                thisdata = this_axes(jdx).data;
                data(:,end+1) = thisdata(:); %#ok
            end
        end
        fnames{1}='original_data'; % going to set the first name rather than use the data name
        switch tag
            case 'uimenufileexportMATLABts'
                % Need to loop over the names making them a timeseries
                % object and adding them to a timeseries collection
                tsc = tscollection(dates,'IsDateNum',true); % empty collection
                for idx = 1:length(fnames)
                    mts = timeseries(data(:,idx),dates,'name',fnames{idx},'IsDateNum',true);
                    tsc = addts(tsc,mts);
                end  
                assignin('base',varname,tsc);
            case 'uimenufileexportfints'
                fts = fints(dates,data,fnames);
                assignin('base',varname,fts);
        end
end