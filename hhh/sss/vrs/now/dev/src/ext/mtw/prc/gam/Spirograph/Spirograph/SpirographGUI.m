function SpirographGUI()
%--------------------------------------------------------------------------
% Syntax:       SpirographGUI;
%               SpirographGUI();
%               
% Dependencies: Make sure you add the folder "./HelperFcns/" to your MATLAB
%               path before running SpirographGUI(). This folder contains
%               helper functions that are called during execution
%               
% Description:  This function generates a GUI in a MATLAB figure window
%               that allows the user to draw customizable multi-layer
%               spirographs
%               
% Controls:     Controls are broken into three button groups: Shapes,
%               Figure, and Spirograph
%               
%               The Shapes button group allows the user to select from a
%               list of available inner/outer shapes and customize their
%               parameters, including the ability to 1) modify the
%               positions of the holes in the inner shape, 2) change the
%               active hole, and 3) show/hide the shapes (e.g., you may
%               want to hide the shapes to view your finished spirograph!)
%               
%               The Figure button group allows the user to 1) rotate
%               layer(s) of the existing spirograph, 2) delete layer(s) of
%               the existing spirograph, and 3) change the current axis
%               range
%               
%               The Spirograph button group allows the user to customize
%               the 1) initial angle, 2) number of revolutions, 3) graph
%               resolution, and 4) plotting style (e.g., line color, line 
%               width, etc.) of the next spirograph layer. After
%               customizing the layer, simply push the "Draw" button to
%               watch your spirograph draw itself (you can then push "Stop"
%               to terminate the drawing early, if desired)
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         June 9, 2013
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Default GUI values (can be changed, if desired)
%--------------------------------------------------------------------------
% Define usable shapes
Shapes = cell(1,3);
Shapes{1} = struct('String','Circle', ...
                   'Params','{r}: ', ...
                   'OuterDefaults','{2}', ...
                   'AxisDefaults','[-2 2 -2 2]', ...
                   'InnerDefaults','{1}', ...
                   'HoleDefaults','[[0;0] [-.5;0] [.5;0] [0;-.5] [0;.5]]', ...
                   'IdxDefault','1');
Shapes{2} = struct('String','Ellipse', ...
                   'Params','{r1,r2}: ', ...
                   'OuterDefaults','{2,1}', ...
                   'AxisDefaults','[-2 2 -2 2]', ...
                   'InnerDefaults','{1,0.5}', ...
                   'HoleDefaults','[[0;0] [-.5;0] [.5;0] [0;-.5] [0;.5]]', ...
                   'IdxDefault','1');
Shapes{3} = struct('String','Football', ...
                   'Params','{r1,r2,p}: ', ...
                   'OuterDefaults','{2,1,2}', ...
                   'AxisDefaults','[-2 2 -2 2]', ...
                   'InnerDefaults','{1,0.5,2}', ...
                   'HoleDefaults','[[0;0] [-.5;0] [.5;0] [0;-.5] [0;.5]]', ...
                   'IdxDefault','1');

% GUI init values
DefaultRotation = '10'; % in degrees
DefaultInitAngle = '0'; % in degrees
DefaultRevs = '5';
DefaultRes = '500';
DefaultStyle = '{''g-''}';

% Initial shapes
InitOuterShape = 1;
InitInnerShape = 2;

% Resolution of inner/outer shapes during drawing
Ndraw = 100;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Define global variables
%--------------------------------------------------------------------------
OuterParams = {};
InnerParams = {};

OuterFun = [];
InnerFun = [];

OuterDraw = [];
InnerDraw = [];

hOuter = [];
hInner = [];

Holes = [];
HolesIdx = [];

Spiros = {};

DrawingNow = false;
ShowShapes = true;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Create figure window
%--------------------------------------------------------------------------
f = figure('name','Spirograph - Brian Moore 2013');
set(gca,'Position',[0.075,0.4,0.525,0.5]);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Shapes group
%--------------------------------------------------------------------------
ShapesHeadingSize = 0.11;
ShapesFontSize = 0.5;

ShapeStr = Shapes{1}.String;
for i = 2:length(Shapes)
    ShapeStr = [ShapeStr '|' Shapes{i}.String]; %#ok
end

ShapesGroup = uibuttongroup('Title','Shapes','TitlePosition','centertop','FontUnits','normalized');
set(ShapesGroup,'Position',[0.075 0.05 0.525 0.3],'FontSize',ShapesHeadingSize);

