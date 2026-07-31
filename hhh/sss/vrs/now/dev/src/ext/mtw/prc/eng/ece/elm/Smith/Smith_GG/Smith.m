function Smith()

% Smith : A software tool to solve smith chart on computer ruling out old
% methods of pencil and paper with embedded features to reduce effort and
% improved accuracy

path(path, pwd);
figure;
set(gcf,'doublebuffer','on', ...
        'name','Smith','numbertitle','off', ...
                'menu','none','Units','normalized'...
    ,'pos',[0.1313,0.1481,0.593,0.722]...
    ,'Color',[.9,.9,.9]);

global CharacImp
global Gr
global Gi
global r_norm
global x_norm
global GMod
global GMod_gg
global center_gg
global soln_ind
global GAng
global Cur_X
global Cur_Y
global Smith_name
global MAxesPos
global ImpdAdmtStatus
global FixLoci_G
global FixLoci_r
global FixLoci_x
global CurrentLociTag
global DialogWaitCount
global CircleSolutions
global AHelpPoints
global TempOldPointer
global TempOldLoci
global TempOldData
global TempStorageCell
global URPointer
global PathCounter
global PathTraceDirection
global TempInitialPathCrd
global PathNextRemoveFlag
global IntroductionSeed %#ok<*NUSED>
global Recorded_database
global Recorded_database_len
global Record_Stop_flag
global PlayRecord_Pointer
global PlayRecord_index
global URTemp_Recorded_database
global Hold_Temp_Rec_database_flag

global IsAHelpAllowed
global IsCursAllowed
global IsWaitEnabled
global IsRecordDatabaseCountingAllowed
global IsRecordingDatabaseInProgress
global IsLocusDeletionAllowed
global IsURUpdationAllowed
global IsRecordEnabled
global IsRecordDatabaseUnsaved
global IsLocusModificationAllowed
global IsLociRotationAllowed
global IsAHelpLociActive
global IsURActionAllowed
global IsPathTracingAllowed
global IsPathcalledfromOther
global IsSavingFileAllowed
global IsOpeningNewFileAllowed

FixLoci_G = 0;
FixLoci_r = 0;
FixLoci_x = 0;
CurrentLociTag = '';
CharacImp = 0;
Gr = 0;
Gi = 0;
r_norm = 1;
x_norm = 0;
GMod = 0;
GAng = 0;
Cur_X = 0;
Cur_Y = 0;
MAxesPos = [0.25,0.031,0.763,0.941];
ImpdAdmtStatus = 'Impd';
Smith_name = 'Smith';
GMod_gg = 0;
center_gg = 0;
soln_ind = 0;
DialogWaitCount = 0;
CircleSolutions = 0;
AHelpPoints = [];
TempOldPointer = 0;
URPointer = 0;
PathCounter = 0;
PathTraceDirection = '-';
TempOldLoci = '';
TempOldData = 0;
TempStorageCell = {};
TempInitialPathCrd = [0,0];
PathNextRemoveFlag = 0;
Recorded_database = cell(2,1);
Recorded_database_len = 0;
Record_Stop_flag = 0;
PlayRecord_Pointer = 0;
PlayRecord_index = 0;
URTemp_Recorded_database = [];
Hold_Temp_Rec_database_flag = 0;

IsAHelpAllowed = 0;
IsCursAllowed = 0;
IsWaitEnabled = 0;
IsLocusDeletionAllowed = 0;
IsLocusModificationAllowed = 0;
IsURUpdationAllowed = 1;
IsRecordEnabled = 0;
IsSavingFileAllowed = 0;
IsOpeningNewFileAllowed = 1;
IsRecordDatabaseUnsaved = 0;
IsRecordingDatabaseInProgress = 0;
IsRecordDatabaseCountingAllowed = 1;
IsLociRotationAllowed = 0;
IsAHelpLociActive = 0;
IsURActionAllowed = 1;
IsPathTracingAllowed = 0;
IsPathcalledfromOther = 0;

Initialize_Figure();
set(gcf,'WindowButtonDownFcn',@wbdcb...
    ,'WindowButtonUpFcn',@wbucb, 'KeyPressFcn',...
    @kpfgr_cb, 'CloseRequestFcn', @dispose_fig);
fid1 = fopen('URdataStatus.log', 'w');
fprintf(fid1, 'Undo_Redo_Database$');
fclose(fid1);
UR = 10*ones(1,14);
dlmwrite('URdata.log', UR, 'precision', '%.6f');


function edit2_cb(hObject, evnt)

global Gr
global Gi
global center_gg
global GMod_gg
global GMod
global FixLoci_G
global CircleSolutions
global IsURUpdationAllowed
global IsLocusModificationAllowed
global IsPathTracingAllowed
global IsPathcalledfromOther
global TempInitialPathCrd
global PathTraceDirection
global PathNextRemoveFlag
global PathCounter
global IsWaitEnabled

IsURUpdationAllowed = 1;
TempOldPointer = [Gr,Gi];
val_ne = str2num(get(hObject, 'String')); %#ok<*ST2NM>
if isempty(val_ne), 
    ErrWarnings('g002');
    return;
end
Gr = val_ne;
epsilon = 10^-9;

if FixLoci_G && abs(Gr) <= GMod,
    if abs(GMod-Gr) > epsilon
        CircleSolutions = [{[Gr,sqrt(GMod^2 - Gr^2)]},...
        {[Gr,-sqrt(GMod^2 - Gr^2)]}];
        SubFcnCheckExistingOverlap(CircleSolutions);
        ErrWarnings('g001');
        GetFinalSolution();
        IsWaitEnabled = 1;
    else
    Gi = 0;
    end
end

SetCursCoord();
flag = 0;
if IsPathTracingAllowed, 
    TempInitialPathCrd = TempOldPointer; 
    flag = TakePathTraceAction(TempOldPointer,[Gr,Gi],'GG');
    if PathNextRemoveFlag
%         create virtual path
        PathCounter = PathCounter + 1;
        flag = 1;
    end
    IsPathcalledfromOther = 1;
end

if ~IsLocusModificationAllowed
    if IsPathTracingAllowed && flag
        str = ['crd_path_', PathTraceDirection];
        C = [real(center_gg), imag(center_gg)];
        UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {C, GMod_gg}, {0});
    else
        UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
    end
else
    ModifyLocus();
end


function edit3_cb(hObject, evnt)

global Gr
global Gi
global center_gg
global GMod_gg
global GMod
global FixLoci_G
global CircleSolutions
global IsWaitEnabled
global IsPathTracingAllowed
global IsPathcalledfromOther
global TempInitialPathCrd
global PathTraceDirection
global PathNextRemoveFlag
global PathCounter
global IsURUpdationAllowed
global IsLocusModificationAllowed

TempOldPointer = [Gr,Gi];
IsURUpdationAllowed = 1;
val_ne = str2num(get(hObject, 'String'));
if isempty(val_ne), 
    ErrWarnings('g002');
    return;
end
Gi = val_ne;
epsilon = 10^-9;

if FixLoci_G && abs(Gi) <= GMod,
    if abs(GMod-Gi) > epsilon
        CircleSolutions = [{[sqrt(GMod^2 - Gi^2),Gi]},...
        {[-sqrt(GMod^2 - Gi^2),Gi]}];
        SubFcnCheckExistingOverlap(CircleSolutions);
        ErrWarnings('g001');
        GetFinalSolution();
        IsWaitEnabled = 1;
    else
    Gr = 0;
    end
end
SetCursCoord();
flag = 0;
if IsPathTracingAllowed, 
    TempInitialPathCrd = TempOldPointer; 
    flag = TakePathTraceAction(TempOldPointer,[Gr,Gi],'GG');
    IsPathcalledfromOther = 1;
    if PathNextRemoveFlag
%         create virtual path
        PathCounter = PathCounter + 1;
        flag = 1;
    end
end

if ~IsLocusModificationAllowed
    if IsPathTracingAllowed && flag
        str = ['crd_path_', PathTraceDirection];
        C = [real(center_gg), imag(center_gg)];
        UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {C, GMod_gg}, {0});        
    else
        UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
    end
else
    ModifyLocus();
end


function edit4_cb(hObject, evnt)

global GMod
global Gr
global Gi
global center_gg
global GMod_gg
global FixLoci_G
global FixLoci_r
global FixLoci_x
global IsPathTracingAllowed
global IsPathcalledfromOther
global TempInitialPathCrd
global PathTraceDirection
global IsURUpdationAllowed
global IsLocusModificationAllowed
global PathNextRemoveFlag
global PathCounter

IsURUpdationAllowed = 1;
TempOldPointer = [Gr,Gi];
if FixLoci_G, 
    ErrWarnings('g006');
    return; 
end
val_ne = str2num(get(hObject, 'String'));
if isempty(val_ne), 
    ErrWarnings('g002');
    return;
end
GMod = val_ne;
if FixLoci_r || FixLoci_x
    LocatePoint('G', GMod);
    SetCursCoord();
else
    if GMod <= 0, GMod = 0;Gr=0;Gi=0;end
    SetCursCoord('GMod');
end
flag = 0;

if IsPathTracingAllowed,
    TempInitialPathCrd = TempOldPointer; 
    flag = TakePathTraceAction(TempOldPointer,[Gr,Gi],'GG');
    IsPathcalledfromOther = 1;
    if PathNextRemoveFlag
%         create virtual path
        PathCounter = PathCounter + 1;
        flag = 1;
    end
end

if ~IsLocusModificationAllowed
    if IsPathTracingAllowed && flag
        str = ['crd_path_', PathTraceDirection];
        C = [real(center_gg), imag(center_gg)];
        UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {C, GMod_gg}, {0});
    else
        UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
    end
else
    ModifyLocus();
end


function edit5_cb(hObject, evnt)

global GAng
global Gr
global Gi
global GMod
global IsPathTracingAllowed
global IsPathcalledfromOther
global TempInitialPathCrd
global PathTraceDirection
global FixLoci_r
global FixLoci_x
global IsURUpdationAllowed
global IsLocusModificationAllowed

IsURUpdationAllowed = 1;
if FixLoci_r || FixLoci_x, 
    ErrWarnings('g006');
    return;
end
TempOldPointer = [Gr,Gi];
val_ne = str2num(get(hObject, 'String'));
if isempty(val_ne), 
    ErrWarnings('g002');
    return;
end
GAng = val_ne;
GAng = SubFcnChangeAngleRange(GAng);
SetCursCoord('GAng');
flag = 0;
if IsPathTracingAllowed, 
    TempInitialPathCrd = TempOldPointer; 
    flag = TakePathTraceAction(TempOldPointer,[Gr,Gi],'Curs_rot');
    IsPathcalledfromOther = 1;
end

if ~IsLocusModificationAllowed
    if IsPathTracingAllowed && flag
        str = ['crd_path_', PathTraceDirection];
        UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {[0,0], GMod}, {0});
    else
        UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
    end
else
    ModifyLocus();
end


function edit6_cb(hObject, evnt) %#ok<*INUSD>


function edit7_cb(hObject, evnt)

global r_norm
global x_norm
global Gi
global Gr
global ImpdAdmtStatus
global center_gg
global GMod_gg
global FixLoci_G
global FixLoci_x
global IsPathTracingAllowed
global IsPathcalledfromOther
global TempInitialPathCrd
global PathTraceDirection
global PathNextRemoveFlag
global PathCounter
global IsURUpdationAllowed
global IsLocusModificationAllowed
IsURUpdationAllowed =1;

TempOldPointer = [Gr,Gi];
val_ne = str2num(get(hObject, 'String'));
if isempty(val_ne) || val_ne < 0
    ErrWarnings('g002');
    return;
end
r_norm = val_ne;
if strcmp(ImpdAdmtStatus, 'Admt')
    z_temp = complex(r_norm, x_norm);
    z_temp = z_temp^-1;
    r_norm = real(z_temp);
    x_norm = imag(z_temp);
end
if FixLoci_G || FixLoci_x
% if there is a constraint
    LocatePoint('r',r_norm);
else
    cmp = complex(r_norm, x_norm);
    G = (cmp-1)/(cmp+1);
    Gr = real(G);
    Gi = imag(G);
end
SetCursCoord();
flag = 0;
if IsPathTracingAllowed, 
    TempInitialPathCrd = TempOldPointer; 
    flag = TakePathTraceAction(TempOldPointer,[Gr,Gi],'GG');
    IsPathcalledfromOther = 1;
    if PathNextRemoveFlag
%         create virtual path
        PathCounter = PathCounter + 1;
        flag = 1;
    end
end

if ~IsLocusModificationAllowed
    if IsPathTracingAllowed && flag
        str = ['crd_path_', PathTraceDirection];
        C = [real(center_gg), imag(center_gg)];
        UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {C, GMod_gg}, {0});
    else
        UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
    end
else
    ModifyLocus();
end


function edit8_cb(hObject, evnt)

global r_norm
global x_norm
global Gi
global Gr
global ImpdAdmtStatus
global center_gg
global GMod_gg
global FixLoci_G
global FixLoci_r
global IsPathTracingAllowed
global IsPathcalledfromOther
global TempInitialPathCrd
global PathTraceDirection
global PathNextRemoveFlag
global PathCounter
global IsURUpdationAllowed
global IsLocusModificationAllowed

IsURUpdationAllowed =1;
TempOldPointer = [Gr,Gi];
val_ne = str2num(get(hObject, 'String'));
if isempty(val_ne), 
    ErrWarnings('g002');
    return;
end
x_norm = val_ne;
if strcmp(ImpdAdmtStatus, 'Admt')
    z_temp = complex(r_norm, x_norm);
    z_temp = z_temp^-1;
    r_norm = real(z_temp);
    x_norm = imag(z_temp);
end
if FixLoci_G || FixLoci_r
    LocatePoint('x',x_norm);
else
    cmp = complex(r_norm, x_norm);
    G = (cmp-1)/(cmp+1);
    Gr = real(G);
    Gi = imag(G);
end
SetCursCoord();
flag = 0;
if IsPathTracingAllowed, 
    TempInitialPathCrd = TempOldPointer; 
    flag = TakePathTraceAction(TempOldPointer,[Gr,Gi],'GG');
    IsPathcalledfromOther = 1;
    if PathNextRemoveFlag
%         create virtual path
        PathCounter = PathCounter + 1;
        flag = 1;
    end
end

if ~IsLocusModificationAllowed
    if IsPathTracingAllowed && flag
        str = ['crd_path_', PathTraceDirection];
        C = [real(center_gg), imag(center_gg)];
        UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {C, GMod_gg}, {0});
    else
        UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
    end
else
    ModifyLocus();
end


function edit9_cb(hObject,evnt)

global GAng
global Gr
global Gi
global GMod
global FixLoci_r
global FixLoci_x
global IsPathTracingAllowed
global IsPathcalledfromOther
global TempInitialPathCrd
global PathTraceDirection
global IsURUpdationAllowed
IsURUpdationAllowed = 1;
if FixLoci_x || FixLoci_r
    ErrWarnings('g006');
    return
end
TempOldPointer = [Gr,Gi];
val_ne = str2num(get(hObject, 'String'));
if isempty(val_ne), 
    ErrWarnings('g002');
    return;
