% GETXLS is a GUI that allows you to easily transfer data from an Excel
% file into Matlab's workspace.
%
% Usage:
%   getxls
%   getxls(style)
%   h = getxls(style)
%
% Inputs and Outputs:
%   style       Can be 'normal', 'modal', or 'docked' (or 'n', 'm', or
%               'd', for short), indicating the WindowStyle of the GUI.
%               Default is 'normal'.
%   h           A struct containing handles to the GUI and to its
%               components.
%
% Note: This GUI was programmatically created, without using GUIDE.
% Other than the code generated with GUIDE, it uses nested functions,
% which has the advantage that all variables that are defined in the main
% function are also in the scope of the nested functions. Furthermore, the
% program demonstrates how to use the Excel COM server and also contains an
% example how to access Matlab's editor with a program.
%
% Author : Yvan Lengwiler
% Release: $1.4b$
% Date   : $2012-10-20$
%
% see also XLSREAD

% History:
% 2010-05-30 : first version
% 2010-05-31 : these updates:
%            - added callback to edVariable, so that hitting the return key
%              has the same functionality as pressing the pbWriteVariable
%              button
%            - added toggle for row/col headings and buttons for font size
%            - added use of 'genvarname' in case the user selects an
%              invalid variable name
%            - added 'style' argument
%            - added tooltip texts to all objects in the GUI
% 2010-06-07 : Added 'Dates' filter to extract only cells that have some
%              date format
% 2010-06-23 : these updates:
%            - added 'generate m-file' functionality
%            - fixed bug when resizing window too small
%            - fixed bug that manifested on empty worksheets
% 2010-07-03 : Fixed the following bug: Clicking the 'Write Variable'
%              button caused the variable to be pushed twice, once by the
%              pbWriteVariable callback and once by the edVariable
%              callback. I use the KeyPressFnc callback on hedVariable now.
%              The same bug also caused the variable to be pushed when the
%              user clicked the 'Generate M-File' button.
% 2010-07-05 : these updates:
%            - If no range is selected, the whole worksheet is imported.
%            - Some objects are initially disabled and are enabled only
%              after a file has been loaded. This guides the user a bit
%              better.
% 2011-05-13 : 'Generate M-File' now reads the variablename and uses it for
%              the generated script.
% 2011-09-17 : Fixed bug that happened when only a single cell is selected.
%              Moreover, showing Row/Col headings is now the default.
% 2012-10-20 : 'editorservices' is no longer supported by the latest
%              version of ML, so GETXLS adapts to this change.
%
% TO DO: keep selection when changing type of data to import (but not when
% changing Worksheet or Workbook). For this, one needs to set the selected
% cells in the uitable programmatily. How do I do that?

function handles = getxls(style)

% *** initialize some variables ******************************************
% (these variables are 'global' within this program)

    hExcel      = NaN;          % handle to Excel server
    hBook       = NaN;          % handle to Excel workbook
    hSheet      = NaN;          % handle to Excel worksheet
    strFilename = '';           % name of Excel file
    strVariable = '';           % variable name, to be pushed to the
                                % base workspace
    xlsRaw      = [];           % raw data from Excel file
    xlsNum      = [];           % numerical data from Excel file
    xlsDates    = [];           % numerical dates from Excel file
    xlsTxt      = [];           % string data from Excel file
    rng         = zeros(1,4);   % selected range
    tblFontSize = 8;            % size of font in uitable

    vsizeGUI = 420; hsizeGUI = 670;     % size of GUI
    vspace = 18;    hspace = 24;        % vert and horiz spacing
    hpb = 105;      vpb = 30;           % size of pushbuttons
    smallspace = 5;                     % small space
    vpu = 24;                           % vert size of popup menu

