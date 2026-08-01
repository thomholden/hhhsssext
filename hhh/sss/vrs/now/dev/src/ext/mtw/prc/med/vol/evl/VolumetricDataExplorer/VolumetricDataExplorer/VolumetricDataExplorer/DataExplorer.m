classdef DataExplorer < handle
    
    % DataExplorer
    % Version 1.6.1
    %
    % DataExplorer is the class file for the Volumetric Data Explorer app.
    % This app provides an interactive environment to explore higher
    % dimensional data using some of MATLAB's abilities for volumetric
    % visualization and animation. It was designed for data that was
    % measured in a 3D grid of data points, for example temperature or wind
    % speed taken at each point in a 3D space. If this data is taken over
    % time, it can also be animated. Any data that fits the form v =
    % f(x,y,z) or v = f(x,y,z,t) can be used.
    %
    % DataExplorer can be called from the command line to bring up the app:
    %
    % >> app = DataExplorer
    %
    % It can also be used in a functional form for inputting the data to be
    % visualized, v, the dimensional values, x y and z, and the time
    % vector, t. It can be used with the following syntax:
    %
    % >> app = DataExplorer(v)            % Specify data only
    % >> app = DataExplorer(x,y,z,v)      % Specify dimensions and data
    % >> app = DataExplorer(x,y,z,v,t)    % Specify dimensions, data and time
    % >> app = DataExplorer([],[],[],v,t) % Specify data and time, but not
    % dimensions
    %
    % Adam Filion 
    % Copyright 2013, The MathWorks, Inc.
    
    properties
        Figure % handle to figure
        % menu properties
        Data % holds the data to be visualized
        ImportMenu % holds handles to import data menu
        OptionsMenu % holds handles to Options menu
        HelpMenu % holds handles to Help menu
        DimValues % 1x3 cell array, holds X, Y, Z data if used
        TimeValues % holds time values if used
        FontSize % size of edit box fonts
        RecordOption % option of whether or not to record animation to avi file
        RecordFileName % name of file to record to
        RecordFrameRate % frame rate of recording
        WriteObject % handle to avi file
        % Top level panel properties
        SlicePanel % handle to panel containing slice visualization
        ISOPanel % handle to panel containing isosurface visualization
        ControlPanel % handle to panel containing controls
        VBox % vertial box, HBox on top, ControlPanel on bottom
        HBox % horizontal box, contains SlicePanel on left and ISOPanel on right
        % Control panel content properties
        HBoxCon % horizontal box inside ControlPanel, from left to right contains DelayPanel, PlayButton, DisplayPanel, and SliderPanel
        DelayPanel % panel containing VBoxDelay
        DisplayPanel % panel containing VBoxDisplay
        SliderPanel % panel containing HBoxSlider
        HBoxSlider % horizontal box containing PlaySlider
        VBoxDelay % veritcal box containing DelayPlus, DelayText and DelayMinus
        VBoxDisplay % vertical box containing HBoxStartAt
        PlaySlider % handle to slider control
        DelayPlus % handle to delay plus button
        DelayText % handle to edit box showing delay amount
        Delay % holds the delay value
        DelayMinus % handle to delay minus button
        HBoxStartAt % array of handles containing SampleText, SampleNum, TimeText and TimeNum
        SampleText % handle to text box for samples
        SampleNum % handle to edit box for starting sample number
        CurrentSample % holds the current sample being displayed
        TimeText % handle to text box for time
        TimeNum % handle to edit box for starting time number
        CurrentTime % holds the current time being displayed
        PlayButton % handle to PLAY button
        % Slice panel content properties
        SliceGrid % handle to Grid used in SlicePanel, contains GridComp
        GridComp % 3x3 cell array of handles to different components in SliceGrid
        SliceAxis % handle to axis used for slice
        SliceValuePanel % 1x3 array of handles to panels used in GridComp{3,2}
        SliceValueVBox % 1x3 array of handles to verital boxes used in SliceValuePanel
        SliceValue % 1x3 array of handles to edit boxes used in SliceValueVBox
        SliceColorbar % handle to colorbar, if created
        SliceHandle % 3x1 array of handles to slices
        SliceSliderListener % 3x1 array of handles to listeners for slice callbacks
        % ISO panel content properties
        HBoxISO % horizontal box containing ISOPanel components
        ISOAxis % handle to axis for isosurface plot
        VBoxISO % handle to vertical box containing ISOPanel controls
        ISOLevelPanel % 1x2 array of handles to panels for ISO Levels
        VBoxISOLevel % 1x2 array of handles to vertical boxes used in ISOLevelPanel
        ISOLevelText % 1x2 array of handles to edit boxes used in VBoxISOLevel
        ISOAlphaPanel % 1x2 array of handles to panels for ISO Alphas
        VBoxISOAlpha % 1x2 array of handles to vertical boxes used in ISOLevelAlpha
        ISOAlphaText % 1x2 array of handles to edit boxes used in VBoxISOAlpha
        ISOGridEmpty % 1x4 array of handles to empty holding spots in VBoxISO
        PatchHandle % 1x2 array of handles to patch plots
        HBoxISOSlider
        ISOSlider
        ISOContainer
        ISOColorbar
    end
    
    
    methods
        % Constructor
        function app = DataExplorer(varargin)
            % create figure
            screensize = get(0,'ScreenSize');
            app.Figure = figure('Position',[(screensize(3)-1100)/2 (screensize(4)-600)/2-20 ...
                1100 600],'NumberTitle','off','Name','Volumetric Data Explorer','ResizeFcn',@app.ResizeFcnCB,...
                'HandleVisibility','off','CloseRequestFcn',@app.CloseRequestFcnCB,'Renderer','OpenGL');
            
            % find toolbar toggle tools and delete unwanted ones
            delete(findall(app.Figure,'Tag','Exploration.Brushing'));
            tt = findall(app.Figure,'Type','uitoggletool');delete(tt([1:3 6 9]));
            % find and delete toolbar push tools
            pt = findall(app.Figure,'Type','uipushtool');delete(pt([1:3,5:end]));
            % find and delete menus
            delete(findall(app.Figure,'Type','uimenu'));
            % custom data tip display
            dcm_obj = datacursormode(app.Figure);
            set(dcm_obj,'UpdateFcn',@app.DataTipCB)
            % create custom menu
            app.FontSize = 18;
            app.RecordOption = 0;
            app.ImportMenu(1) = uimenu(app.Figure,'Label','Import Data');
            app.ImportMenu(2) = uimenu(app.ImportMenu(1),'Label','Import from Workspace','Callback',@app.ImportWorkspaceCB);
            app.ImportMenu(3) = uimenu(app.ImportMenu(1),'Label','Example Data');
            app.ImportMenu(4) = uimenu(app.ImportMenu(3),'Label','Oscillating Ellipsoid','Callback',@app.LoadEllipsoidCB);
            app.ImportMenu(5) = uimenu(app.ImportMenu(3),'Label','Fluid Flow','Callback',@app.LoadFluidFlowCB);
            app.OptionsMenu(1) = uimenu(app.Figure,'Label','Options');
            app.OptionsMenu(2) = uimenu(app.OptionsMenu(1),'Label','Save/Load options');
            app.OptionsMenu(3) = uimenu(app.OptionsMenu(2),'Label','Save current configuration','Callback',@app.SaveConfCB);
            app.OptionsMenu(4) = uimenu(app.OptionsMenu(2),'Label','Load saved configuration','Callback',@app.LoadConfCB);
            app.OptionsMenu(5) = uimenu(app.OptionsMenu(2),'Label','Delete saved configuration','Callback',@app.DeleteConfCB);
            app.OptionsMenu(6) = uimenu(app.OptionsMenu(2),'Label','Set current as default','Callback',@app.DefaultConfCB);
            app.OptionsMenu(7) = uimenu(app.OptionsMenu(2),'Label','Restore factory defaults','Callback',@app.RestoreConfCB);
            app.OptionsMenu(8) = uimenu(app.OptionsMenu(1),'Label','Link Rotation','Checked','on','Callback',@app.LinkRotationCB);
            app.OptionsMenu(9) = uimenu(app.OptionsMenu(1),'Label','Equalize Axes','Callback',@app.EqualAxesCB);
            app.OptionsMenu(10) = uimenu(app.OptionsMenu(1),'Label','Loop Animation','Checked','off','Callback',@app.LoopAnimationCB);
            app.OptionsMenu(11) = uimenu(app.OptionsMenu(1),'Label','Record Animation','Checked','off','Callback',@app.RecordAnimationCB);
            app.OptionsMenu(12) = uimenu(app.OptionsMenu(1),'Label','Colorbars','Checked','off','Callback',@app.ColorbarCB);
            app.OptionsMenu(13) = uimenu(app.OptionsMenu(1),'Label','Set Colormap','Checked','off','Callback',@app.SetColormapCB);
            app.OptionsMenu(14) = uimenu(app.OptionsMenu(1),'Label','Set Font Size','Checked','off','Callback',@app.SetFontSizeCB);
            app.OptionsMenu(15) = uimenu(app.OptionsMenu(1),'Label','Set Axes Names','Checked','off','Callback',@app.SetAxesNamesCB);
            app.OptionsMenu(16) = uimenu(app.OptionsMenu(1),'Label','Beep on Warning','Checked','on','Callback',@app.BeepCB);
            app.OptionsMenu(17) = uimenu(app.OptionsMenu(1),'Label','Dynamic ISO Color','Checked','off','Callback',@app.DynamicISOCB);
            app.HelpMenu(1) = uimenu(app.Figure,'Label','Help');
            app.HelpMenu(2) = uimenu(app.HelpMenu(1),'Label','Open Help Documentation','Checked','off','Callback',@app.HelpCB);
            
            % create top level panels
            app.VBox = uiextras.VBox('Parent',app.Figure,'Padding',2,'Spacing',2);
            app.HBox = uiextras.HBox('Parent',app.VBox,'Padding',2,'Spacing',2);
            app.SlicePanel = uiextras.BoxPanel('Parent',app.HBox,'Title','Slices','FontSize',12);
            app.ISOPanel = uiextras.BoxPanel('Parent',app.HBox,'Title','Isosurfaces','FontSize',12);
            app.ControlPanel = uiextras.BoxPanel('Parent',app.VBox,'Title','Controls','FontSize',12);
            set(app.VBox, 'Sizes', [-1 150]);
            
            % create control panel contents
            app.HBoxCon = uiextras.HBox('Parent',app.ControlPanel,'Spacing',5,'Padding',2);
            app.DelayPanel = uiextras.BoxPanel('Parent',app.HBoxCon,'Title','Delay Animation (sec)');
            app.PlayButton = uicontrol('Parent',app.HBoxCon,'Style','togglebutton','String','PLAY','Value',0,'FontSize',24,'Callback',@app.PlayButtonCB);
            app.DisplayPanel = uiextras.BoxPanel('Parent',app.HBoxCon,'Title','Displaying:');
            app.PlaySlider = uicontrol('Parent',app.HBoxCon,'Style', 'slider','Min',1,'Max',50,'Value',1,'Callback', @app.PlaySliderCB);            
            addlistener(app.PlaySlider,'ContinuousValueChange',@app.PlaySliderCB);
            app.CurrentSample = get(app.PlaySlider,'Value');
            set(app.HBoxCon, 'Sizes', [120 150 200 -1]);
            app.VBoxDelay = uiextras.VBox('Parent',app.DelayPanel,'Spacing',2,'Padding',2);
            app.VBoxDisplay = uiextras.VBox('Parent',app.DisplayPanel,'Spacing',2,'Padding',2);
            app.DelayPlus = uicontrol('Parent',app.VBoxDelay,'String','+','FontSize',18,'Callback',@app.DelayPlusCB);
            app.DelayText = uicontrol('Parent',app.VBoxDelay,'Style','edit','String','0','FontSize',app.FontSize,'Callback',@app.DelayTextCB);
            app.Delay = str2double(get(app.DelayText,'String'));
            app.DelayMinus = uicontrol('Parent',app.VBoxDelay,'String','-','FontSize',18,'Callback',@app.DelayMinusCB);
            app.HBoxStartAt(1) = uiextras.HBox('Parent',app.VBoxDisplay);
            app.SampleText = uicontrol('Parent',app.HBoxStartAt(1),'Style','text','String','Current sample:','FontSize',16);
            app.SampleNum = uicontrol('Parent',app.HBoxStartAt(1),'Style','edit','String','1','FontSize',app.FontSize,'Callback',@app.SampleNumCB);
            app.HBoxStartAt(2) = uiextras.HBox('Parent',app.VBoxDisplay);
            app.TimeText = uicontrol('Parent',app.HBoxStartAt(2),'Style','text','String','Current time:','FontSize',16);
            app.TimeNum = uicontrol('Parent',app.HBoxStartAt(2),'Style','edit','String','N/A','FontSize',app.FontSize,'Callback',@app.TimeNumCB);
            
            % create slice panel contents
            app.SliceGrid = uiextras.Grid('Parent',app.SlicePanel,'Spacing',10,'Padding',10);
            app.GridComp = cell(3,2);
            app.GridComp{1,1} = uiextras.Empty('Parent',app.SliceGrid);
            app.GridComp{2,1} = uicontrol('Parent',app.SliceGrid,'Style','slider');
            app.GridComp{3,1} = uiextras.Empty('Parent',app.SliceGrid);
            app.GridComp{1,2} = uicontrol('Parent',app.SliceGrid,'Style','slider');
            app.GridComp{2,2} = uicontainer('Parent',app.SliceGrid);
            app.SliceAxis = axes('Parent',app.GridComp{2,2});grid(app.SliceAxis,'on');
            xlabel(app.SliceAxis,'X');ylabel(app.SliceAxis,'Y');zlabel(app.SliceAxis,'Z');
            app.GridComp{3,2} = uicontrol('Parent',app.SliceGrid,'Style','slider');
            app.GridComp{1,3} = uiextras.Empty('Parent',app.SliceGrid);
            app.GridComp{2,3} = uiextras.VBox('Parent',app.SliceGrid,'Spacing',2,'Padding',2);
            app.GridComp{3,3} = uiextras.Empty('Parent',app.SliceGrid);
            addlistener(app.GridComp{2,1},'ContinuousValueChange',@app.RedrawSlice);
            addlistener(app.GridComp{1,2},'ContinuousValueChange',@app.RedrawSlice);
            addlistener(app.GridComp{3,2},'ContinuousValueChange',@app.RedrawSlice);
            app.SliceValuePanel(1) = uiextras.BoxPanel('Parent',app.GridComp{2,3},'Title','X Slice At:');
            app.SliceValueVBox(1) = uiextras.VBox('Parent',app.SliceValuePanel(1),'Spacing',2,'Padding',2);
            app.SliceValue(1) = uicontrol('Parent',app.SliceValueVBox(1),'Style','edit','String','0','FontSize',app.FontSize,'Callback',@app.SliceValueCB);
            app.SliceValuePanel(2) = uiextras.BoxPanel('Parent',app.GridComp{2,3},'Title','Y Slice At:');
            app.SliceValueVBox(2) = uiextras.VBox('Parent',app.SliceValuePanel(2),'Spacing',2,'Padding',2);
            app.SliceValue(2) = uicontrol('Parent',app.SliceValueVBox(2),'Style','edit','String','0','FontSize',app.FontSize,'Callback',@app.SliceValueCB);
            app.SliceValuePanel(3) = uiextras.BoxPanel('Parent',app.GridComp{2,3},'Title','Z Slice At:');
            app.SliceValueVBox(3) = uiextras.VBox('Parent',app.SliceValuePanel(3),'Spacing',2,'Padding',2);
            app.SliceValue(3) = uicontrol('Parent',app.SliceValueVBox(3),'Style','edit','String','0','FontSize',app.FontSize,'Callback',@app.SliceValueCB);
            set(app.SliceGrid, 'ColumnSizes', [30 -1 80], 'RowSizes', [30 -1 30] );
            
            % create isosurface panel contents
            app.HBoxISO = uiextras.HBox('Parent',app.ISOPanel,'Spacing',5,'Padding',2);
            app.ISOContainer = uicontainer('Parent',app.HBoxISO);
            app.ISOAxis = axes('Parent',app.ISOContainer);grid(app.ISOAxis,'on');
            xlabel(app.ISOAxis,'X');ylabel(app.ISOAxis,'Y');zlabel(app.ISOAxis,'Z');
            app.HBoxISOSlider = uiextras.HBox('Parent',app.HBoxISO,'Spacing',5,'Padding',2);
            app.VBoxISO = uiextras.VBox('Parent',app.HBoxISO,'Spacing',5,'Padding',2);
            app.ISOGridEmpty(1) = uiextras.Empty('Parent',app.VBoxISO);
            app.ISOLevelPanel(1) = uiextras.BoxPanel('Parent',app.VBoxISO,'Title','ISO Level 1');
            app.VBoxISOLevel(1) = uiextras.VBox('Parent',app.ISOLevelPanel(1),'Spacing',2,'Padding',2);
            app.ISOLevelText(1) = uicontrol('Parent',app.VBoxISOLevel(1),'Style','edit','String','2','FontSize',app.FontSize,'Callback',@app.RedrawISO);
            app.ISOAlphaPanel(1) = uiextras.BoxPanel('Parent',app.VBoxISO,'Title','ISO Alpha 1');
            app.VBoxISOAlpha(1) = uiextras.VBox('Parent',app.ISOAlphaPanel(1),'Spacing',2,'Padding',2);
            app.ISOAlphaText(1) = uicontrol('Parent',app.VBoxISOAlpha(1),'Style','edit','String','0.5','FontSize',app.FontSize,'Callback',@app.RedrawISO);
            app.ISOGridEmpty(2) = uiextras.Empty('Parent',app.VBoxISO);
            app.ISOGridEmpty(3) = uiextras.Empty('Parent',app.VBoxISO);
            app.ISOLevelPanel(2) = uiextras.BoxPanel('Parent',app.VBoxISO,'Title','ISO Level 2');
            app.VBoxISOLevel(2) = uiextras.VBox('Parent',app.ISOLevelPanel(2),'Spacing',2,'Padding',2);
            app.ISOLevelText(2) = uicontrol('Parent',app.VBoxISOLevel(2),'Style','edit','String','1','FontSize',app.FontSize,'Callback',@app.RedrawISO);
            app.ISOAlphaPanel(2) = uiextras.BoxPanel('Parent',app.VBoxISO,'Title','ISO Alpha 2');
            app.VBoxISOAlpha(2) = uiextras.VBox('Parent',app.ISOAlphaPanel(2),'Spacing',2,'Padding',2);
            app.ISOAlphaText(2) = uicontrol('Parent',app.VBoxISOAlpha(2),'Style','edit','String','0.7','FontSize',app.FontSize,'Callback',@app.RedrawISO);
            app.ISOGridEmpty(4) = uiextras.Empty('Parent',app.VBoxISO);
            app.ISOSlider(1) = uicontrol('Parent',app.HBoxISOSlider,'Style','slider');
            app.ISOSlider(2) = uicontrol('Parent',app.HBoxISOSlider,'Style','slider');
            addlistener(app.ISOSlider(1),'ContinuousValueChange',@app.ISOSliderCB);
            addlistener(app.ISOSlider(2),'ContinuousValueChange',@app.ISOSliderCB);
            set(app.HBoxISO,'Sizes',[-1 60 80]);
            
            % disable the GUI components until data is imported, then link
            % axes rotation and set the viewing angle
            set([app.PlaySlider,app.GridComp{2,1},app.GridComp{1,2},...
                app.GridComp{3,2},app.ISOSlider,app.DelayText,...
                app.SampleNum,app.TimeNum,app.SliceValue,...
                app.ISOLevelText,app.ISOAlphaText,app.PlayButton,...
                app.DelayPlus,app.DelayMinus,app.OptionsMenu],'Enable','off');
            % link axes rotation
            setappdata(app.SliceAxis,'graphics_linkprop',linkprop([app.SliceAxis app.ISOAxis],{'CameraPosition','CameraUpVector'}));
            view(app.SliceAxis,-30,50);
            
            % if functional syntax form is used, save into data variable in
            % same form as returned by uigetvariable so validation code can
            % be reused
            if numel(varargin) > 0
                names = {'','X','Y','Z'}; % put in same format returned by uigetvariables
            end
            if numel(varargin) == 1
                data{1} = varargin{1};
                data{2} = [];data{3} = [];data{4} = [];data{5} = [];
                ValidateData(app,data,names);
            elseif numel(varargin) == 4
                data{5} = [];data{1} = varargin{4};
                data{2} = varargin{1};data{3} = varargin{2};data{4} = varargin{3};
                ValidateData(app,data,names);
            elseif numel(varargin) == 5
                data{5} = varargin{5};data{1} = varargin{4};
                data{2} = varargin{1};data{3} = varargin{2};data{4} = varargin{3};
                ValidateData(app,data,names);
            elseif numel(varargin) > 0
                warning('Incorrect number of inputs');BeepOnWarn(app);
            end
            
            % Save factory settings and create default if it doesn't exist
            curdir = which('DataExplorer');
            if ~(exist([curdir(1:end-15) filesep 'DE_factory.mat'],'file')==2)
                conf = getSettings(app); %#ok
                save([curdir(1:end-15) filesep 'DE_factory.mat'],'conf');
            end
            if ~(exist([curdir(1:end-15) filesep 'DE_default.mat'],'file')==2)
                load([curdir(1:end-15) filesep 'DE_factory.mat']);
                save([curdir(1:end-15) filesep 'DE_default.mat'],'conf');
            end
            % turn off configuration options until data is loaded
            set(app.OptionsMenu(2),'Enable','off')
            set(app.OptionsMenu(9),'Enable','off')
        end
        
        function ResizeFcnCB(app,~,~)
            % ResizeFcnCB is run after the DataExplorer figure window is
            % resized. This is needed to make sure the colorbar does not
            % overlap with the plot after resizing.
            if ishandle(app.SliceColorbar) % if colorbar exists
                delete(app.SliceColorbar) % delete it
                drawnow; % force graphics update, doesn't work without this!
                app.SliceColorbar = colorbar('peer',app.SliceAxis); % create new colorbar
            end
            if ishandle(app.ISOColorbar) % if colorbar exists
                delete(app.ISOColorbar) % delete it
                drawnow; % force graphics update, doesn't work without this!
                app.ISOColorbar = colorbar('peer',app.ISOAxis); % create new colorbar
            end
        end
        
        function CloseRequestFcnCB(app,~,~)
            % CloseRequestFcnCB is run when the figure is closed. It closes
            % the avi file if it is actively being recorded to at the time
            % of closing.
            if app.RecordOption == 1
                close(app.WriteObject);
                app.RecordOption = 0;
            end
            delete(app.Figure);
        end
    
        % menu functions
        function SaveConfCB(app,~,~)
            % SaveConfCB is the callback for the Options -> Save/Load
            % options -> Save current configuration menu option. It
            % will save the current set of options to a file in the app's
            % directory for later use.
            prompt = 'Enter a name for this set of preferences.';
            def = {'mypref'};
            answer = inputdlg(prompt,'Set Font Size',1,def);
            if ~(strcmp(answer{1},'default') || strcmp(answer{1},'factory'))
                conf = getSettings(app); %#ok
                curdir = which('SaveConfCB');
                save([curdir(1:end-15) filesep 'DE_' answer{1} '.mat'],'conf');
            else
                warning('''default'' and ''factory'' are reserved preferences names, please resave under a different name');
                BeepOnWarn(app);
            end
        end
        
        function LoadConfCB(app,~,~)
            % LoadConfCB is the callback for the Options -> Save/Load
            % options -> Load saved configuration menu option. It
            % will load a set of saved option settings from a mat file in
            % the app's directory.
            curdir = which('LoadConfCB');
            list = struct2cell(dir([curdir(1:end-15) filesep 'DE_*.mat']));
            names = list(1,:);
            for ii = 1:numel(names)
                names{ii} = names{ii}(4:end-4);
                if strcmp(names{ii},'factory')
                    % user can't directly load factory settings
                    names{ii} = '';
                end
            end
            [answer,ok] = listdlg('ListString',names,'SelectionMode','single','Name','Select Preferences File','PromptString','Select a preferences file to load');
            if ok && ~strcmp(names{answer},'')
                load([curdir(1:end-15) filesep list{1,answer}]);
                setSettings(app,conf);
            end
        end
        
        function DeleteConfCB(~,~,~)
            % DeleteConfCB is the callback for the Options -> Save/Load
            % options -> Deleted saved preferences menu option. It allows
            % the user to select a custom saved preferences file and delete
            % it.
            curdir = which('DeleteConfCB');
            list = struct2cell(dir([curdir(1:end-15) filesep 'DE_*.mat']));
            names = list(1,:);
            for ii = 1:numel(names)
                names{ii} = names{ii}(4:end-4);
                if strcmp(names{ii},'factory') || strcmp(names{ii},'default')
                    % remove both factory and default, don't want user
                    % deleting either
                    names{ii} = '';
                end
            end
            [answer,ok] = listdlg('ListString',names,'SelectionMode','single','Name','Select Preferences File','PromptString','Select a preferences file to delete');
            if ok && ~strcmp(names{answer},'')
                delete([curdir(1:end-15) filesep list{1,answer}]);
            end
        end
        
        function DefaultConfCB(app,~,~)
            % DefaultConfCB is the callback for the Options -> Save/Load
            % options -> Set Current As Default menu option. This
            % will set the current options configuration as both the
            % current and default set to use.
            conf = getSettings(app); %#ok
            curdir = which('DefaultConfCB');
            save([curdir(1:end-15) filesep 'DE_default.mat'],'conf');
        end
        
        function RestoreConfCB(app,~,~)
            % RestoreConfCB is the callback for the Options -> Save/Load
            % options -> Restore factory defaults menu option. This
            % will reset both the current and default options configuration
            % to their original settings.
            curdir = which('RestoreConfCB');
            load([curdir(1:end-15) filesep 'DE_factory.mat']);
            setSettings(app,conf);
            save([curdir(1:end-15) filesep 'DE_default.mat'],'conf');
        end
        
        function conf = getSettings(app)
            % getSettings is a helper function that returns a structure
            % containing all the options information needed for
            % saving/loading options
            conf.LinkRotation = get(app.OptionsMenu(8),'Checked');
            conf.EqualAxes = get(app.OptionsMenu(9),'Checked');
            conf.LoopAnimation = get(app.OptionsMenu(10),'Checked');
            conf.RecordAnimation = get(app.OptionsMenu(11),'Checked');
            conf.Colorbar = get(app.OptionsMenu(12),'Checked');
            conf.Colormap = get(app.Figure,'Colormap');
            conf.FontSize = app.FontSize;
            conf.Beep = get(app.OptionsMenu(16),'Checked');
            conf.RecordOption = app.RecordOption;
            conf.RecordFileName = app.RecordFileName;
            conf.DynamicISO = get(app.OptionsMenu(17),'Checked');
        end
        
        function setSettings(app,conf)
            % setSettings is a helper function that accepts a sturcture
            % created by getSettings and will set all the appropriate
            % options to match the saved options configuration
            if strcmp(conf.LinkRotation,'on')
                % if the saved setting was 'on', set the current option
                % to 'off' and run callback so it gets turned on and
                % link axes
                set(app.OptionsMenu(8),'Checked','off');LinkRotationCB(app);
            else
                set(app.OptionsMenu(8),'Checked','on');LinkRotationCB(app);
            end
            if strcmp(conf.EqualAxes,'on')
                set(app.OptionsMenu(9),'Checked','off');EqualAxesCB(app);
            else
                set(app.OptionsMenu(9),'Checked','on');EqualAxesCB(app);
            end
            % no additional code to run for the LoopAnimation option, so we
            % can set it directly
            set(app.OptionsMenu(10),'Checked',conf.LoopAnimation);
            app.RecordOption = conf.RecordOption;
            if strcmp(conf.RecordAnimation,'on')
                % if the record option is on, do not rerun callback as file
                % name is saved in preferences
                set(app.OptionsMenu(11),'Checked','on');
                app.RecordFileName = conf.RecordFileName;
            else
                set(app.OptionsMenu(11),'Checked','off');
            end
            if strcmp(conf.Colorbar,'on')
                set(app.OptionsMenu(12),'Checked','off');ColorbarCB(app);
            else
                set(app.OptionsMenu(12),'Checked','on');ColorbarCB(app);
            end
            set(app.Figure,'Colormap',conf.Colormap);
            app.FontSize = conf.FontSize;
            set([app.SampleNum, app.TimeNum, app.DelayText, app.SliceValue,...
                app.ISOLevelText, app.ISOAlphaText],'FontSize',app.FontSize);
            set(app.OptionsMenu(16),'Checked',conf.Beep);
            if strcmp(conf.DynamicISO,'on')
                set(app.OptionsMenu(17),'Checked','off');DynamicISOCB(app);
            else
                set(app.OptionsMenu(17),'Checked','on');DynamicISOCB(app);
            end
        end
        
        function LoopAnimationCB(app,~,~)
            % LoopAnimationCB is the callback for the Options -> Loop
            % Animation menu option. This toggles whether the animation
            % will loop upon finishing.
            if strcmp(get(app.OptionsMenu(10),'Checked'),'off')
                set(app.OptionsMenu(10),'Checked','on')
            else
                set(app.OptionsMenu(10),'Checked','off')
            end
        end
        
        function DynamicISOCB(app,~,~)
            % DynamicISOCB is the callback  for the Options -> Dynamic ISO
            % Color menu option. Turning this on will cause the isosurface
            % colors to match the colors for the corresponding value in the
            % slice plot using the figures colormap. Turning it off will
            % set them to default values.
            if strcmp(get(app.OptionsMenu(17),'Checked'),'off')
                set(app.OptionsMenu(17),'Checked','on')
                RedrawISO(app);
            else
                set(app.OptionsMenu(17),'Checked','off')
                RedrawISO(app);
            end
        end
        
        function RecordAnimationCB(app,~,~)
            % RecordAnimationCB is the callback for the Options -> Record
            % Animation menu option. Turning it on asks the user for the
            % name of the file to record to.
            if strcmp(get(app.OptionsMenu(11),'Checked'),'off')
                prompt = {'Enter name of avi file in which to save animation';'Enter frame rate for recorded file (frames/sec)'};
                answer = inputdlg(prompt,'File Name',1,{'DataExplorerAVI';'10'});
                if ~isempty(answer{1})
                    set(app.OptionsMenu(11),'Checked','on')
                    app.RecordOption = 1;
                    app.RecordFileName = answer{1};
                    fr = str2double(answer{2});
                    if fr > 0 && rem(fr,1) == 0
                        app.RecordFrameRate = fr;
                    else
                        warning('Frame rate must be a positive integer, using default of 10 frames/sec');
                        BeepOnWarn(app);
                    end
                end
            else
                set(app.OptionsMenu(11),'Checked','off')
                app.RecordOption = 0;
            end
        end
        
        function EqualAxesCB(app,~,~)
            % EqualAxesCB is the callback for the Options -> Equalize Axes
            % menu option. This toggles whether the aspect ratio is set so
            % that the data units are the same in every direction
            if strcmp(get(app.OptionsMenu(9),'Checked'),'off')
                % if it's off when clicked, turn it on and set axis equal
                set(app.OptionsMenu(9),'Checked','on')
                axis([app.SliceAxis app.ISOAxis],'equal')
                % the bounds need to be reset for ISO axis
                minx = min(app.DimValues{1}(:));maxx = max(app.DimValues{1}(:));
                miny = min(app.DimValues{2}(:));maxy = max(app.DimValues{2}(:));
                minz = min(app.DimValues{3}(:));maxz = max(app.DimValues{3}(:));
                set(app.ISOAxis,'XLim',[minx maxx],'YLim',[miny maxy],'ZLim',[minz maxz]);
            else % if it's on, turn it off and return axis to normal
                set(app.OptionsMenu(9),'Checked','off')
                axis([app.SliceAxis app.ISOAxis],'normal')
            end
        end
        
        function HelpCB(~,~,~)
            % HelpCB is the callback for the Help menu option. It opens the
            % MATLAB web browser to an html help page for this app.
            web([filesep 'html' filesep 'HelpDocFile.html']);
        end
        
        function ColorbarCB(app,~,~)
            % ColorbarCB is the callback for the Options -> Colorbar menu
            % option. It toggles whether there is a colorbar for SliceAxis.
            if strcmp(get(app.OptionsMenu(12),'Checked'),'off')
                % if it's not on when clicked, turn it on and create the
                % colorbar
                set(app.OptionsMenu(12),'Checked','on');
                app.SliceColorbar = colorbar('peer',app.SliceAxis);
                app.ISOColorbar = colorbar('peer',app.ISOAxis);
            else % if it's on, turn it off and delete colorbar
                set(app.OptionsMenu(12),'Checked','off');
                if ishandle(app.SliceColorbar)
                    delete(app.SliceColorbar)
                end
                if ishandle(app.ISOColorbar)
                    delete(app.ISOColorbar)
                end
            end
        end
        
        function BeepCB(app,~,~)
            % BeepCB is the callback for the Options -> Beep on Warning
            % options. This toggles whether MATLAB will beep when invalid
            % data or settings are used.
            if strcmp(get(app.OptionsMenu(16),'Checked'),'on')
                set(app.OptionsMenu(16),'Checked','off')
            else
                set(app.OptionsMenu(16),'Checked','on')
            end
        end
        
        function LinkRotationCB(app,~,~)
            % LinkRotationCB is the callback for the Options -> Link
            % Rotation menu option. It toggles whether the viewing azimuth
            % and elevation of both SliceAxis and ISOAxis are the same, and
            % allows the rotate tool to rotate both at the same time.
            if strcmp(get(app.OptionsMenu(8),'Checked'),'off')
                % if it's off, turn it on and link axes rotation
                set(app.OptionsMenu(8),'Checked','on');
                setappdata(app.SliceAxis,'graphics_linkprop',linkprop([app.SliceAxis app.ISOAxis],{'CameraPosition','CameraUpVector'}));
            else % if it's on, turn it off and decouple axes rotation
                set(app.OptionsMenu(8),'Checked','off');
                setappdata(app.SliceAxis,'graphics_linkprop',[]);
            end
        end
        
        function SetFontSizeCB(app,~,~)
            % SetFontSizeCB is the callback for the Options -> Set Font
            % Size menu option. It creates a dialog box that asks the user
            % to enter a value for the font size used in the edit boxes. If
            % the entered value is invalid it warns and keeps the original
            % value.
            prompt = {'Enter font size for edit boxes'};
            answer = inputdlg(prompt,'Set Font Size',1,{num2str(app.FontSize,15)});
            fontans = str2double(answer{1});
            try
                validateattributes(fontans,{'double'},{'scalar','nonempty','>',0});
                app.FontSize = fontans;
                set([app.SampleNum, app.TimeNum, app.DelayText, app.SliceValue,...
                    app.ISOLevelText, app.ISOAlphaText],'FontSize',app.FontSize);
            catch
                warning('Invalid font size entered');BeepOnWarn(app);
            end
        end
        
        function SetAxesNamesCB(app,~,~)
            % SetAxesNamesCB is the callback function for the Options ->
            % Set Axes Names option. It opens a dialog box that allows the
            % user to specify custom axes names.
            prompt = {'Enter x-axis label','Enter y-axis label','Enter z-axis label'};
            xl = get(app.SliceAxis,'XLabel');yl = get(app.SliceAxis,'YLabel');
            zl = get(app.SliceAxis,'ZLabel');
            def = {get(xl,'String'),get(yl,'String'),get(zl,'String')};
            answer = inputdlg(prompt,'Set Font Size',1,def);
            if ~isempty(answer)
                % set the axes names
                set(xl,'String',answer{1});set(yl,'String',answer{2});set(zl,'String',answer{3});
                xlabel(app.ISOAxis,answer{1});ylabel(app.ISOAxis,answer{2});zlabel(app.ISOAxis,answer{3});
                % store names in UserData for use in custom data tip
                set(app.SliceHandle,'UserData',answer);
                set(app.PatchHandle,'UserData',answer);
            end
        end
        
        function SetColormapCB(app,~,~)
            % SetColormapCB is the callback for the Options -> Set Colormap
            % menu option. It opens a list box that lets the user import a
            % variable from the workspace, invert the current colormap, or
            % edit the current colormap. For importing a colormap, another
            % dialog box is opened that allows the user to specify a
            % variable in the base workspace that contains the colormap.
            list = {'jet','hsv','hot','cool','spring','summer','autmn','winter','gray','bone','copper','pink','Invert current colormap','Import from workspace','Open Colormap Editor'};
            [answer,ok] = listdlg('ListString',list,'SelectionMode','single','Name','Select Colormap','PromptString','Select a colormap');
            if ok
                switch answer
                    case 1; set(app.Figure,'ColorMap',jet); close(gcf);
                    case 2; set(app.Figure,'ColorMap',hsv); close(gcf);
                    case 3; set(app.Figure,'ColorMap',hot); close(gcf);
                    case 4; set(app.Figure,'ColorMap',cool); close(gcf);
                    case 5; set(app.Figure,'ColorMap',spring); close(gcf);
                    case 6; set(app.Figure,'ColorMap',summer); close(gcf);
                    case 7; set(app.Figure,'ColorMap',autumn); close(gcf);
                    case 8; set(app.Figure,'ColorMap',winter); close(gcf);
                    case 9; set(app.Figure,'ColorMap',gray); close(gcf);
                    case 10; set(app.Figure,'ColorMap',bone); close(gcf);
                    case 11; set(app.Figure,'ColorMap',copper); close(gcf);
                    case 12; set(app.Figure,'ColorMap',pink); close(gcf);
                    case 13 % invert current colormap
                        set(app.Figure,'Colormap',flipdim(get(app.Figure,'Colormap'),1));
                    case 14 % custom colormap
                        text = {'Enter colormap variable from workspace'};
                        checkvars = @(in) ismatrix(in) && length(in(1,:))==3 ...
                            && max(in(:)) <= 1 && min(in(:)) >= 0;
                        customcm = uigetvariables(text,'ValidationFcn',checkvars);
                        if ~isempty(customcm)
                            try
                                set(app.Figure,'ColorMap',customcm{1});
                            catch
                                warning('Invalid colormap variable used');BeepOnWarn(app);
                            end
                        end
                    case 15 % open colormap editor
                        colormapeditor(app.Figure);
                end
                RedrawISO(app);
            end
        end
        % load data functions
        function ImportWorkspaceCB(app,~,~)
            % ImportWorkspaceCB is the callback for the Import Data ->
            % Import from Workspace menu option. This opens up a dialog to
            % select variables from the workspace using the uigetvariables
            % command. It checks if selected variables are of proper size,
            % and issues warning and uses defaults if they are not.
            
            % strings for use in variable selection popup
            intro = ['DataExplorer expects the imported data variable to be either 3D or 4D. The first three dimensions ',...
                'hold the measurements through the 3D space (i.e. temperature), while the 4th dimension (if available) denotes ',...
                'which sample this data came from. You can optionally specify the X, Y and Z values to be used when visualizing the data. ',...
                'If you do not specify X, Y, and Z data, then DataExplorer will use default axes of 1:length(dim), where dim is the particular ',...
                'dimension. You may also optionally specify a time vector. See the Help documentation for more details.'];
            text = {'Select data values (3-D or 4-D):';
                'X values (1-D or 3-D) (optional):';
                'Y values (1-D or 3-D) (optional):';
                'Z values (1-D or 3-D) (optional):';
                'Time values (1-D) (optional):'};
            % custom validation functions so user can only select
            % appropriately sized variables in popup dialog
            checkvars_data = @(in) (ndims(in)==4 || ndims(in)==3) && isa(in,'double');
            checkvars_dim = @(in) ((isvector(in) && ~isscalar(in)) || ndims(in)==3) && isa(in,'double');
            checkvars_time = @(in) (isvector(in) && ~isscalar(in)) && isa(in,'double');
            checkvars = {checkvars_data;checkvars_dim;checkvars_dim;checkvars_dim;checkvars_time};
            % get data
            [data,names] = uigetvariables(text,'ValidationFcn',checkvars,'Introduction',intro);
            % check if selected variables are valid, and load if yes
            ValidateData(app,data,names);
        end
        
        function ValidateData(app,data,names)
            % ValidateData checks if user selected inputs are valid, and if
            % so uses the valid ones. If any of them are invalid or not
            % selected by the user, it will warn and use defaults.
            valdata = isempty(data) || ~(ndims(data{1}) == 3 || ndims(data{1}) == 4)...
                || ~isa(data{1},'double');
            if valdata
                % if data to be visualized is not of right dimensions, set
                % it to empty
                data{1} = [];
            end
            if ~isempty(data{1})
                % if valid data to visualize was selected...
                app.Data = data{1}; % store data
                try
                    % This try statement checks if the X, Y, and Z data
                    % selected were all 3D matricies of proper size, or if
                    % all were left blank. If any were 3D matricies of
                    % improper size, it will issue a warning and use
                    % default axis values. If any were not 3D matricies it
                    % will error and move to the catch block.
                    validmatricies = ((size(data{2}) == size(app.Data(:,:,:,1)))...
                        & (size(data{3}) == size(app.Data(:,:,:,1)))...
                        & (size(data{4}) == size(app.Data(:,:,:,1))))...
                        | (isempty(data{2}) && isempty(data{3}) && isempty(data{4}));
                    if validmatricies
                        app.DimValues{1} = data{2};xlabel(app.SliceAxis,names{2});xlabel(app.ISOAxis,names{2});
                        app.DimValues{2} = data{3};ylabel(app.SliceAxis,names{3});ylabel(app.ISOAxis,names{3});
                        app.DimValues{3} = data{4};zlabel(app.SliceAxis,names{4});zlabel(app.ISOAxis,names{4});
                    else
                        warning('Invalid X, Y and/or Z data selected, using defaults');BeepOnWarn(app);
                        [app.DimValues{1},app.DimValues{2},app.DimValues{3}]=...
                            meshgrid(1:length(app.Data(1,:,1,1)),1:length(app.Data(:,1,1,1)),1:length(app.Data(1,1,:,1)));
                        xlabel(app.SliceAxis,'X');ylabel(app.SliceAxis,'Y');zlabel(app.SliceAxis,'Z');
                        xlabel(app.ISOAxis,'X');ylabel(app.ISOAxis,'Y');zlabel(app.ISOAxis,'Z');
                    end
                catch
                    % the catch block checks if the X, Y, and Z variables
                    % selected were all 1D vectors of proper sizes. If not,
                    % it will use default values. If the variables were not
                    % empty and invalid, it will issue a warning.
                    validvectors = (isvector(data{2}) && length(data{2})==length(app.Data(1,:,1,1)))...
                        && (isvector(data{3}) && length(data{3})==length(app.Data(:,1,1,1)))...
                        && (isvector(data{4}) && length(data{4})==length(app.Data(1,1,:,1)));
                    if validvectors
                        app.DimValues{1} = data{2};app.DimValues{2} = data{3};app.DimValues{3} = data{4};
                        xlabel(app.SliceAxis,names{2});ylabel(app.SliceAxis,names{3});zlabel(app.SliceAxis,names{4});
                        xlabel(app.ISOAxis,names{2});ylabel(app.ISOAxis,names{3});zlabel(app.ISOAxis,names{4});
                    else
                        if ~isempty(data{2}) || ~isempty(data{3}) || ~isempty(data{4})
                            warning('Invalid X, Y and/or Z data, using defaults');BeepOnWarn(app);
                        end
                        [app.DimValues{1},app.DimValues{2},app.DimValues{3}]=...
                            meshgrid(1:length(app.Data(1,:,1,1)),1:length(app.Data(:,1,1,1)),1:length(app.Data(1,1,:,1)));
                        xlabel(app.SliceAxis,'X');ylabel(app.SliceAxis,'Y');zlabel(app.SliceAxis,'Z');
                        xlabel(app.ISOAxis,'X');ylabel(app.ISOAxis,'Y');zlabel(app.ISOAxis,'Z');
                    end
                end
                % check if the selected time vector is of the right size
                validtime = isvector(data{5}) && length(data{5})==length(app.Data(1,1,1,:));
                if validtime
                    app.TimeValues = data{5};
                else
                    if ~isempty(data{5})
                        warning('Invalid time data, using defaults');BeepOnWarn(app);
                    end
                    app.TimeValues = [];
                end
                % take guess at ISO levels (this is before we expand 3D
                % only input data to 4D in LoadDataSetup, so we don't have
                % to worry about filtering out the added zeros)
                mind = min(app.Data(:));maxd = max(app.Data(:));
                diff = maxd-mind;
                set(app.ISOLevelText(1),'String',num2str(min(app.Data(:))+diff/3,15));
                set(app.ISOSlider(1),'Min',mind,'Max',maxd,'Value',min(app.Data(:))+diff/3);
                set(app.ISOLevelText(2),'String',num2str(min(app.Data(:))+2*diff/3,15));
                set(app.ISOSlider(2),'Min',mind,'Max',maxd,'Value',min(app.Data(:))+2*diff/3);
                % setup GUI with imported data
                LoadDataSetup(app);
            else % otherwise selected data was invalid, warn and do not setup app
                warning('Invalid or missing input data. Check size and data type.');BeepOnWarn(app);
            end
        end
        
        function LoadEllipsoidCB(app,~,~)
            % LoadEllipsoidCB is the callback for the Import Data ->
            % Example Data -> Oscillating Ellipsoid menu option. It creates
            % sample data for an ellipsoid whose semi-principal axes in the
            % X and Z directions vary with time according to
            % x^2/(5-4*cos(t)) + y^2 + z^2/(5+4*cos(t)).
            x = -10:1:10;t = 0:0.2:40;
            [xx,yy,zz] = meshgrid(x,x,x);
            data(length(x),length(x),length(x),length(t)) = 0;
            for ii=1:length(t)
                data(:,:,:,ii) = xx.^2/(5-4*cos(t(ii))) + yy.^2 + zz.^2/(5+4*cos(t(ii)));
            end
            app.Data = data;
            app.DimValues{1} = xx;
            app.DimValues{2} = yy;
            app.DimValues{3} = zz;
            app.TimeValues = t;
            set(app.ISOLevelText(1),'String','20');
            set(app.ISOSlider(1),'Min',min(app.Data(:)),'Max',max(app.Data(:)),'Value',20);
            set(app.ISOLevelText(2),'String','6');
            set(app.ISOSlider(2),'Min',min(app.Data(:)),'Max',max(app.Data(:)),'Value',6);
            LoadDataSetup(app);
        end
        
        function LoadFluidFlowCB(app,~,~)
            % LoadFluidFlowCB is the callback for the Import Data ->
            % Example Data -> Fluid Flow menu option. It uses a modified
            % version of MATLAB's built-in FLOW command to vary the flow
            % parameters A and nu over time.
            x = 0:0.5:10;y = -3:0.2:3;z = y;t = 0:0.1:10;
            [app.DimValues{1},app.DimValues{2},app.DimValues{3},app.Data] = flowmod(x,y,z,t);
            app.TimeValues = t;
            set(app.ISOLevelText(1),'String','4');
            set(app.ISOSlider(1),'Min',min(app.Data(:)),'Max',max(app.Data(:)),'Value',4);
            set(app.ISOLevelText(2),'String','5');
            set(app.ISOSlider(2),'Min',min(app.Data(:)),'Max',max(app.Data(:)),'Value',5);
            set(app.ISOAlphaText(2),'String','0.7');
            LoadDataSetup(app);
        end
        
        function LoadDataSetup(app)
            % LoadDataSetup is run after importing a new data set. It sets
            % up the limits and values for the various sliders and axes in
            % the app, and creates visualizations of the first sample.
            set([app.PlaySlider,app.GridComp{2,1},app.GridComp{1,2},...
                app.GridComp{3,2},app.ISOSlider,app.DelayText,...
                app.SampleNum,app.TimeNum,app.SliceValue,...
                app.ISOLevelText,app.ISOAlphaText,app.PlayButton,...
                app.DelayPlus,app.DelayMinus,app.OptionsMenu],'Enable','on');
            if ndims(app.Data) == 3 % if 3-D data (no animation dimension)
                app.Data(:,:,:,2) = 0; % add a 4th dimension so we can reuse same code (costs extra memory, planning to fix that in future)
                set([app.PlaySlider,app.DelayText,app.SampleNum,app.TimeNum,app.PlayButton,...
                    app.DelayPlus,app.DelayMinus],'Enable','off'); % turn off control panel if there is nothing to animate over
                set(app.OptionsMenu(10),'Checked','off','Enable','off'); % no animation, so disabling looping option
                set(app.OptionsMenu(11),'Checked','off','Enable','off'); % no animation, so disabling recording option
            end
            ylength = length(app.Data(:,1,1,1));
            xlength = length(app.Data(1,:,1,1));
            zlength = length(app.Data(1,1,:,1));
            tlength = length(app.Data(1,1,1,:));
            minx = min(app.DimValues{1}(:));maxx = max(app.DimValues{1}(:));
            miny = min(app.DimValues{2}(:));maxy = max(app.DimValues{2}(:));
            minz = min(app.DimValues{3}(:));maxz = max(app.DimValues{3}(:));
            mind = min(app.Data(:));maxd = max(app.Data(:));
            set(app.GridComp{3,2},'Min',minx,'Max',maxx,'Value',maxx,'SliderStep',[.1/(xlength-1) 1/(xlength-1)]);
            set(app.GridComp{1,2},'Min',miny,'Max',maxy,'Value',maxy,'SliderStep',[.1/(ylength-1) 1/(ylength-1)]);
            set(app.GridComp{2,1},'Min',minz,'Max',maxz,'Value',minz,'SliderStep',[.1/(zlength-1) 1/(zlength-1)]);
            set(app.ISOAxis,'CLim',[mind maxd],'XLim',[minx maxx],'YLim',[miny maxy],'ZLim',[minz maxz]);
            set(app.SliceAxis,'CLim',[mind maxd],'XLim',[minx maxx],'YLim',...
                [miny maxy],'ZLim',[minz maxz]);
            app.CurrentSample = 1;
            set(app.PlaySlider,'Min',1,'Max',tlength,'Value',app.CurrentSample,'SliderStep',[1/(tlength-1) 10/(tlength-1)]);
            set(app.SampleNum,'String',num2str(app.CurrentSample,15));
            if isempty(app.TimeValues)
                % if valid time variable WAS NOT selected
                set(app.TimeNum,'Style','text'); % remove ability to edit time value
                app.CurrentTime = 0;
            else % if valid time variable WAS selected
                app.CurrentTime = app.TimeValues(app.CurrentSample);
                set(app.TimeNum,'Style','edit','String',num2str(app.CurrentTime,15)); % set current time and make it editable
            end
            % create Slice and Isosurface visualizations
            if ishandle(app.SliceHandle)
                % if slices exist, clear them for recreation in
                % RedrawSlice, otherwise their sizes won't be right
                delete(app.SliceHandle);
                app.SliceHandle = [];
            end
            RedrawSlice(app);
            RedrawISO(app);
            view(app.SliceAxis,-30,50); % set viewing angle
            set(app.OptionsMenu(2),'Enable','on'); % enable save/load configurations
            set(app.OptionsMenu(9),'Enable','on');
            curdir = which('LoadDataSetup');
            load([curdir(1:end-15) filesep 'DE_default.mat']);
            setSettings(app,conf); % set default settings
        end
        
        function BeepOnWarn(app)
            % BeepCB is used to determine whether an audible beep is issued
            % when a warning occurs.
            if strcmp(get(app.OptionsMenu(16),'Checked'),'on');
                beep; 
            end
        end
        % control panel functions
        function DelayPlusCB(app,~,~)
            % DelayPlusCB is the callback for the + push button in the
            % Delay panel. It adds 0.1 to the delay value.
            app.Delay = app.Delay + 0.1;
            set(app.DelayText,'String',num2str(app.Delay,15));
        end
        
        function DelayTextCB(app,~,~)
            % DelayTextCB is the callback for the edit box in the Delay
            % panel. It displays the current delay time. If manually set to
            % a value less than zero, it will warn and reset the delay
            % value to the previous value.
            Delaynum = str2double(get(app.DelayText,'String'));
            if Delaynum >= 0
                app.Delay = Delaynum;
            else
                set(app.DelayText,'String',num2str(app.Delay,15));
                warning('Delay time must be positive');BeepOnWarn(app);
            end
        end
        
        function DelayMinusCB(app,~,~)
            % DelayMinusCB is the callback for the - button in the Delay
            % panel. It will decrease the delay value by 0.1, unless it
            % would decrease it to less than 0.01 in which case it rounds
            % the delay value to zero.
            if (app.Delay - 0.1) < 0.01
                app.Delay = round(app.Delay);
                set(app.DelayText,'String',num2str(app.Delay,15));
            else
                app.Delay = app.Delay - 0.1;
                set(app.DelayText,'String',num2str(app.Delay,15));
            end
        end
        
        function SampleNumCB(app,~,~)
            % SampleNumCB is the callback for the top edit box in the
            % Display panel. It allows the user to enter a sample number to
            % visualize, and is updated during animation. It must be an
            % integer in the range of samples taken. If it is outside the
            % range, it will be reset to the original value. If it is a
            % non-integer in range, it will be rounded to the nearest
            % integer.
            StNum = str2double(get(app.SampleNum,'String'));
            if (round(StNum)-StNum) ~= 0
                warning('Starting sample must be an integer value...entry rounded');BeepOnWarn(app);
            end
            if StNum >= get(app.PlaySlider,'Min') && StNum <= get(app.PlaySlider,'Max')
                app.CurrentSample = round(StNum);
                set(app.SampleNum,'String',app.CurrentSample);
                set(app.PlaySlider,'Value',app.CurrentSample);
                if ~isempty(app.TimeValues)
                    dispt = app.TimeValues;
                    set(app.TimeNum,'String',num2str(dispt(app.CurrentSample),15));
                end
                RedrawSlice(app);
                RedrawISO(app);
            else
                warning('Starting Sample must be within number of samples');BeepOnWarn(app);
                set(app.SampleNum,'String',num2str(app.CurrentSample,15));
            end
        end
        
        function TimeNumCB(app,~,~)
            % TimeNumCB is the callback for the bottom edit box in the
            % Display panel. If no valid time variable was selected when
            % importing data, it is disabled. Otherwise it allows the user
            % to select the time sample to display, and is updated during
            % animation. If the entered time value is not one that was
            % sampled at, then it will warn and round to the nearest one.
            CT = str2double(get(app.TimeNum,'String'));
            dispt = app.TimeValues;
            if ~ismember(CT,dispt)
                warning('Must be a time value sampled at, setting to nearest valid value');BeepOnWarn(app);
                [minl,lowt] = min(abs(dispt-CT));
                [minh,hight] = min(abs(dispt+CT));
                if minl < minh
                    app.CurrentSample = lowt;
                    app.CurrentTime = dispt(lowt);
                else
                    app.CurrentSample = hight;
                    app.CurrentTime = dispt(hight);
                end
            else
                app.CurrentTime = CT;
                app.CurrentSample = find(dispt == app.CurrentTime);
            end
            set(app.TimeNum,'String',num2str(app.CurrentTime,15));
            set(app.SampleNum,'String',num2str(app.CurrentSample,15));
            set(app.PlaySlider,'Value',app.CurrentSample);
            RedrawSlice(app);
            RedrawISO(app);
        end
        
        function PlaySliderCB(app,~,~)
            % PlaySliderCB is the callback for the Play Slider in the
            % Controls panel. It is disabled during animation. Outside of
            % animation it allows the user to scroll through visualizations
            % of time samples.
            app.CurrentSample = round(get(app.PlaySlider,'Value'));
            set(app.SampleNum,'String',num2str(app.CurrentSample,15));
            if ~isempty(app.TimeValues)
                dispt = app.TimeValues;
                set(app.TimeNum,'String',num2str(dispt(app.CurrentSample),15));
            end
            RedrawSlice(app);
            RedrawISO(app);
        end
        
        function PlayButtonCB(app,~,~)
            % PlayButtonCB is the callback for the PLAY toggle button in
            % the Controls panel. When it displays PLAY, clicking on it
            % will begin animation at the current sample, and change it to
            % a STOP button. When the STOP button is clicked, it halts the
            % animation and changes back to PLAY. While animation is in
            % progress, the Display panel and Play Slider are disabled.
            if get(app.PlayButton,'Value') == 1
                if app.RecordOption == 1
                    app.WriteObject = VideoWriter(app.RecordFileName);
                    app.WriteObject.FrameRate = app.RecordFrameRate;
                    open(app.WriteObject);
                end
                % only run if button was in PLAY state when clicked
                set(app.PlayButton,'String','STOP');
                % disable certain controls during animation
                set(app.SampleNum,'Enable','off');
                set(app.PlaySlider,'Enable','off');
                set(app.TimeNum,'Enable','off');
                set(app.ImportMenu(1),'Enable','off');
                % reset to beginning if starting animation from the last
                % sample
                if app.CurrentSample == length(app.Data(1,1,1,:))
                    app.CurrentSample = 1;
                end
                % begin animation
                t = app.CurrentSample;
                % while the play button is clicked and the time is less
                % than or equal to the max time, keep running
                while t <= length(app.Data(1,1,1,:)) && get(app.PlayButton,'Value') == 1
                    app.CurrentSample = t;
                    set(app.SampleNum,'String',num2str(app.CurrentSample,15));
                    set(app.PlaySlider,'Value',app.CurrentSample);
                    if ~isempty(app.TimeValues)
                        set(app.TimeNum,'String',num2str(app.TimeValues(app.CurrentSample),15));
                    end
                    % update visualziations
                    RedrawSlice(app);
                    RedrawISO(app);
                    drawnow; % pause execution until rendering is done
                    if app.RecordOption == 1
                        % if recording, capture the figure and write to the
                        % file
                        im = screencapture(app.Figure);
                        writeVideo(app.WriteObject,im);
                    end
                    pause(app.Delay); % introduce additional pause based on Animation Delay panel
                    % if it is the last sample and loop animation option is
                    % on, reset to beginning
                    if t == length(app.Data(1,1,1,:)) && strcmp(get(app.OptionsMenu(10),'Checked'),'on')
                        t = 1;
                    else
                        t = t + 1;
                    end
                end
                if app.RecordOption == 1 % close file connection when animation stops
                    close(app.WriteObject);
                end
                % reenable controls after animation is complete
                set(app.SampleNum,'Enable','on');
                set(app.PlaySlider,'Enable','on');
                if ~isempty(app.TimeValues)
                    % only enable if valid time values exist
                    set(app.TimeNum,'Enable','on');
                end
                set(app.ImportMenu(1),'Enable','on'); % import new data
                set(app.PlayButton,'Value',0,'String','PLAY');
            end
        end
        % slice panel functions
        function RedrawSlice(app,~,~)
            % RedrawSlice is the callback for the Slice panel sliders and
            % also creates the slice visualization. It uses a modified
            % version of MATLAB's built-in SLICE command, with lines 40,
            % 131-133 and 137 commented out to make animation easier.
            SliceLoc(1) = get(app.GridComp{3,2},'Value');
            set(app.SliceValue(1),'String',num2str(SliceLoc(1),15));
            SliceLoc(2) = get(app.GridComp{1,2},'Value');
            set(app.SliceValue(2),'String',num2str(SliceLoc(2),15));
            SliceLoc(3) = get(app.GridComp{2,1},'Value');
            set(app.SliceValue(3),'String',num2str(SliceLoc(3),15));
            if isempty(app.SliceHandle) % if slices don't exist, intialize them
                app.SliceHandle = slicemod(app.SliceAxis,app.DimValues{1},app.DimValues{2},app.DimValues{3},app.Data(:,:,:,app.CurrentSample),SliceLoc(1),SliceLoc(2),SliceLoc(3));
                set(app.SliceHandle,'FaceColor','interp','EdgeAlpha',0.2);
                xl = get(app.SliceAxis,'XLabel');yl = get(app.SliceAxis,'YLabel');zl = get(app.SliceAxis,'ZLabel');
                set(app.SliceHandle,'UserData',{get(xl,'String');get(yl,'String');get(zl,'String')});
            else % otherwise, update underlying data rather than recreate them
                UpdateSlice(app,SliceLoc(1),SliceLoc(2),SliceLoc(3));
            end
        end
        
        function UpdateSlice(app,xh,yh,zh)
            % UpdateSlice updates the slices without recreating them. This
            % avoids creating and deleting graphics objects unnecessarily.
            % It uses the same method for computing the color of slices as
            % the built-in |slice| command.
            % x-slice
            if ~isempty(xh)
                xs = size(get(app.SliceHandle(1),'XData'));
                xd = xh*ones(xs(1),xs(2)); % new x values for x-slice
                yd = get(app.SliceHandle(1),'YData'); % keep y values for x-slice
                zd = get(app.SliceHandle(1),'ZData'); % keep z values for x-slice
                % new color data for x-slice, found using interp3 which is
                % used under the hood of the slice command
                vi = interp3(app.DimValues{1},app.DimValues{2},app.DimValues{3},app.Data(:,:,:,app.CurrentSample),xd,yd,zd);
                set(app.SliceHandle(1),'XData',xd,'CData',vi);
            end
            % y-slice
            if ~isempty(yh)
                xd = get(app.SliceHandle(2),'XData');
                ys = size(get(app.SliceHandle(2),'XData'));
                yd = yh*ones(ys(1),ys(2));
                zd = get(app.SliceHandle(2),'ZData');
                vi = interp3(app.DimValues{1},app.DimValues{2},app.DimValues{3},app.Data(:,:,:,app.CurrentSample),xd,yd,zd);
                set(app.SliceHandle(2),'YData',yd,'CData',vi);
            end
            % z-slice
            if ~isempty(zh)
                xd = get(app.SliceHandle(3),'XData');
                yd = get(app.SliceHandle(3),'YData');
                zs = size(get(app.SliceHandle(3),'ZData'));
                zd = zh*ones(zs(1),zs(2));
                vi = interp3(app.DimValues{1},app.DimValues{2},app.DimValues{3},app.Data(:,:,:,app.CurrentSample),xd,yd,zd);
                set(app.SliceHandle(3),'ZData',zd,'CData',vi);
            end
        end
        
        function SliceValueCB(app,~,~)
            % SliceValueCB is the callback for the edit boxes in the Slice
            % panel. It checks if the entered values are within the axes
            % ranges. If they are, it will update the values of the Slice
            % panel sliders and execute RedrawSlice. If not, it will warn
            % and return to the previous values.
            SV(3) = str2double(get(app.SliceValue(3),'String'));
            SV(2) = str2double(get(app.SliceValue(2),'String'));
            SV(1) = str2double(get(app.SliceValue(1),'String'));
            validrange = SV(3) >= get(app.GridComp{2,1},'Min') && SV(3) <= get(app.GridComp{2,1},'Max')...
                && SV(2) >= get(app.GridComp{1,2},'Min') && SV(2) <= get(app.GridComp{1,2},'Max')...
                && SV(1) >= get(app.GridComp{3,2},'Min') && SV(1) <= get(app.GridComp{3,2},'Max');
            if validrange
                set(app.GridComp{2,1},'Value',SV(3));
                set(app.GridComp{1,2},'Value',SV(2));
                set(app.GridComp{3,2},'Value',SV(1));
                RedrawSlice(app);
            else
                warning('Slice value must be within range of data');BeepOnWarn(app);
                set(app.SliceValue(3),'String',num2str(get(app.GridComp{2,1},'Value'),15));
                set(app.SliceValue(2),'String',num2str(get(app.GridComp{1,2},'Value'),15));
                set(app.SliceValue(1),'String',num2str(get(app.GridComp{3,2},'Value'),15));
            end
        end
        % ISO panel functions
        function ISOSliderCB(app,~,~)
            SliceLoc(1) = get(app.ISOSlider(1),'Value');
            set(app.ISOLevelText(1),'String',num2str(SliceLoc(1),15));
            SliceLoc(2) = get(app.ISOSlider(2),'Value');
            set(app.ISOLevelText(2),'String',num2str(SliceLoc(2),15));
            RedrawISO(app);
        end
        
        function RedrawISO(app,~,~)
            % RedrawISO is the callback for the ISOSurface panel edit boxes
            % and creates the isosurface visualization. If the alpha values
            % are positive, it will create the surface. If one of them is
            % set to a negative value, it will warn and not render the
            % surface.
            ISOData(1) = str2double(get(app.ISOLevelText(1),'String'));
            ISOData(2) = str2double(get(app.ISOAlphaText(1),'String'));
            ISOData(3) = str2double(get(app.ISOLevelText(2),'String'));
            ISOData(4) = str2double(get(app.ISOAlphaText(2),'String'));
            if ISOData(1) >= min(app.Data(:)) && ISOData(1) <= max(app.Data(:)) % if iso level is in right range
                if ISOData(2) > 0 && ISOData(2) <= 1 % if alpha in right range
                    surf1data = isosurface(app.DimValues{1},app.DimValues{2},app.DimValues{3},app.Data(:,:,:,app.CurrentSample),ISOData(1));
                    if strcmp(get(app.OptionsMenu(17),'Checked'),'on')
                        cm=get(app.Figure,'Colormap');cl=get(app.SliceAxis,'CLim');
                        pos=(ISOData(1)-cl(1))/(cl(2)-cl(1))*length(cm);
                        newcolor=interp1(linspace(0,length(cm),length(cm)),cm,pos);
                    else
                        newcolor = [0 1 0];
                    end
                    if isempty(app.PatchHandle) || ~ishandle(app.PatchHandle(1));% if second patch doesn't exist, create it
                        app.PatchHandle(1) = patch(surf1data,'FaceColor',newcolor,'EdgeColor','none','FaceAlpha',ISOData(2),'Parent',app.ISOAxis);
                        xl = get(app.ISOAxis,'XLabel');yl = get(app.ISOAxis,'YLabel');zl = get(app.ISOAxis,'ZLabel');
                        set(app.PatchHandle(1),'UserData',{get(xl,'String');get(yl,'String');get(zl,'String')},'Tag','FirstISO');
                    else % otherwise don't create new patch, just update underlying data
                        set(app.PatchHandle(1), 'Faces', surf1data.faces, 'Vertices', surf1data.vertices,'FaceAlpha',ISOData(2),'FaceColor',newcolor);
                    end
                elseif (ISOData(2) <= 0 || ISOData(2) > 1 ) && ishandle(app.PatchHandle(1))
                    % if the alpha is invalid AND the patch is currently
                    % rendered, delete the patch rather than setting it's
                    % Visible property to 'off' so animation speeds up
                    delete(app.PatchHandle(1));
                    warning('ISO Alpha must be between zero and one');BeepOnWarn(app);
                end
            else % if iso level is outside correct range
                warning('ISO Level must be between the min and max values of the imported data');BeepOnWarn(app);
                set(app.ISOLevelText(1),'String',num2str(get(app.ISOSlider(1),'Value'),15));
            end
            if ISOData(3) >= min(app.Data(:)) && ISOData(3) <= max(app.Data(:)) % if iso level is in right range
                if ISOData(4) > 0 && ISOData(4) <= 1
                    surf2data = isosurface(app.DimValues{1},app.DimValues{2},app.DimValues{3},app.Data(:,:,:,app.CurrentSample),ISOData(3));
                    if strcmp(get(app.OptionsMenu(17),'Checked'),'on')
                        cm=get(app.Figure,'Colormap');cl=get(app.SliceAxis,'CLim');
                        pos=(ISOData(3)-cl(1))/(cl(2)-cl(1))*length(cm);
                        newcolor=interp1(linspace(0,length(cm),length(cm)),cm,pos);
                    else
                        newcolor = [0 0 1];
                    end
                    if length(app.PatchHandle) == 1 || ~ishandle(app.PatchHandle(2))% if second patch doesn't exist, create it
                        app.PatchHandle(2) = patch(surf2data,'FaceColor',newcolor,'EdgeColor','none','FaceAlpha',ISOData(4),'Parent',app.ISOAxis);
                        xl = get(app.ISOAxis,'XLabel');yl = get(app.ISOAxis,'YLabel');zl = get(app.ISOAxis,'ZLabel');
                        set(app.PatchHandle(2),'UserData',{get(xl,'String');get(yl,'String');get(zl,'String')},'Tag','SecondISO');
                    else % otherwise update the underlying data
                        set(app.PatchHandle(2), 'Faces', surf2data.faces, 'Vertices', surf2data.vertices,'FaceAlpha',ISOData(4),'FaceColor',newcolor);
                    end
                elseif (ISOData(4) <= 0 || ISOData(4) > 1 ) && ishandle(app.PatchHandle(2))
                    delete(app.PatchHandle(2));
                    warning('ISO Alpha must be between zero and one');BeepOnWarn(app);
                end
            else % if iso level is outside correct range
                warning('ISO Level must be between the min and max values of the imported data');BeepOnWarn(app);
                set(app.ISOLevelText(2),'String',num2str(get(app.ISOSlider(1),'Value'),15));
            end
        end
    end
    
    methods(Static)
        function output_txt = DataTipCB(~,event_obj)
            % output_txt = DataTipCB(obj,event_obj)
            % Custom data tip callback function
            % obj          Currently not used (empty)
            % event_obj    Handle to event object (i.e. slice)
            % output_txt   Data cursor text string (string or cell array of strings).
            pos = get(event_obj,'Position');
            tg = get(event_obj,'Target');
            idx = get(event_obj,'dataindex');
            names = get(tg,'UserData');
            SliceColor = get(tg,'CData'); % doesn't exist for patch
            output_txt = {[names{1},': ',num2str(pos(1),4)],...
                [names{2},': ',num2str(pos(2),4)],...
                [names{3},': ',num2str(pos(3),4)]};
            if ~isempty(SliceColor) % if it's not the patch
                output_txt{end+1} = ['Value: ',num2str(SliceColor(idx),4)];
            end
        end
    end
    
end