OuterShapeText = uicontrol(f,'Style','text','FontUnits','normalized','String','Outer Shape','parent',ShapesGroup);
InnerShapeText = uicontrol(f,'Style','text','FontUnits','normalized','String','Inner Shape','parent',ShapesGroup);
OuterShapePopup = uicontrol(f,'Style','popup','FontUnits','normalized','Callback',@myOuterShapeFun,'String',ShapeStr,'parent',ShapesGroup);
InnerShapePopup = uicontrol(f,'Style','popup','FontUnits','normalized','Callback',@myInnerShapeFun,'String',ShapeStr,'parent',ShapesGroup);
set(OuterShapeText,'Units','normalized','Position',[0.1 0.79 0.35 0.2],'FontSize',ShapesFontSize,'HorizontalAlignment','center');
set(InnerShapeText,'Units','normalized','Position',[0.55 0.79 0.35 0.2],'FontSize',ShapesFontSize,'HorizontalAlignment','center');
set(OuterShapePopup,'Units','normalized','Position',[0.1 0.64 0.35 0.2],'FontSize',ShapesFontSize);
set(InnerShapePopup,'Units','normalized','Position',[0.55 0.64 0.35 0.2],'FontSize',ShapesFontSize);

OuterParamsText = uicontrol(f,'Style','text','FontUnits','normalized','parent',ShapesGroup);
OuterParamsEdit = uicontrol(f,'Style','edit','FontUnits','normalized','Callback',@myOuterParamsFun,'parent',ShapesGroup);
set(OuterParamsText,'Units','normalized','Position',[0 0.35 0.225 0.2],'FontSize',ShapesFontSize,'HorizontalAlignment','right');
set(OuterParamsEdit,'Units','normalized','Position',[0.225 0.38 0.225 0.2],'FontSize',ShapesFontSize);

InnerParamsText = uicontrol(f,'Style','text','FontUnits','normalized','parent',ShapesGroup);
InnerParamsEdit = uicontrol(f,'Style','edit','FontUnits','normalized','Callback',@myInnerParamsFun,'parent',ShapesGroup);
set(InnerParamsText,'Units','normalized','Position',[0.5 0.35 0.175 0.2],'FontSize',ShapesFontSize,'HorizontalAlignment','right');
set(InnerParamsEdit,'Units','normalized','Position',[0.675 0.38 0.225 0.2],'FontSize',ShapesFontSize);

HolesText = uicontrol(f,'Style','text','FontUnits','normalized','String','Holes','parent',ShapesGroup);
HolesEdit = uicontrol(f,'Style','edit','FontUnits','normalized','Callback',@myInnerParamsFun,'parent',ShapesGroup);
set(HolesText,'Units','normalized','Position',[0.1 0.15 0.35 0.2],'FontSize',ShapesFontSize);
set(HolesEdit,'Units','normalized','Position',[0.1 0.05 0.35 0.2],'FontSize',ShapesFontSize);

IndexText = uicontrol(f,'Style','text','FontUnits','normalized','String','Index','parent',ShapesGroup);
IndexEdit = uicontrol(f,'Style','edit','FontUnits','normalized','Callback',@myInnerParamsFun,'parent',ShapesGroup);
set(IndexText,'Units','normalized','Position',[0.55 0.15 0.15 0.2],'FontSize',ShapesFontSize);
set(IndexEdit,'Units','normalized','Position',[0.55 0.05 0.15 0.2],'FontSize',ShapesFontSize);

ShowHideButton = uicontrol(f,'Style','pushbutton','FontUnits','normalized','String','Hide','BackgroundColor','r','Callback',@myShowHideFun,'parent',ShapesGroup);
set(ShowHideButton,'Units','normalized','Position',[0.75 0.05 0.15 0.2],'FontSize',ShapesFontSize);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Figure group
%--------------------------------------------------------------------------
FigureHeadingSize = 0.1;
FigureFontSize = 0.36;

FigureGroup = uibuttongroup('Title','Figure','TitlePosition','centertop','FontUnits','normalized');
set(FigureGroup,'Position',[0.65 0.6 0.3 0.32],'FontSize',FigureHeadingSize);