end
lambda = val_ne;
GAng = 180 - 720*lambda;
GAng = SubFcnChangeAngleRange(GAng);
SetCursCoord('GAng');
flag = 0;
if IsPathTracingAllowed, 
    TempInitialPathCrd = TempOldPointer; 
    flag = TakePathTraceAction(TempOldPointer,[Gr,Gi],'Curs_rot');
    IsPathcalledfromOther = 1;
end

if IsPathTracingAllowed && flag
    str = ['crd_path_', PathTraceDirection];
    UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {[0,0], GMod}, {0});
else
    UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
end


function push1_cb(hObject,evnt)

global IsLociRotationAllowed
global GAng;
global Gr
global Gi
global GMod
global FixLoci_G
global FixLoci_r
global FixLoci_x
global PathTraceDirection
global IsURUpdationAllowed
global IsPathTracingAllowed
global TempInitialPathCrd

IsURUpdationAllowed =1;

TempOldPointer = [Gr,Gi];

handles = guidata(gcbf);
val_ne = str2num(get(handles.edit6, 'String'));
if isempty(val_ne),
    ErrWarnings('g002');
    return;
end
dAng = val_ne;
if IsLociRotationAllowed
    RotateLoci(-dAng);
    return
end
if FixLoci_r || FixLoci_x
    ErrWarnings('g006');
    return;
end
GAng = GAng - dAng;
SetCursCoord('GAng');
flag = 0;
if IsPathTracingAllowed && ~FixLoci_G && ~FixLoci_r && ~FixLoci_x
    set(handles.radio6, 'Value', 1);
    set(handles.radio7, 'Value', 0);
    PathTraceDirection = '-';
    TempInitialPathCrd = TempOldPointer;
    flag = TakePathTraceAction(TempInitialPathCrd,[Gr,Gi],'Curs_rot');
end

if IsPathTracingAllowed && flag
    str = ['crd_path_', PathTraceDirection];
    UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {[0,0], GMod}, {0});
else
    UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
end


function push2_cb(hObject,evnt)

global GAng;
global IsLociRotationAllowed
global Gr
global Gi
global GMod
global FixLoci_G
global FixLoci_r
global FixLoci_x
global PathTraceDirection
global IsURUpdationAllowed
global IsPathTracingAllowed
global TempInitialPathCrd

IsURUpdationAllowed = 1;

TempOldPointer = [Gr,Gi];
handles = guidata(gcbf);
dAng = str2num(get(handles.edit6, 'String'));
if IsLociRotationAllowed
    RotateLoci(dAng);
    return
end
if FixLoci_r || FixLoci_x
    ErrWarnings('g006');
    return;
end
GAng = GAng + dAng;
SetCursCoord('GAng');
flag = 0;
if IsPathTracingAllowed && ~FixLoci_G && ~FixLoci_r && ~FixLoci_x
    set(handles.radio6, 'Value', 0);
    set(handles.radio7, 'Value', 1);
    PathTraceDirection = '+';
    flag = TakePathTraceAction(TempOldPointer,[Gr,Gi],'Curs_rot');
end
    
if IsPathTracingAllowed && flag
    str = ['crd_path_', PathTraceDirection];
    UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {[0,0], GMod}, {0});
else
    UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
end


function push3_cb(hObject, evnt)

global IsURUpdationAllowed
IsURUpdationAllowed = 1;

%-------------- by default make pointer free------------------

handles = guidata(gcbf);

NullifyCurrentLoci();
% ------------------------------------------------------------
str = get(handles.popup1, 'String');
val = get(handles.popup1, 'Value');
string = str{val};

if strcmp(get(hObject, 'String'), 'Leave')
    set(hObject, 'String', 'Join');
    UpdateURDatabase('Pointer', 'path', string, 'free', {0}, {0});
else
    SubFcn_JoinLoci(string);
end
    

function push4_cb(hObject, evnt)

global IsURActionAllowed
% global IsRecordingDatabaseInProgress
% global Recorded_database
global URTemp_Recorded_database
if IsURActionAllowed, TakeURAction('undo');end
% if IsRecordingDatabaseInProgress
%     URTemp_Recorded_database{1} = Recorded_database{1,1}(end);
%     URTemp_Recorded_database{2} = Recorded_database{2}(end,:);
%     Recorded_database{1,1}(end) = [];
%     Recorded_database{2}(end,:) = [];
% end



function push5_cb(hObject, evnt)

global IsURActionAllowed
if IsURActionAllowed,TakeURAction('redo');end


function push6_cb(hObject, evnt)

global AHelpPoints
global PathCounter
global IsURUpdationAllowed
global IsLocusModificationAllowed
global IsRecordDatabaseCountingAllowed

handles = guidata(gcbf);
str = get(handles.popup1, 'string');
val = get(handles.popup1, 'Value');
str2 = get(handles.popup2, 'string');
val2 = get(handles.popup2, 'Value');

if strcmp(str{val}, 'none') && strcmp(str2{val2}, '') && ~PathCounter
    return;
end
if IsURUpdationAllowed
    UpdateURDatabase('Clear', 'crash','crash', 'all', {0}, {0});
end
IsRecordDatabaseCountingAllowed = 0;
% RemoveAllPath
if PathCounter
    use = {'Path_', 'Pathatop_', 'Pathabot_', 'Pathlen_'};
    for i=1:PathCounter 
        for j = 1:length(use)
            tag = [use{j}, sprintf('%d', i)];
            h = findobj(gca, 'tag', tag);
            if j==1 && IsURUpdationAllowed
                if ~isempty(h)
                    data = get(h, 'Userdata');
                    string = ['crd_path_', data{4}];
                    C = [data{3}(1), data{3}(2)];
                    UpdateURDatabase('Pointer', string, data{1}, data{2}, {C, data{3}(3)}, {0}); 
                else
%                     create virtual path
                    UpdateURDatabase('Pointer', 'crd_path_*', [0,0], [0,0], {[0,0], 0}, {0}); 
                end
            end
            delete(h);
        end
    end
    PathCounter = 0;
end

% if strcmp(str{val}, 'none') && strcmp(str2{val2}, '') 
%     return;
% end
N = size(str, 1);
N2 = size(str2, 1);
if isempty(str2{val2}), N2 = 0;end
NullifyCurrentLoci();
IsLocusModificationAllowed = 0;
% Clear marker starts
% UpdateURDatabase('Clear', 'crash','crash', 'all', {0}, {0});
for i = 1:N
    h = findobj(gca, 'tag', str{i});
    data  = get(h, 'Userdata');
    delete(h);
    if IsURUpdationAllowed
        UpdateURDatabase('Loci', 'dummy', str{i}, 'crash', data, {0});
    end
end
use = {'Mark_', 'Markstr_', 'Markcrd_'};
for i = 1:N2
    for j=1:3
        tag = strcat(use{j}, str2{i});
        h = findobj(gca, 'tag', tag);
        if j==1
            TempOlddata(1) = get(h, 'Xdata');
            TempOlddata(2) = get(h, 'Ydata');
        end
        delete(h);
    end
    if IsURUpdationAllowed
        UpdateURDatabase('Marker', 'dummy', str2{i}, 'crash', {TempOlddata,0}, {0});
    end
end

AHelpPoints =[];
set(handles.popup1, 'string', {'none'}, 'value', 1);
set(handles.popup2, 'string', {''}, 'value', 1);
set(handles.push8, 'Enable', 'off');
% clear maker ends
if IsURUpdationAllowed
    UpdateURDatabase('Clear', 'crash','crash', 'all', {0}, {0});
end
IsRecordDatabaseCountingAllowed = 1;


function push7_cb(hObject, evnt)

global Gr
global Gi
global IsURUpdationAllowed

IsURUpdationAllowed =1;

handles = guidata(gcbf);
str = get(handles.edit10, 'String');
if isempty(str)
    ErrWarnings('g021');
    return
end
Create_Marker(str, [Gr,Gi]);


function Create_Marker(str, data)

global IsURUpdationAllowed
handles = guidata(gcbf);
tag_mark = strcat('Mark_', str);
h = findobj(gca, 'tag', tag_mark);
if ~isempty(h)
    ErrWarnings('g020');
    return
end
if CheckExistingMarker(str, data), return;end
scatter(data(1), data(2), 'filled', 'tag', tag_mark);
tag_markstr = strcat('Markstr_', str);
h = text('pos',data, 'parent', handles.axes, 'string', str, 'linewidth', 1.5, 'color', 'b'...
    ,'tag', tag_markstr, 'ButtonDownFcn', @marker_bdcb, 'FontSize', 14);
posOldUnits = get(h, 'Units');
set(h, 'Units', 'characters');
pos = get(h, 'pos');
pos(1) = pos(1) + 1;
set(h, 'pos', pos);
set(h, 'Units', posOldUnits);
ext = get(h, 'Extent');
tf = CheckMarkerExtent(ext);
if tf
    pos(1) = pos(1) - 2;
    set(h, 'Units', 'characters');
    set(h, 'HorizontalAlignment', 'right', 'pos', pos);
    set(h, 'Units', posOldUnits);
end
Update_list2(str, 1);
if IsURUpdationAllowed
    UpdateURDatabase('Marker', 'dummy','crash', str, {0}, {data,0});
end


function tf = CheckExistingMarker(str, data)

tf = 0;
handles = guidata(gcbf);
str_pop = get(handles.popup2, 'String');
if strcmp(str_pop{1}, ''), return;end
sz = size(str_pop, 1);
epsilon = 10^-4;
for i=1:sz
    tag = ['Mark_', str_pop{i}];
    h = findobj(gca, 'tag', tag);
    x = get(h, 'Xdata');
    y = get(h, 'Ydata');
    c = [x,y] - data;
    if c(1)^2 + c(2)^2 < epsilon
        ErrWarnings('g022');
        tf = 1;
        return
    end
end


function push8_cb(hObject, evnt)

global IsURUpdationAllowed

IsURUpdationAllowed =1;
handles = guidata(gcbf);
str = get(handles.popup2, 'String');
val = get(handles.popup2, 'Value');
if strcmp(str{val}, ''), return;end

Remove_Marker(str{val});


function push9_cb(hObject, evnt)

global IntroductionSeed
IntroductionSeed = 1;
closereq;
Smith


function push10_cb(hObject, evnt)

global Recorded_database
global Record_Stop_flag
global PlayRecord_Pointer
global PlayRecord_index
global Recorded_database_len
global Smith_name
global IsURUpdationAllowed
global IsRecordDatabaseUnsaved
% global IsRecordFileJustOpened

handles = guidata(gcbf);
if IsRecordDatabaseUnsaved
    out = questdlg({'Do you want to save previous recorded data';'before opening new file'}...
        ,'Save','Yes','No','Yes');
    if strcmp(out, 'Yes')
        push11_cb(handles.push11);
    end
end
% IsRecordDatabaseUnsaved = 0;

[filename, pathname] = uigetfile({'*.smt', 'Smith file (*.smt)'},'Open');
if ~ischar(filename) || ~ischar(pathname)
    return
end
fid1 = fopen([pathname,filename], 'r');
Smith_name = [filename(1:end-4), ' - ', 'Smith'];
set(gcf, 'name', Smith_name);
Rec_char = fread(fid1, '*char')';
Rec_data = textscan(Rec_char, '%s', 'delimiter', '&');
Recorded_database(1) = textscan(Rec_data{1,1}{3}, '%s', 'delimiter', '$');
read_flag = Rec_data{1,1}{1};
Recorded_database_len = str2num(Rec_data{1,1}{2});
Recorded_database{2} = eval(Rec_data{1,1}{4});
% % %Erase present contents
IsURUpdationAllowed = 0;
push6_cb(handles.push6);
ClearURDatabase
% % % % % % % % %

if strcmp(read_flag,'Recorded_data_steps')
    PlayRecord_Pointer = 0;
    PlayRecord_index = 0;
    ExecuteForwardPlay;
    set(handles.push15, 'Enable', 'on');
    set(handles.push14, 'Enable', 'off');
    IsRecordDatabaseUnsaved = 1;
end


function ClearURDatabase

global URPointer

handles = guidata(gcbf);
URPointer = 0;
set(handles.push4, 'Enable', 'off');
set(handles.push5, 'Enable', 'off');
set(handles.hmenu_undo, 'Enable', 'off');
set(handles.hmenu_redo, 'Enable', 'off');



function push11_cb(hObject, evnt)

global Smith_name
global Recorded_database_len
global Recorded_database
global IsSavingFileAllowed
global IsRecordDatabaseUnsaved

sz = size(Recorded_database{1,1},1);
if ~Recorded_database_len, return;end
[filename, pathname] = uiputfile({'*.smt', 'Smith file (*.smt)'},'Save as...');

if ~ischar(filename) || ~ischar(pathname)
    return
end
fid1 = fopen([pathname,filename], 'w');
fprintf(fid1, 'Recorded_data_steps&%s&',num2str(Recorded_database_len));
for i = 1:sz
    fprintf(fid1, '%s$', Recorded_database{1,1}{i});
end
fprintf(fid1, '&');
fprintf(fid1, '%s', mat2str(Recorded_database{2}, 6)); % 6-digit precision
fclose(fid1);
% IsRecordDatabaseUnsaved = 1;
IsSavingFileAllowed = 0;
Smith_name = [filename(1:end-4), ' - ', 'Smith'];
set(gcf, 'name', Smith_name);
set(hObject, 'Enable', 'off');


function push12_cb(hObject, evnt)

global IsRecordEnabled
global IsRecordDatabaseUnsaved
global IsSavingFileAllowed
global IsOpeningNewFileAllowed
global Recorded_database
global URTemp_Recorded_database
global Recorded_database_len
global PlayRecord_index
global PlayRecord_Pointer
global Record_Stop_flag
global Smith_images

handles = guidata(gcbf);
if ~Record_Stop_flag
    if IsRecordDatabaseUnsaved
        out = questdlg({'Do you want to save previous recorded data';'before starting record'}...
            ,'Save','Yes','No','Yes');
        if strcmp(out, 'Yes')
            push11_cb(handles.push11);
        end
    end
    IsRecordDatabaseUnsaved = 0;
    IsSavingFileAllowed = 0;
    IsOpeningNewFileAllowed = 0;
    Recorded_database = cell(2,1);
    Recorded_database_len = 0;
    URTemp_Recorded_database = cell(2,1);
    IsRecordEnabled = 1;
    Record_Stop_flag = 1;
    PlayRecord_index = 0;
    PlayRecord_Pointer = 0;
    set(hObject, 'cdata', Smith_images.stop, 'tooltipstring', 'stop');
    set(handles.push9, 'Enable', 'off');
    set(handles.push10, 'Enable', 'off');
    set(handles.push11, 'Enable', 'off');
    set(handles.push14, 'Enable', 'off');
    set(handles.push15, 'Enable', 'off');
    set(handles.text1, 'String', '0/0');
    ClearURDatabase
else
    Record_Stop_flag = 0;
    IsRecordEnabled = 0;
    IsSavingFileAllowed = 1;
    IsOpeningNewFileAllowed = 1;
    set(hObject, 'cdata', Smith_images.record, 'tooltipstring', 'record');
    set(handles.push9, 'Enable', 'on');
    set(handles.push10, 'Enable', 'on');
    set(handles.push11, 'Enable', 'on');
    if Recorded_database_len > 0
        set(handles.push14,'Enable', 'on');
    end
    ClearURDatabase
