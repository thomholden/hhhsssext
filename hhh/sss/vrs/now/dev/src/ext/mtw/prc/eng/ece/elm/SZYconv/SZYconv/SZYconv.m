function SZYconv
% SZYconv - quick S-parameter converter
% 
% for more info type SZYconv, then choose Help | Quick Start
%
% Tudor Dima, tudima@yahoo.com
% ver. 2.0, 26.04.2009

close('all');

WPosition = [ 350 100 820 600];
figNr = figure('NumberTitle', 'off', ...
    'Position', WPosition, ...
    'Resize' , 'off', ...
    'menu', 'none', ...
    'Name', 'S Z Y  - Impedance Converter');
% expected buttonDown Action : get (X,Y), draw point, update strings
set(figNr, 'WindowButtonDownFcn', {@GetS11ReIm, figNr})

figBckgndCol = get(figNr,'color'); % and duplicate it for the labels...

YX_ratio = WPosition(4)/WPosition(3);

Axes.Position = [ 0 0 YX_ratio 1];
set(figNr,'defaultaxesposition', Axes.Position );
Axes.h = axes('position', Axes.Position);

TextFontWeight = 'bold';

nAreas = 5; % come up with five colours :-)
%AreaColour = ones(5,3); % future colour of edit fields bkgd
%AreaColour = [1 1 1; 0.9 1 0.8; 0.7 0.7 1; 0.9 0.8 1; 1 1 1];      
AreaColour = [...
    1    0.01 0.01; ... %ReIm      
    0.02 0.02 1; ...    % Pol  
    1    1    0.01; ... % Z
    0.01 1    0.01; ... % Y
    1    1    1];       % RL VSWR
MakeDarkerBy = 1; % darken some of the legends
DesaturateBy = 30;
% init S-point ! its labels...
% ----------------------------------
sp = spRecalc;
LabelStr = {'S11, complex', num2str(sp.sRe), num2str(sp.sIm), 'real', 'imaginary',...
    'S11, polar coordinates', num2str(sp.rad), num2str(sp.deg), 'radius', 'angle',...
    'normalized Z = R+jX', num2str(sp.r), num2str(sp.x), 'R', 'X',...
    'normalized Y = G+jB', num2str(sp.g), num2str(sp.b), 'G', 'B',...
    '', num2str(sp.rl), num2str(sp.vswr), 'Return Loss', 'VSWR',...
    };
ParamName = {'sRe', 'sIm', 'rad', 'deg', 'r', 'x', 'g', 'b', 'rl', 'vswr'}; % to use in callbacks

% --- draw grid and point ---
GridOptions = uConstr;
GridRedraw(Axes.h, GridOptions)
RepositionPoint(sp.sRe, sp.sIm, get(figNr, 'CurrentAxes'))

% --- generate UI grid toggling uimenu ---
h.GridMenuH = uimenu(gcf, 'label', 'Toggle Grids');
Labels = {'Smith Z (impedance)', 'Smith Y (admittance)', 'Polar Chart'};
Actions = {'Z', 'Y', 'C'};
for i=1:3
    h.GridMenu(i) = uimenu(h.GridMenuH,'Label', Labels{i}, ...
        'Callback',{@GridToggle, figNr, ['toggle ' Actions{i}]},...
        'Enable', 'on');
    ToCheck = GridOptions.(Actions{i}).show;
    if ToCheck  % eye candy
        set(h.GridMenu(i), 'checked', 'on')
    else
        set(h.GridMenu(i), 'checked', 'off')
    end
end

% --- generate help uimenu ---
h.HelpMenu = uimenu(gcf, 'label', 'Help', ...
    'Enable', 'on');
h.QuickStart = uimenu(h.HelpMenu, 'label', 'Quick Start', ...
    'Callback', {@uQuickStart, 'QuickStart'},...
    'Enable', 'on');
h.About = uimenu(h.HelpMenu, 'label', 'About', ...
    'Callback', {@uQuickStart, 'About'},...
    'Enable', 'on');