RotateEdit = uicontrol(f,'Style','edit','FontUnits','normalized','String',DefaultRotation,'parent',FigureGroup);
RotateText = uicontrol(f,'Style','text','FontUnits','normalized','String','deg','parent',FigureGroup);
RotateButton = uicontrol(f,'Style','pushbutton','FontUnits','normalized','String','Rotate','Callback',@myRotateFun,'parent',FigureGroup);
set(RotateEdit,'Units','normalized','Position',[0.05 0.6875 0.25 0.25],'FontSize',FigureFontSize);
set(RotateText,'Units','normalized','Position',[0.32 0.63 0.15 0.25],'FontSize',FigureFontSize);
set(RotateButton,'Units','normalized','Position',[0.5 0.6875 0.45 0.25],'FontSize',FigureFontSize);

SpiroIdxPopup = uicontrol(f,'Style','popup','FontUnits','normalized','String','All','parent',FigureGroup);
set(SpiroIdxPopup,'Units','normalized','Position',[0.05 0.32 0.4 0.25],'FontSize',FigureFontSize);

ClearButton = uicontrol(f,'Style', 'pushbutton','FontUnits','normalized','String','Clear','Callback',@myClearFun,'parent',FigureGroup);
set(ClearButton,'Units','normalized','Position',[0.5 0.3525 0.45 0.25],'FontSize',FigureFontSize);

AxisText = uicontrol(f,'Style','text','FontUnits','normalized','String','Axis:','parent',FigureGroup);
AxisEdit = uicontrol(f,'Style','edit','FontUnits','normalized','Callback',@myAxisFun,'parent',FigureGroup);
set(AxisText,'Units','normalized','Position',[0.05 0.03 0.4 0.25],'FontSize',FigureFontSize);
set(AxisEdit,'Units','normalized','Position',[0.5 0.085 0.45 0.25],'FontSize',FigureFontSize);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Spirograph group
%--------------------------------------------------------------------------
SpiroHeadingSize = 0.07;
SpiroFontSize = 0.37;

SpirographGroup = uibuttongroup('Title','Spirograph','TitlePosition','centertop','FontUnits','normalized');
set(SpirographGroup,'Position',[0.65 0.05 0.3 0.47],'FontSize',SpiroHeadingSize);

AngleText1 = uicontrol(f,'Style','text','FontUnits','normalized','String','Init. Angle:','parent',SpirographGroup);
AngleEdit = uicontrol(f,'Style','edit','FontUnits','normalized','String',DefaultInitAngle,'Callback',@myInnerParamsFun,'parent',SpirographGroup);
AngleText2 = uicontrol(f,'Style','text','FontUnits','normalized','String','deg','parent',SpirographGroup);
set(AngleText1,'Units','normalized','Position',[0.05 0.765 0.4 0.16],'FontSize',SpiroFontSize);
set(AngleEdit,'Units','normalized','Position',[0.5 0.805 0.25 0.16],'FontSize',SpiroFontSize);
set(AngleText2,'Units','normalized','Position',[0.75 0.765 0.15 0.16],'FontSize',SpiroFontSize);

RevsText = uicontrol(f,'Style','text','FontUnits','normalized','String','Revolutions:','parent',SpirographGroup);
RevsEdit = uicontrol(f,'Style','edit','FontUnits','normalized','String',DefaultRevs,'parent',SpirographGroup);
set(RevsText,'Units','normalized','Position',[0.05 0.572 0.4 0.16],'FontSize',SpiroFontSize);
set(RevsEdit,'Units','normalized','Position',[0.5 0.612 0.45 0.16],'FontSize',SpiroFontSize);

ResText = uicontrol(f,'Style','text','FontUnits','normalized','String','Resolution:','parent',SpirographGroup);
ResEdit = uicontrol(f,'Style','edit','FontUnits','normalized','String',DefaultRes,'parent',SpirographGroup);
set(ResText,'Units','normalized','Position',[0.05 0.379 0.4 0.16],'FontSize',SpiroFontSize);
set(ResEdit,'Units','normalized','Position',[0.5 0.419 0.45 0.16],'FontSize',SpiroFontSize);

StyleText = uicontrol(f,'Style','text','FontUnits','normalized','String','Style:','parent',SpirographGroup);
StyleEdit = uicontrol(f,'Style','edit','FontUnits','normalized','String',DefaultStyle,'parent',SpirographGroup);
set(StyleText,'Units','normalized','Position',[0.05 0.186 0.4 0.16],'FontSize',SpiroFontSize);
set(StyleEdit,'Units','normalized','Position',[0.5 0.226 0.45 0.16],'FontSize',SpiroFontSize);

