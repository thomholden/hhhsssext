function UpdateURDatabase(ent, way, OldData, NewData, data_i, data_f)

global URPointer
global Smith_name
global Smith_images
global Recorded_database
global Recorded_database_len
global PlayRecord_Pointer
global PlayRecord_index
global Record_Stop_flag
global URTemp_Recorded_database
global IsRecordEnabled
global IsRecordDatabaseUnsaved
global IsSavingFileAllowed
global IsOpeningNewFileAllowed
global IsRecordDatabaseCountingAllowed
% if isequal (OldData, NewData), return;end
% --------------------------------------------------------------------

UR = 10*ones(1,14);
sz = [size(data_i,2), size(data_f, 2)];
data = {data_i, data_f};
ind = [0,7];
for i=1:2
    if sz(i)==1
        UR(1+ind(i)) = data{i}{1};
    elseif sz(i) == 2
        UR(1+ind(i)) =data{i}{1}(1);
        UR(2+ind(i)) =data{i}{1}(2);
        UR(3+ind(i)) =data{i}{2};
    elseif sz(i) == 4
        UR(1+ind(i)) =data{i}{1}(1);
        UR(2+ind(i)) =data{i}{1}(2);
        UR(3+ind(i)) =data{i}{2};
        UR(4+ind(i)) =data{i}{3}(1);
        UR(5+ind(i)) =data{i}{3}(2);
        UR(6+ind(i)) =data{i}{4}(1);
        UR(7+ind(i)) =data{i}{4}(2);
    end
end
% --------------------------------------------------------------------
fid1 = fopen('URDataStatus.log', 'r+');
frewind(fid1); % to take pointer back to starting position
URdata = textscan(fid1, '%s', 'delimiter', '$');
n = size(URdata{1,1}, 1);
handles = guidata(gcbf);
set(handles.push4, 'Enable', 'on');
set(handles.hmenu_undo, 'Enable', 'on');
if strcmp(ent, 'Pointer')
    if strcmp(way, 'crd')
        str = sprintf('Pointer|crd|%f|%f|to|%f|%f|', ...
            OldData(1), OldData(2), NewData(1), NewData(2));
    elseif strcmp(way, 'path')
        str = sprintf('Pointer|path|%s|to|%s|',OldData, NewData);
    elseif strcmp(way(1:8), 'crd_path') || strcmp(way(1:13), 'crd_repl_path')
        str = sprintf('Pointer|%s|%f|%f|to|%f|%f|',way,...
            OldData(1), OldData(2), NewData(1), NewData(2));
    end
elseif strcmp(ent, 'Loci')
    str = sprintf('Loci|%s|to|%s|', OldData, NewData);
elseif strcmp(ent, 'Clear')
    str = sprintf('Clear|%s|to|%s|', OldData, NewData);
elseif strcmp(ent, 'Marker')
    str = sprintf('Marker|%s|to|%s|', OldData, NewData);
end

UR_data = dlmread('URdata.log');

if URPointer+1 ~= n, 
    URdata{1,1}(URPointer+2:n, :) = [];
    UR_data(URPointer+2:n, :) = [];
    n = URPointer + 2;
end
UR_data = [UR_data;UR];
dlmwrite('URdata.log', UR_data, 'precision', '%.6f', 'newline', 'pc')
URdata = [URdata{1,1};{str}];

URPointer = URPointer + 1;
if ~URPointer
   set(handles.push4, 'Enable', 'off');
   set(handles.hmenu_undo, 'Enable', 'off');
elseif URPointer == n-1
    set(handles.push5, 'Enable', 'off');
    set(handles.hmenu_redo, 'Enable', 'off');
end
fclose(fid1);
fid1 = fopen('URDataStatus.log', 'w');
for i=1:URPointer+1
    fprintf(fid1, '%s$', URdata{i});
end
fclose(fid1);

handles = guidata(gcbf);
if IsRecordEnabled
    Recorded_database{1} = [Recorded_database{1};{str}];
    Recorded_database{2} = [Recorded_database{2};UR];
    IsRecordDatabaseUnsaved = 1;
    PlayRecord_Pointer = PlayRecord_Pointer + 1;
    if IsRecordDatabaseCountingAllowed
        Recorded_database_len = Recorded_database_len + 1;
        PlayRecord_index = PlayRecord_index + 1;
        str = num2str(Recorded_database_len);
        set(handles.text1, 'String', [str,'/',str]);
    end
    set(gcf, 'name', [Smith_name,'*']);
elseif IsRecordDatabaseUnsaved
    out = questdlg({'Do you want to save current actions to';'previous recorded actions set'}...
        ,'Save','Yes','No','Yes');
    IsSavingFileAllowed = 0;
    if strcmp(out, 'Yes')
        Record_Stop_flag = 1;
        IsRecordEnabled = 1;
        Recorded_database{1} = [Recorded_database{1}(1:PlayRecord_Pointer);{str}];
        Recorded_database{2} = [Recorded_database{2}(1:PlayRecord_Pointer,:);UR];
        Recorded_database_len = PlayRecord_index;
        IsRecordDatabaseUnsaved = 1;
        URTemp_Recorded_database = cell(2,1); %starting of UR temp database
        IsOpeningNewFileAllowed = 0;
%       clear UR database to be called
        handles.hand_clearUR();
        PlayRecord_Pointer = PlayRecord_Pointer + 1;
        if IsRecordDatabaseCountingAllowed
            Recorded_database_len = Recorded_database_len + 1;
            PlayRecord_index = PlayRecord_index + 1;
            str = num2str(Recorded_database_len);
            set(handles.text1, 'String', [str,'/',str]);
        end
        set(gcf, 'name', [Smith_name,'*']);
        set(handles.push12, 'cdata', Smith_images.stop, 'tooltipstring', 'stop');
        set(handles.push9, 'Enable', 'off');
        set(handles.push10, 'Enable', 'off');
        set(handles.push11, 'Enable', 'off');
        set(handles.push14, 'Enable', 'off');
        set(handles.push15, 'Enable', 'off');
    elseif strcmp(out, 'No')
        IsRecordDatabaseUnsaved = 0;
        Recorded_database = cell(2,1);
        Recorded_database_len = 0;
        IsRecordEnabled = 0;
        PlayRecord_index = 0;
        PlayRecord_Pointer = 0;
        set(handles.text1, 'String', '0/0');
        set(handles.push11, 'Enable', 'off');
        set(handles.push14, 'Enable', 'off');
        set(handles.push15, 'Enable', 'off');
        set(gcf, 'name', 'Smith');
    end
end