%----------------------------------------
% default button sizes, preferences
%----------------------------------------
BtnAreaDX = 1-YX_ratio;
BtnAreaDY = 1;

AdX = BtnAreaDX;
AdY = BtnAreaDY/nAreas;
AXo = 1-BtnAreaDX;
AYo = (nAreas-1:-1:0)/nAreas;
ysym = AYo + 0.5/nAreas; % y symmetry :

Wbtn = 8/20 * AdX;
Hbtn = 8/20 * AdY;
Hlbl = 4/20 * AdY;

nGObj = 5; % no. of gobj /area
nGObjEdit = 2; % same, only editable, that is 
% those which that are still to be addressed after creation

%-------------
% draw buttons
%-------------
% build nAreas, inside each: 2 buttons, three labels
hG = zeros(1, nGObjEdit*nAreas);
for ixA = 1:nAreas         
    ix = nGObj*(ixA-1)+1; % ix of first object
    % will increment 1-to-nGobj inside this 'for'; to use in labeling
    thisBackgroundColour = min(ones(1,3), AreaColour(ixA,:)*DesaturateBy);
    
    % draw top label
    PosLabelTop = [AXo+AdX/20 ysym(ixA)+Hbtn/2 AdX*18/20 Hlbl]; 
    uicontrol('Style','text','Units','normalized', ...
        'Position', PosLabelTop, 'String', LabelStr{ix}, ...
        'FontWeight', TextFontWeight, ...
        'BackgroundColor', figBckgndCol, ...
        'ForegroundColor', AreaColour(ixA,:));
    
    % ---> draw left edit field ---
    % --------------------------------------
    PosBtnLeft = [AXo+AdX/20 ysym(ixA)-Hbtn/2 Wbtn Hbtn];
    ixBtnLeft = nGObjEdit*(ixA-1)+1;    
    hG(ixBtnLeft)=uicontrol( 'Style','edit', 'Units','normalized', ...
        'Position', PosBtnLeft, ...
        'String', LabelStr{ix+1}, ...
        'BackgroundColor', thisBackgroundColour, 'ForegroundColor', 'black' , ...
        'Enable','on');
    set(hG(ixBtnLeft), 'Callback', {@spUpdate, figNr, ParamName{2*(ixA-1)+1}});
    % ---> draw right edit field ---
    % ---------------------------------------
    PosBtnRight = [1-Wbtn-AdX/20 ysym(ixA)-Hbtn/2 Wbtn Hbtn];
    ixBtnRight = nGObjEdit*(ixA-1)+2;
    hG(ixBtnRight)=uicontrol( 'Style','edit', 'Units','normalized', ...
        'Position', PosBtnRight, ...
        'String', LabelStr{ix+2}, ...
        'BackgroundColor', thisBackgroundColour, 'ForegroundColor', 'black' , ...
        'Enable','on' );
    set(hG(ixBtnRight), 'Callback', {@spUpdate, figNr, ParamName{2*(ixA-1)+2}});

    % draw left legend
    PosDescLeft = PosBtnLeft + [0 -Hlbl-AdY/20 0 0];
    PosDescLeft(4) = Hlbl;
    uicontrol( 'Style','text', 'Units','normalized', ...
        'Position', PosDescLeft, 'String', LabelStr{ix+3}, ...
        'BackgroundColor', figBckgndCol, 'ForegroundColor', AreaColour(ixA,:)*MakeDarkerBy);
    
    % draw right legend
    PosDescRight = PosBtnRight + [0 -Hlbl-AdY/20 0 0];
    PosDescRight(4) = Hlbl;
    uicontrol( 'Style','text', 'Units','normalized', ...
        'Position', PosDescRight, 'String', LabelStr{ix+4}, ...
        'BackgroundColor', figBckgndCol, 'ForegroundColor', AreaColour(ixA,:)*MakeDarkerBy);
end

