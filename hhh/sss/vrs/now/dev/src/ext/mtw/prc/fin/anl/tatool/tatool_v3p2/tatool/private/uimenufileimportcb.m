function uimenufileimportcb(obj,eventdata)
% tatool helper function for processing the file menu callbacks
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);

if ~isfield(ad.handles,'welcomeinfo')
    % if this isn't the first time through then query user about throwing
    % away current plots
    qstring = {'Importing new data will cause the current data to be destroyed.',...
            'Do you wish to continue?'};
    button = questdlg(qstring,'Import Confirmation');
    if ~strcmpi('yes',button)
        % no or cancel where pressed
        return
    end
end

% Import appropriate data and massage into the form required by
% tatool
switch get(obj,'Tag')
    case 'uimenufileimportyahoo'
        datastruct = importyahoo(obj,eventdata);
        if isempty(datastruct)
            % cancel was pressed so just return
            return
        end
        tats.name = datastruct.ticker;
        tats.dates = datastruct.dates;
        tats.data = datastruct.data(:,strcmp(datastruct.columns,'Close'));
    case 'uimenufileimportarray'
        arrayin = importarray(obj,eventdata);
        if isempty(arrayin)
            % cancel was pressed so just return
            return
        end
        tats.name = arrayin.name;
        tats.dates = arrayin.data(:,1);
        tats.data = arrayin.data(:,2);
    case 'uimenufileimportstruct'
        structin = importstruct(obj,eventdata);
        if isempty(structin)
            % cancel was pressed so just return
            return
        end
        tats.name = structin.name;
        tats.dates = structin.data.dates;
        fnames = fieldnames(structin.data);
        if any(strcmp(fnames,'close'))
            tats.data = structin.data.close;
        elseif any(strcmp(fnames,'price'))
            tats.data = structin.data.price;
        end
    case 'uimenufileimportMATLABts'
        mtsin = importMATLABts(obj,eventdata);
        if isempty(mtsin)
            % cancel was pressed so just return
            return
        end
        tats.name = mtsin.name;
        tats.dates = mtsin.data.time;
        tats.data = mtsin.data.data(:,1);
        if size(mtsin.data.data,2) > 1
            % Throw a warning about only using the first column
            str = {['The time series ', tats.name, ' contains multiple columns.'];...
                ' Only the first column is being used.'};
            h=warndlg(str,'TATOOL IMPORT MESSAGE','modal');
            uiwait(h);
        end
    case 'uimenufileimportfints'
        ftsin = importfints(obj,eventdata);
        if isempty(ftsin)
            % cancel was pressed so just return
            return
        end
        tats.name = ftsin.name;
        tats.dates = ftsin.data.dates;
        fnames = fieldnames(ftsin.data,1);
        if any(strcmp(fnames,'close')) % take the series called close
            tats.data = fts2mat(ftsin.data.close);
        elseif any(strcmp(fnames,'price')) % else the one called price
            tats.data = fts2mat(ftsin.data.price);
        else % otherwise take the first series
            tats.data = fts2mat(ftsin.data.(fnames{1}));
            str = {'No series called close or price could be found so the first one,';...
                    ['called ',fnames{1},', is being used.']};
            h=warndlg(str,'TATOOL IMPORT MESSAGE','modal');
            uiwait(h);
        end
    otherwise
        str = [mfilename,' shouldn''t be called in this way,'];
        error(str);
end

% ensure data is sorted with the most recent last
[tats.dates,idx]=sort(tats.dates);
tats.data = tats.data(idx);

if isfield(ad.handles,'welcomeinfo')
    % this is the first time through so finish initialization and store
    % data
    importinit(obj,tats);
else
    importnew(obj,tats);
end


