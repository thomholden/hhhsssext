function [Pcode,Scode,str_code, Userdata] = ReadURDatabase(task)

global URPointer
global Gr
global Gi
global IsRecordEnabled
global Hold_Temp_Rec_database_flag
handles = guidata(gcbf);
Pcode = '';
Scode = '';
str_code = '';
Userdata = {};
fid1 = fopen('URdataStatus.log', 'r');
URchar = fread(fid1, '*char')';
URdata = textscan(URchar, '%s', 'delimiter', '$');
fclose(fid1);
URdata_val = dlmread('URdata.log');
n = size(URdata{1,1}, 1);
if ~URPointer && strcmp(task, 'undo'), return;
elseif URPointer == n-1 && strcmp(task, 'redo'), return;
end
% URPointer
if strcmp(task, 'undo')
    data = textscan(URdata{1,1}{URPointer+1}, '%s', 'delimiter', '|');
    ent{1} = data{1,1}{1}; 
    way = data{1,1}{2};
    set(handles.push5, 'Enable', 'on');
    set(handles.hmenu_redo, 'Enable', 'on');
    if strcmp(ent, 'Pointer')
        if strcmp(way, 'crd')
            Pcode = 'UR001';
            Gr = str2double(data{1,1}{3});Gi = str2double(data{1,1}{4});
        elseif strcmp(way, 'path') % joined or left path
            if strcmp(data{1,1}{3}, 'free')
                Pcode ='UR002';
            else
                Pcode = 'UR003';
                str_code = data{1,1}{3};
            end
        elseif strcmp(way(1:8), 'crd_path')
            Pcode = 'UR004';
            Gr = str2double(data{1,1}{3});Gi = str2double(data{1,1}{4});
        elseif strcmp(way(1:13), 'crd_repl_path')
            Pcode = 'UR006';
            data_gg = textscan(URdata{1,1}{URPointer}, '%s', 'delimiter', '|');
            way = data_gg{1,1}{2};
            if strcmp(way(1:3), 'crd') && length(way)==3
                Pcode = 'UR007';
            elseif strcmp(way(1:8), 'crd_path')
                str_code{1} = way(10);
            elseif strcmp(way(1:13), 'crd_repl_path')
                str_code{1} = way(15);
            end
            Udata = URdata_val(URPointer,:);
            Gr = str2double(data_gg{1,1}{6});Gi = str2double(data_gg{1,1}{7});
            C_i = [str2double(data_gg{1,1}{3}),str2double(data_gg{1,1}{4})];
            C_f = [Gr, Gi];
            Userdata = {C_i, C_f,[Udata(1), Udata(2), Udata(3)]};
        end
        
    elseif strcmp(ent, 'Loci')
        if strcmp(data{1,1}{2}, 'crash')
            Pcode = 'UR010';
            str_code = data{1,1}{4};
            Udata = URdata_val(URPointer+1,:);
            Userdata = {[Udata(8),Udata(9)], Udata(10), [Udata(11),Udata(12)],...
                [Udata(13),Udata(14)]};
        elseif strcmp(data{1,1}{4}, 'crash')
            Pcode = 'UR011';
            str_code = data{1,1}{2};
            Udata = URdata_val(URPointer+1,:);
            Userdata = {[Udata(1),Udata(2)], Udata(3), [Udata(4),Udata(5)],...
                [Udata(6),Udata(7)]};
        else
            Pcode = 'UR012';
            str_code{1} = data{1,1}{4};
            str_code{2} = data{1,1}{2};
            Udata = URdata_val(URPointer+1,:);
            Userdata = {[Udata(1),Udata(2)], Udata(3), [Udata(4),Udata(5)],...
                [Udata(6),Udata(7)]};
        end
    elseif strcmp(ent, 'Clear')
        Pcode = 'UR020';
        i = 0;
        Userdata = {};
        while(1)
            i = i + 1;
            data = textscan(URdata{1,1}{URPointer+1 - i}, '%s', 'delimiter', '|');
            ent{1} = data{1,1}{1}; 
            way = data{1,1}{2};
            if strcmp(ent, 'Clear'), break;end
            str_code{i} = data{1,1}{2};
            Scode{i} = ent{1};
            Udata = URdata_val(URPointer+1 - i,:);
            if strcmp(Scode{i}, 'Loci')
                Userdata_gg = {[Udata(1),Udata(2)], Udata(3), [Udata(4),Udata(5)],...
                    [Udata(6),Udata(7)]};
            elseif strcmp(Scode{i}, 'Marker')
                Userdata_gg = {[Udata(1), Udata(2)],0, [0,0], [0,0]};
            elseif strcmp(way(1:8), 'crd_path')
                Scode{i} = 'crd_path';
                str_code{i} = way(10);