% --- append S-data sp and handle info hG to figNr ---
% ----------------------------------------------------
myhandles = guihandles(figNr);
myhandles.sp = sp;
myhandles.hG = hG;
myhandles.GridOptions = GridOptions;
guidata(figNr,myhandles);
end

function GetS11ReIm(src,evtd, figNr)
% get 1 (x,y) point ->sp
[sRe, sIm] = ginput(1);
% condition this point here, (inside spRecalc would miss the 1st value)
% find polar > limit radius to 1, reconvert...
[TryDeg, TryRad] = cart2pol(sRe, sIm);
[sRe, sIm] = pol2cart(TryDeg, min(TryRad,1-1e-12));  
% init SP, need not recover SP from fig.sp
sp = spRecalc; % init la harneala, will overwrite both Re & Im
sp = spRecalc(sp, 'sRe', sRe);
sp = spRecalc(sp, 'sIm', sIm);
% update data at top, refresh text fields
myhandles = guidata(figNr);
myhandles.sp = sp;
guidata(figNr,myhandles)
StringsUpdate(sp, myhandles.hG)
% as well as the point position in plot (grids first !)
GridRedraw(get(figNr, 'CurrentAxes'), myhandles.GridOptions)
RepositionPoint(sp.sRe, sp.sIm, get(figNr, 'CurrentAxes'))
end

function sp = spRecalc(sp, parName, parVal)
% sp = spRecalc(sp, parName, parValue)
% 
% new, 29.03.2009, for new smith converter
% running fine
if nargin < 1, sp = uConstr('spoint'); end
if nargin < 3, parName = 'r'; parVal = 1; end % vaya data checking... :-)

Zo = 1; % to set later from top ?
eps = 1e-12;

% sp = setfield(sp, parName, parVal); % to improve later
sp.(parName) = parVal;
% now calculate .sRe, .sIm, then only update once
switch lower(parName)
    case 'sre'              % -> S11 input : % bound values 
        % such that radius <= 1-eps !
        % bound Re value, given the Im value 
        vmax = sqrt(1-eps - (sp.sIm)^2);                
        sp.sRe = max(min(sp.sRe,vmax-eps),-vmax+eps); % bound values            
    case 'sim'
        % bound Im value, given the Re value
        vmax = sqrt(1-eps - (sp.sRe)^2);         
        sp.sIm = max(min(sp.sIm,vmax-eps),-vmax+eps);
        
    case 'rad'              % -> polar input bound Radius
        sp.rad = min(sp.rad,1);     % to keep the S-point inside
        [sp.sRe sp.sIm] = pol2cart(sp.deg*pi/180, sp.rad);        
    case 'deg'
        sp.deg = sp.deg - round(sp.deg/360)*360; % wrap ph., remainder only
        [sp.sRe sp.sIm] = pol2cart(sp.deg*pi/180, sp.rad);

    case {'r', 'x'}     % -> Z input: bound point inside (r>0)
        sp.r = max(sp.r, 0);
        z = sp.r + j*sp.x;
        sRI = (z -Zo) / (z +Zo);
        sp.sRe = real(sRI);
        sp.sIm = imag(sRI);
    case {'g', 'b'}     % -> Y input: bound point inside (g>0)
        sp.g = max(sp.g, 0);
        y = sp.g + j*sp.b;
        sRI = (1 -y*Zo) / (1 +y*Zo);
        sp.sRe = real(sRI);
        sp.sIm = imag(sRI);
    case 'rl'           % -> RL input
        sp.rl = min(sp.rl,-eps); % 0-protect this value
        sp.rad = 10^(sp.rl/20);
        [sp.sRe sp.sIm] = pol2cart(sp.deg*pi/180, sp.rad);
    case 'vswr'         % -> VSWR input
        sp.vswr = max(sp.vswr,1); % floor it to 1 (RL<0, inside chart)
        sp.rad = (sp.vswr-1)/(1+sp.vswr);
        [sp.sRe sp.sIm] = pol2cart(sp.deg*pi/180, sp.rad);
    otherwise
        disp('spRecalc > unknown paramater name !')