end


function push14_cb(hObject, evnt)

global PlayRecord_index
global IsURUpdationAllowed

handles = guidata(gcbf);
if PlayRecord_index > 1
    IsURUpdationAllowed = 0;
    ExecuteBackwardPlay
    set(handles.push15, 'Enable', 'on');
    if PlayRecord_index == 1
        set(hObject, 'Enable', 'off');
    end
end


function push15_cb(hObject, evnt)

global PlayRecord_index
global Recorded_database_len
global IsURUpdationAllowed

handles = guidata(gcbf);
if PlayRecord_index < Recorded_database_len
    IsURUpdationAllowed = 0;
    ExecuteForwardPlay;
    set(handles.push14, 'Enable', 'on');
    if PlayRecord_index == Recorded_database_len, 
        set(hObject, 'Enable', 'off');
    end
end


function ExecuteForwardPlay

global Gr
global Gi
global PlayRecord_Pointer
global PlayRecord_index
global Recorded_database
global Recorded_database_len
global PathTraceDirection
global PathCounter

handles = guidata(gcbf);
PlayRecord_index = PlayRecord_index + 1;
data = textscan(Recorded_database{1,1}{PlayRecord_Pointer+1}, '%s', 'delimiter', '|');
ent{1} = data{1,1}{1};
way = data{1,1}{2};
if strcmp(ent, 'Pointer')
    if strcmp(way, 'crd')
        Gr = str2double(data{1,1}{6});Gi = str2double(data{1,1}{7});
        SetCursCoord();
    elseif strcmp(way, 'path')
        if strcmp(data{1,1}{5}, 'free')
            NullifyCurrentLoci();
            set(handles.push3,'String', 'Join');
        else
            SubFcn_JoinLoci(data{1,1}{5});
        end
    elseif strcmp(way(1:8), 'crd_path')
        Gr = str2double(data{1,1}{6});Gi = str2double(data{1,1}{7});
        C_i = [str2double(data{1,1}{3}),str2double(data{1,1}{4})];
        C_f = [Gr, Gi];
        SetCursCoord();
        OldPathDirection = PathTraceDirection;
        PathTraceDirection = way(10);
        Udata = Recorded_database{2}(PlayRecord_Pointer+1,:);
        flag = Trace_Path(C_i, C_f, [Udata(1), Udata(2), Udata(3)]);
        PathTraceDirection = OldPathDirection;
        if isequal(C_i, C_f),...
%               create virtual path
                PathCounter = PathCounter + 1;
        end
    elseif strcmp(way(1:13), 'crd_repl_path')
        Gr = str2double(data{1,1}{6});Gi = str2double(data{1,1}{7});
        C_i = [str2double(data{1,1}{3}),str2double(data{1,1}{4})];
        C_f = [Gr, Gi];
        Udata = Recorded_database{2}(PlayRecord_Pointer+1,:);
        SetCursCoord();
        Remove_Path();
        if isequal(C_i, C_f)
%               create virtual path
                PathCounter = PathCounter + 1;
        end
        OldPathDirection = PathTraceDirection;
        PathTraceDirection = way(15);
        flag = Trace_Path(C_i, C_f, [Udata(1), Udata(2), Udata(3)]);
        PathTraceDirection = OldPathDirection;
    end
elseif strcmp(ent, 'Loci')
     if strcmp(data{1,1}{4}, 'crash')
        Remove_Locus(data{1,1}{2});
    elseif strcmp(data{1,1}{2}, 'crash')
        Udata = Recorded_database{2}(PlayRecord_Pointer+1,:);
        Userdata = {[Udata(8),Udata(9)], Udata(10), [Udata(11),Udata(12)],...
            [Udata(13),Udata(14)]};
        Create_Locus(data{1,1}{4}, Userdata);
        SubFcn_JoinLoci(data{1,1}{4});
     else
        Udata = Recorded_database{2}(PlayRecord_Pointer+1,:);
        Userdata = {[Udata(8),Udata(9)], Udata(10), [Udata(11),Udata(12)],...
            [Udata(13),Udata(14)]};
        Remove_Locus(data{1,1}{2});
        Create_Locus(data{1,1}{4}, Userdata);
        SubFcn_JoinLoci(data{1,1}{4});
        NullifyCurrentLoci();
        set(handles.push3,'String', 'Join');
     end
elseif strcmp(ent, 'Clear')
    i = 0;
    Userdata = {};
    while(1)
        i = i + 1;
        data = textscan(Recorded_database{1,1}{PlayRecord_Pointer+1 + i}, '%s', 'delimiter', '|');
        ent{1} = data{1,1}{1};
        if strcmp(ent, 'Clear'), break;end
        if strcmp(ent{1}, 'Loci')
            Remove_Locus(data{1,1}{2});
        elseif strcmp(ent{1}, 'Marker')
            Remove_Marker(data{1,1}{2});
        end
    end
    PlayRecord_Pointer = PlayRecord_Pointer + i;
    RemoveAllPath();
elseif strcmp(ent, 'Marker')
    if strcmp(data{1,1}{2}, 'crash')
        Udata = Recorded_database{2}(PlayRecord_Pointer+1,:);
        Gr = Udata(8); Gi = Udata(9);
        Create_Marker(data{1,1}{4}, [Gr,Gi]);
    elseif strcmp(data{1,1}{4}, 'crash')
        Remove_Marker(data{1,1}{2});
    end
end
str = sprintf('%d/%d', PlayRecord_index, Recorded_database_len);
set(handles.text1, 'String', str);
PlayRecord_Pointer = PlayRecord_Pointer + 1;


function ExecuteBackwardPlay

global Gr
global Gi
global PlayRecord_Pointer
global PlayRecord_index
global Recorded_database
global Recorded_database_len
global PathTraceDirection
global PathCounter

handles = guidata(gcbf);
PlayRecord_index = PlayRecord_index - 1;
PlayRecord_Pointer = PlayRecord_Pointer - 1;
data = textscan(Recorded_database{1,1}{PlayRecord_Pointer+1}, '%s', 'delimiter', '|');
ent{1} = data{1,1}{1}; 
way = data{1,1}{2};
set(handles.push15, 'Enable', 'on');
if strcmp(ent, 'Pointer')
    if strcmp(way, 'crd')
        Gr = str2double(data{1,1}{3});Gi = str2double(data{1,1}{4});
        SetCursCoord();
    elseif strcmp(way, 'path') % joined or left path
        if strcmp(data{1,1}{3}, 'free')
            NullifyCurrentLoci();
            set(handles.push3,'String', 'Join');
        else
            SubFcn_JoinLoci(data{1,1}{3});
        end
    elseif strcmp(way(1:8), 'crd_path')
        Gr = str2double(data{1,1}{3});Gi = str2double(data{1,1}{4});
        Remove_Path();
        SetCursCoord();
    elseif strcmp(way(1:13), 'crd_repl_path')
        data_gg = textscan(Recorded_database{1,1}{PlayRecord_Pointer}, '%s', 'delimiter', '|');
        way = data_gg{1,1}{2};
        if strcmp(way(1:3), 'crd') && length(way)==3
            str = sprintf('%d/%d', PlayRecord_index, Recorded_database_len);
            set(handles.text1, 'String', str);
            PlayRecord_Pointer = PlayRecord_Pointer - 1;
            Remove_Path();
            return
        elseif strcmp(way(1:8), 'crd_path')
            str_code = way(10);
        elseif strcmp(way(1:13), 'crd_repl_path')
            str_code = way(15);
        end
        Udata = Recorded_database{2}(PlayRecord_Pointer,:);
        Gr = str2double(data_gg{1,1}{6});Gi = str2double(data_gg{1,1}{7});
        C_i = [str2double(data_gg{1,1}{3}),str2double(data_gg{1,1}{4})];
        C_f = [Gr, Gi];
        SetCursCoord();
        Remove_Path();
        if isequal(C_i, C_f)
%               create virtual path
            PathCounter = PathCounter + 1;
        end
        OldPathDirection = PathTraceDirection;
        PathTraceDirection = str_code;
        flag = Trace_Path(C_i, C_f, [Udata(1), Udata(2), Udata(3)]);
        PathTraceDirection = OldPathDirection;
    end
elseif strcmp(ent, 'Loci')
    if strcmp(data{1,1}{2}, 'crash')
        Remove_Locus(data{1,1}{4});
    elseif strcmp(data{1,1}{4}, 'crash')
        Udata = Recorded_database{2}(PlayRecord_Pointer+1,:);
        Userdata = {[Udata(1),Udata(2)], Udata(3), [Udata(4),Udata(5)],...
            [Udata(6),Udata(7)]};
        
        Create_Locus(data{1,1}{2}, Userdata);
        SubFcn_JoinLoci(data{1,1}{2});
    else
        Udata = Recorded_database{2}(PlayRecord_Pointer+1,:);
        Userdata = {[Udata(1),Udata(2)], Udata(3), [Udata(4),Udata(5)],...
            [Udata(6),Udata(7)]};
        Remove_Locus(data{1,1}{4});
        Create_Locus(data{1,1}{2}, Userdata);
        SubFcn_JoinLoci(data{1,1}{2});
        NullifyCurrentLoci();
        set(handles.push3,'String', 'Join');
    end
elseif strcmp(ent, 'Clear')
    N = 0;
    while(1)
        N = N + 1;
        data = textscan(Recorded_database{1,1}{PlayRecord_Pointer+1 - N}, '%s', 'delimiter', '|');
        if strcmp(data{1,1}{1}, 'Clear'), break;end
    end
    Userdata = cell(N,1);
    check = zeros(1,N);
    path_dir = cell(N,1);
    for i = 1:N
        data = textscan(Recorded_database{1,1}{PlayRecord_Pointer+1 - i}, '%s', 'delimiter', '|');
        ent = data{1,1}{1}; 
        way = data{1,1}{2};
        if strcmp(ent, 'Clear'), break;end
        Udata = Recorded_database{2}(PlayRecord_Pointer+1 - i,:);
        if strcmp(ent, 'Loci')
            Userdata_gg = {[Udata(1),Udata(2)], Udata(3), [Udata(4),Udata(5)],...
                [Udata(6),Udata(7)]};
            Create_Locus(data{1,1}{2}, Userdata_gg);
        elseif strcmp(ent, 'Marker')
            Create_Marker(data{1,1}{2}, [Udata(1), Udata(2)]);
        elseif strcmp(way(1:8), 'crd_path')
            path_dir{i} = way(10);
            C_i = [str2double(data{1,1}{3}),str2double(data{1,1}{4})];
            C_f = [str2double(data{1,1}{6}), str2double(data{1,1}{7})];
            Userdata_gg = {C_i, C_f,[Udata(1), Udata(2), Udata(3)],0};
            
            check(i) = i;
            Userdata{i} = Userdata_gg;
        end
    end
    PlayRecord_Pointer = PlayRecord_Pointer - N;
        
    chk = find(~check);
    path_dir(chk) = [];
    check(check==0) = [];
    n = length(check);
    PathCounter = n+1;
    count = 1:n;
    for i = 1:n
        PathCounter = PathCounter - 2;
        OldPathDirection = PathTraceDirection;
        PathTraceDirection = path_dir{i};
        flag = Trace_Path(Userdata{check(i)}{1}, Userdata{check(i)}{2},...
            Userdata{check(i)}{3});
        PathTraceDirection = OldPathDirection;
        if isequal(Userdata{check(i)}{1}, Userdata{check(i)}{2})
%                 create virtual path
            PathCounter = PathCounter + 1;
        end
    end
    PathCounter = n;
    NullifyCurrentLoci();
    set(handles.push3,'String', 'Join');
        
elseif strcmp(ent, 'Marker')
    if strcmp(data{1,1}{2}, 'crash')
        Remove_Marker(data{1,1}{4});
    elseif strcmp(data{1,1}{4}, 'crash')
        Udata = Recorded_database{2}(PlayRecord_Pointer+1,:);
        Gr = Udata(1); Gi = Udata(2);
        Create_Marker(data{1,1}{2}, [Gr,Gi]);
    end
end
str = sprintf('%d/%d', PlayRecord_index, Recorded_database_len);
set(handles.text1, 'String', str);


function Remove_Marker(str)

global IsURUpdationAllowed
use = {'Mark_', 'Markstr_', 'Markcrd_'};
tag = strcat('Mark_', str);
h = findobj(gca, 'tag', tag);
TempOlddata(1) = get(h, 'Xdata');
TempOlddata(2) = get(h, 'Ydata');

for i=1:3
    tag = strcat(use{i}, str);
    h = findobj(gca, 'tag', tag);
    delete(h);
end
Update_list2(str, 0);
if IsURUpdationAllowed
    UpdateURDatabase('Marker', 'dummy',str, 'crash', {TempOlddata,0}, {0});
end


function Update_list2(entry, oper)

% oper = 1 for adding entry
% oper = 0 for deleting that entry
handles = guidata(gcbf);
str = get(handles.popup2, 'String');
sz = size(str,1);
for i=1:sz
    if strcmp(str{i},entry)
        index = i;
    end
end

if oper
    if strcmp(str{1},'')
        str{1} = entry;
    else 
        str{sz+1,1} = entry;
    end
else    
    if sz ==1
        str{1} = '';
    else
        str(index) = [];
    end
end
set(handles.popup2,'String',str,'Value',1);
if ~isempty(str{1}), 
    set(handles.push8, 'Enable', 'on');
else
    set(handles.push8, 'Enable', 'off');
end

    
function pop2_cb(hObject, evnt)


function marker_bdcb(src, evnt)

handles = guidata(gcbf);
str = get(src, 'String');
tag = strcat('Markcrd_', str);
h = findobj(gca, 'tag', tag);
if ~isempty(h), 
    delete(h);
    return;
end
tag = strcat('Mark_', str);
h = findobj(gca, 'tag', tag);
crd(1) = get(h, 'Xdata');
crd(2) = get(h, 'Ydata');
tag = strcat('Markstr_', str);
h = findobj(gca, 'tag', tag);
MarkOldUnits = get(h, 'Units');
MarkOldPos = get(h, 'pos');
set(h, 'Units', 'characters');
pos = get(h, 'pos');
set(h, 'Units', MarkOldUnits, 'pos', MarkOldPos);
pos(2) = pos(2) - 1;
string = sprintf('(%.3f, %.3f)', crd(1), crd(2));
tag_markcrd = strcat('Markcrd_', str);
htxt = text('pos',pos, 'parent', handles.axes, 'string', string, 'linewidth', 1.5, 'color', 'k'...
    ,'tag', tag_markcrd, 'Units', 'characters', 'HorizontalAlignment', 'center',...
    'FontSize', 12);
set(htxt, 'Units', 'data');


function tf = CheckMarkerExtent(ext)

tf = 0;
ctop = [ext(1)+ext(3), ext(2)+ext(4)];
cbot = [ext(1)+ext(3), ext(2)];
% if ctop(1)^2 + ctop(2)^2 > 1 ||...
%         cbot(1)^2 + cbot(2)^2 > 1
if abs(ctop(1))> 1.1 || abs(ctop(2))>1.1 ||...
        abs(cbot(1)) > 1.1 || abs(cbot(2))>1.1
    tf = 1;
