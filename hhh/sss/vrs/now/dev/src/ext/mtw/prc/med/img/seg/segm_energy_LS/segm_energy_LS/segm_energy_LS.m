function segm_energy_LS(figNo)
% GUI for studying energy-based (or "area-based") segmentation
% using level sets. For more info type 
% >> h = segm_energyLS;
% then click on Help.
%
% by Tudor Dima, tudima at zahoo dot com
% 18.02.2013    - rev. 1.0.1

% interface > segmentation parameter input, commands
   
if nargin < 1, figNo = 1; end;

h.Handle = figure(figNo);
set(h.Handle, 'menubar', 'none', 'NumberTitle', 'off', 'position', [250 250 760 380]); 

% initialize the user data (various options)
% ----------------------------------
myData = uConstruct('collection'); % nested call

% --- generate uimenus ---
% ------------------------
% - loads - data file x2
h.UIMenu.Load = uimenu(h.Handle, 'label', 'Load');
h.UIMenu.LoadImage = uimenu(h.UIMenu.Load, 'label', 'image file -> Data',...
    'callback', {@fLoadData, h.Handle, 'image'});
h.UIMenu.LoadData = uimenu(h.UIMenu.Load, 'label', '.mat file -> Data',...
    'callback', {@fLoadData, h.Handle, 'matlab'});
% - state, filex2
h.UIMenu.FnLoad = uimenu(h.UIMenu.Load, 'label', '.mat file ->  LS (Fn) ',...
    'callback', {@fLoadFile, h.Handle}, 'separator', 'on');
h.UIMenu.LoadMsk = uimenu(h.UIMenu.Load, 'label', '.mat file -> Mask',...
    'callback', {@fLoadFile, h.Handle, 'mask'});

% - workspace x3
h.UIMenu.LoadVar = uimenu(h.UIMenu.Load, 'label', 'workspace -> Data ',...
    'callback', {@fLoadVar, h.Handle, 'data'});
h.UIMenu.LoadVar = uimenu(h.UIMenu.Load, 'label', 'workspace -> LS (Fn)',...
    'callback', {@fLoadVar, h.Handle, 'fn'});
h.UIMenu.LoadVar = uimenu(h.UIMenu.Load, 'label', 'workspace -> Mask',...
    'callback', {@fLoadVar, h.Handle, 'mask'});


%h.UIMenu.LoadBoth = uimenu(h.UIMenu.Load, 'label', '.mat file >> Fn + Mask',...
%    'callback', {@fLoadFile, h.Handle, 'both'});
% reinit membrane
h.UIMenu.MembraneIni = uimenu(h.UIMenu.Load, 'label', '(Re)Init Membrane',...
    'callback', {@iniMembrane, h.Handle}, 'separator', 'on');

% - saves -
h.UIMenu.Save = uimenu(h.Handle, 'label', 'Save');
h.UIMenu.FnSave = uimenu(h.UIMenu.Save, 'label', 'Level-Set (Fn)  -> File',...
    'callback', {@fSave2File, h.Handle});
h.UIMenu.SaveMsk = uimenu(h.UIMenu.Save, 'label', 'Segmentation Mask -> File',...
    'callback', {@fSave2File, h.Handle, 'sphi'});
%h.UIMenu.SaveBoth = uimenu(h.UIMenu.Save, 'label', 'Fn + Mask >> File',...
%    'callback', {@fSave2File, h.Handle, 'both'});
h.UIMenu.PrefIni = uimenu(h.UIMenu.Save, 'label', 'prefs (later)',...
    'callback', '', 'separator', 'on', 'enable', 'off');


h.UIMenu.ShowData = uimenu(h.Handle, 'label', 'Show', ...
    'callback', {@ShowData_W, h.Handle});

% --- View MENU, debug ---
pref_figNoView = [501 (701:706)];
h.UIMenu.View = uimenu(h.Handle, 'label', 'View');
h.UIMenu.VErr = uimenu(h.UIMenu.View, 'label', 'View Error', ...
    'callback', {@ShowError_W, h.Handle, pref_figNoView(1)});
h.UIMenu.VFn = uimenu(h.UIMenu.View, 'label', 'View Fn', ...
    'callback', {@vFn, h.Handle, pref_figNoView(2)}, 'separator', 'on');
h.UIMenu.VGrad = uimenu(h.UIMenu.View, 'label', 'View grad(Fn)', ...
    'callback', {@vGrad, h.Handle, pref_figNoView(3)});
h.UIMenu.VHvi = uimenu(h.UIMenu.View, 'label', 'View H(Fn)', ...
    'callback', {@vHviItsGrad, h.Handle, pref_figNoView(4)});
h.UIMenu.VResidual = uimenu(h.UIMenu.View, 'label', 'View Residue', ...
    'callback', {@vResidual, h.Handle, pref_figNoView(5)});

h.UIMenu.VData = uimenu(h.UIMenu.View, 'label', 'Inspect Data', ...
    'callback', {@vInspectData, h.Handle, pref_figNoView(6)});
h.UIMenu.ReportOut = uimenu(h.UIMenu.View, 'label', 'Report', ...
    'callback', {@vReportOut, h.Handle, pref_figNoView(7)});