end

% update all fields using sRe, sIm
 s = sp.sRe + j*sp.sIm;
 % find polar > [rad, deg]
 [sp.deg, sp.rad] = cart2pol(sp.sRe, sp.sIm);
 sp.deg = sp.deg*180/pi; % always display in degrees...
 % find Z > r+jx
 z = (1+s)/(1-s)*Zo;
 sp.r = real(z);
 sp.x = imag(z);
 % find Y > g+jb
 y = (1-s)/(1+s)/Zo;
 sp.g = real(y);
 sp.b = imag(y);
 % find RL, VSWR
 sp.rl = 20*log10(abs(s));
 sp.vswr = (1+abs(s)) / (1-abs(s));

end

function spUpdate(src,evtd, figNr, parName)
% get user value -> based on its meaning recalculate structure sp
% then save sp data to figNr
thisParValue = str2double(get(gcbo, 'string')); % was get(hG, 'string');
myhandles = guidata(figNr);

sp = spRecalc(myhandles.sp, parName, thisParValue);
% update all strings in window
StringsUpdate(sp, myhandles.hG)
% as well as the point position in plot (grids first !)
GridRedraw(get(figNr, 'CurrentAxes'), myhandles.GridOptions)
RepositionPoint(sp.sRe, sp.sIm, get(figNr, 'CurrentAxes'))
% update the changes to the sp structure
myhandles.sp = sp;
guidata(figNr,myhandles)
end

function StringsUpdate(sp, hG)
% refresh all editable field strings in order
%
% hG are the handles of the Text Fields in the GUI
% sp is the impedance data structure that contains the fields :
% 'sRe', 'sIm', 'rad', 'deg', 'r', 'x', 'g', 'b', 'rl' , 'vswr' 
FieldStr = fieldnames(sp);
for ixF = 1:length(FieldStr)
    set(hG(ixF), 'String', sp.(FieldStr{ixF}) )
end

end

function RepositionPoint(sRe, sIm, axesHandle)
hold on
plot(axesHandle, sRe, sIm, 'c+')
plot(axesHandle, sRe, sIm, 'ro')
set(axesHandle, 'YLim', [-1.15 1.15])
set(axesHandle, 'XLim', [-1.15 1.15])

end

function GridToggle(src, evtd, figNr, ToDo)
% this is the new update...
myhandles = guidata(figNr);
GOpt = myhandles.GridOptions; % short..
switch ToDo
    case 'toggle Z'
        GOpt.Z.show = ~GOpt.Z.show;
        ToCheck = GOpt.Z.show;
        % later check/uncheck menu items ?
    case 'toggle Y'
        GOpt.Y.show = ~GOpt.Y.show;
        ToCheck = GOpt.Y.show;
    case 'toggle C'
        GOpt.C.show = ~GOpt.C.show;
        ToCheck = GOpt.C.show;
end
if ~(GOpt.Z.show) && ... % catch for grid:none
        ~(GOpt.Y.show) && ~(GOpt.C.show)
    GOpt.C.show = ~GOpt.C.show;
end
if ToCheck  % eye candy
    set(gcbo, 'checked', 'on')
else
    set(gcbo, 'checked', 'off')
end
myhandles.GridOptions = GOpt;
guidata(figNr,myhandles)

axesHandle = get(figNr, 'CurrentAxes');
GridRedraw(axesHandle, GOpt)
RepositionPoint(myhandles.sp.sRe, myhandles.sp.sIm, axesHandle)
% later fix the nice black background !
hold off;
end

function GridRedraw(TheseAxes, GridOptions)
% GridRedraw(TheseAxes, GridOptions)
%
% form older 't_smith' scripts
if nargin < 2,
    r = [0 0.2 0.5 1 2 5];
    jx = [ -5 -2 -1 -0.5 -0.2 0.2 0.5 1 2 5];
    g = r; jb = jx;
    GridOptions.Z.show = 1;
    GridOptions.Y.show = 1;
    GridOptions.C.show = 1;