end


function toggle1_cb(hObject, evnt)

global FixLoci_G
global FixLoci_r
global FixLoci_x
global CurrentLociTag
global IsLocusModificationAllowed
global IsAHelpLociActive
global TempOldData
global TempStorageCell
global IsURActionAllowed
handles = guidata(gcbf);
val = get(hObject, 'Value');
str = get(handles.popup1, 'String');
val_str = get(handles.popup1, 'Value');
if strcmp(str{val_str}, 'none'), 
    set(hObject, 'Value', 0);
    ErrWarnings('g007');
    return;
end
dumm = textscan(str{val_str}, '%s');
if length(dumm{1,1}) > 1, 
    set(hObject, 'Value', 0);
        ErrWarnings('g003');
    return
end
if val 
    h = findobj(gca, 'tag', str{val_str});
    TempOldData = get(h, 'Userdata');
    TempStorageCell{1} = get(h, 'Xdata');
    TempStorageCell{2} = get(h, 'Ydata');
    IsLocusModificationAllowed = 1;
    IsAHelpLociActive = 1;
    IsURActionAllowed = 0;
    FixLoci_G = 0;
    FixLoci_r = 0;
    FixLoci_x = 0;
    CurrentLociTag = '';
    set(handles.radio1, 'value', 0, 'Enable', 'off');
    set(handles.radio2, 'value', 0, 'Enable', 'off');
    set(handles.radio3, 'value', 0, 'Enable', 'off');
    set(handles.radio4,'Enable', 'off');
    set(handles.radio5,'Enable', 'off');
    set(handles.push1, 'Enable', 'off');
    set(handles.push2, 'Enable', 'off');
    set(handles.push4, 'Enable', 'off');
    set(handles.push5, 'Enable', 'off');
    set(handles.push6, 'Enable', 'off');
    set(handles.push7, 'Enable', 'off');
    set(handles.push8, 'Enable', 'off');
    set(handles.push3, 'Enable', 'off','String', 'Join');
    set(handles.popup1, 'Enable', 'off');
    set(handles.edit9, 'Enable', 'off');
else
    SetTagforModifiedLocus();
    IsLocusModificationAllowed = 0;
    IsAHelpLociActive = 0;
    IsURActionAllowed = 1;
    TriggerButtonUpdates();
    set(handles.radio1,'Enable', 'on');
    set(handles.radio2,'Enable', 'on');
    set(handles.radio3,'Enable', 'on');
    set(handles.radio4,'Enable', 'on');
    set(handles.radio5,'Enable', 'on');
    set(handles.push3, 'Enable', 'on');
    set(handles.push4, 'Enable', 'on');
    set(handles.push6, 'Enable', 'on');
    set(handles.push7, 'Enable', 'on');
    set(handles.popup1,'Enable', 'on');     
    set(handles.edit9,'Enable', 'on');         
end


function toggle2_cb(hObject, evnt)

global IsPathTracingAllowed
handles = guidata(gcbf);
val = get(hObject, 'Value');
if val
    IsPathTracingAllowed = 1;
    set(hObject, 'tooltipstring', 'path trace pen up');
    set(handles.hmenu_pendown, 'Enable', 'off');
    set(handles.hmenu_penup, 'Enable', 'on');
else
    IsPathTracingAllowed = 0;
    set(hObject, 'tooltipstring', 'path trace pen down');
    set(handles.hmenu_pendown, 'Enable', 'on');
    set(handles.hmenu_penup, 'Enable', 'off');
end


function ModifyLocus()

global Gr
global Gi
global GMod
global GAng
global r_norm
global x_norm
global IsAHelpAllowed

handles = guidata(gcbf);
str = get(handles.popup1, 'String');
val = get(handles.popup1, 'Value');
h = findobj(gca, 'tag', str{val});
tag = str{val}(1:7);
GMTemp = sqrt(Gr^2 + Gi^2);
if GMTemp > 1,
    GMTemp = 1;
    Gr = GMTemp*cos(GAng*pi/180);
    Gi = GMTemp*sin(GAng*pi/180);
end
    
switch tag
    case 'Const_G'
        GMod = sqrt(Gr^2 + Gi^2);
        if IsAHelpAllowed, AHLociTangency('Const_G');end
        [x,y] = circle([0,0], GMod);
        data = {[0,0], GMod};
        SetCursCoord('GMod');
        
    case 'Const_r'
        r_norm = (1-Gr^2-Gi^2)/((1-Gr)^2+Gi^2);
        if IsAHelpAllowed, AHLociTangency('Const_r');end
        [x,y] = circle([r_norm/(1+r_norm), 0], 1/(1+r_norm));
        data = {[r_norm/(1+r_norm), 0], 1/(1+r_norm)};

    case 'Const_x'
        x_norm = 2*Gi / ((1-Gr)^2+Gi^2);
        if IsAHelpAllowed, AHLociTangency('Const_x');end
        if x_norm > 0
            i = [1,0];
            f = [(x_norm^2-1)/(x_norm^2+1), 2*x_norm/(1+x_norm^2)];
        else
            f = [1,0];
            i = [(x_norm^2-1)/(x_norm^2+1), 2*x_norm/(1+x_norm^2)];
        end 
        [x,y] = arc([1,1/x_norm], 1/abs(x_norm), i, f);
        data = {[1,1/x_norm], 1/abs(x_norm), i, f};
        
end
set(h, 'Xdata', x, 'Ydata', y, 'Userdata', data);


function AHLociTangency(type)

global GMod
global Gi
global r_norm
global x_norm
handles = guidata(gcbf);
str = get(handles.popup1,'String');
val = get(handles.popup1,'Value');
N = size(str, 1);
str(val) = []; % remove the circle itself from list
N = N - 1;
if ~N, return;end

if strcmp(type, 'Const_G')
    for i = 1:N
        h = findobj(gca, 'tag', str{i});
        data = get(h, 'Userdata');
        C1C2 = sqrt(data{1}(1)^2 + data{1}(2)^2);
        if abs(C1C2 - (data{2} + GMod)) < 0.05
            GMod = C1C2 - data{2};
            return
        elseif abs(C1C2 - (data{2}-GMod)) < 0.05
            GMod = data{2} - C1C2;
            return
        end
    end
elseif strcmp(type, 'Const_r')
    for i = 1:N
        dumm = textscan(str{i}, '%s');
%         to take care of permanent tangency of two Const_r circles
%           at (1,0)
        if length(dumm{1,1}) == 1 && strcmp(dumm{1,1}{1}(1:7), ...
                'Const_r'), continue;end
        h = findobj(gca, 'tag', str{i});
        data = get(h, 'Userdata');
        C1C2 = sqrt((data{1}(1) - r_norm/(1+r_norm))^2 + ...
            data{1}(2)^2);
        K = data{1}(1)^2 + data{1}(2)^2 - data{2}^2;
        if abs(C1C2 - (data{2} + 1/(1+r_norm))) < 0.05
%             for outside circles
            r_norm = (1-K+2*data{2})/(K+1 - 2*data{1}(1));
            return
        elseif abs(C1C2 - abs(data{2} - 1/(1+r_norm))) < 0.05
%             for one inside other circle
            r_norm = (1-K-2*data{2})/(K+1 - 2*data{1}(1));
            return
        end
    end
    elseif strcmp(type, 'Const_x')
    for i = 1:N
        h = findobj(gca, 'tag', str{i});
        data = get(h, 'Userdata');
        C1C2 = sqrt((data{1}(1) - 1/x_norm)^2 + ...
            (data{1}(2) - 1)^2);
        K = data{1}(1)^2 + (data{1}(2)-1)^2 - data{2}^2;
        if abs(C1C2 - (data{2} + abs(1/x_norm))) < 0.05
%             for outer circle
            if Gi >= 0
                x_norm = 2*(data{1}(1)+data{2})/K;
            else
                x_norm = 2*(data{1}(1)-data{2})/K;
            end
            return
        elseif abs(C1C2 - abs(data{2} - abs(1/x_norm))) < 0.05
%             for one inside other circle
            if Gi >= 0
                x_norm = 2*(data{1}(1)-data{2})/K;
            else
                x_norm = 2*(data{1}(1)+data{2})/K;
            end
            return
        end     
    end
end


function SetTagforModifiedLocus()

global GMod
global r_norm
global x_norm
global TempOldData
global TempStorageCell
global IsURUpdationAllowed
handles = guidata(gcbf);
IsURUpdationAllowed = 1;
str = get(handles.popup1, 'String');
val = get(handles.popup1, 'Value');
h = findobj(gca, 'tag', str{val});
tag = str{val};
Update_list1(tag, 0);
ModifyAutoHelpPoints(0, tag)
switch tag(1:7)
    case 'Const_G'
        str = sprintf('Const_G=%.3f', GMod);
    case 'Const_r'
        str = sprintf('Const_r=%.3f', r_norm);
    case 'Const_x'
        str = sprintf('Const_x=%.3f', x_norm);
end
if CheckExistingLocus(str)
%     we have to revert changes
    Update_list1(tag, 1);
    set(h, 'Xdata', TempStorageCell{1}, 'Ydata', TempStorageCell{2},...
        'Userdata', TempOldData);
    ModifyAutoHelpPoints(1, tag);
    return
end
set(h, 'tag', str);
Update_list1(str, 1);
ModifyAutoHelpPoints(1, str);
data = get(h, 'Userdata');

UpdateURDatabase('Loci', 'dummy', tag, str, TempOldData, data); 


function chk1_cb(hObject, evnt)

global AHelpPoints
global IsAHelpAllowed
global IsURUpdationAllowed
IsURUpdationAllowed = 1;
val = get(hObject, 'Value');
if val
    IsAHelpAllowed = 1;
    InitializeAutoHelpPoints();
else
    IsAHelpAllowed = 0;
    AHelpPoints = [];
end


function radio1_cb(hObject, evnt)

global FixLoci_G
global FixLoci_r
global FixLoci_x
global CurrentLociTag
global IsURUpdationAllowed
global GMod
global center_gg
global GMod_gg
IsURUpdationAllowed = 1;

FixLoci_G = 0;
FixLoci_r = 0;
FixLoci_x = 0;
handles = guidata(gcbf);
val = get(hObject, 'Value');
tag = sprintf('Const_G=%.3f',GMod);
if val
    set(handles.radio3, 'Value', 0);
    set(handles.radio2, 'Value', 0);
    Udata = {[0,0], GMod};
    GMod_gg = GMod;
    center_gg = 0;
    Create_Locus(tag, Udata);
else

    Remove_Locus(tag);
    CurrentLociTag = '';
end

    
function radio2_cb(hObject, evnt)

global FixLoci_G
global FixLoci_r
global FixLoci_x
global CurrentLociTag
global r_norm
global GMod_gg
global center_gg
global IsURUpdationAllowed
IsURUpdationAllowed = 1;
FixLoci_G = 0;
FixLoci_r = 0;
FixLoci_x = 0;
handles = guidata(gcbf);
val = get(hObject, 'Value');
tag = sprintf('Const_r=%.3f',r_norm);
if val
    set(handles.radio1, 'Value', 0);
    set(handles.radio3, 'Value', 0);
    Create_Locus(tag, {[r_norm/(1+r_norm),0], 1/(1+r_norm)});
    GMod_gg = 1/(r_norm+1);
    center_gg = complex(r_norm/(1+r_norm), 0);
else
    Remove_Locus(tag);
    CurrentLociTag = '';
end


function radio3_cb(hObject, evnt)

global FixLoci_G
global FixLoci_r
global x_norm
global FixLoci_x
global CurrentLociTag
global GMod_gg
global center_gg
global IsURUpdationAllowed
IsURUpdationAllowed = 1;
handles = guidata(gcbf);
val = get(hObject, 'Value');
FixLoci_G = 0;
FixLoci_r = 0;
FixLoci_x = 0;
tag = sprintf('Const_x=%.3f',x_norm);
if val
    set(handles.radio1, 'Value', 0);
    set(handles.radio2, 'Value', 0);
     if x_norm > 0
        i = [1,0];
        f = [(x_norm^2-1)/(x_norm^2+1), 2*x_norm/(1+x_norm^2)];
    else
        f = [1,0];
        i = [(x_norm^2-1)/(x_norm^2+1), 2*x_norm/(1+x_norm^2)];
    end
    Create_Locus(tag, {[1,1/x_norm], 1/abs(x_norm), i, f});
    GMod_gg = 1/abs(x_norm);
    center_gg = complex(1, 1/x_norm);
else
    Remove_Locus(tag);
    CurrentLociTag = '';
end


function radio4_cb(hObject, evnt)

global IsLocusDeletionAllowed
global IsLocusModificationAllowed
global IsLociRotationAllowed
IsLociRotationAllowed = 0;
handles = guidata(gcbf);
val = get(hObject, 'Value');
val_other = get(handles.radio5,'Value');
if val
    set(handles.push1, 'Enable','on');
    set(handles.push2, 'Enable','on');
    if val_other
        set(handles.radio5,'Value',0);
        pos = get(handles.panel1,'pos');
        pos_wav = get(handles.hAxeswav,'pos');
        pos(2) = pos(2) + 0.044;
        pos_wav(2) = pos_wav(2) + 0.044;
        set(handles.panel1,'pos',pos);
        set(handles.hAxeswav,'pos',pos_wav);
        set(handles.popup1, 'visible','off');
        set(handles.push3, 'Visible','off');
        set(handles.toggle1, 'Visible','off', 'Value', 0);
        IsLocusDeletionAllowed = 0;
    end
    IsLocusModificationAllowed = 0;
else
    set(handles.push1, 'Enable','off');
    set(handles.push2, 'Enable','off');
end
    

function radio5_cb(hObject, evnt)

global IsLocusDeletionAllowed
global IsLocusModificationAllowed
handles = guidata(gcbf);
val = get(hObject, 'Value');
if val
    set(handles.radio4,'Value',0);
    pos = get(handles.panel1,'pos');
    pos_wav = get(handles.hAxeswav, 'pos');
    pos(2) = pos(2) - 0.044;
    pos_wav(2) = pos_wav(2) - 0.044;
    set(handles.panel1,'pos',pos);
    set(handles.hAxeswav, 'pos', pos_wav);
    set(handles.popup1, 'visible','on');
    set(handles.push3, 'visible','on');
    set(handles.toggle1, 'Visible','on');
    IsLocusDeletionAllowed = 1;
else
    pos = get(handles.panel1,'pos');
    pos_wav = get(handles.hAxeswav, 'pos');
    pos(2) = pos(2) + 0.044;
    pos_wav(2) = pos_wav(2) + 0.044;
    set(handles.panel1,'pos',pos);
    set(handles.hAxeswav, 'pos', pos_wav);
    set(handles.popup1, 'visible','off');
    set(handles.push3, 'visible','off');
    set(handles.toggle1, 'Visible','off', 'Value', 0);
    IsLocusModificationAllowed = 0;
    IsLocusDeletionAllowed = 0;
end
TriggerButtonUpdates();
guidata(hObject,handles);


function radio6_cb(hObject, evnt)

global PathTraceDirection
handles = guidata(gcbf);
val = get(hObject, 'Value');
if val
    set(handles.radio7, 'Value', 0);
    PathTraceDirection = '-';