%                 Gr = str2double(data{1,1}{6});Gi = str2double(data{1,1}{7});
                C_i = [str2double(data{1,1}{3}),str2double(data{1,1}{4})];
                C_f = [str2double(data{1,1}{6}), str2double(data{1,1}{7})];
                Userdata_gg = {C_i, C_f,[Udata(1), Udata(2), Udata(3)],0};
            end
            Userdata = [Userdata;Userdata_gg];
        end
        URPointer = URPointer - i;
        if IsRecordEnabled
            URActionforRecordedDatabase('undo', i+1)
            Hold_Temp_Rec_database_flag = 1;
        end
    elseif strcmp(ent, 'Marker')
        if strcmp(data{1,1}{2}, 'crash')
            Pcode = 'UR030';
            str_code{1} = data{1,1}{4};
        elseif strcmp(data{1,1}{4}, 'crash')
            Pcode = 'UR031';
            str_code{1} = data{1,1}{2};
            Udata = URdata_val(URPointer+1,:);
            Gr = Udata(1); Gi = Udata(2);
        end
    end
    URPointer = URPointer -1;
    if IsRecordEnabled
        URActionforRecordedDatabase('undo', 1)
        Hold_Temp_Rec_database_flag = 0;
    end
else % redo
    URPointer = URPointer + 1;
    data = textscan(URdata{1,1}{URPointer+1}, '%s', 'delimiter', '|');
    ent{1} = data{1,1}{1};
    way = data{1,1}{2};
    set(handles.push4, 'Enable', 'on');
    if strcmp(ent, 'Pointer')
        if strcmp(way, 'crd')
            Gr = str2double(data{1,1}{6});Gi = str2double(data{1,1}{7});