else
    r = GridOptions.Z.r;
    jx = GridOptions.Z.jx;
    g = GridOptions.Y.g;
    jb = GridOptions.Y.jb;
end

if nargin < 1, TheseAxes = gca; end

% pick grid values..., could also try
% jx = [-r r]; jx = jx(find(jx)); % to symm, eliminate 0
Tick.r = 'y';
Tick.jx = 'y';
Tick.g = 'g';
Tick.jb = 'g';
% pick resolution ...
Npoints = 256;
ArchFull = (2*pi/Npoints:2*pi/Npoints:2*pi);

% -------------------------------------
% start actual drawing on a blank sheet
% -------------------------------------
hold off, polar(.01, .99, 'k'); hold on

if GridOptions.C.show
     % nada   
else % patch black !
    set(TheseAxes, 'YLim', [-1.15 1.15])
    set(TheseAxes, 'XLim', [-1.15 1.15])
    set(TheseAxes, 'XGrid', 'off')
    set(TheseAxes, 'YGrid', 'off')
    
    Noversamp = 4; % make nice round black patch
    ArchPatch = (2*pi/Npoints/Noversamp:2*pi/Npoints/Noversamp:2*pi);
    xd = cos(ArchPatch);
    yd = sin(ArchPatch);
    
    zout = 1.9;
    fill(xd*zout, yd*zout, [1 1 1]*0.2)
    fill(xd, yd, [0 0 0])
    % draw horizontal line, jX = jB = 0
    plot([-1 1], [0 0], 'w:');  
    % draw r=0 circle
    plot(xd, yd, 'w:'); 
end

if GridOptions.Z.show
    circles.center_r = r./(r+1);
    circles.radius_r = 1./(r+1);
    nr = max(size(r));
    
    % draw R circles ... xd, yd are the dot values, to be overwritten
    axes(TheseAxes) % draw where allowed
    
    for i = nr:-1:1 % so as to use r=1 at end
        % generate some dotted points
        % next as a function of scale...
        xd = cos(ArchFull)*circles.radius_r(i) + circles.center_r(i);
        yd = sin(ArchFull)*circles.radius_r(i);
        plot(xd, yd, [Tick.r, ':']); hold on;
    end;
    
    % draw jX circles
    circles.center_jx = 1./jx; % this is its y coord; x is always 1 !
    circles.radius_jx = abs(circles.center_jx); % for clarity
    njx = max(size(jx));
    for i = 1:njx
        R2 = circles.radius_jx(i);
        Cx2 = 1; Cy2 = circles.center_jx(i);

        % calculate intersections of (1,circles.radius_jx), r= circles.radius_jx
        % with (0,0),r=1... see developement lower, at end
        R1 = 1; Cx1 = 0; Cy1 = 0; % to write it into a function later
        [xi1, yi1, xi2, yi2] = uCircleInt(Cx1, Cy1, R1, Cx2, Cy2, R2);

        % calculate angles of intersection points as in the jX circle
        alpha = [atan2(yi1-Cy2,xi1-Cx2) atan2(yi2-Cy2,xi2-Cx2)];
        Arch = uPickSmallerArch(alpha, 2*pi/Npoints/max(1,R2));
        xd = cos(Arch)*R2 + 1;
        yd = sin(Arch)*R2 + Cy2;
        plot(xd, yd, [Tick.jx, ':']); hold on;
    end;
end