DrawButton = uicontrol(f,'Style', 'pushbutton','FontUnits','normalized','String','Draw','Callback',@myDrawFun,'parent',SpirographGroup);
set(DrawButton,'Units','normalized','Position',[0.25 0.033 0.5 0.16],'FontSize',SpiroFontSize);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Initialize GUI
%--------------------------------------------------------------------------
% Setup something fun to start
set(OuterShapePopup,'Value',InitOuterShape);
set(InnerShapePopup,'Value',InitInnerShape);

% Initialize shapes
myOuterShapeFun();
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Nested functions
%--------------------------------------------------------------------------
function myShowHideFun(varargin)
    if ShowShapes
        % Hide inner/outer shapes
        ShowShapes = false;
        set(ShowHideButton,'String','Show');
        set(ShowHideButton,'BackgroundColor','g');
        try
        delete(hOuter);
        delete(hInner);
        catch %#ok
        end
    else
        % Show inner/outer shapes
        ShowShapes = true;
        set(ShowHideButton,'String','Hide');
        set(ShowHideButton,'BackgroundColor','r');
        myOuterParamsFun();
    end
end
    
function myAxisFun(varargin)
    % Update axis
    title('Spirograph','FontUnits','normalized','FontSize',0.1,'FontName','Lucida Handwriting');
    hold on;
    axis equal;
    eval(['axis(' get(AxisEdit,'String') ');']);
    drawnow;
end

function myOuterShapeFun(varargin)
    %
    % Update outer shape type
    %
    
    % Get new outer shape type
    idx = get(OuterShapePopup,'Value');
    OuterShape = Shapes{idx}.String;
    OuterFun = eval(['@Update' OuterShape '1']);
    OuterDraw = eval(['@Draw' OuterShape]);
    
    % Update Shapes group w/ default params
    set(OuterParamsText,'String',Shapes{idx}.Params);
    set(OuterParamsEdit,'String',Shapes{idx}.OuterDefaults);
    set(AxisEdit,'String',Shapes{idx}.AxisDefaults);
    
    % Update outer plot
    myOuterParamsFun();
end

function myOuterParamsFun(varargin)
    %
    % Update outer shape params
    %
    
    % Get outer shape params
    OuterParams = eval([get(OuterParamsEdit,'String') ';']);
    
    % Update plot using current outer params
    try
    delete(hOuter);
    catch %#ok
    end
    [hOuter,~] = OuterDraw(0,0,OuterParams{:},Ndraw,0,[],[],ShowShapes,{'r'});
    myAxisFun();
    
    % Update inner plot, too
    if (isempty(InnerFun) || isempty(InnerDraw))
        myInnerShapeFun();
    else
        myInnerParamsFun();
    end
end

function myInnerShapeFun(varargin)
    %
    % Update inner shape type
    %
    
    % Get new inner shape type
    idx = get(InnerShapePopup,'Value');
    InnerShape = Shapes{idx}.String;
    InnerFun = eval(['@Update' InnerShape '2']);
    InnerDraw = eval(['@Draw' InnerShape]);
    
    % Update Shapes group w/ default params
    set(InnerParamsText,'String',Shapes{idx}.Params);
    set(InnerParamsEdit,'String',Shapes{idx}.InnerDefaults);
    set(HolesEdit,'String',Shapes{idx}.HoleDefaults);
    set(IndexEdit,'String',Shapes{idx}.IdxDefault);
    
    % Update inner plot
    myInnerParamsFun();
end

function myInnerParamsFun(varargin)
    %
    % Update inner shape params
    %
    
    % Get inner shape params
    InnerParams = eval([get(InnerParamsEdit,'String') ';']);
    Holes = eval([get(HolesEdit,'String') ';']);
    HolesIdx = eval([get(IndexEdit,'String') ';']);
    
    % Get initial angle (in radians) of inner object
    theta0 = (pi / 180) * mod(str2double(get(AngleEdit,'String')),360);
    
    % Show initial position of specified inner object
    if ShowShapes
        UpdateSpirograph(theta0);
    end
end