% *** create but hide the GUI as it is being constructed *****************

    hGUI = figure(...
        'Visible'        ,'off',...
        'Units'          ,'pixel',...
        'WindowStyle'    ,'normal',...
        'Position'       ,[0,0,hsizeGUI,vsizeGUI],...
        'MenuBar'        ,'none',...
        'NumberTitle'    ,'off',...
        'Resize'         ,'on',...
        'Color'          ,get(0,'defaultUicontrolBackgroundColor'),...
        'ResizeFcn'      ,{@resizeGUI},...
        'CloseRequestFcn',{@cleanup}...
        );
    
    if nargin > 0
        try
            set(hGUI,'WindowStyle',style);
        catch e
            id = e.identifier;
            msg = ['getxls: argument must be one of the following: ',...
                '''normal'', ''modal'', or ''docked''.\n',e.message];
            error(id,msg);
        end
    end
    
% *** populate the GUI with objects **************************************
% Note that at this point the positions and sizes of the objects are not
% specified. They will be set later in 'resizeGUI'.

    htblData = uitable(...
        'RowName'        ,'numbered',...
        'ColumnName'     ,'numbered',...
        'FontSize'       ,tblFontSize,...
        'CellSelectionCallback', {@tblData_CellSelectionCallback});
    hpbLoadXLS = uicontrol(...
        'Style'          ,'pushbutton',...
        'String'         ,'Load Excel File',...
        'TooltipString'  ,'Select Excel workbook to load',...
        'Callback'       ,{@pbLoadXLS_Callback});
    hpbWriteVariable = uicontrol(...
        'Style'          ,'pushbutton',...
        'String'         ,'Write to Variable',...
        'Enable'         ,'off',...
        'TooltipString'  ,'Store selected data in variable',...
        'Callback'       ,{@pbWriteVariable_Callback});
    hpbWriteMcode = uicontrol(...
        'Style'          ,'pushbutton',...
        'String'         ,'Generate M-File',...
        'Enable'         ,'off',...
        'TooltipString'  ,'Generate script to import automatically',...
        'Callback'       ,{@pbWriteMcode_Callback});
    hpuSheets = uicontrol(...
        'Style'          ,'popupmenu',...
        'String'         ,{''},...
        'Enable'         ,'off',...
        'TooltipString'  ,'Select the sheet to use in the Excel workbook',...
        'BackgroundColor',[1 1 1],...
        'Callback'       ,{@puSheets_Callback});
    hpuType = uicontrol(...
        'Style'          ,'popupmenu',...
        'String'         ,{'Raw Data','Numerical','Dates','Text'},...
        'Enable'         ,'off',...
        'TooltipString'  ,'Choose what kind of data to import',...
        'BackgroundColor',[1 1 1],...
        'Callback'       ,{@puType_Callback});
    hedVariable = uicontrol(...
        'Style'          ,'edit',...
        'String'         ,'',...
        'Enable'         ,'off',...
        'TooltipString'  ,['Specify the name of the variable that will ',...
                           'contain the data'],...
        'BackgroundColor',[1 1 1],...
        'KeyPressFcn'    ,{@edVariable_KeyPressFcn});
    htbRowCol = uicontrol(...
        'Style'          ,'togglebutton',...
        'String'         ,'No Headings',...
        'Value'          ,false,...
        'TooltipString'  ,'Hide or show row/column headings',...
        'Callback'       ,{@tbRowCol_Callback});
    hpbSmaller = uicontrol(...
        'Style'          ,'pushbutton',...
        'String'         ,'-',...
        'TooltipString'  ,'Make font smaller',...
        'Callback'       ,{@pbSmaller_Callback});
    hpbLarger = uicontrol(...
        'Style'          ,'pushbutton',...
        'String'         ,'+',...
        'TooltipString'  ,'Make font larger',...
        'Callback'       ,{@pbLarger_Callback});
    
% *** prepare output arg (if requested) **********************************

    if nargout > 0
        % collect all handles
        handles = struct('GUI',hGUI, 'tblData',htblData, ...
            'pbLoadXLS',hpbLoadXLS, 'pbWriteVariable',hpbWriteVariable, ...
            'pbWriteMcode',hpbWriteMcode, ...
            'puSheets',hpuSheets, 'puType',hpuType, ...
            'edVariable',hedVariable, 'tbRowCol',htbRowCol, ...
            'pbSmaller',hpbSmaller, 'pbLarger',hpbLarger);
    end

% *** finalize appearance of GUI *****************************************

    % no element is adjusted automatically on resize ('units' are
    % not 'normalized')
    set([hGUI,htblData,hpbLoadXLS,hpbWriteVariable,hpbWriteMcode, ...
        hpuSheets,hpuType,hedVariable],'Units','pixel');
    resizeGUI();                % size and position all elements
    if ~strcmp(get(hGUI,'WindowStyle'),'docked')
        movegui(hGUI,'center')  % move it to the center of the screen
    end
    settitle('(no file)');      % set title of GUI
    % the GUI should never become the 'current figure'
    set(hGUI,'HandleVisibility','off');
    set(hGUI,'Visible','on');   % now show it

% *** functions for adjusting the GUI ************************************

    % position all the objects of the GUI
    % all objects remain fixed; only the table object adjusts size
    function resizeGUI(varargin)
        % get current position of GUI
        p = get(hGUI,'Position'); hsizeGUI = p(3); vsizeGUI = p(4);
        % tblData
        hsize = hsizeGUI-hpb-3*hspace; vsize = vsizeGUI-2*vspace;
        hpos = hspace; vpos = vspace;   
        % avoid negative sizes
        hsize = max(hsize,1); vsize = max(vsize,1);
        set(htblData, 'Position', [hpos,vpos,hsize,vsize]);
        % pbLoadXLS
        hpos = hsizeGUI-hpb-hspace; hsize = hpb;
        vpos = vsizeGUI-vspace-vpb;
        set(hpbLoadXLS, 'Position', [hpos,vpos,hsize,vpb]);
        % puSheets
        vpos = vpos-vpu-smallspace;
        set(hpuSheets, 'Position', [hpos,vpos,hsize,vpu]);
        % puType
        vpos = vpos-vpu-smallspace;
        set(hpuType, 'Position', [hpos,vpos,hsize,vpu]);
        % pbWriteVariable
        vpos = vpos-vpb-3*smallspace;
        set(hpbWriteVariable, 'Position', [hpos,vpos,hsize,vpb]);
        % edVariable
        vpos = vpos-vpu-smallspace;
        set(hedVariable, 'Position', [hpos,vpos,hsize,vpu]);
        % pbWriteMcode
        vpos = vpos-vpb-4*smallspace;
        set(hpbWriteMcode, 'Position', [hpos,vpos,hsize,vpb]);
        %
        % tbRowCol and pbSmaller and pbLarger are placed in the lower right
        % corner of the GUI. However, they are hidden if they get in the
        % way of pbWriteMcode.
        p = get(hpbWriteMcode,'Position');
        if vspace+2*vpb + smallspace > p(2);
            set([hpbSmaller,hpbLarger,htbRowCol],'Visible','off');
        else
            % pbSmaller/pbLarger
            set([hpbSmaller,hpbLarger,htbRowCol],'Visible','on');
            vpos = vspace;
            set(hpbSmaller, 'Position', [hpos,vpos,hsize/2,vpb]);
            set(hpbLarger, 'Position', [hpos+hsize/2,vpos,hsize/2,vpb]);
            % tbRowCol
            vpos = vpos+vpb;
            set(htbRowCol, 'Position', [hpos,vpos,hsize,vpb]);
        end
    end
    
    % set the title of the GUI
    function settitle(str)
        set(hGUI,'Name',[' GET XLS : ',str]);
    end
    
    % close open files and COM server when quitting
    function cleanup(varargin)
        try
            hBook.Close(false);
            hExcel.Quit;
        end
        delete(hGUI);
    end

% *** callbacks **********************************************************

    function pbLoadXLS_Callback(varargin)
        % ask user which file to import
        FilterSet = {'*.xl??','Excel Files (*.xl?)';...
            '*.csv','CSV Files (*.csv)';...
            '*.*','All Files (*.*)'};
        [FileName,PathName] = ...
            uigetfile(FilterSet,'Select Excel file to import');
        if ~isequal(FileName,0)         % not cancelled
            strFilename = fullfile(PathName,FileName);
            success = ConnectWithExcel();
            if success
                settitle(strFilename);  % set title of GUI
                UpdateSheetlist();      % update list of available sheets
                readXLSfile();          % read data from XLS file
                UpdateTable();          % show in GUIs table
                rng = zeros(1,4);       % selected range
                % enable a few objects on the GUI that start to make sense
                % if a file has been loaded
                set(hpbWriteVariable,'Enable','on');
                set(hedVariable,'Enable','on');
                set(hpbWriteMcode,'Enable','on');
                set(hpuSheets,'Enable','on');
                set(hpuType,'Enable','on');
            else
                % restore previous strFilename
                strFilename = get(hGUI,'Name');
                strFilename = strFilename(12:end);
            end
        end
    end
    
    % check if 'return' was pressed in the edVariable field
    function edVariable_KeyPressFcn(~, eventdata)
        if strcmp(eventdata.Key,'return')
            drawnow();   % required to make get(hedVariable,'String') work
            PushVariable();
        end
    end

    % write button clicked
    function pbWriteVariable_Callback(varargin)
        PushVariable();
    end

    % make a new M script
    function pbWriteMcode_Callback(varargin)
        MakeScript();
    end

    % select sheet to import
    function puSheets_Callback(varargin)
        idxSheet = get(hpuSheets,'Value');
        hSheet = get(hBook.Sheets,'item',idxSheet);
        readXLSfile();              % read data from XLS file
        UpdateTable();              % show in GUIs table
        rng = zeros(1,4);           % selected range
    end

    % raw, numeric, dates, text?
    function puType_Callback(varargin)
        UpdateTable();              % show in GUIs table
        % Here I'd like to keep the selected cells, i.e. to re-select the
        % cells that were selected before, but I don't know how to do that.
        rng = zeros(1,4);           % no range selected
    end

    % selection in the table has changed
    function tblData_CellSelectionCallback(~, eventdata)
        rng = eventdata.Indices;    % list of selected coordinates
        if numel(rng) < 4               % only one cell selected
            rng = [rng,rng];
        else
            rng = [min(rng),max(rng)];  % fill to one rectangular area
        end
    end

    % show or hide col and row names in table?
    function tbRowCol_Callback(varargin)
        if get(htbRowCol,'Value')
            showit = '';
        else
            showit = 'numbered';
        end
        set(htblData,'RowName',showit);
        set(htblData,'ColumnName',showit);
    end

    % increase font size
    function pbLarger_Callback(varargin)
        if tblFontSize < 20     % maximum font size
            tblFontSize = tblFontSize + 1;
            set(htblData,'FontSize',tblFontSize);
        end
    end

    % decrease font size
    function pbSmaller_Callback(varargin)
        if tblFontSize > 4      % minimum font size
            tblFontSize = tblFontSize - 1;
            set(htblData,'FontSize',tblFontSize);
        end
    end

% *** some subfunctions **************************************************

    % --- connect to Excel COM server
    function success = ConnectWithExcel()
        success = true;
        if ~isa(hExcel,'handle')    % COM server not there yet
            try
                hExcel = actxserver('Excel.Application');
            catch exception
                success = false;
                clear hExcel;
                errordlg(sprintf('Cannot start Excel server. Excel must be installed.\n%s',...
                    exception.message),'Can''t run Excel');
            end
        else
            if isa(hBook,'handle')  % close file if one is already open
                hBook.Close(false);
            end
        end
        try
            hBook = hExcel.workbooks.Open(strFilename,0,true);
        catch exception
            success = false;
            errordlg(sprintf('Cannot open the file ''%s''\n%s',...
                strFilename,exception.message),'File may be corrupt');
        end
    end

    % --- read list of Worksheets contained in Workbook and update
    %     popup menu accordingly
    function UpdateSheetlist()
        nbSheets = hBook.Sheets.Count;
        coll = cell(1,nbSheets);
        for s = 1:nbSheets
            coll{s} = hBook.Sheets.Item(s).Name;
        end
        set(hpuSheets,'String',coll);
        set(hpuSheets,'Value',1);
        hSheet = get(hBook.Sheets,'item',1);
    end

    % --- read and parse content of Excel file
    function readXLSfile()
        % simple solution, but fails on empty sheets and does not
        % necessarily start from $A$1: AllCells = hSheet.UsedRange;
        %
        % --- check if sheet is empty
        AddrUsedRange = hSheet.UsedRange.Address;
        % AddrUsedRange = get(hSheet.UsedRange,'Address',true,true,-4150);    % xlR1C1
        if strcmp(AddrUsedRange,'$A$1') && isnan(hSheet.UsedRange.Value)
            xlsRaw   = {'(sheet is empty)'};
            xlsTxt   = {''};
            xlsDates = {NaN};
            xlsNum   = {NaN};
            return
        end
        % --- get UsedRange, but make sure it starts at $A$1
        pos = strfind(AddrUsedRange,':');
        if isempty(pos)
            AddrUsedRange = ['$A$1:',AddrUsedRange];
        else
            AddrUsedRange = ['$A$1',AddrUsedRange(pos(1):end)];
        end
        AllCells = hSheet.Range(AddrUsedRange);
        % --- read in cell contents; place them in 'raw' array
        xlsRaw   = AllCells.Value;
        xlsRaw2  = AllCells.Value2;
        % Acknowledgement: Much of the following is taken from 'xlsread',
        % though it is simplified here.
        % --- Excel returns COM errors when it has a #N/A field.
        isXLNA = strcmp(xlsRaw,'ActiveX VT_ERROR: ');
        if any(isXLNA(:))
            xlsRaw(isXLNA)  = {'#N/A'};
            xlsRaw2(isXLNA) = {'#N/A'};
        end
        % --- place text cells in text array
        xlsTxt    = cell(size(xlsRaw));
        xlsTxt(:) = {''};   % fill cells with empty strings first
        isText         = cellfun('isclass',xlsRaw,'char');
        xlsTxt(isText) = xlsRaw(isText);    % fill in just the text cells ...
        xlsTxt(isXLNA) = {''};              % ... and remove the remaining '#N/A's 
        % --- place numeric cells in numeric array
        isNoNumber      = (cellfun('isempty',xlsRaw) | isText );
        aux             = xlsRaw;   % temporary copy of xlsRaw to work on
        aux(isNoNumber) = {NaN};    % remove all non-numbers
        xlsNum  = cell2mat(aux);    % make it a numeric array
        % --- place date cells in numeric array
        % cells that are strings in 'Value' but numeric in 'Value2' are
        % likely to be date cells
        isText2      = cellfun('isclass',xlsRaw2,'char');
        isDate       = (isText & ~isText2);
        aux          = xlsRaw2;         % temporary copy of xlsRaw2 to work on
        aux(~isDate) = {NaN};           % remove all non-dates
        xlsDates     = cell2mat(aux);   % make it a numeric array
        % adjust date code convention from Excel to Matlab
        xlsDates = xlsDates + 693960;
    end

    % --- fill content of GUIs uitable
    function UpdateTable()
        data = GetChosenData();
        set(htblData,'Data',data);
    end

    % --- return the relevant data (raw or num or txt)
    function data = GetChosenData()
        switch get(hpuType,'Value');
            case 1
                data = xlsRaw;
            case 2
                data = xlsNum;
            case 3
                data = xlsDates;
            case 4
                data = xlsTxt;
        end
    end

    % assign the selected content of the table to a variable whose name is
    % given by the edVariable edit field; assign it in the base workspace
    function PushVariable()
        strVariable = get(hedVariable,'String');
        if isempty(strVariable)
            warndlg('Please select a variable name first.',...
                'Missing Variable Name');
        else
            data = GetChosenData(); % read in the data
            if numel(rng) < 4 || any(rng == 0)  % no range selected ...
                thisdata = data;                % ... so import everything
            else
                % restrict to selected range
                thisdata = data(rng(1):rng(3),rng(2):rng(4));
            end
            try
                % push data into variable in base workspace
                assignin('base',strVariable,thisdata);
                fprintf('(variable ''%s'' has been assigned)\n', strVariable);
            catch exception
                newVariable = genvarname(strVariable);
                errordlg(sprintf(['Cannot assign to variable ''%s''.\n',...
                    'Maybe try ''%s'' instead?\n%s'],...
                    strVariable,newVariable,exception.message),...
                    'Assign has failed');
                set(hedVariable,'String',newVariable);  % update edit field
            end
        end
    end

    % create a new M script/function in ML's editor
    function MakeScript()
        if isempty(strFilename)
            warndlg('You need to load an Excel file first.',...
                'No file open');
            return;
        end
        % read variable name or assign default if missing or illegal
        strVariable = get(hedVariable,'String');
        newVariable = genvarname(strVariable);
        if ~strcmp(strVariable,newVariable)
        % this happens if strVariable is empty or an illegal variable name
            variablename = 'temp';
        else
            variablename = strVariable;
        end
        % convert selected range to Excel's address format
        if numel(rng) < 4 || any(rng == 0)
            % If no range is selected, an empty string is returned.
            % In that case, xlsread reads in all available data.
            rngStr = '';
        else
            toprow = int2str(rng(1));
            topcol = to26(rng(2));
            botrow = int2str(rng(3));
            botcol = to26(rng(4));
            rngStr = [topcol,toprow,':',botcol,botrow];
        end
        % header
        code = sprintf(['%% Code for importing data from Excel file, ', ...
            'generated with GETXLS.\n']);
        switch get(hpuType,'Value');
            case 1  % raw
                code = [code, sprintf('filename = ''%s'';\n', strFilename)];
                code = [code, sprintf('[~, ~, %s] = xlsread(filename, ''%s'', ''%s'');\n', ...
                    variablename, hSheet.Name, rngStr)];
            case 2  % numeric
                code = [code, sprintf('filename = ''%s'';\n', strFilename)];
                code = [code, sprintf('%s = xlsread(filename, ''%s'', ''%s'');\n', ...
                    variablename, hSheet.Name, rngStr)];
            case 3  % dates
                code = [code, sprintf('%% Use as follows: %s = importdata();\n\n', variablename)];
                code = [code, sprintf('function out = importdata()\n')];
                code = [code, sprintf('    filename = ''%s'';\n', strFilename)];
                code = [code, sprintf('    [~, ~, ~, out] = xlsread(filename, ''%s'', ''%s'', [], @val2);\n', ...
                    hSheet.Name, rngStr)];
                code = [code, sprintf('    out = cell2mat(out) + 693960;\n\n')];
                code = [code, sprintf(['function [DataRange, customOutput] = val2(DataRange)\n', ...
                    '    customOutput = DataRange.Value2;\n'])];
            case 4  % text
                code = [code, sprintf('filename = ''%s'';\n', strFilename)];
                code = [code, sprintf('[~, %s] = xlsread(filename, ''%s'', ''%s'');\n', ...
                    variablename, hSheet.Name, rngStr)];
        end
        % create new empty file in ML's editor and copy content into it
        try
            matlab.desktop.editor.newDocument(code);
        catch
            % for some older version(s) of ML
            editorservices.new(code);
        end
        %
        % nested function: convert to 26imal code
        function adr = to26(number)
            adr = '';
            while number>0
                m = mod(number-1,26);
                adr = [char(65+m),adr];
                number = (number - m - 1) / 26;
            end
        end
        % --- end of 'to26'
    end

end     % --- end main function