if GridOptions.Y.show
    % draw horizontal line, jX = 0
    %plot([-1 1], [0 0], 'w:');

    % G circles : centru (-g/(g+1),0), raza 1/(1+g)
    % B : (-1,-1./b), r^2= 1/b^2

    % --- draw G circles ... xd, yd are the dot values, to be overwritten
    circles.center_g = -g./(g+1);
    circles.radius_g = 1./(g+1);
    nr = max(size(g));
    ArchFull = (-pi+2*pi/Npoints:2*pi/Npoints:pi);
    for i = 1:nr
        % generate some dotted points, but from -pi,pi,
        % so that the 0 point is filled in
        xd = cos(ArchFull)*circles.radius_g(i) + circles.center_g(i);
        yd = sin(ArchFull)*circles.radius_g(i);
        plot(xd, yd, [Tick.g, ':']); hold on;
    end;

    % --- draw jB circles ---
    % -----------------------
    circles.center_jb = -1./jb; % this is its y coord; x is always -1 !
    circles.radius_jb = abs(circles.center_jb); % for clarity
    njb = max(size(jb));
    for i = 1:njb
        R2 = circles.radius_jb(i);
        Cx2 = -1; Cy2 = circles.center_jb(i);

        % calculate intersections of (0,0),r=1...with
        % (1,circles.radius_jx), r= circles.radius_jx
        R1 = 1; Cx1 = 0; Cy1 = 0;
        [xi1, yi1, xi2, yi2] = uCircleInt(Cx1, Cy1, R1, Cx2, Cy2, R2);
        %plot([xi1 xi2], [yi1 yi2], 'r+')

        % calculate angles of intersection points as in the jX circle
        alpha = [atan2(yi1-Cy2,xi1-Cx2) atan2(yi2-Cy2,xi2-Cx2)];
        Arch = uPickSmallerArch(alpha, 2*pi/Npoints/max(1,R2));
        xd = cos(Arch)*R2 - 1;
        yd = sin(Arch)*R2 + Cy2;
        plot(xd, yd, [Tick.jb, ':']); hold on;

    end;
end

axis off;  % hold off; to add the point !

end

function Arc = uPickSmallerArch(alpha, resolution)
% picks smaller arc between alpha(2) and alpha(1)
% for smithcharts
%
% 16.12.2007 - new
% 21.02.2009 - cleanup, include in SZYconv

if nargin < 1
    alpha = [.9 -0.5]*pi; disp('>t_order: no arg passed !!!')
end;
if nargin < 2, resolution = pi/90; end; % lamishto, 2deg

d0 = alpha(2) - alpha(1);
d0 = d0-round(d0/2/pi)*2*pi; % unwrap excess 2*pi -> [-pi,pi)

if d0 > 0
    % 1 -> 2
    start_value = alpha(1);
    end_value = alpha(2); % only when grid not fine enough...
else
    % 2 -> 1
    start_value = alpha(2);
    end_value = alpha(1);
end;

Arc = (start_value : resolution : start_value + abs(d0));
if Arc(end) ~= end_value % if grid not fine enough...
    Arc = [Arc end_value];
end;

end

function [x1, y1, x2, y2] = uCircleInt(Cx1, Cy1, R1, Cx2, Cy2, R2, Verbose)
%[x1, y1, x2, y2] = uCircleInt(Cx1, Cy1, R1, Cx2, Cy2, R2, Verbose);
%
% circle intersection
%
% 16.12.2007    - new, for smith
% 21.02.2009    - cleanup, include in SZY

if nargin < 7, Verbose = 1; end; %
if nargin < 6, R2 = 0; end; %
if nargin < 5, Cy2= 0; end;
if nargin < 4, Cx2= 0; end;
if nargin < 3, R1 = 0; end; % etc, add later

% take origin as centre of circle 1, calculate d, xa, ya (common chord)
% then transform at end coords !

% init with zeros... for non-intersection (complex)
x1=0; y1=0; x2=0; y2=0;

% 0. --- calc distance, check it vs. R1, R2
dsq = (Cx2-Cx1)^2 + (Cy2-Cy1)^2;
d = sqrt(dsq);
if d >(R1+R2) % exteriour circles
    if Verbose, disp(' -> uCercleInt : exteriour circles !'); end;
elseif d < abs(R1-R2) % interiour circles
    if Verbose, disp(' -> uCercleInt : interiour circles !'); end;