function myRotateFun(varargin)
    %
    % Rotate the current spirograph
    %
    
    % Get desired rotation
    phi = (pi / 180) * mod(str2double(get(RotateEdit,'String')),360);
    M = RotationMatrix(phi);
    
    % Get spiro idx popup setting
    idxlist = get(SpiroIdxPopup,'Value') - 1;
    if ~idxlist
        idxlist = 1:length(Spiros);
    end
    
    % Loop over each layer
    for ii = idxlist
        % Rotate layer
        s = M * Spiros{ii}.s;
        
        % Delete old plot
        delete(Spiros{ii}.h);
        
        % Redraw layer
        h = DrawSpirograph(s(1,:),s(2,:),Spiros{ii}.style);
        
        % Save new data
        Spiros{ii}.s = s;
        Spiros{ii}.h = h;
    end
    myAxisFun();
end

function myClearFun(varargin)
    %
    % Clears the specified spirals from the current spirograph
    %
    
    % Get spiro idx popup setting
    idxlist = get(SpiroIdxPopup,'Value') - 1;
    if ~idxlist
        idxlist = 1:length(Spiros);
    end
    
    % Delete specified spirograph(s)
    for ii = length(idxlist):-1:1
        delete(Spiros{idxlist(ii)}.h);
        Spiros(idxlist(ii)) = [];
    end
    myAxisFun();
    
    % Update clear popup label
    UpdateClearPopup();
end

function UpdateClearPopup()
    % Update clear popup menu
    clearstr = 'All';
    for ii = 1:length(Spiros)
        clearstr = [clearstr '|' num2str(ii)]; %#ok
    end
    set(SpiroIdxPopup,'String',clearstr);
    set(SpiroIdxPopup,'Value',1);
end

function myDrawFun(varargin)
    %
    % Draws spirograph using current settings
    %
    
    if ~DrawingNow
        % Set status to drawing
        DrawingNow = true;
        set(DrawButton,'String','Stop');
        set(DrawButton,'BackgroundColor','r');
        
        % Get drawing params
        theta0 = (pi / 180) * mod(str2double(get(AngleEdit,'String')),360);
        revs = str2double(get(RevsEdit,'String'));
        res = str2double(get(ResEdit,'String'));
        style = eval([get(StyleEdit,'String') ';']);
        
        % Generate spirograph
        theta = linspace(theta0,theta0 + 2 * pi * revs,res);
        sxy = zeros(2,0);
        
        ii = 1;
        while (ii <= res)
            % Update position on spirograph
            sxy = [sxy UpdateSpirograph(theta(ii))]; %#ok
            
            % Draw the spirograph line
            try
            delete(hxy);
            catch %#ok
            end
            hxy = DrawSpirograph(sxy(1,1:ii),sxy(2,1:ii),style);
            myAxisFun();
            
            % Increment counter
            if ~DrawingNow
                ii = res + 1;
            else
                ii = ii + 1;
            end
        end
        
        % Save current spirograph layer
        Spiros{length(Spiros)+1} = struct('s',sxy,'h',hxy,'style',{style});
        UpdateClearPopup();
        
        % Reset sprios
        myOuterParamsFun();
    end
    
    % Set status to not drawing
    DrawingNow = false;
    set(DrawButton,'String','Draw');
    set(DrawButton,'BackgroundColor',0.9294 * [1 1 1]);
end

function sxy = UpdateSpirograph(theta)
    %
    % Generate spirograph at current angle
    %
    
    % Update position on outer object
    [s xo to] = OuterFun(theta,OuterParams{:});
    
    % Update position on inner object
    [xi ti] = InnerFun(s,InnerParams{:});
    
    % Compute required rotation/translation
    phi = acos(to' * ti);
    M = RotationMatrix(phi);
    err = norm(to - M * ti);
    if (norm(to - RotationMatrix(2 * pi - phi) * ti) < err)
        phi = 2 * pi - phi;
        M = RotationMatrix(phi);
    end
    trans = xo - M * xi;
    
    % Update plot using current inner params
    try
    delete(hInner);
    catch %#ok
    end
    [hInner sxy] = InnerDraw(trans(1),trans(2),InnerParams{:},Ndraw,phi,Holes,HolesIdx,ShowShapes,{'b'});
    myAxisFun();
end

function h = DrawSpirograph(x,y,args)
    % Draw the current spirograph curve
    h = plot(x,y,args{:});
end
%--------------------------------------------------------------------------
end