else
    set(handles.radio7, 'Value', 1);
    PathTraceDirection = '+';
end


function radio7_cb(hObject, evnt)

global PathTraceDirection
handles = guidata(gcbf);
val = get(hObject, 'Value');

if val
    set(handles.radio6, 'Value', 0);
    PathTraceDirection = '+';
else
    set(handles.radio6, 'Value', 1);
    PathTraceDirection = '-';
end


function flag = Trace_Path(P_initial, P_final, C_R)

global PathTraceDirection
global PathCounter

flag = 0;
epsilon = 10^-7;
delta = P_initial - P_final;
if delta(1)^2 + delta(2)^2 < epsilon^2, return;end
dtheta = 0.001;
dtheta_arrow = 0.07;
dr_arrow = 0.04;
r = C_R(3);
% Note: l = r*theta;
dtheta_arrow = dtheta_arrow/r;
% 
cmp_i = complex(P_initial(1) - C_R(1), P_initial(2) - C_R(2));
cmp_f = complex(P_final(1) - C_R(1), P_final(2) - C_R(2));
theta_i = angle(cmp_i);
theta_f = angle(cmp_f);

if strcmp(PathTraceDirection, '+')
    if theta_f < theta_i, theta_f = theta_f+2*pi;end
    dtheta_arrow = -dtheta_arrow;
    theta = theta_i : dtheta : theta_f;
elseif strcmp(PathTraceDirection, '-')
    if theta_f > theta_i, theta_i = theta_i+2*pi;end
    theta = theta_i : -dtheta : theta_f;
else
    ErrWarnings('g100');
end
theta_mid = (theta_i + theta_f)/2;

x = r*cos(theta) + C_R(1);
y = r*sin(theta) + C_R(2);
G = x.^2 + y.^2 > 1;
if sum(G) > 0, ErrWarnings('g009');return;end
PathCounter = PathCounter + 1;
num = sprintf('%d', PathCounter);
str = ['Path_',num ];
plot(x, y, 'linewidth', 1.5, 'tag', str, 'Userdata', ...
    {[x(1),y(1)],[x(end),y(end)],C_R,PathTraceDirection}, 'ButtonDownFcn',...
    @path_bdcb);

crd_mid = [r*cos(theta_mid) + C_R(1), r*sin(theta_mid) + C_R(2)];
crd_atop = [(r+dr_arrow)*cos(theta_mid+dtheta_arrow)+C_R(1),(r+dr_arrow)*sin(theta_mid+dtheta_arrow)+C_R(2)];
crd_abot = [(r-dr_arrow)*cos(theta_mid+dtheta_arrow)+C_R(1),(r-dr_arrow)*sin(theta_mid+dtheta_arrow)+C_R(2)];
str = ['Pathatop_', num];
plot([crd_atop(1),crd_mid(1)], [crd_atop(2),crd_mid(2)],  'linewidth', 1.5, 'tag', str, 'ButtonDownFcn',...
    @path_bdcb);
str = ['Pathabot_', num];
plot([crd_abot(1),crd_mid(1)], [crd_abot(2),crd_mid(2)],  'linewidth', 1.5, 'tag', str, 'ButtonDownFcn',...
    @path_bdcb);
flag = 1;


function path_bdcb(src, evnt)

handles = guidata(gcbf);
str = get(src, 'tag');
tag = strcat('Pathlen_', str(end));
h = findobj(gca, 'tag', tag);
if ~isempty(h), 
    delete(h);
    return;
end

% path_number = last digit of str
h = findobj(gca, 'tag', ['Path_', str(end)]);
UD = get(h, 'Userdata');
if ~isequal(UD{3}(1:2), [0,0]), return;end
P_initial = UD{1};
P_final = UD{2};
C_R = UD{3};
PathTraceDirection = UD{4};
cmp_i = complex(P_initial(1) - C_R(1), P_initial(2) - C_R(2));
cmp_f = complex(P_final(1) - C_R(1), P_final(2) - C_R(2));
theta_i = angle(cmp_i);
theta_f = angle(cmp_f);

if strcmp(PathTraceDirection, '+')
    if theta_f < theta_i, theta_f = theta_f+2*pi;end
    ratioed_length = (theta_f - theta_i)/(4*pi);
elseif strcmp(PathTraceDirection, '-')
    if theta_f > theta_i, theta_i = theta_i+2*pi;end
    ratioed_length = (theta_i - theta_f)/(4*pi);
end

theta_mid = (theta_i + theta_f)/2;
crd_mid = [C_R(3)*cos(theta_mid) + C_R(1), C_R(3)*sin(theta_mid) + C_R(2)];
string = sprintf('%.3f', ratioed_length);
tag_pathlen = strcat('Pathlen_', str(end));
htxt = text('pos', crd_mid, 'parent', handles.axes, 'string', [string, '\lambda'], 'linewidth', 1.5, 'color', 'k'...
    ,'tag', tag_pathlen, 'HorizontalAlignment', 'center','backgroundcolor', [163,173,154]/255,...
    'edgecolor', 'k', 'FontSize', 12, 'ButtonDownFcn', @path_bdcb);


function Remove_Path(instr)

global PathCounter

if ~PathCounter, return;end
num = sprintf('%d', PathCounter);
use = {'Path_', 'Pathatop_', 'Pathabot_', 'Pathlen_'};
for i=1:length(use)
    h = findobj(gca, 'tag', [use{i}, num]);
    delete(h);
end
PathCounter = PathCounter - 1;


function RemoveAllPath()

global PathCounter
if ~PathCounter, return;end

use = {'Path_', 'Pathatop_', 'Pathabot_', 'Pathlen_'};
for i = 1:PathCounter
    for j = 1:length(use)
        tag = [use{j}, sprintf('%d', i)];
        h = findobj(gca, 'tag', tag);
        delete(h);
    end
end
PathCounter = 0;


function pop1_cb(hObject, evnt)

TriggerButtonUpdates();


function TriggerButtonUpdates

global IsLociRotationAllowed
global CurrentLociTag
IsLociRotationAllowed = 0;
handles = guidata(gcbf);
set(handles.push1,'Enable','off');
set(handles.push2,'Enable','off');
set(handles.push3,'Enable','off');
val = get(handles.radio4, 'Value');
if val, 
    set(handles.push1,'Enable','on');
    set(handles.push2,'Enable','on');    
end
str = get(handles.popup1, 'String');
val = get(handles.popup1, 'Value');
if strcmp(str{val},'none'),return;end
tag = str{val}(1:7);
if isequal(tag,'Const_r') && ...
        strcmp(get(handles.popup1, 'Visible'), 'on')
    set(handles.push1,'Enable','on');
    set(handles.push2,'Enable','on');    
    IsLociRotationAllowed = 1;
end
if strcmp(CurrentLociTag, str{val})
    set(handles.push3,'Enable','on','String','Leave');
else
    set(handles.push3,'Enable','on','String','Join');
end
str = get(handles.popup2, 'String');
if isempty(str{1})
    set(handles.push8, 'Enable', 'off');
else
    set(handles.push8, 'Enable', 'on');
end
    

function Update_list1(entry, oper)
% oper = 1 for adding entry
% oper = 0 for deleting that entry
if strcmp(entry, 'none'),return;end
handles = guidata(gcbf);
str = get(handles.popup1, 'String');
sz = size(str,1);
index = 0;
for i=1:sz
    if strcmp(str{i},entry)
        index = i;
    end
end
% if index=0, => entry is new to list
% otherwise entry is at i th location

if oper && ~index % to ensure that a previous entry not exist of same tag
    if strcmp(str{1},'none')
        str{1} = entry;
    else 
        str{sz+1,1} = entry;
    end
else    
    if sz ==1
        str{1} = 'none';
    else
        str(index) = [];
    end
end
set(handles.popup1,'String',str,'Value',1);
TriggerButtonUpdates();


function Create_Locus(tag, data)

global FixLoci_G
global FixLoci_r
global FixLoci_x
global IsAHelpAllowed
global CurrentLociTag
global IsURUpdationAllowed
FixLoci_G = 0;
FixLoci_r = 0;
FixLoci_x = 0;

CurrentLociTag = '';
handles = guidata(gcbf);
set(handles.radio1, 'Value', 0);
set(handles.radio2, 'Value', 0);
set(handles.radio3, 'Value', 0);
if CheckExistingLocus(tag),return;end
CurrentLociTag = tag;

if strcmp(tag(1:7), 'Const_G')
    FixLoci_G = 1;
    set(handles.radio1, 'Value', 1);
    [x,y] = circle(data{1}, data{2});
elseif strcmp(tag(1:7), 'Const_r')
    str_test = textscan(tag, '%s');
    sz=size(str_test{1,1},1);
    if sz == 1
        FixLoci_r = 1;
        set(handles.radio2, 'Value', 1);
    end
    [x,y] = circle(data{1}, data{2});
elseif strcmp(tag(1:7), 'Const_x')
    FixLoci_x = 1;
    set(handles.radio3, 'Value', 1);
    [x,y] = arc(data{1}, data{2}, data{3}, data{4});
end
plot(x,y,'--', 'tag', tag, 'Userdata', data, 'color', [75, 142, 35]/255, 'linewidth', 1.5);
if IsURUpdationAllowed
    UpdateURDatabase('Loci', 'dummy','crash', tag, {0}, data);
end
if IsAHelpAllowed, ModifyAutoHelpPoints(1, tag);end
Update_list1(tag,1);


function Remove_Locus(tag)

global IsURUpdationAllowed
if strcmp(tag, 'none'),return;end
global FixLoci_G
global FixLoci_r
global FixLoci_x
global IsAHelpAllowed

if IsAHelpAllowed, ModifyAutoHelpPoints(0, tag);end
handles = guidata(gcbf);
indicator = tag(1:7);
if strcmp(indicator, 'Const_G')
    FixLoci_G = 0;
    set(handles.radio1, 'Value', 0);
elseif strcmp(indicator, 'Const_r')
    FixLoci_r = 0;
    set(handles.radio2, 'Value', 0);
elseif strcmp(indicator, 'Const_x')
    FixLoci_x =0;
    set(handles.radio3, 'Value', 0);
end
h = findobj(gca, 'tag', tag);
data = get(h, 'Userdata');
delete(h);
Update_list1(tag,0);
if IsURUpdationAllowed
    UpdateURDatabase('Loci', 'dummy',tag, 'crash', data, {0});
end


function wbmcb(src, evnt)

global Gr
global Gi
global IsAHelpAllowed
global IsAHelpLociActive
global IsLocusModificationAllowed
global AHelpPoints

[Gr, Gi] = getcurscoordonaxes();
if IsLocusModificationAllowed, ModifyLocus();end
if IsAHelpAllowed && ~isempty(AHelpPoints) && ~IsAHelpLociActive
    CheckAHelpPoints();
end
SetCursCoord();


function wbdcb(src, evnt)

global Gr
global Gi
global IsWaitEnabled
global DialogWaitCount
global TempOldPointer
global TempInitialPathCrd
global IsPathTracingAllowed
global IsURUpdationAllowed
global IsLocusModificationAllowed

IsWaitEnabled = 0;
DialogWaitCount = 0;
TempOldPointer = [Gr, Gi];
[Cx, Cy] = getcurscoordonaxes();
IsURUpdationAllowed = 0;
if abs(Cx) <= 1 && abs(Cy) <= 1
    Gr = Cx;
    Gi = Cy;
    IsURUpdationAllowed = 1;
    set(gcf, 'WindowButtonMotionFcn', @wbmcb);
    SetCursCoord();
end
if IsLocusModificationAllowed, ModifyLocus();end
if IsPathTracingAllowed, TempInitialPathCrd = [Gr,Gi];end


function wbucb(src, evnt)

global TempOldPointer
global TempInitialPathCrd
global Gr
global Gi
global center_gg
global GMod_gg
global IsLocusModificationAllowed
global IsURUpdationAllowed
global IsPathTracingAllowed
global IsPathcalledfromOther
global PathTraceDirection

set(gcf, 'WindowButtonMotionFcn', '');
flag = 0;
if IsPathTracingAllowed && ~IsPathcalledfromOther
    flag = TakePathTraceAction(TempInitialPathCrd,[Gr, Gi],'GG');
end
if ~IsLocusModificationAllowed && IsURUpdationAllowed
    if IsPathTracingAllowed && flag
        str = ['crd_path_', PathTraceDirection];
        C = [real(center_gg), imag(center_gg)];
        UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {C, GMod_gg}, {0});
    else
        UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
    end
end

AHTempLine(0);
IsPathcalledfromOther = 0;


function kpcommon_cb(src, evnt)

global IsURActionAllowed
global IsSavingFileAllowed
global IsOpeningNewFileAllowed
global CurrentLociTag

switch evnt.Key
    case 'n'
        if strcmp(evnt.Modifier, 'control')
            handles = guidata(gcbf);
            push9_cb(handles);
        end
        
    case 'z'
        if strcmp(evnt.Modifier, 'control')
            if IsURActionAllowed,TakeURAction('undo');end
        end
    case 'r'
        if strcmp(evnt.Modifier, 'control')
            if IsURActionAllowed, TakeURAction('redo');end
        end
    case 'f'
        handles = guidata(gcbf);
        string = CurrentLociTag;
        NullifyCurrentLoci();
        set(handles.push3, 'String', 'Join');
        UpdateURDatabase('Pointer', 'path', string, 'free', {0}, {0});
    case 'o'
        if strcmp(evnt.Modifier, 'control') && IsOpeningNewFileAllowed
            handles = guidata(gcbf);
            push10_cb(handles);
        end
    case 's'
        if strcmp(evnt.Modifier, 'control') && IsSavingFileAllowed
            handles = guidata(gcbf);
            push11_cb(handles.push11);
        end     
end


function kppop_cb(src,evnt) %#ok<*INUSL>

global IsURActionAllowed
global IsSavingFileAllowed
global IsOpeningNewFileAllowed
global CurrentLociTag

handles = guidata(gcbf);
switch evnt.Key
    
    case 'n'
        if strcmp(evnt.Modifier, 'control')
            push9_cb(handles);
        end
        
    case 'delete'
        str = get(handles.popup1, 'String');
        val = get(handles.popup1, 'Value');
        Remove_Locus(str{val});
    case 'z'
        if strcmp(evnt.Modifier, 'control')
            if IsURActionAllowed,TakeURAction('undo');end
        end
    case 'r'
        if strcmp(evnt.Modifier, 'control')
            if IsURActionAllowed,TakeURAction('redo');end
        end
    case 'f'
        string = CurrentLociTag;
        NullifyCurrentLoci();
        set(handles.push3, 'String', 'Join');
        UpdateURDatabase('Pointer', 'path', string, 'free', {0}, {0});
    case 'o'
        if strcmp(evnt.Modifier, 'control') && IsOpeningNewFileAllowed
            push10_cb(handles);
        end
    case 's'
        if strcmp(evnt.Modifier, 'control') && IsSavingFileAllowed
            push11_cb(handles.push11);
        end     
end
        

function kpfgr_cb(src, evnt)