%             set(handles.push4, 'Enable', 'on');
            Pcode = 'UR001';
        elseif strcmp(way, 'path')
            if strcmp(data{1,1}{5}, 'free')
                Pcode ='UR002';
            else
                Pcode = 'UR003';
                str_code = data{1,1}{5};
            end
        elseif strcmp(way(1:8), 'crd_path')
            Pcode = 'UR005';
            str_code{1} = way(10);
            Udata = URdata_val(URPointer+1,:);
            Gr = str2double(data{1,1}{6});Gi = str2double(data{1,1}{7});
            C_i = [str2double(data{1,1}{3}),str2double(data{1,1}{4})];
            C_f = [Gr, Gi];
            Userdata = {C_i, C_f,[Udata(1), Udata(2), Udata(3)]};
        elseif strcmp(way(1:13), 'crd_repl_path')
            Pcode = 'UR006';
            str_code{1} = way(15);
            Udata = URdata_val(URPointer+1,:);
            Gr = str2double(data{1,1}{6});Gi = str2double(data{1,1}{7});
            C_i = [str2double(data{1,1}{3}),str2double(data{1,1}{4})];
            C_f = [Gr, Gi];
            Userdata = {C_i, C_f,[Udata(1), Udata(2), Udata(3)]};
        end
    elseif strcmp(ent, 'Loci')
         if strcmp(data{1,1}{4}, 'crash')
            Pcode = 'UR010';
            str_code = data{1,1}{2};
            Udata = URdata_val(URPointer+1,:);
            Userdata = {[Udata(1),Udata(2)], Udata(3), [Udata(4),Udata(5)],...
                [Udata(6),Udata(7)]};
        elseif strcmp(data{1,1}{2}, 'crash')
            Pcode = 'UR011';
            str_code = data{1,1}{4};
            Udata = URdata_val(URPointer+1,:);
            Userdata = {[Udata(8),Udata(9)], Udata(10), [Udata(11),Udata(12)],...
                [Udata(13),Udata(14)]};
        else
            Pcode = 'UR012';
            str_code{1} = data{1,1}{2};
            str_code{2} = data{1,1}{4};
            Udata = URdata_val(URPointer+1,:);
            Userdata = {[Udata(8),Udata(9)], Udata(10), [Udata(11),Udata(12)],...
                [Udata(13),Udata(14)]};
         end
    elseif strcmp(ent, 'Clear')
        Pcode = 'UR021';
        i = 0;
        Userdata = {};
        while(1)
            i = i + 1;
            data = textscan(URdata{1,1}{URPointer+1 + i}, '%s', 'delimiter', '|');
            ent{1} = data{1,1}{1};
            if strcmp(ent, 'Clear'), break;end
            str_code{i} = data{1,1}{2};
            Scode{i} = ent{1};
        end
        URPointer = URPointer + i;
        if IsRecordEnabled
            URActionforRecordedDatabase('redo', i+1)
            Hold_Temp_Rec_database_flag = 1;
        end
    elseif strcmp(ent, 'Marker')
        if strcmp(data{1,1}{2}, 'crash')
            Pcode = 'UR031';
            str_code{1} = data{1,1}{4};
            Udata = URdata_val(URPointer+1,:);
            Gr = Udata(8); Gi = Udata(9);
        elseif strcmp(data{1,1}{4}, 'crash')
            Pcode = 'UR030';
            str_code{1} = data{1,1}{2};
        end
    end
    if IsRecordEnabled
        URActionforRecordedDatabase('redo', 1)
        Hold_Temp_Rec_database_flag = 0;
    end
end

if ~URPointer, 
    set(handles.push4, 'Enable', 'off');
    set(handles.hmenu_undo, 'Enable', 'off');
elseif URPointer == n-1,
    set(handles.push5, 'Enable', 'off');
    set(handles.hmenu_redo, 'Enable', 'off');
end


function URActionforRecordedDatabase(action, len)

global Recorded_database
global Recorded_database_len
global PlayRecord_Pointer
global PlayRecord_index
global URTemp_Recorded_database
global Hold_Temp_Rec_database_flag

if Hold_Temp_Rec_database_flag, return;end
handles = guidata(gcbf);
if strcmp(action, 'undo')
    URTemp_Recorded_database{1} = [URTemp_Recorded_database{1};...
        Recorded_database{1,1}(end-len+1:end)];
    URTemp_Recorded_database{2} = [URTemp_Recorded_database{2};...
        Recorded_database{2}(end-len+1:end,:)];
    Recorded_database{1,1}(end-len+1:end) = [];
    Recorded_database{2}(end-len+1:end,:) = [];
    Recorded_database_len = Recorded_database_len - 1;
    PlayRecord_Pointer = PlayRecord_Pointer - len;
    PlayRecord_index = PlayRecord_index - 1;
elseif strcmp(action, 'redo')
    Recorded_database{1,1} = [Recorded_database{1,1};URTemp_Recorded_database{1,1}(end-len+1:end)];
    Recorded_database{2} = [Recorded_database{2};URTemp_Recorded_database{2}(end-len+1:end,:)];
    URTemp_Recorded_database{1,1}(end-len+1:end) = [];
    URTemp_Recorded_database{2}(end-len+1:end,:) = [];
    Recorded_database_len = Recorded_database_len + 1;
    PlayRecord_index  = PlayRecord_index + 1;
    PlayRecord_Pointer = PlayRecord_Pointer + len;
end

str = num2str(Recorded_database_len);
set(handles.text1, 'String', [str,'/',str]);