% --- HELP menu ---
h.UIMenu.H = uimenu(h.Handle, 'label', 'Help');
cb =  ['msgbox({''            energy-based level-set segmentation'', ', ...
    '''                 v. 1.0.1, 18.02.2013'', ', ...
    ''''', ''click on more specific options in the ''''Help'''' menu '', ', ...
    '''and get contents printed in the command window'', '''', ', ....
    '''            contact: tudima@yahoo.com''}, ''segm_energy_LS'', ''help'', ''replace'');'];
h.UIMenu.H0 = uimenu(h.UIMenu.H, 'label', 'About',...
    'callback', cb ); % ['helpdlg(''' , si, ''',''' so, ''')']
si = 'more on; type help/read_me'; so = '.txt; more off';
h.UIMenu.Hi = uimenu(h.UIMenu.H, 'label', 'Intro', 'separator', 'on',...
    'callback', [si '_intro' so]);
h.UIMenu.Hs = uimenu(h.UIMenu.H, 'label', 'Get Started', ...
    'callback', [si '_getstarted' so]);
h.UIMenu.Hi = uimenu(h.UIMenu.H, 'label', 'Menus',...
    'callback', [si '_menus' so]);
h.UIMenu.Hs = uimenu(h.UIMenu.H, 'label', 'Buttons/Options', ...
    'callback', [si '_options' so]);
h.UIMenu.Hs = uimenu(h.UIMenu.H, 'label', 'Workflow', ...
    'callback', [si '_howto' so]);
clear si so

% --- exit menu
h.UIMenu.Exit = uimenu(h.Handle, 'label', 'Exit');
h.UIMenu.ExitIndeed = uimenu(h.UIMenu.Exit, 'label', 'Really Exit ?', ...
    'callback', 'eval(''close(gcf) '')');

% --- generate the panels ---
% ---------------------------
% -> draw a panel grid, 4 X-lines, 4 Y-lines :   
PereferedPanelGrid = {...
    [1 19 21 39]/40, ...
    [1 19 21 39]/40};
Corners = { ...
    {[1 3], [2 4]}, {[1 1], [2 2]}, ...
    {[3 1], [4 2]}, {[3 3], [4 4]}};

Names = { 'parameters', 'scale', 'iterations', 'options' }; 
Tags = { 'par', 'res', 'it', 'opt'}; % used to ID the panels
% -> draw the panels
for i=1:size(Tags,2)
    thisPosition = uiCorners2Position(PereferedPanelGrid, Corners{i}{1}, Corners{i}{2});
    uiDrawPanel(h.Handle, thisPosition, Tags{i}, Names{i}, myData.(Tags{i}));
end

% init handle collection, append the userdata to it
% ----------------------------------------------------
myHandles = guihandles(h.Handle);
myHandles.myData = myData; % myData initialized before panel init.
clear myData
guidata(h.Handle, myHandles)
end

function uiXferIn2Struct(src, evtd, ForceChar)
% capture double or char from form, update input structures accordingly
if nargin < 3, ForceChar = 0; end

InterceptedButton = get(gcbo, 'style');
switch InterceptedButton
    case 'popupmenu'
        InterceptedValue = get(gcbo, 'value');
        AllStrings = get(gcbo, 'string');
        InterceptedValue = AllStrings{InterceptedValue};
    case 'edit'
        % - button detection (field)
        InterceptedValue = get(gcbo, 'string');
        if ~ForceChar % normal behaviour, allow 2-long vector (Lp)
            InterceptedValue = str2num(InterceptedValue);
        end        
    case 'radiobutton'
        InterceptedValue = logical(get(gcbo, 'value'));
end

InterceptedName = get(gcbo, 'tag');
% - panel detection
hPanel = get(gcbo, 'parent');
hFig = get(hPanel, 'parent');
PanelDataName = get(hPanel, 'tag');
% - update the panel.field data HERE
attData = guidata(hFig);
attData.myData.(PanelDataName).(InterceptedName) = InterceptedValue;
% - export it
guidata(hFig, attData)
end

function uiDrawPanel(hParent, thisPosition, PanelTag, PanelName, thisStruct)
% draw one panel at a time, really just a big switch (unclutter the top)

if nargin < 5
    error('segm2D > uiDrawPanel > insuff. input args'); 
end

% draw the panel spanning thisPosition
hPanel = uipanel('parent', hParent,...
    'title', PanelName, 'tag', PanelTag , ...
    'units', 'normalized', 'position', thisPosition );

switch PanelTag
    case {'par', 'segmentation'}    % --------------------------------
        % pick a grid
        PreferedButtonGrid = {[0.01 2 7 12 14 19 ]/20, [3 6 9 12 15 18]/20};
        % place buttons on this grid
        Corners = {...
            {[1 5], [2 6]}, {[2 5], [3 6]},  ... % Miu x2
            {[4 5], [5 6]}, {[5 5], [6 6]}, ... % Nu x 2
            {[1 3], [2 4]}, {[2 3], [3 4]},  ... % 2nd row, Lambda+(P) x2            
            {[4 3], [5 4]}, {[5 3], [6 4]}, ... % dT x2? </end row>            
            {[1 1], [2 2]}, {[2 1], [3 2]}, ... % 3rd row, Lambda-(M) x2                        
            {[4 1], [5 2]}, {[5 1], [6 2]}, ... % epsilon, placeholder
            };       

        Strings = {'Mu', num2str(thisStruct.Miu), 'Nu', num2str(thisStruct.Niu), ...
            'L+', num2str(thisStruct.Lp),  ...% 2ndrow
            'dt', num2str(thisStruct.dt),... 
            'L-', num2str(thisStruct.Lm), ...% 3rd row
            'eps', num2str(thisStruct.eps)};         
        Styles = {'text', 'edit', 'text', 'edit', ... Mu, Nu, dt
            'text', 'edit', 'text', 'edit', ... Lp, dt
            'text', 'edit', 'text', 'edit'};% Lm, eps
        
        Tags = {'txt', 'Miu', 'txt', 'Niu'... % Mu, Nu
            'txt', 'Lp', 'txt', 'dt', ...% Lp, dt
            'txt', 'Lm', 'txt', 'eps'}; % Lm, eps
        Callbacks = {...
            '', {@uiXferIn2Struct}, '', {@uiXferIn2Struct}, ... 1st x 3
            '', {@uiXferIn2Struct}, '', {@uiXferIn2Struct}, ... 2nd x 3
            '', {@uiXferIn2Struct}, '', {@uiXferIn2Struct} }; % 3rd x2
        Enable = {...
            '', 'on', '', 'on', ... Mu, Nu, dt
            '', 'on', '', 'on', ... Lp, dt
            '', 'on', '', 'on'}; % Lm,  eps
        
    case {'opt', 'options'}
        % -----------------------------------------------------------------
        % pick a grid
        PreferedButtonGrid = {[0.05 5 8 11  11.5 12 16 19.95]/20, ...
            [1 4 5 8   11 14  15 16  19 19.9 ]/20}; % 19.9 only for pulldown
        % place buttons on this grid
        Corners = {...
            {[1 8], [2 9]}, {[2 8], [4 10]}, {[4 8], [7 9]}, {[7 8], [8 9]},... % membr.ini X2, noCircles x2
            {[1 5], [2 6]}, {[2 5], [4 6]}, {[4 5], [7 6]}, {[7 5], [8 6]}, ... % DistMethod.x2, Reg x2
            {[1 3], [2 4]}, {[2 3], [4 4]}, {[4 3], [7 4]}, {[7 3], [8 4]}, ... % opDown x2, doMovie X2
            };
        
        Strings = {'Ini.Method', {'circles', 'draw'}, ...
            '#Circles', num2str(thisStruct.nCircles),... % 1:4 membr.ini x2, #C x 2
            'Dist.Fcn', { 'bwdist', 'built in'} ...% 5:6 DistThreshold x2
            'Reg.Style', {'atan', 'sine'},...   % 7:8 Regularization x2
            'Dec/Interp', {'vertex-full', 'cell-full'}, ... 9:10 opDwn method x2            
            'test', ''};
        
        Values = false(size(Corners));
        % popup values... 1 !
        Values([2 6 8 10 ]) = 1;

        Styles = {'text', 'popupmenu', 'text', 'edit',  ... % membr.ini x2, nCircles x2
            'text', 'popupmenu', 'text', 'popupmenu', ...      % DistMethod, RegStyle x4
            'text', 'popupmenu', 'text', 'radiobutton', ... % opDwn method x2, DoMovie x2
            };
        Tags = {'txt', 'MembrIniMethod', 'txt', 'nCircles',...
            'txt', 'DistMethod', 'txt', 'RegStyle'...
            'txt', 'DwnMethod', 'txt', 'DoMovie'}; %                
        
        Callbacks = {...
            '', {@uiXferIn2Struct}, '', {@uiXferIn2Struct}, ...
            '', {@uiXferIn2Struct}, '', {@uiXferIn2Struct}, ...
            '', {@uiXferIn2Struct}, '', {@uiXferIn2Struct}  };        

    case {'res', 'resolution'}
        % -----------------------------------------------------------------
        % pick a grid
        PreferedButtonGrid = {[0.5 6 7 13 14 19.5 ]/20, [1 4 6 12 14 17]/20};
        % place buttons on this grid

        Corners = {...
            {[1 5], [2 6]}, {[3 5], [4 6]}, {[5 5], [6 6]}, ... % kMax  x2
            {[1 3], [2 4]}, {[3 3], [4 4]}, {[5 3], [6 4]}, ... % opUp/ GO! / opDown PushB
            {[1 1], [6 2]}  }; ... % report (curr. resol, MG...)

        Strings = {'reset', 'depth', num2str(thisStruct.kMax), ...
            '<< Go Down', 'DO Iter!', 'Go Up >>',... %
            'scale info(k = 3), resolution nRows x nCols ...)'};  % report

        Styles = {'pushbutton', 'text', 'edit', 'pushbutton', 'pushbutton', 'pushbutton',...
            'text'};
        Tags = {'reset', 'txt', 'kMax', 'opDwn', 'opNext', 'opUp', 'reportOut'};
        Callbacks = {{@opDist}, '', {@uiRefreshData}, ... % was @uiXferIn2Struct
            {@opChangeResolution_W, 0}, {@opNextStep_W}, {@opChangeResolution_W, 1},''};

    case {'it', 'iteration'}
        % pick a grid
        PreferedButtonGrid = {[0.1 5 9 14 19 ]/20, [3 6 9 12 15 18]/20};
        % place buttons on this grid
        Corners = {...
            {[1 5], [2 6]}, {[2 5], [3 6]}, ... % Steps x2
            {[3 5], [4 6]}, {[4 5], [5 6]}, ... % It x2
            {[1 1], [2 2]}, {[2 1], [5 2]}, ... % method > E-O, G-S
            };
        Strings = {'steps', num2str(thisStruct.nSteps), 'it/step', ...
            num2str(thisStruct.nItPerStep),... % end of 1st row
            'method', {'Jacobi' }};  % 3rd row
        Styles = {'text', 'edit', 'text', 'edit', ...
            'text', 'popupmenu'};
        Tags = {'txt', 'nSteps', 'txt', 'nItPerStep',...
            'txt', 'Method'};
        Callbacks = {...
            '', {@uiXferIn2Struct}, '', {@uiXferIn2Struct}, ...
            '', {@uiXferIn2Struct} };
end

% -----------------------------
% actual button initialization
% -----------------------------

nButtons = size(Styles,2);
hButton = zeros(1, nButtons);
for i = 1:nButtons
    if ~exist('Enable', 'var')
        thisEnable = 'on';
    elseif isempty(Enable{i})
        thisEnable = 'on';
    else
        thisEnable = Enable{i};
    end
    thisPosition = uiCorners2Position(PreferedButtonGrid, ...
        Corners{i}{1}, Corners{i}{2});
    hButton(i) = uicontrol('parent', hPanel, ...
        'Style', Styles{i}, 'String', Strings{i}, ...
        'Tag', Tags{i}, 'callback', Callbacks{i}, 'Enable', thisEnable,...
        'units', 'normalized', 'position', thisPosition );
end

switch PanelName
    case {'opt', 'options'} % later all panels with Values (radiobuttons, popups)
        for i = 1:nButtons
            set(hButton(i), 'Value', Values(i))
        end
    otherwise % nada
end
end

function Position = uiCorners2Position(PereferedPanelGrid, LeftLow, RightUp)
% transforms data in PereferedPanelGrid{} as : 1->X, 2->Y in 
XoYo = [ PereferedPanelGrid{1}(LeftLow(1)) ...
    PereferedPanelGrid{2}(LeftLow(2)) ];
WidthHeight = [ PereferedPanelGrid{1}(RightUp(1)) ...
    PereferedPanelGrid{2}(RightUp(2)) ] - XoYo;
Position = [XoYo WidthHeight];
end

function fLoadData(src, evtd, hFig, DataType)
% load image file (or data) to segment from .mat
% 14.10.2012    - splice off uPrepEnv - reset counters, etc

if nargin < 3 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end

attData = guidata(hFig); % the interesting user data
% lives in attData.myData; double nesting...

% --- capture path and file name ---
loc_CurrDir = pwd;
if isfield(attData, 'myData') && isfield(attData.myData, 'loc') &&...
        isfield(attData.myData.loc, 'ImageDir')
    cd(attData.myData.loc.ImageDir)
end

if strcmp(DataType, 'image')
    fileSelectionLine = {'*.png; *.jpg; *.tif; *.gif; *.bmp', ...
        'All Image Files (*.png, *.jpg, *.tif, *.gif, *.bmp)'};
    ActionCode = 1;
elseif strcmp(DataType, 'matlab')
    fileSelectionLine = {'*.mat', 'matlab data (*.mat)'};
    ActionCode = 2;
else
    ActionCode = 0;
end

[loc_ImageSrcName, loc_ImageDir] = uigetfile([fileSelectionLine; {'*.*', 'All Files (*.*)'}],...
    'Pick a file');

% --- attempt to load the image
if ~isequal(loc_ImageSrcName,0) && ~isequal(loc_ImageDir,0)
        
    DataReadOK = false;
    
    if ActionCode==1 %  'image'
        disp(['load image from file  ', fullfile(loc_ImageDir, loc_ImageSrcName)])
        % later check if .mat or .gif , etc
        g0 = imread([loc_ImageDir loc_ImageSrcName]);
        DataReadOK = true;
    elseif ActionCode == 2 % 'matlab'
        disp(['load data from file  ', fullfile(loc_ImageDir, loc_ImageSrcName)])
        inData = load([loc_ImageDir loc_ImageSrcName]); % make sure data is saved using g0, for now
        AllFieldNames = fieldnames(inData);        
        ix = find(strcmp(AllFieldNames, 'g0'));
       
        strcmp(fieldnames(inData), 'g0')
        if ~isempty(ix)
            g0 = inData.(AllFieldNames{ix});
        else    % atempt 1st field...
            g0 = inData.(AllFieldNames{1});
            disp('fLoadData> loaded data does not contain g0. Attempting 1st variable')
        end        
        
        DataReadOK = true;
    else
        disp('unrecognized DataType')
    end

    if DataReadOK
        % place values in structure to be attached to the gui at the end of function
        attData.myData.loc.ImageSrcName = loc_ImageSrcName;
        attData.myData.loc.ImageDir = loc_ImageDir;
        attData.myData.loc.CurrDir = loc_CurrDir; % should ?

        % --- force B/W ! --- SCALE it ...later
        [nRo, nCo, isCol] = size(g0);
        if isCol > 1, g0 = sum(g0,3)/3; end
        g0 = single(g0);
        % scale it HARD 255
        ScFact = 255/max(g0(:));
        g0 = g0 * ScFact;
        
        % --- calculate subsampled data versions, if any ---
        kMax = attData.myData.res.kMax;        
        [attData.myData.g, attData.myData.gOffset] = ...
            InitG(g0, kMax); % later spline/linear as option?
        clear g0
                              
        guidata(hFig, attData) % ---> export !
        
        uPrepEnv(src, evtd, hFig) % reset counters, etc
        set(hFig, 'name', ['seg:: ' attData.myData.loc.ImageSrcName])
        
        % --- membrane init + dist calc. plastered here, to avoid clickkking, later in Init :-)
        iniMembrane(src, evtd, hFig)
        
    end
else    % --- unsuccessful file load, cancel, etc ---
    disp('no file to load, reverting to old')
end

end

%% --- DATA I/O -----------------------------------
function fLoadVar(src, evtd, hFig, what2load) % workspace var
% look for all workspace variables of type what2load
if nargin < 4, what2load = 'data'; end

switch what2load
    case 'data' 
        wtdClass = {'single', 'double', 'uint8', 'uint16'};
        SetFieldName = 'g';        
    case 'mask'
        wtdClass = {'logical'}; % maybe allow uint8, convert later...
        SetFieldName = 'sphi';
    case 'fn'
        wtdClass = {'single', 'double'};
        SetFieldName = 'fn'; 
end

WtdWorkspace = 'caller'; % or 'base'
a = evalin(WtdWorkspace, 'whos');
% was in base only, a = evalin('base', 'whos');
% trim, keep only wanted class
nC = numel(wtdClass);
ixKeep = false(1, numel(a));
for i=1:nC
    ixKeep(strcmp(wtdClass{i}, {a.class})) = true;
end
a = a(ixKeep);
nVar = numel(a);

% select data which is either 2D or nR x nC x 3 !
ix2D = false(1,nVar);
for i=1:nVar
    if numel(a(i).size) == 2
        ix2D(i) = true;
    elseif numel(a(i).size) == 3 && a(i).size(3) == 3 % colorimage
        ix2D(i) = true;
    end
end
a = a(ix2D);

if isempty(a)
    disp(['no ' wtdClass ' variables in specified workspace'])
    return
end

str = {a.name};
str_mat = strvcat(str);

% adapt list length, later width
ListSize  = size(str_mat) .* [30 30]; % Y, X
ListSize = min(max(ListSize, [100 100]), [160 300]);
[sel, DidPickVar] = listdlg('ListString',str, ...
    'ListSize', ListSize([2 1]), 'name', ['load ' what2load]); % ListSize is X, Y !
addInfo = ''; % tag it onto the fig name
if DidPickVar > 0
        ReadData = evalin(WtdWorkspace, [a(sel).name ';']);
else
    return
end

% only now store it at its right place
attData = guidata(hFig); % user data in attData.myData; double nesting...

switch SetFieldName
    case 'g'
        % --- force B/W ! --- SCALE it ...later
        [nRo, nCo, isCol] = size(ReadData);
        if isCol > 1, ReadData = sum(ReadData,3)/3; end
        ReadData = single(ReadData);
        % scale it HARD 255
        ScFact = 255/max(ReadData(:));
        ReadData = ReadData * ScFact;
        
        % --- calculate subsampled data versions, if any ---
        kMax = attData.myData.res.kMax;        
        [attData.myData.g, attData.myData.gOffset] = ...
            InitG(ReadData, kMax); % later spline/linear as option?
        clear ReadData
        
        guidata(hFig, attData) 
        uPrepEnv(src, evtd, hFig)
        % only now reinit membrane
        iniMembrane(src, evtd, hFig)
                
    case 'sphi'
        attData.myData.sphi = ReadData; clear ReadData
        % refresh ... not reinit membrane :-)
        attData.myData.fn = opReDist(attData.myData.sphi, ...
                attData.myData.opt.DistMethod);
end

end
function fLoadFile(src, evtd, hFig, what2load)
% load Fn or membrane (2-phase mask) from file 
if nargin < 4, what2load = 'fn'; end
if nargin < 3 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end
DoMoreFields = false;

attData = guidata(hFig); % the interesting user data
% lives in attData.myData; double nesting...
switch what2load
    case 'fn'
        loc.message = 'load LS func. Fn ';
        loc.field = 'fn';
    case 'mask'
        loc.message = 'load segmentation mas (boolean)';
        loc.field = 'sphi';
    case 'both'
        loc.message = 'load Fn + segmentation mask';
        loc.field = {'fn', 'sphi'};
        DoMoreFields = true;
end

fileSelectionLine = {'*.mat', 'matlab data (*.mat)'};

% --- capture path and file name ---
[loc.ImageSrcName, loc.ImageDir] = uigetfile([fileSelectionLine; {'*.*', 'All Files (*.*)'}],...
    loc.message);

% --- attempt to load the file
if ~isequal(loc.ImageSrcName,0) && ~isequal(loc.ImageDir,0)
    loc.FullPath = fullfile(loc.ImageDir, loc.ImageSrcName);
    fprintf(1, '\n%s%s\n%s%s', loc.message, ' from dir', loc.ImageDir,  ' > file  ', loc.ImageSrcName);
    
    inData = load(loc.FullPath); % data was saved using 'fn', 'sphi', but allow external files
    
    
    if ~DoMoreFields  %  repack single field as cell, easy for-loop
        cfield = {loc.field};
    else
        cfield = loc.field;
    end
    clear loc fileSelectionLine % yp
    
    nF = numel(cfield);
    db_MissingFields = {};
    db_ixmf = 0;
    
    for i = 1:nF
        AllFieldNames = fieldnames(inData);
        ix = find(strcmp(AllFieldNames, cfield{i}));
        
        if isempty(ix)
            ix = 1;
            % mark missing
            db_ixmf = db_ixmf + 1;
            db_MissingFields{db_ixmf} = ['wtd:' cfield{i} ' loaded:' AllFieldNames{1}];
            %attempt 1st field...
            %attData.myData.(cfield{i}) = inData.(AllFieldNames{1});
        end
        attData.myData.(cfield{i}) = inData.(AllFieldNames{ix});
        inData = rmfield(inData, AllFieldNames{ix});
    end
    
    if db_ixmf > 0
        fprintf(1, '\n%s\n%s', 'fLoadFile > loaded data missing req. fields ', db_MissingFields{1});
        if db_ixmf > 1
           fprintf(1, '\n%s', db_MissingFields{2}); 
        end
    end

    clear inData 
    
    switch what2load
        case 'fn'  % recalculate mask based on the loaded Fn
            attData.myData.sphi = attData.myData.fn > 0;
        case 'sphi' % reset...
            attData.myData.fn = opReDist(attData.myData.sphi, ...
                attData.myData.opt.DistMethod);
        case 'both' % do nothing, fn and sphi JIVE
    end
    
    % reset counters, error
    attData.myData.err = [];
    attData.myData.count.It = 0;
    attData.myData.count.Steps = 0;
    guidata(hFig, attData) % > export !
    
else    % --- unsuccessful file load, cancel, etc ---
    disp('fLoadFile> no file to load, reverting to old')
end

end
function fSave2File(src, evtd, hFig, what2load)
attData = guidata(hFig);
if nargin < 4, what2load = 'fn'; end
DoMoreFields = false;
switch what2load
    case 'fn'
        loc.message = 'levelset function';
        loc.field = 'fn';
        loc.candname = 'Fn.mat';
    case {'mask', 'sphi'}
        loc.message = 'segmentation mask';
        loc.field = 'sphi';
        loc.candname = 'Mask.mat';
    case 'both'
        loc.message = 'levelset function + segmentation mask';        
        loc.field = {'fn', 'sphi'};
        loc.candname = 'FnMask.mat';
        DoMoreFields = true;
end
% generate some info string
strInfo = [loc.message ' saved by segm_energy_LS.m at ' datestr(now)];
% capture the wanted location
[filename, pathname] = uiputfile(loc.candname, ['Save current ' loc.message ' as']);
if ~DoMoreFields % one variable
    eval([loc.field ' = attData.myData.(loc.field);'])
    save(fullfile(pathname, filename), loc.field, strInfo)
else % do all, baby, fn=sphi for now
    eval([loc.field{1} ' = attData.myData.(loc.field{1});']) % make 2 local variables
    eval([loc.field{2} ' = attData.myData.(loc.field{2});'])
    save(fullfile(pathname, filename), loc.field{1}, loc.field{2}, strInfo) % dump'em to file
end
% fn = attData.myData.(loc.field);

end
%% "ENGINE"

function uPrepEnv(src, evtd, hFig)
% prepares environment after data reload, resets counters, fn, reinits G{}...
% 14.10.2012    - new, splice pieces off fLoadData

if nargin < 3 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end
attData = guidata(hFig); % user data in attData.myData; double nesting...

% attData.myData.g has been calculated!!

% -> gTILE start at roughest resolution
kMax = attData.myData.res.kMax;   
attData.myData.gTile = attData.myData.g{kMax+1};

% -> reset counters, Fn (and not when re-setting to distance), err
attData.myData.count = uConstruct('count');
attData.myData.fn = [];
attData.myData.err = [];

% -> actualize 'res' structure and box, (using lowest res):
attData.myData.res.kLevel = kMax;
[nRk, nCk] = size(attData.myData.g{kMax+1});
attData.myData.res.kGridSize = [nRk nCk];
set(attData.reportOut, 'string', ['k = ' num2str(attData.myData.res.kLevel) ...
    ', resolution ' num2str(nRk) ' x ' num2str(nCk) ])

% export
guidata(hFig, attData) 
end

function uiRefreshData(src, evtd, hFig)
if nargin < 3 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end
uiXferIn2Struct % read in the new kMax, export it
disp('rescale original...')
tic, attData = guidata(hFig);
kMax = attData.myData.res.kMax;
[attData.myData.g, attData.myData.gOffset] = ...
    InitG(attData.myData.g{1}, kMax); % later spline/linear as option?
toc
guidata(hFig, attData) % ---> export !
end

function iniMembrane(src, evtd, hFig)
% separated > can call from a button
attData = guidata(hFig);

% classical behaviour
k = attData.myData.res.kLevel;
[nR, nC] = size(attData.myData.g{k+1});

DoUpdate = true;

switch attData.myData.opt.MembrIniMethod
    % all calls to getMembrane.m phased out ! decision is taken HERE
    case 'draw'
        thisResMethod = attData.myData.opt.DwnMethod;
        % interpolate the existent, if needed
        if k>1
            sphi = attData.myData.sphi;
            for ik = k:-1:1
                sphi = opUpDown(sphi, true, attData.myData.gOffset(ik,:), ...
                    thisResMethod);
            end
            m = membraneAct('mask2vertices', sphi);
        else
            m = attData.myData.m(1);
        end
        
        figNo = 700; % later controlled at top
        % DRAW at finest level
        [nR_0, nC_0] = size(attData.myData.g{1});
        figure(figNo), imagesc(attData.myData.g{1}), colormap gray
        set(figNo, 'number', 'off', 'name', 'seg: membrane input')
        axis equal off
        title('existent membrane:blue; input desired one using the mouse')
        % plot the existent:
        membraneAct('plot', m, 'fig', figNo, 'color', 'b', 'width', 2)
        % draw the new one
        m = membraneAct('draw', 'figNo', figNo, 'color', 'r', 'width', 2);
        % fill it
        if ~isempty(m.Arrows)
            m = membraneAct('arrows2mask', m, 'size', [nR_0 nC_0], 'ForceTrueInside', 0);
            % down-scale SPHI to current res.level
            sphi = single(m.mask);
            for i = 2:k+1
                sphi = opUpDown(sphi, false, [], thisResMethod);
            end
            sphi = sphi > 0.5;
        else % keep old stuff
            disp('no membrane drawn, revert to old')
            DoUpdate = false;
            m = attData.myData.m(1);
            sphi = attData.myData.sphi;
        end
                
    case 'circles'
        sphi = false(nR,nC);
        N = attData.myData.opt.nCircles;
        % assume figNo_N circles on width, a.k.a. nC
        Rad = floor(nC/(4*N));
        % find  y_centers (along nC)
        y_c = (2*Rad:4*Rad:nC);
        % and x_centers (along nR), with their offset
        Nr = floor(nR/4/Rad+1/2);
        x_offset = floor((nR-2*Rad*(2*Nr-1))/2);
        x_c = (x_offset+Rad:4*Rad:nR-Rad);

        % figure out mask of each circle (boolean->sign)
        %mask = uDrawStrel(Rad, 'circle', 1);
        mask = drawCircle(Rad, 1);
        % replicate this disk -> assign 'true' into binary matrix
        for i = 1:size(x_c,2)
            for j = 1:size(y_c,2)
                sphi(x_c(i)-Rad:x_c(i)+Rad, y_c(j)-Rad:y_c(j)+Rad) = mask;
            end
        end
        % optimize distance when multiple circles.. later

    case 'gate'
        % thick; later do some xor-s :-)
        % use attData.myData.opt.nCircles as PixelClearance around gate
        EuclideanDist = nMembrOrSphi2Dist(thisGateMask) - attData.myData.opt.nCircles;
        sphi = EuclideanDist >0; % or even use this crude cuasi-distance
        
    case 'load'
        disp('use pulldown menu!')
end

% --------------------------------------------------------------------
% --- export mask: sign defined inside GateMask, set outside to TRUE
% so it won't show funny objects... 2check

if DoUpdate    
    attData.myData.sphi = sphi;
    
    % calc. Fn only if and where needed (inside thisGateMask)
    redistMethod = attData.myData.opt.DistMethod;
    attData.myData.fn = opReDist(sphi, redistMethod);
    
    % re-calc vertices to plot @ curr.res.level, poz.(2) is prev.membr
    attData.myData.m(1) = membraneAct('mask2vertices', attData.myData.sphi);
    
    % --- (re-)initialize Residue, Dirac
    [Err_ini, ResidueSQ, Dirac, Hvi, gHvi] = opReset_Wrap(...
        attData.myData.fn, attData.myData.gTile, attData.myData.par,...
        attData.myData.opt.RegStyle);
    
    % --- wipe older errors
    attData.myData.err = Err_ini;
    attData.myData.evol.Hvi = Hvi;
    attData.myData.evol.gradHviMag = gHvi;
    attData.myData.evol.Residue = ResidueSQ;
    attData.myData.evol.Dirac = Dirac;
    attData.myData.count.It = 0;
    attData.myData.count.Steps = 0;
end

% actual export :-)
guidata(hFig, attData) 
end

function opDist(src, evtd, hFig)
% (re)initialize Fn with the signed distance function
if nargin < 3 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end
attData = guidata(hFig);

if isempty(attData.myData.fn) % first time only
    mask = attData.myData.sphi>0;
else 
    mask = attData.myData.fn>0;
end

redistMethod = attData.myData.opt.DistMethod;
fn = opReDist(mask, redistMethod);

attData.myData.fn = fn;
guidata(hFig, attData)
end

function fn = opReDist(mask, redistMethod)
% (re)initialize Fn with the signed distance function

fprintf('%s', ['.redist.' redistMethod ', '])
tic
switch redistMethod
    case 'built in'        
        fn = nMembrOrSphi2Dist(mask);
    case 'bwdist'
        fn = -bwdist(mask,'euclidean');
        % also do the inside!!!
        temp = bwdist(~mask,'euclidean');
        fn(mask) = temp(mask);
        clear temp
end
toc
end

function opNextStep_W(src, evtd, hFig)
% iterate Fn it.nSteps (reset) x nIterPerStep (relaxation iterations)
tic
fprintf('%s', 'run... ')
if nargin < 3 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end
attData = guidata(hFig);
%attData.myData = opNextStep_OK(attData.myData);
attData.myData = opNextStep(attData.myData);
guidata(hFig, attData) % check !
toc
tic
fprintf(1, '%s', 'show... ')
ShowData_W(hFig)
toc
end

function opChangeResolution_W(src, evtd, GoUp, hFig)
% just this, changes the scale of Fn (i.e. h)
% update of sphi, sphi_prev, fn_prev
if nargin < 4 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end
attData = guidata(hFig);
[attData.myData, KStatusStr] = opChangeResolution(attData.myData, GoUp); 
set(attData.reportOut, 'string', KStatusStr)
guidata(hFig, attData)
end

function ShowData_W(src, evtd, hFig)
% shows Fn (+ membrane if there's any)
if nargin < 3 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end
attData = guidata(hFig);
attData.myData = ShowData(attData.myData); % wrapped function
guidata(hFig, attData) % export!
end

function ShowError_W(src, evtd, hFig, figNo)
if nargin < 4, figNo = 501; end
if nargin < 3 % should be in a 2-deep menu
    hFig = get(get(gcbo, 'parent'), 'parent');
end
attData = guidata(hFig);
% call wrapped function
ShowError(attData.myData.err, ...
    attData.myData.it.nSteps+1, figNo)
% no need to export!
% guidata(hFig, attData)
end

%% VIEWs, Status report

function vFn(src, evtd, hFig, figNo) % view Fn, Lipschitz study, debug
if nargin < 4, figNo = 701; end
attData = guidata(hFig);
k = attData.myData.res.kLevel;
mAbsSpacing = 2;
optDoPerc = true;
mPercSpacing = 0.1;
fn = attData.myData.fn;
if ~isempty(fn)
    %size(attData.myData.g,2) >= k+1
    optPrefPos = [250 275 400 400];
    [hCheck, isNew] = ReplaceFigWhenNew(figNo, optPrefPos);
    imagesc(fn), zoom off, colormap gray, axis equal off
    set(hCheck, 'number', 'off', 'name', ['seg:Fn:' num2str(k)])    
    if isNew, impixelinfo(hCheck), end
    zoom on
    % generate title
    minF = min(fn(:));
    maxF = max(fn(:));
    nDig = 5;
    title(['f_n range: ' num2str(maxF-minF, nDig) ...
        ', \in [' num2str(minF, nDig) ', ' num2str(maxF, nDig) ']']);
    % superimpose 3 membranes
    
    mp = membraneAct('mask2vertices', fn > mAbsSpacing);
    mn = membraneAct('mask2vertices', fn < -mAbsSpacing);
    membraneAct('plot', mp, 'fig', figNo, 'color', 'r');
    membraneAct('plot', mn, 'fig', figNo, 'color', 'b');
    if optDoPerc
        mp = membraneAct('mask2vertices', fn > maxF * mPercSpacing);
        membraneAct('plot', mp, 'fig', figNo, 'color', 'm', 'linewidth', 1);
        mn = membraneAct('mask2vertices', fn < minF * mPercSpacing);
        membraneAct('plot', mn, 'fig', figNo, 'color', 'c', 'linewidth', 1);
    end
    membraneAct('plot', attData.myData.m(1), 'fig', figNo, 'color', 'y');
    
else
    disp('obtain Fn first :-)')
end
end

function vGrad(src, evtd, hFig, figNo) % view gradient of Fn, debug
if nargin < 4, figNo = 702; end
attData = guidata(hFig);
optDoContour = true;

k = attData.myData.res.kLevel;
gM = attData.myData.evol.gradFnMag;
gPh = attData.myData.evol.gradFnPhase;
if ~isempty(gM)       
    optPrefPos = [50 200 500 250];
    hCheck = ReplaceFigWhenNew(figNo, optPrefPos);
    set(hCheck, 'number', 'off', 'name', ['seg:FnGrad:' num2str(k)])
    subplot(121)
    imagesc(gM), colorbar, colormap gray, axis equal off
    % generate title, find contour line value
    minG = min(gM(:));
    maxG = max(gM(:));
    nDig = 5;
    AbsGradLimit = 1.41 + 0.25*(maxG-1);
    title(['\nabla f_n \in [' num2str(minG, nDig) ', ' num2str(maxG, nDig)...
        '], LS at 25% over: ' num2str(AbsGradLimit, nDig-1)]);

    if optDoContour
        m = membraneAct('mask2vertices', gM > AbsGradLimit);
        membraneAct('plot', m, 'fig', figNo, 'color', 'y');
    end
    membraneAct('plot', attData.myData.m(1), 'fig', figNo, ...
        'linewidth', 1, 'color', 'r');
    subplot(122)
    imagesc(gPh), colormap gray, axis equal off
    
    title('\nabla f_n, unwrapped phase')
else
    disp('obtain grad(Fn) first :-)')
end
end

function vHviItsGrad(src, evtd, hFig, figNo)
if nargin < 4, figNo = 703; end
attData = guidata(hFig);
k = attData.myData.res.kLevel;
optDoContour = true; % false; % 
hvi = attData.myData.evol.Hvi;
g = attData.myData.evol.gradHviMag;
if isempty(attData.myData.evol.Hvi) || ...
        isempty(attData.myData.evol.gradHviMag)
    disp('obtain Hvi and its gradient first :-)')
    return
end

optPrefPos = [225 225 600 300];
hCheck = ReplaceFigWhenNew(figNo, optPrefPos);
set(hCheck, 'number', 'off', 'name', ['seg:Residue:' num2str(k)])
subplot(121) % Hvi
imagesc(hvi), colorbar, colormap gray, axis equal off
title('\bf{Heaviside}\rm function, \bf{H_{\epsilon}}\rm');
subplot(122) % its grad
imagesc(g), colorbar, colormap gray, axis equal off
% generate title
minG = min(g(:)); maxG = max(g(:)); nDig = 5;
title(['\nabla(H_{\epsilon}) \in [' num2str(minG, nDig) ...
    ', ' num2str(maxG, nDig) ']']);
if optDoContour
    m = membraneAct('mask2vertices', hvi > 0.5);
    membraneAct('plot', m, 'fig', figNo, 'color', 'r');
end

end

function vResidual(src, evtd, hFig, figNo)
if nargin < 4, figNo = 704; end
attData = guidata(hFig);
k = attData.myData.res.kLevel;
optDoContour = false; % true;
g = attData.myData.evol.Residue;
if ~isempty(g)
    Pmask = g > 0;
    Mmask = ~Pmask;
    gRMS = sqrt(abs(g));
    gRMS(Mmask) = -gRMS(Mmask);
    optPrefPos = [200 225 600 200];
    hCheck = ReplaceFigWhenNew(figNo, optPrefPos);
    set(hCheck, 'number', 'off', 'name', ['seg:Residue:' num2str(k)])
    % generate title
    minG = min(gRMS(:));
    maxG = max(gRMS(:));
    nDig = 5;
    subplot(121)
    imagesc(gRMS), colorbar, colormap gray, axis equal off
    title(['sqrt(\bf{Residue}\rm) \in [' num2str(minG, nDig) ', ' num2str(maxG, nDig) ']']);
    % show seg result:
    membraneAct('plot', attData.myData.m(1), 'fig', figNo, ...
        'linewidth', 1, 'color', 'r');
    if optDoContour % also show P mask (Residue pos., fn descending)
        m = membraneAct('mask2vertices', Pmask);
        membraneAct('plot', m, 'fig', figNo, 'color', 'r');
    end
    subplot(122) % regularized
    g = g .* attData.myData.evol.Dirac;
    imagesc(g), colorbar, colormap gray, axis equal off
    title('reg. \bf{Residue}\rm');
    membraneAct('plot', attData.myData.m(1), 'fig', figNo, ...
        'linewidth', 1, 'color', 'r');
    
else
    disp('obtain Residual first :-)')
end
end

function vInspectData(src, evtd, hFig, figNo)
if nargin < 4, figNo = 706; end
attData = guidata(hFig);
k = attData.myData.res.kLevel;
if size(attData.myData.g,2) >= k+1
    optPrefPos = [180 300 500 200];
    ReplaceFigWhenNew(figNo, optPrefPos);
    g = attData.myData.g{k+1};
    MaxGVal = max(g(:));
    g = g * (255/MaxGVal);
    set(figNo, 'number', 'off', 'name', ...
        ['seg::inspect: res-' num2str(k) ',scale-' num2str(MaxGVal)])
    hCheck = subplot(121);
    imshow(uint8(g)), impixelinfo(hCheck)
    membraneAct('plot', attData.myData.m(1), 'fig', figNo, 'color', 'r');
    % find histograms
    nBins = 256;
    msk = attData.myData.sphi;

    subplot(122), plTicks = {'b', 'r'}; % in/out
    for i=1:2
        nIn = sum(msk(:));
        gIn = [g(msk)' 0 255];
        hIn = hist(gIn, nBins) * nBins/nIn;
        plot(hIn, plTicks{i}), hold on
        msk = ~msk;
    end
    hold off, grid on, zoom on
    title('histograms IN (red) and OUT (blue)')
else
    disp('load data first :-)')
end
end

function vReportOut(src, evtd, hFig, figNo)
if nargin < 4, figNo = 707; end
optFontSize = 14;
attData = guidata(hFig);

par = attData.myData.par;
err = attData.myData.err;
% generate two pairs of strings, IN(Segm.Par.) and OUT (performance)
strParam{1} = ['Seg.Par. \mu=' num2str(par.Miu) ...
    ', \nu=' num2str(par.Niu) ];
strParam{2} = ['\lambda_P= ' num2str(par.Lp) ...
    ', \lambda_M= ' num2str(par.Lm) ];

nIt = size(err.Cp, 2);
nDig = 4;
strPerf{1} = ['E_{TOT}: ' num2str(err.total(nIt)) ...
    ', CorrExp: ' num2str(log10(err.total_corr(nIt))) ...
    ', RMS_{A/P/M}= ' num2str(err.E_pix(nIt), nDig) '/'...
    num2str(err.Ep(nIt), nDig) '/' num2str(err.Em(nIt), nDig) ...
    ', C_{P/M}= ' num2str(err.Cp(nIt), nDig) '/' num2str(err.Cm(nIt), nDig)];
strPerf{2} = ['P_{RAW} =' num2str(err.Interface_raw(nIt), nDig) ...
    ', P_{ADJ} =' num2str(err.Interface_adj(nIt), nDig) ...
    ', A_P = ' num2str(round(err.Region_P(nIt))) ...
    '<px>, A_{ratio} = ' num2str(err.Region_ratio(nIt)*100, nDig) '%'];
fprintf(' %s\n %s\n %s\n %s\n', strParam{1}, strParam{2}, ...
    strPerf{1}, strPerf{2})
% show'em
figure(figNo), imagesc(attData.myData.g{1})
colormap gray, axis equal off
membraneAct('plot', attData.myData.m(1), 'fig', figNo, 'color', 'r');
zoom on
% append some nice title & labels ... use the mouse:
for i=1:2
    disp(['place IN str ' num2str(i)])
    gtext(strParam{i}, 'fontsize', optFontSize)
    disp(['place OUT str ' num2str(i)])
    gtext(strPerf{i}, 'fontsize', optFontSize)
end

end