global Gi
global Gr
global GMod_gg
global center_gg
global soln_ind
global IsLocusDeletionAllowed
global IsWaitEnabled
global IsPathTracingAllowed
global IsSavingFileAllowed
global IsOpeningNewFileAllowed
global TempInitialPathCrd
global PathTraceDirection
global IsURActionAllowed
global PathCounter
global CurrentLociTag

handles = guidata(gcbf);

switch evnt.Key
    case 'rightarrow'
        Gr = Gr + 0.01;
        SetCursCoord;
        
    case 'leftarrow'
        Gr = Gr - 0.01;
        SetCursCoord;
        
    case 'uparrow'
        Gi = Gi + 0.01;
        SetCursCoord;
        
    case 'downarrow'
        Gi = Gi - 0.01;
        SetCursCoord;
        
    case 'delete'
        if ~IsLocusDeletionAllowed,return;end
        str = get(handles.popup1, 'String');
        val = get(handles.popup1, 'Value');
        Remove_Locus(str{val});
        
    case 'n'
        if strcmp(evnt.Modifier, 'control')
            push9_cb(handles);
        end
        if IsWaitEnabled
            soln_ind = ~soln_ind;
            TempOldPointer = [Gr,Gi];
            GetFinalSolution();
            SetCursCoord();
            if IsPathTracingAllowed, 
                Remove_Path();
                flag = TakePathTraceAction(TempInitialPathCrd,[Gr,Gi],'GG');
                if SubFcnCheckExistingOverlapKeyPress() 
                    % virtual path
                    PathCounter = PathCounter + 1;
                    flag = 1;
                end
                
            end
            
            if IsPathTracingAllowed && flag
                str = ['crd_repl_path_', PathTraceDirection];
                C = [real(center_gg), imag(center_gg)];
                UpdateURDatabase('Pointer', str, TempInitialPathCrd, [Gr,Gi], {C, GMod_gg}, {0});
            else
                UpdateURDatabase('Pointer', 'crd', TempOldPointer, [Gr,Gi], {0}, {0});
            end
        end
    case 'z'
        if strcmp(evnt.Modifier, 'control')
%             if IsURActionAllowed,TakeURAction('undo');end
            push4_cb(handles);
        end
    case 'r'
        if strcmp(evnt.Modifier, 'control')
%             if IsURActionAllowed,TakeURAction('redo');end
            push5_cb(handles);
        end
    case 'f'
        string = CurrentLociTag;
        NullifyCurrentLoci();
        set(handles.push3, 'String', 'Join');
        UpdateURDatabase('Pointer', 'path', string, 'free', {0}, {0});
    case 'o'
        if strcmp(evnt.Modifier, 'control') && IsOpeningNewFileAllowed
            push10_cb(handles);
        end     
    case 's'
        if strcmp(evnt.Modifier, 'control') && IsSavingFileAllowed
            push11_cb(handles.push11);
        end     
end


function Initialize_Figure()

global MAxesPos
global IntroductionSeed
global Smith_images

if isempty(IntroductionSeed)

    str = {'************************************************************************';...
        'Welcome to Smith';'Smith is a software tool to solve smith chart on computer ruling out old';
    'methods of pencil and paper with embedded features to reduce effort and';
    'improved accuracy';...
    '************************************************************************'};
    fprintf('%s\n', str{:});
end

% menu
hmenu_file = uimenu('label', 'File');
hmenu_edit = uimenu('label', 'Edit');
hmenu_help = uimenu('label', 'Help');
handles.hmenu_new = uimenu('parent', hmenu_file, 'label', 'New', 'callback', @menu_file_new);
handles.hmenu_fig = uimenu('parent', hmenu_file, 'label', 'Save Figure As...', 'callback', @menu_file_print);
handles.hmenu_close = uimenu('parent', hmenu_file, 'label', 'Exit Smith', 'callback', @menu_file_close);
handles.hmenu_undo = uimenu('parent', hmenu_edit, 'label', 'Undo          Ctrl+Z', 'Enable', 'off','callback', @menu_edit_undo);
handles.hmenu_redo = uimenu('parent', hmenu_edit, 'label', 'Redo          Ctrl+R', 'Enable', 'off','callback', @menu_edit_redo);
handles.hmenu_Impd = uimenu('parent', hmenu_edit, 'label', 'Impedance', 'Enable', 'off', 'separator', 'on', 'callback', @menu_edit_Impd);
handles.hmenu_Admt = uimenu('parent', hmenu_edit, 'label', 'Admittance', 'Enable', 'on', 'callback', @menu_edit_Admt);
handles.hmenu_pendown = uimenu('parent', hmenu_edit, 'label', 'Pen Down', 'Enable', 'on', 'separator', 'on', 'callback', @menu_edit_pendown);
handles.hmenu_penup = uimenu('parent', hmenu_edit, 'label', 'Pen Up', 'Enable', 'off', 'callback', @menu_edit_penup);
handles.hmenu_Smith_help = uimenu('parent', hmenu_help, 'label', 'Smith Help', 'callback', @menu_help_help);
handles.hmenu_about = uimenu('parent', hmenu_help, 'label', 'About Smith', 'callback', @menu_help_about);