else % continue normally
    % 1. --- do simple problem, {(0,0), R1 (d,0) R2 }
    xa = (dsq + R1^2 - R2^2)/2/d;
    ya_half_sq = R1^2 -(dsq + R1^2 - R2^2)^2/4/dsq; % half chord squared
    ya = sqrt(ya_half_sq);

    % 2. --- rotate by theta ---
    theta = atan2(Cy2-Cy1, Cx2-Cx1);
    cost = cos(theta);
    sint = sin(theta);
    rotM = [ cost -sint; sint cost];
    xy1 = rotM * [xa ya]';
    xy2 = rotM * [xa -ya]';

    % 3. --- translate from (0,0) to (Cx1, Cy1)---
    x1 = xy1(1) + Cx1;
    y1 = xy1(2) + Cy1;
    x2 = xy2(1) + Cx1;
    y2 = xy2(2) + Cy1;
end;

end

function obj = uConstr(what)
% 'constructor' function

if nargin < 1, what = 'GridOptions'; end

switch lower(what)
    case 'gridoptions'
        obj.Z.r = [0.2 0.5 1 2 5];
        obj.Z.jx = [ -5 -2 -1 -0.5 -0.2 0.2 0.5 1 2 5];
        obj.Y.g = obj.Z.r;
        obj.Y.jb = obj.Z.jx;
        obj.Z.show = 0;
        obj.Y.show = 1;
        obj.C.show = 1;
    case 'spoint'
        eps = 1e-12;        
        obj.sRe = eps;
        obj.sIm = 0;
        obj.rad = 0;
        obj.deg = 0; % not ang, radians !
        obj.r = 0;
        obj.x = 0;
        obj.g = 0;
        obj.b = 0;
        obj.rl = 0; %
        obj.vswr = 1;
        obj = spRecalc(obj, 'sIm', 0);
end
end

function uQuickStart(src, evtd, ToDo)
switch ToDo
    case 'QuickStart'
        str = {'SZYconv - S-parameter converter and smith chart/ polar chart plotter', ...
            ' ', ...
            'it accepts graphical and text input in a variety of formats', ...
            ' ', ...
            'text input/output into the following formats:', ...
            ' ', ...
            '    - GAMMAIN, a.k.a. S_in, S11, input reflection coefficient', ...
            '      > RI, real & imaginary', ...
            '      > MA, magnitude & angle (degrees)', ...
            '    - Z <ohms>, input impedance, normalized', ...
            '    - Y <mS>, input admittance, normalized', ...
            '    - RL, return loss (dB)', ...
            '    - VSWR, voltage standing-wave ratio ', ...
            ' ', ...
            'changing one input will automatically update', ...
            'all the fields as well as the point position', ...
            ' ', ...
            'for graphical input/output click on the chart :', ...
            '    - 1st time in order to get the haircross cursor', ...
            '    - 2nd time in order to actually input the data point', ...
            'one can also toggle the grid (polar, smith Z, smith Y)', ...
            ' ', ...
            'original files : cca. 1997 (let''s say v 1.0 :-)) )', ...
            'v. 1.1  - 15.12.2007, RL & VSWR added as inputs', ...
            '        - kept inside this distribution, it works in matlab 4.*', ...
            'v. 2.0  - 27.04.2009, added toggable smith chart grids (Z and Y) ', ...
            ' ', ...
            'written by Tudor Dima,', ...
            'contact : tudima@yahoo.com'};
    case 'About'


        str = {'SZYconv - S-parameter converter, smith chart/ polar chart plotter', ...
            'v. 2.0, - 27.04.2009', ...
            ' ', ...
            'v. 1.1  - works in matlab 4.* ', ...
            '        - preserved with this distribution in directory /SZYconv_v1.1', ...
            ' ', ...
            'written by Tudor Dima, tudima@yahoo.com'};

end

clc,
for i = 1:length(str)
    fprintf('%s\n', str{i})
end
end