%Reading Images
inst = {'undo', 'redo', 'new', 'open', 'save', 'record','stop','next','previous'};
for i=1:size(inst, 2)
    str = strcat(pwd,'\Img\',inst{i}, '.jpg');
    [a,map] = imread(str);
    [r,c,d] = size(a);
    x = ceil(r / 30); %#ok<*NASGU>
    y = ceil(c / 30);
    eval([inst{i} '_Img = a(1:x:end, 1:y:end, :);']);
end
Smith_images.record = record_Img;
Smith_images.stop = stop_Img;

%Record toolbar
handles.push9 = uicontrol('units','normalized','tag','New','pos',[.009,.960,.029,.037],'Fontunits','pixels','Fontsize',15,'callback',@push9_cb,'Enable','on', 'CData', new_Img,'tooltipstring', 'New', ...
    'KeyPressFcn',@kpcommon_cb, 'Visible', 'on');
handles.push10 = uicontrol('units','normalized','tag','Open','pos',[.0385,.960,.029,.037],'Fontunits','pixels','Fontsize',15,'callback',@push10_cb,'Enable','on', 'CData', open_Img,'tooltipstring', 'Open', ...
    'KeyPressFcn',@kpcommon_cb, 'Visible', 'on');
handles.push11 = uicontrol('units','normalized','tag','Save','pos',[.068,.960,.029,.037],'Fontunits','pixels','Fontsize',15,'callback',@push11_cb,'Enable','on', 'CData', save_Img,'tooltipstring', 'Save', ...
    'KeyPressFcn',@kpcommon_cb, 'Visible', 'on', 'Enable', 'off');
handles.hand_push11cb = @push11_cb;
handles.push12 = uicontrol('units','normalized','tag','Record_but','pos',[.1067,.960,.029,.037],'Fontunits','pixels','Fontsize',15,'callback',@push12_cb,'Enable','on', 'CData', record_Img,'tooltipstring', 'Record', ...
    'KeyPressFcn',@kpcommon_cb, 'Visible', 'on');
handles.push14 = uicontrol('units','normalized','tag','Previous','pos',[.1407,.960,.029,.037],'Fontunits','pixels','Fontsize',15,'callback',@push14_cb,'Enable','on', 'CData', previous_Img,'tooltipstring', 'Previous', ...
    'KeyPressFcn',@kpcommon_cb, 'Visible', 'on', 'Enable', 'off');
handles.text1 = uicontrol('parent', gcf,'style', 'text','units', 'normalized','String', '0/0', 'pos', [.1702,.960,.0725,.037], 'FontUnits', 'pixels','Fontsize', 18, 'backgroundcolor', [1,1,1], 'Visible', 'on');
handles.push15 = uicontrol('units','normalized','tag','Next','pos',[.2432,.960,.029,.037],'Fontunits','pixels','Fontsize',15,'callback',@push15_cb,'Enable','on', 'CData', next_Img,'tooltipstring', 'Next', ...
    'KeyPressFcn',@kpcommon_cb, 'Visible', 'on', 'Enable', 'off');

% Undo Redo
handles.push4 = uicontrol('units','normalized','tag','Undo','pos',[.009,.920,.029,.037],'Fontunits','pixels','Fontsize',15,'callback',@push4_cb,'Enable','off', 'CData', undo_Img,'tooltipstring', 'Ctrl+Z', ...
    'KeyPressFcn',@kpcommon_cb);
handles.push5 = uicontrol('units','normalized','tag','Redo','pos',[.061,.920,.029,.037],'Fontunits','pixels','Fontsize',15,'callback',@push5_cb,'Enable','off', 'CData', redo_Img,'tooltipstring', 'Ctrl+R',...
    'KeyPressFcn',@kpcommon_cb);


% checkbox
handles.chk1 = uicontrol('style','checkbox','tag','AutoHelp','units','normalized','pos',[.123,.920,.1,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','Auto Help','callback',@chk1_cb,...
    'KeyPressFcn',@kpcommon_cb);
% texts
hAxes1 = axes('parent', gcf,'Color','none','CreateFcn','','HandleVisibility','off','HitTest','off','Position',[.009,.755,.031,.151], ...
   'Visible','off');
text('parent', hAxes1, 'Units', 'normalized','String', '|\Gamma|', 'pos', [0.2,0.15], 'FontUnits', 'pixels','Fontsize', 18);
text('parent', hAxes1, 'Units', 'normalized','String', '\Gamma_i', 'pos', [0.3,0.5], 'FontUnits', 'pixels','Fontsize', 18);
text('parent', hAxes1, 'Units', 'normalized','String', '\Gamma_r', 'pos', [0.3,0.9], 'FontUnits', 'pixels','Fontsize', 18);
uicontrol('style','text','units','normalized','pos',[.123,.755,.027,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','L');
uicontrol('style','text','units','normalized','pos',[.009,.697,.093,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','Rotate(deg)', 'HorizontalAlignment', 'left');
handles.text6 = uicontrol('style','text','units','normalized','pos',[.123,.871,.027,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','r');
handles.text7 = uicontrol('style','text','units','normalized','pos',[.123,.813,.027,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','x');
% marker and path
uicontrol('style','text','units','normalized','pos',[.009,.27,.15,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','Marker and Path', 'HorizontalAlignment', 'left');
uicontrol('style','text','units','normalized','pos',[.009,.221,.05,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',16,'String','Text', 'HorizontalAlignment', 'left');
handles.edit10=uicontrol('style','edit','tag','Marker','units','normalized','pos',[0.05,0.225,.056,.035],'Backgroundcolor','white');
handles.push7 = uicontrol('units','normalized','tag','Place_marker','pos',[.129,.225,.06,.037],'visible','on','Fontunits','pixels','Fontsize',15,'String','Place','callback',@push7_cb,'Enable','on',...
    'KeyPressFcn',@kpcommon_cb);
handles.push8 = uicontrol('units','normalized','tag','Place_marker','pos',[.129,.17,.06,.037],'visible','on','Fontunits','pixels','Fontsize',15,'String','Remove','callback',@push8_cb,'Enable','off',...
    'KeyPressFcn',@kpcommon_cb);
handles.popup2 = uicontrol('style', 'popup','tag','list2','units','normalized','pos',[0.009,.17,.10,.035],'Backgroundcolor','white','visible','on','Fontunits','pixels','Fontsize',15,'string',{''},'callback',@pop2_cb,...
    'KeyPressFcn',@kpcommon_cb);
handles.radio6=uicontrol('style','radiobutton','tag','toward_gen','units','normalized','pos',[.009,.13,.05,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','+','callback',@radio6_cb,...
    'KeyPressFcn',@kpcommon_cb, 'Value', 1, 'tooltipstring', 'towards generator');
handles.radio7=uicontrol('style','radiobutton','tag','toward_load','units','normalized','pos',[.06,.13,.05,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','-','callback',@radio7_cb,...
    'KeyPressFcn',@kpcommon_cb , 'tooltipstring', 'towards load');
handles.toggle2 = uicontrol('style', 'togglebutton','units','normalized','tag','Trace_path','pos',[.129,.13,.09,.037],'visible','on','Fontunits','pixels','Fontsize',15,'String','Trace Path','callback',@toggle2_cb,'Enable','on',...
    'KeyPressFcn',@kpcommon_cb, 'tooltipstring', 'Path trace pen down');

% GG
hAxesGG = axes('parent', gcf,'Color','none','CreateFcn','','HandleVisibility','off','HitTest','off','Position',[0,0,.1,.04], ...
   'Visible','off');
img = imread([pwd, '\Img\GG.jpg']);
imagesc(1:120,1:150,img, 'parent', hAxesGG);
text(130,70,'a Gaurav Gupta Production', 'FontSize', 8);
axis([0,350,0,150]);axis off;
% Entering boxes
handles.edit2=uicontrol('style','edit','tag','G_real','units','normalized','pos',[0.061,.871,.056,.035],'Backgroundcolor','white','callback',@edit2_cb);
handles.edit3=uicontrol('style','edit','tag','G_img','units','normalized','pos',[0.061,.813,.056,.035],'Backgroundcolor','white','callback',@edit3_cb);
handles.edit4=uicontrol('style','edit','tag','norm_G','units','normalized','pos',[0.061,.755,.056,.035],'Backgroundcolor','white','callback',@edit4_cb);
handles.edit5=uicontrol('style','edit','tag','G_ang','units','normalized','pos',[0.149,0.755,.056,.035],'Backgroundcolor','white','callback',@edit5_cb);
handles.edit7=uicontrol('style','edit','tag','Z/Y_real','units','normalized','pos',[0.149,0.871,.056,.035],'Backgroundcolor','white','callback',@edit7_cb);
handles.edit8=uicontrol('style','edit','tag','Z/Y_img','units','normalized','pos',[0.149,0.813,.056,.035],'Backgroundcolor','white','callback',@edit8_cb);

% variable popupmenu and pushbutton and togglebutton
handles.popup1 = uicontrol('style', 'popup','tag','list1','units','normalized','pos',[0.009,.61,.2,.035],'Backgroundcolor','white','visible','off','Fontunits','pixels','Fontsize',15,'string',{'none'},'callback',@pop1_cb,...
    'KeyPressFcn',@kppop_cb);
handles.push3 = uicontrol('units','normalized','tag','Join_Leave','pos',[.22,.61,.06,.037],'visible','off','Fontunits','pixels','Fontsize',15,'String','Leave','callback',@push3_cb,'Enable','off',...
    'KeyPressFcn',@kpcommon_cb);
handles.toggle1 = uicontrol('style','togglebutton','tag','transform','units','normalized','pos',[.16,.548,.07,.044],'visible','off','Fontunits','pixels','Fontsize',15,'string','Transform','callback',@toggle1_cb);
% panel
posp = [0,0.417,.205,.232];
handles.panel1 = uipanel('tag','panel1','Units','normalized','pos',posp,'Backgroundcolor',[.9,.9,.9],'Bordertype','none');

handles.edit6=uicontrol('parent',handles.panel1,'style','edit','tag','Rotate_deg','units','normalized','pos',[.009/posp(3),(.581-.407)/posp(4),.047/posp(3),.044/posp(4)],'Backgroundcolor','white','callback',@edit6_cb);
% Push buttons
handles.push1=uicontrol('parent',handles.panel1,'units','normalized','tag','rot_clock','pos',[.077/posp(3),(.581-.407)/posp(4),.032/posp(3),.044/posp(4)],'Fontunits','pixels','Fontsize',15,'callback',@push1_cb,'String','+','tooltipstring','Rotate Clockwise','Enable','off',...
    'KeyPressFcn',@kpcommon_cb);
handles.push2=uicontrol('parent',handles.panel1,'units','normalized','tag','rot_aclock','pos',[.117/posp(3),(.581-.407)/posp(4),.032/posp(3),.044/posp(4)],'Fontunits','pixels','Fontsize',15,'callback',@push2_cb,'String','-','tooltipstring','Rotate AntiClockwise','Enable','off',...
    'KeyPressFcn',@kpcommon_cb);
% Radio buttons

handles.radio1=uicontrol('parent',handles.panel1,'style','radiobutton','tag','constant_G','units','normalized','pos',[.009/posp(3),(.523-.407)/posp(4),.16/posp(3),.035/posp(4)],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','Constant |Gamma|','callback',@radio1_cb,...
    'KeyPressFcn',@kpcommon_cb);
handles.radio2=uicontrol('parent',handles.panel1,'style','radiobutton','tag','constant_r','units','normalized','pos',[.009/posp(3),(.465-.407)/posp(4),.11/posp(3),.035/posp(4)],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','Constant r','callback',@radio2_cb,...
    'KeyPressFcn',@kpcommon_cb);
handles.radio3=uicontrol('parent',handles.panel1,'style','radiobutton','tag','constant_x','units','normalized','pos',[.009/posp(3),(.407-.407)/posp(4),.11/posp(3),.035/posp(4)],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','Constant x','callback',@radio3_cb,...
    'KeyPressFcn',@kpcommon_cb);
handles.radio4=uicontrol('style','radiobutton','tag','cursor_radio','units','normalized','pos',[.009,.658,.1,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','Cursor','callback',@radio4_cb,...
    'KeyPressFcn',@kpcommon_cb);
handles.radio5=uicontrol('style','radiobutton','tag','Locus_radio','units','normalized','pos',[.123,.658,.1,.035],'Backgroundcolor',[.9,.9,.9],'Fontunits','pixels','Fontsize',18,'String','Locus','callback',@radio5_cb,...
    'KeyPressFcn',@kpcommon_cb);
handles.edit9=uicontrol('parent',handles.panel1,'style','edit','tag','wavelength','units','normalized','pos',[0.009/posp(3),(0.35-.407)/posp(4),.056/posp(3),.035/posp(4)],'Backgroundcolor','white','callback',@edit9_cb,...
    'KeyPressFcn',@kpcommon_cb);
handles.hAxeswav = axes('parent', gcf,'Color','none','CreateFcn','','HandleVisibility','off','HitTest','off','Position',[0.07,.36,.1,.035], ...
   'Visible','off');
text(0.009,0.5,'\lambda', 'parent', handles.hAxeswav, 'Fontsize', 15);
% clear
handles.push6 = uicontrol('Units', 'normalized', 'pos', [.129,.07,.08, .044], 'FontSize', 10, 'String', 'CLEAR', 'callback', @push6_cb, 'tooltipstring', 'clear page', ...
    'keypressFcn', @kpcommon_cb);
% Initialize main axis
handles.axes=axes('pos',MAxesPos);

% function handles
handles.hand_clearUR = @ClearURDatabase;
InitializePlot(handles);

guidata(gcf, handles);


function InitializePlot(handles)

global Cur_X;
global Cur_Y;

Cur_X = 0;
Cur_Y = 0;
[x,y] = circle([0,0], 1);
[x1,y1] = circle([.5,0],.5);
[x2,y2] = arc([1,1],1,[1,0],[0,1]);
[x3,y3] = arc([1,-1],1,[0,-1],[1,0]);
set(gca, 'nextplot', 'add');
plot(handles.axes,x, y);
plot(x1,y1,'--k', x2,y2,'--k', x3,y3,'--k');
Ini_wavelength(1.02);
[xv, yv] = circle([0,0], 1.09);
plot(xv, yv);
line([-1,-1.09], [0,0], 'linestyle',':', 'tag', 'wav_line', ...
    'Linewidth', 1.3, 'color', 'k');
scatter(0,0,'linewidth', 1.5);
set(gca,'PlotBoxAspectRatioMode','manual','plotboxaspectratio',[1,1,1]);
axis([-1.1,1.1,-1.1,1.1]);
color = get(gcf,'Color');
set(gca,'XColor',color,'YColor',color,'TickDir','out');
plot(Cur_X, Cur_Y, 'rs', 'linewidth', 1.5,'tag', 'cursor');
set(handles.edit2, 'String', '0');
set(handles.edit3, 'String', '0');
set(handles.edit4, 'String', '0');
set(handles.edit5, 'String', '0');
set(handles.edit6, 'String', '0');
set(handles.edit7, 'String', '1');
set(handles.edit8, 'String', '0');
set(handles.edit9, 'String', '0');


function Ini_wavelength(in_rad)

color = 'r';
VecLen = 0:.002:0.5;
for ii= 1:length(VecLen)
    if floor((ii-1)/5) ~= (ii-1)/5,
        plot([in_rad*cos(pi*(180-100*VecLen(ii)*7.2)/180), 1.015*in_rad*cos(pi*(180 - 100*VecLen(ii)*7.2)/180)], [in_rad*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.015*in_rad*sin(pi*(180 - 100*VecLen(ii)*7.2)/180)], color);
    else
        plot([in_rad*cos(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.025*in_rad*cos(pi*(180 - 100*VecLen(ii)*7.2)/180)], [in_rad*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.025*in_rad*sin(pi*(180 - 100*VecLen(ii)*7.2)/180)], 'k');
        if VecLen(ii)~=0.5
            h = text(in_rad*1.04*cos(pi*((180 - 100*VecLen(ii)*7.2))/180), in_rad*1.04*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), num2str(VecLen(ii),'%0.2f'));
            set(h,'color',color,'rotation',90+3.6-100*VecLen(ii)*7.2,'fontsize',6,'HorizontalAlignment','center');
        end
    end
end
r  = in_rad+0.20;
th = (140:-.1:135)*pi/180;
plot (r*cos(th), r*sin(th),'k');
h = text((r-0.005)*cos(th(length(th))), (r-0.005)*sin(th(length(th))), '<');
set(h,'rotation',(th(length(th))+pi/2)*180/pi,'VerticalAlignment','middle');

th = [146 145 144]*pi/180;
h = text(r*cos(th(1)), r*sin(th(1)), 'l');
set(h,'rotation',(th(1)-pi/2)*180/pi, 'fontsize',9, 'fontname','mt extra');
h = text(r*cos(th(2)), r*sin(th(2)), '/');
set(h,'rotation',(th(2)-pi/2)*180/pi, 'fontsize',9, 'fontname','Times New Roman');
h = text(r*cos(th(3)), r*sin(th(3)), '\lambda');
set(h,'rotation',(th(3)-pi/2)*180/pi, 'fontsize',9);

r = in_rad + 0.15;
PStr = 'towards generator';
th = (linspace(150,134,length(PStr)))*pi/180;
for jj = 1: length(PStr)
    h = text(r*cos(th(jj)), r*sin(th(jj)), PStr(jj));
    set(h,'rotation',(th(jj)-pi/2)*180/pi, 'fontsize',9, 'fontname','Times New Roman');
end


function [x,y] = circle(c, r)

dtheta = 0.001;
theta = -pi:dtheta:pi;
x = r*cos(theta) + c(1);
y = r*sin(theta) + c(2);


function [x,y] = arc(c,r,i,f)

dtheta = -0.001;
ai = complex(i(1)-c(1),i(2)-c(2));
af = complex(f(1)-c(1),f(2)-c(2));
ti = angle(ai);
tf = angle(af);
if ti < 0, ti=ti+2*pi;end
if tf < 0, tf=tf+2*pi;end
if tf > ti
    tf = tf-2*pi;
end
theta = ti:dtheta:tf;
x = r*cos(theta) + c(1);
y = r*sin(theta) + c(2);


function [x,y] = getcurscoordonaxes()

crd = get(gca, 'CurrentPoint');
x = crd(2,1); y = crd(2,2);


function SetCursCoord(varargin)

global FixLoci_G
global FixLoci_r
global FixLoci_x
global Gr
global Gi
global r_norm
global x_norm
global GMod_gg
global center_gg
global GMod
global GAng
global ImpdAdmtStatus

handles = guidata(gcbf);
cmp = complex(Gr, Gi);

if nargin || FixLoci_G ||FixLoci_r || FixLoci_x
%     case of constrained run
    try
%         case for direct set from modG and angG edit boxes
        if strcmp(varargin{1}, 'GMod')
            GAng = angle(cmp) * 180 / pi;
            if GMod > 1, GMod = 1;end
            Gr = GMod*cos(GAng*pi/180);
            Gi = GMod*sin(GAng*pi/180);
        elseif strcmp(varargin{1}, 'GAng')
            GMod = abs(cmp);
            if GMod > 1, GMod = 1;end
            Gr = GMod*cos(GAng*pi/180);
            Gi = GMod*sin(GAng*pi/180);
        end
    catch %#ok<*CTCH>
        if FixLoci_G
            GAng = angle(cmp) * 180 / pi;
            if GMod > 1, GMod = 1;end
            Gr = GMod*cos(GAng*pi/180);
            Gi = GMod*sin(GAng*pi/180);
        elseif FixLoci_r
            cmp_new = cmp-center_gg;
            GAng_gg = angle(cmp_new);
            G = center_gg + complex(GMod_gg*cos(GAng_gg),GMod_gg*sin(GAng_gg));
            Gr = real(G);
            Gi = imag(G);
            GMod = abs(G);
            GAng = angle(G) * 180 / pi;
        elseif FixLoci_x
            cmp_new = cmp-center_gg;
            GAng_gg = angle(cmp_new);
            G = center_gg + complex(GMod_gg*cos(GAng_gg),GMod_gg*sin(GAng_gg));
            Gr = real(G);
            Gi = imag(G);
            GMod = abs(G);
            GAng = angle(G) * 180 / pi;
            if GMod > 1, GMod = 1;
                cmp = complex(GMod*cos(GAng*pi/180),GMod*sin(GAng*pi/180));
                cmp_new = cmp-center_gg;
                GAng_gg = angle(cmp_new);
                G = center_gg + complex(GMod_gg*cos(GAng_gg),GMod_gg*sin(GAng_gg));
                Gr = real(G);
                Gi = imag(G);
            end
        end
    end
else
%     case of free run
    GMod = abs(cmp);
    GAng = angle(cmp) * 180 / pi;
    if GMod > 1, GMod = 1;end
    Gr = GMod*cos(GAng*pi/180);
    Gi = GMod*sin(GAng*pi/180);
end

if Gr ==1 && Gi < 10^-10,
    ErrWarnings('g005');
    return;
end
r_norm = (1-Gr^2-Gi^2)/((1-Gr)^2+Gi^2);
x_norm = 2*Gi / ((1-Gr)^2+Gi^2);
h_curs = findobj(gca, 'tag', 'cursor');
set(h_curs, 'Xdata', Gr, 'Ydata', Gi);
% drawnow;
Modify_wavlen();
set(handles.edit2, 'String', sprintf('%.5f',Gr));
set(handles.edit3, 'String', sprintf('%.5f',Gi));
set(handles.edit4, 'String', sprintf('%.5f',GMod));
set(handles.edit5, 'String', sprintf('%.3f',GAng));
z_temp = complex(r_norm, x_norm);
if strcmp(ImpdAdmtStatus, 'Admt')
    z_temp = z_temp^-1;
end
set(handles.edit7, 'String', sprintf('%.5f',real(z_temp)));
set(handles.edit8, 'String', sprintf('%.5f',imag(z_temp)));
lambda = (180-GAng)/720;
if abs(lambda) > 0.5
    lambda = Recurs_wavelength(lambda);end
set(handles.edit9, 'String', sprintf('%.5f', lambda));


function Modify_wavlen()

global GAng
h = findobj(gca, 'tag', 'wav_line');
x = cos(GAng*pi/180)*[1,1.09];
y = sin(GAng*pi/180)*[1,1.09];
set(h, 'Xdata', x, 'Ydata', y);


function l = Recurs_wavelength(l)

if l >= 0 && l <= 0.5
    return;
end
if l > 0.5
    l = l - 0.5;
elseif l < 0
    l = l + 0.5;
end
l = Recurs_wavelength(l);


function RotateLoci(dAng)

global FixLoci_r
global TempOldLoci
global TempOldData
global CurrentLociTag
global IsURUpdationAllowed
IsURUpdationAllowed = 1;
if ~dAng, return;end
handles = guidata(gcbf);
str = get(handles.popup1,'String');
val = get(handles.popup1,'Value');
tag = str{val};
h = findobj(gca,'tag',tag);
TempOldLoci = tag;
TempOldData = get(h, 'Userdata');
Update_list1(tag, 0);
ModifyAutoHelpPoints(0, tag);
% Here I will make angles betwen -180 to 180 degrees for uniqueness
try
    er = textscan(tag, '%s');
    prev = str2num(er{1,1}{4}(1:end-1));
    if ~(prev+dAng) || ~rem(prev+dAng,360) %#ok<*BDLOG>
%         for 0 and n*360 cases
        string = er{1,1}{1};
    else
        ang = SubFcnChangeAngleRange(prev+dAng);
        string = [er{1,1}{1},' ',er{1,1}{2},' ',er{1,1}{3},...
        ' ',sprintf('%d',ang),char(176)];
    end
catch
    if ~dAng || ~rem(dAng, 360), 
        string = tag;
    else
        dAng = SubFcnChangeAngleRange(dAng);
        string = sprintf(' rot by %d',dAng);
        string = strcat(tag,string,char(176));
    end
end
if FixLoci_r && isequal(string, tag)
    FixLoci_r = 1;
    set(handles.radio2,'Value',1);
else
    FixLoci_r = 0;
    set(handles.radio2,'Value',0);
end
if CheckExistingLocus(string)
%     we have to revert changes
    Update_list1(TempOldLoci,1);
    ModifyAutoHelpPoints(1, TempOldLoci);
    CurrentLociTag = '';
    return
end

Update_list1(string,1);
data = get(h,'Userdata');
cnt = data{1};
cmp = complex(cnt(1),cnt(2));
cmp = cmp * exp(1i*dAng*pi/180);
[x,y] = circle([real(cmp),imag(cmp)],data{2});
Udata = {[real(cmp),imag(cmp)],data{2}};

set(h, 'Xdata',x, 'Ydata', y, 'Userdata',Udata,...
    'tag',string);
ModifyAutoHelpPoints(1, string);
UpdateURDatabase('Loci', 'dummy', TempOldLoci, string, TempOldData, Udata);


function InitializeAutoHelpPoints()

global AHelpPoints

handles = guidata(gcbf);
str = get(handles.popup1, 'String');
if strcmp(str{1}, 'none'), return;end
N = length(str);
data = cell(N,2);
for i=1:N
    h = findobj(gca, 'tag', str{i});
    dummy = get(h, 'Userdata');
    data(i,:) = dummy(1,1:2); %to take care of userdata of 'x' arc
end

for i = 1:N
    for j = i+1:N
        C1 = [data{i,1}(1),data{i,1}(2),data{i,2}];
        C2 = [data{j,1}(1),data{j,1}(2),data{j,2}];
        [ind, S1, S2] = SolveCircle(C1, C2);
        switch ind
            case 1
                AHelpPoints = [AHelpPoints;{S1, str{i}, str{j}}];
                
            case 2
                AHelpPoints = [AHelpPoints;{S1, str{i}, str{j}}];
                AHelpPoints = [AHelpPoints;{S2, str{i}, str{j}}];
        end
    end
end


function ModifyAutoHelpPoints(ind, tag)
% has to be called before modifying list

global AHelpPoints

handles = guidata(gcbf);
str = get(handles.popup1, 'String');
if strcmp(str{1}, 'none'), return;end
N = length(str);
data = cell(N,2);
for i=1:N
    h = findobj(gca, 'tag', str{i});
    dummy = get(h, 'Userdata');
    data(i,:) = dummy(1,1:2);
end
h = findobj(gca, 'tag', tag);
dummy = get(h, 'Userdata');
data_new = dummy(1,1:2);
if ind
    for i = 1:N
        C1 = [data{i,1}(1),data{i,1}(2),data{i,2}];
        C2 = [data_new{1,1}(1), data_new{1,1}(2), data_new{1,2}];
        [ind, S1, S2] = SolveCircle(C1, C2);
        switch ind
            case 1
                AHelpPoints = [AHelpPoints;{S1, str{i}, tag}];

            case 2
                AHelpPoints = [AHelpPoints;{S1, str{i}, tag}];
                AHelpPoints = [AHelpPoints;{S2, str{i}, tag}];
        end
    end
else
    N = size(AHelpPoints, 1);
    index = zeros(1,N);
    for i = 1:N
        if strcmp(tag, AHelpPoints{i,2}) || strcmp(tag, AHelpPoints{i,3})
            index(i) = i;
        end
    end
    index(index==0) = [];
    AHelpPoints(index,:) = [];
end


function CheckAHelpPoints()

global AHelpPoints
global Gr
global Gi
N = size(AHelpPoints,1);
for i=1:N
%     near 0.05 radius of AHelp Point
    if (Gr-AHelpPoints{i,1}{1}(1))^2 + ...
            (Gi-AHelpPoints{i,1}{1}(2))^2 < 0.05^2
        Gr = AHelpPoints{i,1}{1}(1);
        Gi = AHelpPoints{i,1}{1}(2);
        AHTempLine(1)
        break
    else
        AHTempLine(0)
    end
end


function AHTempLine(ind)

global Gr
global Gi

if ind
    line([Gr,Gr],[-1,1],'LineStyle',':','color','k','tag', 'AH_lineV');
    line([-1,1],[Gi,Gi],'LineStyle',':','color','k','tag', 'AH_lineH');
else
    h = findobj(gca, 'tag', 'AH_lineV');
    delete(h);
    h = findobj(gca, 'tag', 'AH_lineH');
    delete(h);
end


function dispose_fig(hObject, evnt)

global IntroductionSeed
global IsRecordDatabaseUnsaved

handles = guidata(gcbf);
if IsRecordDatabaseUnsaved
    out = questdlg({'Do you want to save previous recorded data';'before exiting Smith'}...
        ,'Save','Yes','No','Yes');
    if strcmp(out, 'Yes')
        push11_cb(handles.push11);
    end
else
    title = 'Smith';
    text = {'Are you sure want to exit'};
    out = questdlg('Are you sure want to exit?','Exit','Yes','No','Yes');
end
if strcmp(out, 'Yes')
        closereq;
        str = {'************************************************************************';...
        'Thanks for trying Smith';...
        'For feedback and suggestions contact : gauravgg@iitk.ac.in';
        '                                       gaurav71531@gmail.com';
        '************************************************************************';};
    fprintf('%s\n', str{:});
    delete('URdataStatus.log');
    delete('URdata.log');
    IntroductionSeed = [];
end


function TakeURAction(task)

global Gr
global Gi
global IsURUpdationAllowed
global PathTraceDirection
global IsRecordingDatabaseInProgress
global PathCounter
IsURUpdationAllowed = 0;
handles = guidata(gcbf);
[Pcode,Scode,str_code, Userdata] = ReadURDatabase(task);

switch Pcode
    case 'UR001'
        SetCursCoord();
    case 'UR002'
        NullifyCurrentLoci();
        set(handles.push3,'String', 'Join');
    case 'UR003'
        SubFcn_JoinLoci(str_code);
    case 'UR004'
        Remove_Path();
        SetCursCoord();
    case 'UR005'
        SetCursCoord();
        OldPathDirection = PathTraceDirection;
        PathTraceDirection = str_code{1};
        flag = Trace_Path(Userdata{1}, Userdata{2}, Userdata{3});
        PathTraceDirection = OldPathDirection;
        if isequal(Userdata{1}, Userdata{2}),...
%               create virtual path
                PathCounter = PathCounter + 1;
        end
    case 'UR006'
        SetCursCoord();
        Remove_Path();
        if isequal(Userdata{1}, Userdata{2})
%               create virtual path
                PathCounter = PathCounter + 1;
        end
        OldPathDirection = PathTraceDirection;
        PathTraceDirection = str_code{1};
        flag = Trace_Path(Userdata{1}, Userdata{2}, Userdata{3});
        PathTraceDirection = OldPathDirection;
    case 'UR007'
        Remove_Path();
     
        
    case 'UR010'
        Remove_Locus(str_code);
    case 'UR011'
        Create_Locus(str_code, Userdata);
        SubFcn_JoinLoci(str_code);
    case 'UR012'
        Remove_Locus(str_code{1});
        Create_Locus(str_code{2}, Userdata);
        SubFcn_JoinLoci(str_code{2});
        NullifyCurrentLoci();
        set(handles.push3,'String', 'Join');
        
    case 'UR020'
        N = size(str_code, 2);
        check = zeros(1,N);
        for i = 1:N
            if strcmp(Scode{i}, 'Loci')
                Create_Locus(str_code{i}, Userdata(i,:));
            elseif strcmp(Scode{i}, 'Marker')
                Create_Marker(str_code{i}, [Userdata{i}(1), Userdata{i}(2)]);
            elseif strcmp(Scode{i}, 'crd_path')
                check(i) = i;
            end
        end
        
        chk = find(~check);
        str_code(chk) = [];
        check(check==0) = [];
        n = length(check);
        PathCounter = n+1;
        count = 1:n;
        for i = 1:n
            PathCounter = PathCounter - 2;
            OldPathDirection = PathTraceDirection;
            PathTraceDirection = str_code{i};
            flag = Trace_Path(Userdata{check(i),1}, Userdata{check(i),2},...
                Userdata{check(i),3});
            PathTraceDirection = OldPathDirection;
            if isequal(Userdata{check(i),1}, Userdata{check(i),2})
%                 create virtual path
                PathCounter = PathCounter + 1;
            end
        end
        PathCounter = n;
        NullifyCurrentLoci();
        set(handles.push3,'String', 'Join');
    case 'UR021'
        N = size(str_code, 2);
        for i = 1:N
            if strcmp(Scode{i}, 'Loci')
                Remove_Locus(str_code{i});
            elseif strcmp(Scode{i}, 'Marker')
                Remove_Marker(str_code{i});
            end
        end
        RemoveAllPath();
        
    case 'UR030'
        Remove_Marker(str_code{1});
    case 'UR031'
        Create_Marker(str_code{1}, [Gr,Gi]);
             
end


function tf = CheckExistingLocus(tag)

tf = 0;
handles = guidata(gcbf);
str = get(handles.popup1, 'String');
val = get(handles.popup1, 'Value');
if strcmp(str{val}, 'none'),return;end
N = size(str,1);
for i=1:N
    if strcmp(tag, str{i})
        ErrWarnings('g008');
        tf = 1;
        return
    end
end


function Ang = SubFcnChangeAngleRange(Ang)

%  This is for making angles between -180 to 180 degrees
Ang = rem(Ang, 360);
if Ang < 180 && Ang >= -180
    return
elseif Ang >= 180
    Ang = Ang - 360;
    Ang = SubFcnChangeAngleRange(Ang);
else
    Ang = Ang + 360;
    Ang = SubFcnChangeAngleRange(Ang);
end


function SubFcn_JoinLoci(string)

global GMod
global Gr
global Gi
global GMod_gg
global center_gg
global r_norm
global x_norm
global FixLoci_G
global FixLoci_r
global FixLoci_x
global CurrentLociTag
global IsURUpdationAllowed

CurrentLociTag = string;
handles = guidata(gcbf);
h = findobj(gca, 'tag', string);
data = get(h, 'Userdata');

% --------------Done for taking care of UR operation UR003---------------
str = get(handles.popup1, 'String');
val = get(handles.popup1, 'Value');
string_pop = str{val};

if strcmp(string_pop, string)
    set(handles.push3, 'String', 'Leave');
end
% -----------------------------------------------------------------------
if strcmp(string(1:7), 'Const_G')
    GMod = data{2};
    GMod_gg = GMod;
    center_gg = [0,0];
    FixLoci_G = 1;
    set(handles.radio1, 'Value', 1);
    SetCursCoord('GMod');
elseif strcmp(string(1:7), 'Const_r')
    dumm = textscan(string, '%s');
    if length(dumm{1,1}) > 1
        GMod_gg = data{2};
        center_gg = complex(data{1}(1), data{1}(2));
    else
        r_norm = 1/data{2} -1;
        GMod_gg = data{2};
        center_gg = complex(data{1}(1), data{1}(2));
        cmp = complex(r_norm, x_norm);
        G = (cmp-1)/(cmp+1);
        Gr = real(G);
        Gi = imag(G);
        set(handles.radio2, 'Value', 1);
    end
    FixLoci_r = 1;
    SetCursCoord();
elseif strcmp(string(1:7), 'Const_x')
    x_norm = 1/data{1}(2);
    GMod_gg = data{2};
    center_gg = complex(data{1}(1), data{1}(2));
    cmp = complex(r_norm, x_norm);
    G = (cmp-1)/(cmp+1);
    Gr = real(G);
    Gi = imag(G);
    FixLoci_x = 1;
    set(handles.radio3, 'Value', 1);
    SetCursCoord();
end
if IsURUpdationAllowed
    UpdateURDatabase('Pointer', 'path','free', string, {0}, {0});
end


function tf = SubFcnCheckExistingOverlapKeyPress()

global TempInitialPathCrd
global Gr
global Gi

tf = 0;
epsilon = 10^-7;

for i=1:2
    if (TempInitialPathCrd(1) - Gr)^2 + (TempInitialPathCrd(2) - Gi)^2 ...
             < epsilon^2
         tf = 1;
    end
end


function SubFcnCheckExistingOverlap(CS)

global PathNextRemoveFlag
global Gr
global Gi

PathNextRemoveFlag = 0;
epsilon = 10^-7;

for i=1:2
    if (CS{i}(1) - Gr)^2 + (CS{i}(2) - Gi)^2 ...
            < epsilon ^2
        PathNextRemoveFlag = 1;
    end
end


function NullifyCurrentLoci()

global FixLoci_G
global FixLoci_r
global FixLoci_x
global CurrentLociTag

FixLoci_G =0;
FixLoci_r =0;
FixLoci_x =0;
CurrentLociTag = '';
handles = guidata(gcbf);
set(handles.radio1, 'Value', 0);
set(handles.radio2, 'Value', 0);
set(handles.radio3, 'Value', 0);


function menu_file_new(hObject, evnt)

global IntroductionSeed
IntroductionSeed = 1;
closereq;
Smith


function menu_file_print(hObject, evnt)

handles = guidata(gcbf);
[fname, path] = uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
          '*.*','All Files' },'Save Image',...
          'C:\Work\newfile.jpg');
if ~fname, return;end
ftemp = figure('visible', 'off');
copyobj(handles.axes, ftemp);
saveas(ftemp, strcat(path,'\', fname));
delete(ftemp);


function menu_file_close(hObject, evnt)

dispose_fig();


function menu_edit_undo(hObject, evnt)

global IsURActionAllowed
if IsURActionAllowed, TakeURAction('undo');end


function menu_edit_redo(hObject, evnt)

global IsURActionAllowed
if IsURActionAllowed, TakeURAction('redo');end


function menu_edit_Impd(hObject, evnt)

handles = guidata(gcbf);
ToggleImpdAdmtOut();
set(hObject, 'Enable', 'off');
set(handles.hmenu_Admt, 'Enable', 'on');


function menu_edit_Admt(hObject, evnt)

handles = guidata(gcbf);
ToggleImpdAdmtOut();
set(hObject, 'Enable', 'off');
set(handles.hmenu_Impd, 'Enable', 'on');


function menu_edit_pendown(hObject, evnt)

global IsPathTracingAllowed
handles = guidata(gcbf);

IsPathTracingAllowed = 1;
set(handles.toggle2, 'Value', 1, 'tooltipstring', 'path trace pen up');
set(hObject, 'Enable', 'off');
set(handles.hmenu_penup, 'Enable', 'on');


function menu_edit_penup(hObject, evnt)

global IsPathTracingAllowed
handles = guidata(gcbf);

IsPathTracingAllowed = 0;
set(handles.toggle2, 'Value', 0, 'tooltipstring', 'path trace pen down');
set(hObject, 'Enable', 'off');
set(handles.hmenu_pendown, 'Enable', 'on');


function menu_help_about(hObject, evnt)

title = 'About Smith';
text ={'Smith';'';'ver 1.1    16/5/12'};
dialog_gg('title', title, 'text', text);


function menu_help_help(hObject, evnt)

open('Help\SmithHELP.pdf')


function flag = TakePathTraceAction(C_i,C_f, instr)

global FixLoci_G
global FixLoci_r
global FixLoci_x
global GMod
global GMod_gg
global center_gg
global IsPathTracingAllowed
flag = 0;

if (~IsPathTracingAllowed || (~FixLoci_G && ~FixLoci_r &&...
        ~FixLoci_x)) && ~strcmp(instr, 'Curs_rot'), return;end

if FixLoci_G || strcmp(instr, 'Curs_rot')
    C_R = [0,0,GMod];
elseif FixLoci_r || FixLoci_x
    C_R = [real(center_gg),imag(center_gg), GMod_gg];
end

flag = Trace_Path(C_i, C_f, C_R);


function ToggleImpdAdmtOut

global ImpdAdmtStatus
global r_norm
global x_norm

handles = guidata(gcbf);
z_temp = complex(r_norm, x_norm);
if strcmp(ImpdAdmtStatus, 'Impd')
    ImpdAdmtStatus = 'Admt';
    set(handles.text6, 'String', 'g');
    set(handles.text7, 'String', 'b');
    z_temp = z_temp^-1;    
elseif strcmp(ImpdAdmtStatus, 'Admt')
    ImpdAdmtStatus = 'Impd';
    set(handles.text6, 'String', 'r');
    set(handles.text7, 'String', 'x');
end
set(handles.edit7, 'String', sprintf('%.5f',real(z_temp)));
set(handles.edit8, 'String', sprintf('%.5f',imag(z_temp)));