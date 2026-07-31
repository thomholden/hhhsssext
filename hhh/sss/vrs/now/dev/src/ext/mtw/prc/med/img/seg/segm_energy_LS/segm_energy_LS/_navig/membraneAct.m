function varargout = membraneAct(varargin)
% varargout = membraneAct(ACTION, data, varargin)
% ACTION can be 'mask2vertices', 'plot', 'draw', 'arrows2mask'
% (other options only in debug)
%
% 22.04.2012    - slimmed down version of 22.04.2011, for 2D segm_energy_LS

%   > CONVERT MASK to VERTICES
% M = membraneAct('mask2vertices', SPHI); % SPHI boolean
% M = membraneAct('mask2vertices', M); % if M init., M.SPHI not empty
%   > PLOT YvXv (NEW, optimized), i.e. vertices calculated with 'mask2vertices'
% membraneAct('plot', M, 'fig', 997, 'color', 'r', 'width', 2)
% membraneAct('plot', M, 'xy_origin', [10 10]) % useful in zoom plots, etc
%   > DRAW
% M = membraneAct('draw', 'figNo', 773, 'color', 'b', 'width', 2);
%
% M is a structure with the fields:
%   M.mask  : boolean matrix
%   M.YvXv  : vertices to plot using
%   M.Stale : boolean, set when re-calculation is forced
% 	M.Arrows: 'old'style - binary arrows of membrane(s)
% 	M.XbYb  : 'old'style - their origins (bases)
%	M.YvXv  : 'old'style - points to plot 'old'
% 	M.XsYs 	: 'safe'style - points to plot 'safe'

switch varargin{1}
    % === NEW === optimized style
    case {'mask2vertices'}
        if isstruct(varargin{2})
            m_out = varargin{2};
        else
            m_out = uConstruct('membrane');
            m_out.mask = varargin{2};
        end
        if isempty(m_out.mask), error('membrane> no mask passed'), end

        m_out.YvXv = uMask2YvXv(m_out.mask);
        varargout{1} = m_out;
    case 'plot'
        PlotParam = uHandlePlotParam(varargin{3:end});
        uPlotM(varargin{2}, PlotParam)

        % === DRAW === convert mouse clicks to arrows
    case 'draw'
        % writes the drawn membrane in fields .Arrows and .XbYb
        PlotParam = uHandlePlotParam(varargin{2:end});
        m_out = uConstruct('membrane');
        [Arrows, XbYb] = uDrawMembrane(PlotParam);
        if ~isempty(Arrows{1}) % actual export (2x Esc results in empty)
            m_out.Arrows = Arrows;
            m_out.XbYb = XbYb;
        end
        varargout{1} = m_out;

        % === FILL === drawn contour
    case 'arrows2mask'
        FillParam = uHandleFillParam(varargin{3:end});
        m_out = varargin{2};        
        m_out.mask = uArrows2Mask(m_out.Arrows, ...
            m_out.XbYb, FillParam.MaskSize, FillParam.ForceTrueInside);
        varargout{1} = m_out;

    otherwise
        disp(['membrane: unrecognized action(' varargin{1} ')'])
end
end

function PlotParam = uHandlePlotParam(varargin)
% assign some defaults
PlotParam.FigNo = 999;
PlotParam.Color = 'b';
PlotParam.LineWidth = 2;
PlotParam.Style = 'normal'; % or 'pcolor' ?
PlotParam.XY_off = []; % if empty then plot full view
% take 2 by 2 keywords, assign values
nIn = size(varargin,2);
if mod(nIn, 2)
    nIn = nIn-1;
end
nP = nIn/2;
for i=1:nP
    switch lower(varargin{2*i-1})
        case {'figno', 'fig'}
            PlotParam.FigNo = varargin{2*i};
        case {'color', 'colour', 'linecolor'}
            PlotParam.Color = varargin{2*i};
        case {'linewidth', 'line width', 'width', 'thickness'}
            PlotParam.LineWidth= varargin{2*i};
        case {'style', 'imagedisplay'}
            PlotParam.Style= varargin{2*i};
        case {'xy_origin', 'xoyo'}
            PlotParam.XY_off= varargin{2*i};
        otherwise
            disp('membraneAct> uPlotCheap> uHandlePlotParam: unrecognized plot parameter')
    end
end
end

function FillParam = uHandleFillParam(varargin)
% assign some defaults
FillParam.MaskSize = [0 0];
FillParam.ForceTrueInside = true;
nIn = size(varargin,2);
if mod(nIn, 2)
    nIn = nIn-1;
end
nP = nIn/2;
for i=1:nP
    switch lower(varargin{2*i-1})
        case {'masksize', 'size'}
            FillParam.MaskSize = varargin{2*i};
        case {'forcefill', 'forcetrueinside'}
            FillParam.ForceTrueInside = logical(varargin{2*i});
    end
end
end
%% functions for the OPT/NEW part
function YvXv = uMask2YvXv(sphi) % new, to phase out old one :-)
% shift U/D, L/R, store all :-)
% dim: 1/2 := y/x, sense 1/2 := -/+ (L/R, D/U)
% matrix = [D U; L R]
%opt_SearchDyn = 2;

[nR, nC] = size(sphi);
if all(sphi(:)) || ~any(sphi(:))
    YvXv = {};
    return
end
ArrowOfPixel = false(nR, nC, 2, 2); % on dims 3,4 will store a 1 in case
% the pixel is adjacent to an Arrow D/U/L/R (columnwise {ixDim,ixSense+1})

Contour{2,2} = 0;
nArrows = 0;
IxWipe = (1:nR:nR*(nC-1)+1); % 1st row, D
Ix2WipeContours{1,1} = IxWipe; % 1st
Ix2WipeContours{1,2} = IxWipe+nR-1; % last row, when U
IxWipe = (1:nR); % first col, L
Ix2WipeContours{2,1} = IxWipe;
Ix2WipeContours{2,2} = nR*nC-nR+1:nR*nC;% last col, when R
% shift on Y D/U, on X L/R, compare with original, mark accordingly
% shifting: "-" (D and L), '+' (U/R)
for ixDim = 1:2 % Y/X
    for ixSense = [0 1] % D/U, L/R
        % detect contour, keep only the inside portion
        Contour{ixDim,ixSense+1} = sphi & ...
            xor(sphi, bShift2DMask(sphi, ixDim, ~ixSense));
        %wipe edges correspondingly (1st row D, last U, 1st col L, last R)
        Contour{ixDim,ixSense+1}(Ix2WipeContours{ixDim,ixSense+1}) = false;
        nArrows_this = sum(Contour{ixDim,ixSense+1}(:));
        ArrowOfPixel(:, :, ixDim, ixSense+1) = Contour{ixDim,ixSense+1};
        %Ind{ixDim,ixSense+1} = IxThis; % 2-by-N
        nArrows = nArrows + nArrows_this;
    end
end

StillLookingForMembranes = true;
pMembrane = 0;
nPosArr = 4*nR*nC;
nIt = 0;
% now pick a trigger, parse it;
% while assigning arrows, delete them from ArrowOfPixel
Ix_TrigLast = 0;
while StillLookingForMembranes && nIt < 2*nArrows
    % find a trigger ... was switch opt_SearchDyn
    FoundTrigger = false;
    for IxTrig = Ix_TrigLast+1:nPosArr
        if ArrowOfPixel(IxTrig)
            FoundTrigger = true;
            break
        end
    end
    if ~FoundTrigger, break, end % i.e. no more arrows left
    % which should be an error if nIt < nArrrows, check later

    Ix_TrigLast = IxTrig; % advance it for the next trigger search
    [i_trig,j_trig,ixD_trig,ixS_trig] = ind2sub([nR, nC, 2, 2], IxTrig);
    % -> reset this ArrowOfPixel !
    ArrowOfPixel(IxTrig) = false;

    bDim = ixD_trig-1; % binary orientation of the trigger arrow
    bSense = (ixS_trig-1);
    % initialize YvXv of this membrane
    YvXv_t = zeros(nArrows-nIt+1,2, 'single');
    YvXv_t(1:2,:)= uInitArr(i_trig, j_trig , bDim, bSense); % isRight at ini

    isR = true; % i.e. MaskIsRight, will flip if hitting edges...
    % execute this trigger, store result at poz. pMembrane
    pMembrane = pMembrane +1;
    pArrInMembr = 2;
    MembraneClosed = false;
    DirectionChangedOnce = 0;
    i_c = i_trig;
    j_c = j_trig;
    while ~MembraneClosed % && (DirectionChanges < 2)
        % go on parsing, D,U,L,R are in matrix convention, not image!
        % --- test turning 'RIGHT'
        % ========================
        TestRightNotLeft = true;
        pixOff  = [0 0];
        if ~isR % 0 when mask on Right
            pixOff = uArr2PixOff(bDim, bSense, TestRightNotLeft);
        end

        i_t = i_c+pixOff(1);
        j_t = j_c+pixOff(2);
        HitBorder = i_t < 1 || i_t > nR || j_t < 1 || j_t > nC;
        if HitBorder % 1st time flip YvXv & isR then continue
            % 2nd time close the membrane
            [YvXv_t, isR, DirectionChangedOnce, MembraneClosed] = ...
                uTestAndFlip(YvXv_t, isR, pArrInMembr, DirectionChangedOnce);
            % reset arrow to the original trigger's, keep dim, flip sense
            bDim = ixD_trig-1;
            bSense = (ixS_trig-1); % don't flip...
            % reset i_c, j_c to the trigger
            i_c = i_trig;
            j_c = j_trig;
            continue
        end

        % find next arrow's orientation, update if successful
        [bDim_next, bSense_next] = uTurnLeftNotRight(bDim, bSense, ~TestRightNotLeft);
        GoRight = ArrowOfPixel(i_t,j_t,bDim_next+1,bSense_next+1);

        if GoRight % is really ---INCurve---
            vOff = uVertexOff(bDim, bSense, TestRightNotLeft, isR);
            YvXv_t(pArrInMembr+1,:) = YvXv_t(pArrInMembr,:) + vOff;
            pArrInMembr = pArrInMembr + 1;
            % -> reset this ArrowOfPixel !
            ArrowOfPixel(i_t,j_t,bDim_next+1,bSense_next+1) = false;
            % -> update binary arrow orientation (bSense, bDim) ---
            bDim = bDim_next;
            bSense = bSense_next;
            % update current i_c,j_c
            i_c = i_t;
            j_c = j_t;

        else % --- test LEFT ---% is really ---OUTCurve---
            % ===================
            % use the _same_ arrow, but on an adjacent pixel
            TestRightNotLeft = false;
            pixOff  = [0 0];
            if isR % 0 when mask on LEFT
                pixOff = uArr2PixOff(bDim, bSense, TestRightNotLeft);
            end

            i_t = i_c+pixOff(1);
            j_t = j_c+pixOff(2);
            HitBorder = i_t < 1 || i_t > nR || j_t < 1 || j_t > nC;
            if HitBorder % 1st time flip YvXv & isR then continue
                % 2nd time close the membrane
                [YvXv_t, isR, DirectionChangedOnce, MembraneClosed] = ...
                    uTestAndFlip(YvXv_t, isR, pArrInMembr, DirectionChangedOnce);
                % reset arrow to the original trigger's, keep dim, flip sense
                bDim = ixD_trig-1;
                bSense = (ixS_trig-1); % don't flip...
                % reset i_c, j_c to the trigger
                i_c = i_trig;
                j_c = j_trig;
                continue
            end
            % xform inArr to presumed outArr (T2)
            [bDim_next, bSense_next] = uTurnLeftNotRight(bDim, bSense, ~TestRightNotLeft);
            GoLeft = ArrowOfPixel(i_t,j_t,bDim_next+1,bSense_next+1);
            if GoLeft
                vOff = uVertexOff(bDim, bSense, TestRightNotLeft, isR);
                YvXv_t(pArrInMembr+1,:) = YvXv_t(pArrInMembr,:) + vOff;
                pArrInMembr = pArrInMembr + 1;
                % -> reset this ArrowOfPixel !
                ArrowOfPixel(i_t,j_t,bDim_next+1,bSense_next+1) = false;
                % update current i_c,j_c, binary arrow's orientation
                i_c = i_t;
                j_c = j_t;
                bDim = bDim_next;
                bSense = bSense_next;

            else % test 'through', SRT8 :-)
                % =========================
                pixOff = [0 0];
                pixOff(~bDim+1) = (xor(xor(bDim, ~isR), bSense)-0.5)*2;
                i_t = i_c+pixOff(1);
                j_t = j_c+pixOff(2);
                HitBorder = i_t < 1 || i_t > nR || j_t < 1 || j_t > nC;
                if HitBorder % 1st time flip YvXv & isR then continue
                    % 2nd time close the membrane
                    [YvXv_t, isR, DirectionChangedOnce, MembraneClosed] = ...
                        uTestAndFlip(YvXv_t, isR, pArrInMembr, DirectionChangedOnce);
                    % reset arrow to the original trigger's, keep dim, flip sense
                    bDim = ixD_trig-1;
                    bSense = (ixS_trig-1); % don't flip...
                    % reset i_c, j_c to the trigger
                    i_c = i_trig;
                    j_c = j_trig;
                    continue
                end

                % arrow: same orientation as input, pixel offset
                GoStr8 = ArrowOfPixel(i_t,j_t,bDim+1,bSense+1);
                if GoStr8 % advance
                    %vOff = [0 0]; % same as pix_off :-)
                    %vOff(~bDim+1) = (xor(xor(bDim, ~isR), bSense)-0.5)*2;
                    % use as vertexOffset the pixOffset already calculated before !
                    YvXv_t(pArrInMembr+1,:) = YvXv_t(pArrInMembr,:) + pixOff;
                    pArrInMembr = pArrInMembr + 1;
                    % -> reset this ArrowOfPixel !
                    ArrowOfPixel(i_t,j_t,bDim+1,bSense+1) = false;
                    i_c = i_t;
                    j_c = j_t;
                    % keep the orientation (bDim, bSense)
                else % should only get inside this when
                    % the membrane closes normally
                    MembraneClosed = true;
                end

            end
        end % of one Arrow advancement
    end % of one closed contour detection
    % store this (closed) membrane, pack them better later
    YvXv{pMembrane} = YvXv_t(1:pArrInMembr,:);
    nIt = nIt + pArrInMembr;

end

% name tDim tSense  nameR/L dR sR  dR = ~tDim
% D     0 1  0 -1    L /R   1  0  sR = xor(tDim,tSense)
% U     0 1  1 1     R /L   1  1  sL = ~xor
% L     1 2  0 -1    U /D   0  1
% R     1 2  1 1     D /U   0  0
end
function YvXv = uInitArr(i,j,bDim,bSense)
% base init................... this Arr
%  D    i-0.5   j+[0.5 -0.5]    R
%  U    i+0.5   j+[-0.5 0.5]    R
%  L    i+[-0.5 0.5]    j-0.5   U
%  R    i+[0.5 -0.5]    j+0.5   U
% Arrow Orientation is kept the same (bDim,bSense)
% and this convention sets isRight to TRUE

offset = zeros(2);
% add shift on this Direction
offset(:,bDim+1) = (bSense-0.5)*[1 1];
% add polar onto perpendicular direction
offset(:,~bDim+1) = (xor(bDim, bSense)-0.5)*[-1 1];

YvXv = [i j; i j] + offset;
% was :
%YvXv(bDim+1, :) = YvXv(bDim+1, :) + (xor(bDim, bSense)-0.5)*[1 1];
%YvXv(~bDim+1, :) = YvXv(~bDim+1, :) + (~bSense-0.5)*[-1 1];

%offset(bDim+1, :) = (xor(bDim, bSense)-0.5)*[1 1];
%offset(~bDim+1, :) = (~bSense-0.5)*[-1 1];

end
function [bD, bS] = uTurnLeftNotRight(bDim, bSense, TurnLeftNotRight)
bD = ~bDim;
bS = xor(xor(TurnLeftNotRight, bDim), bSense);
end
function pixOff = uArr2PixOff(bDim, bSense, TurnRNotL)
pixOff(TurnRNotL+1) = (xor(TurnRNotL, xor(bSense, bDim))-0.5)*2;
pixOff(~TurnRNotL+1) = (bSense-0.5)*2;
end
function vOff = uVertexOff(bDim, bSense, TurnRNotL, isR)
vOff = [0 0];
vOff(bDim+1) = (xor(bSense, ~xor(TurnRNotL, isR))-0.5)*2;
end
function [YvXv, isR, DirectionChangedOnce, MembraneClosed] = ...
    uTestAndFlip(YvXv, isR, pArrInMembr, DirectionChangedOnce)

if ~DirectionChangedOnce
    MembraneClosed = false;
    DirectionChangedOnce = true;
    % flip, continue, test this assumption...
    YvXv(1:pArrInMembr,:) = ...
        YvXv(pArrInMembr:-1:1,:);
    isR = ~isR;
else
    MembraneClosed = true;
end
end

function uPlotM(varargin)
if nargin > 1
    PlotParam = varargin{2};
else
    PlotParam = uHandlePlotParam();
end
nM = size(varargin{1}.YvXv, 2);
ZoomPlot = ~isempty(PlotParam.XY_off);
if ZoomPlot, XY_off = PlotParam.XY_off; end

figure(PlotParam.FigNo), hold on
%RainbowCol = {'r', 'g', 'b', 'm', [0 0.5 0]};
%Styles = {':', '.', '-.'};

for ixM = 1:nM
    points{2} = [];
    for ixy = 1:2
        points{ixy} = varargin{1}.YvXv{ixM}(:,ixy);
        if ZoomPlot
            points{ixy} = points{ixy} - XY_off(ixy);
        end
    end
    plot(points{2}, points{1}, PlotParam.Color, ...
        'LineWidth', PlotParam.LineWidth)
    % was
    %plot(points{2}, points{1}, [RainbowCol{rem(ixM,5)+1} Styles{rem(ixM,3)+1}], ...
    %    'LineWidth', PlotParam.LineWidth + rem(ixM,2))
    clear points
    %    plot(varargin{1}.YvXv{ixM}(:,2), varargin{1}.YvXv{ixM}(:,1), ...
    %        PlotParam.Color, 'LineWidth', PlotParam.LineWidth)
end
hold off
end

%% new bit, DRAW !
function [m, xbyb] = uDrawMembrane(PlotParam)
% from older drawMembraneView(figNo), v. of 18.11, or 11.12.2008 :-)
%
% draw membranes on image, store them as origin+sequence (OLD style, _thin_)
% xbyb(ixm,:)   - origin of membrane ixm, 1 by 2 (x,y)
% m{ixm}        - sequence of membrane ixm, length-by-2
%
% should calculate points on the fly!!! (so one can update 
% XbYb when arrows cancel at trigger)

disp('click desired contour points, end membrane with R-click (ENTER)');
disp('then click once to input another membrane, or hit any key to end membrane drawing')
KeepAddingMembranes = 1;
CurrentM = 1;
ArrowOffset = [0.5 0.5];

figure(PlotParam.FigNo)
while KeepAddingMembranes
    KeepAddingPoints2M = 1;
    % get points for 1st segment, calc:
    [x_o, y_o] = ginput(2);
    % round them to offsets... better 0.5 later
    x = ceil(x_o-1);
    y = ceil(y_o-1);
    
    xy_orig = [x(1) y(1)];
    xy_last = [x(2) y(2)];
    mThis = uDrawSegmentOpt(xy_orig, xy_last);

    plSegment(mThis, xy_orig+ArrowOffset, PlotParam.FigNo, ...
        PlotParam.Color, PlotParam.LineWidth)

    while KeepAddingPoints2M
        [x_o, y_o, button] = ginput(1);
        if button == 1 % normal behviour
            % round points to integer (pixel centers)
            xy_h = ceil([x_o y_o]-1);           
            m_segment = uDrawSegmentOpt(xy_last, xy_h);
            plSegment(m_segment, xy_last+ArrowOffset, PlotParam.FigNo, ...
                PlotParam.Color, PlotParam.LineWidth)            
            % update x, y
            xy_last = xy_h;
        else % end of membrane detected
            KeepAddingPoints2M = 0;
            % add a last segment to close membrane
            m_segment = uDrawSegmentOpt(xy_last, xy_orig);
            plSegment(m_segment, xy_last+ArrowOffset, PlotParam.FigNo, ...
                PlotParam.Color, PlotParam.LineWidth)
        end
        mThis = [mThis; m_segment];
    end
    % cleanup adjacent opposite sign arrows here
    % ------------------------------------------
    % 1st: at trigger point, special
    FoundAdj = true;
    while FoundAdj
        FoundAdj = (mThis(1,1)==mThis(end,1)) && ... % same dir
            xor(mThis(1,2), mThis(end,2)); % opp sense
        if FoundAdj % eliminate them
            % update xy_orig...
            mThis = mThis(2:end-1);
        end
    end
    % 2nd: all along
    FoundAdj = true;    
    while FoundAdj
        FoundAdj = false;
        nArr = size(mThis,1); % always Even!
        iO = 1:nArr-1; %
        ThruDir = ~xor(mThis(iO,1), mThis(iO+1,1));
        indThDir = iO(ThruDir);
        % now check which of these have a flipped next
        indFlippedSense = xor(mThis(indThDir,2),mThis(indThDir+1,2));
        indRemove = indThDir(indFlippedSense);
        if ~isempty(indRemove)    % remove found pairs
            FoundAdj = true;
            ixKeep = true(nArr,1);
            ixKeep(indRemove) = false;
            ixKeep(indRemove+1) = false;
            mThis = mThis(ixKeep,:);
        end
    end
    % --- store trimmed membrane
    m{CurrentM} = mThis;
    xbyb(CurrentM,:) = xy_orig+ArrowOffset;

    % try to see if user wants another membrane
    keydown = waitforbuttonpress;
    if (keydown == 0)
        disp('Mouse click -> Draw the next membrane, end with R-click');
        CurrentM = CurrentM+1;
    else
        disp('Key press -> end of drawing');
        KeepAddingMembranes = 0;
    end
end

end

function ms = uDrawSegmentOpt(xy1, xy2)
% trace 1 linear section between the two points
%
% 23.02.2011    - ok drawing, to sort out adjacent opposite
%arrows
% from older drawMembraneView(figNo), v. of 18.11, or 11.12.2008 :-)
% at its turn from older frontSegment, v. of 01.05.2008 (now _that_'s OLD)
NewRenderStyle = true;
if nargin < 2
    disp('error > uDrawSegmentOpt : insufficient input arguments')
end
xy12 = [xy1; xy2]; % will update call
dxy = diff(xy12);
% store sense, take modulus
SenseAll = dxy>0;
DirAll = [1 0]; % X,Y := H,V, 1,0
SpanAll = abs(dxy);
[v, dShort] = min(SpanAll);
dLong = ~(dShort-1) + 1;
s_LS = SenseAll([dLong dShort]);
d_LS = DirAll([dLong dShort]);
span_LS = SpanAll([dLong dShort]);

% nCh is the no. of direction changes -- will Dither
R_LS = fix(span_LS(1)/span_LS(2));
nExcArr = rem(span_LS(1), span_LS(2));
ShortSpan = span_LS(2);
LongSpan = span_LS(1);
LongDim = d_LS(1); ShortDim = d_LS(2);
LongSense = s_LS(1);  ShortSense = s_LS(2);
nA_S = ShortSpan; % kk


%init branch, d, s
nArr = sum(span_LS);
d_section = false(1,nArr);
s_section = false(1,nArr);
ptrArr = 0;

if NewRenderStyle % dither R_LS, R_LS+1
    % cut in nA_S+1 sections, round...
    if nA_S > 0 % non-grid line
        dPix = ones(1,nA_S)*R_LS;
        if nExcArr > 0
            So = nA_S/(nExcArr+1);
            mskDither = ceil(So:So:nA_S-1);
            dPix(mskDither) = R_LS+1;
        end
        for i = 1:ShortSpan
            % lay R/R+1 long arrows, 1 shor arrow
            nA_L = dPix(i);
            d_section(ptrArr+1:ptrArr+nA_L+1) = ...
                [repmat(LongDim, [1 nA_L]) ShortDim];
            s_section(ptrArr+1:ptrArr +nA_L+1) = ...
                [repmat(LongSense, [1 nA_L]) ShortSense];
            ptrArr = ptrArr +nA_L+1;
        end
    else % one long H/V line :-)
        d_section(1:nArr) = LongDim;
        s_section(1:nArr) = LongSense;
    end
    
else % old dy = R_LS*dx + nExcArr decomposition
    if abs(ShortSpan) % verify whether not degenerated (H/V line)
        for s = 1:ShortSpan
            d_here = [repmat(LongDim, [1 R_LS]) ShortDim];
            s_here = [repmat(LongSense, [1 R_LS]) ShortSense];
            d_section(ptrArr+1:ptrArr+R_LS+1) = d_here;
            s_section(ptrArr+1:ptrArr+R_LS+1) = s_here;
            ptrArr = ptrArr+R_LS+1;
        end

        if nExcArr % last step :
            d_here = repmat(LongDim, [1 nExcArr]);
            s_here = repmat(LongSense, [1 nExcArr]);
            d_section(ptrArr+1:ptrArr+nExcArr) = d_here;
            s_section(ptrArr+1:ptrArr+nExcArr) = s_here;
        end;
    else % dy 1-steps, simplu :-)
        d_section = repmat(LongDim, [1 LongSpan]);
        s_section = repmat(LongSense, [1, LongSpan]);
    end;
end
ms = [d_section' s_section'];
end

%% Arrows to Binary MASK
function sphi = uArrows2Mask(Arrows, XbYb, MaskSize, ForceTrueInside)
% forget nMembrOrSphi2Dist, write new, no Dist needed...
if nargin < 4, ForceTrueInside = false; end
% when ForceTrueInside FALSE one can select the mask polarity:
%   - draw anti-clockwise the "full" contours (filled with TRUE)
%   - draw the "empty" ones clockwise (filled with TRUE)
% when ForceTrueInside TRUE one can draw disjunct objects in any rotating
% sense and they will be filled with TRUE (the background will be FALSE)

nR = MaskSize(1);
nC = MaskSize(2);
nM = size(Arrows,2); % jives with XbYb
sphi = false(MaskSize);
sphi_out = false(MaskSize);
% find individual membrane lengths -> to place outputs of iniFront
nP = zeros(1,nM);
for i=1:nM
    nP(i) = size(Arrows{i},1);
end

% do each Membrane in the collection {Arrows}
for i = 1:nM
    [fr_I_t, fr_O_t] = uIni_Front(Arrows{i}, XbYb(i,:), ForceTrueInside);
    nFp = size(fr_I_t,1);
    for iP = 1:nFp
        sphi(fr_I_t(iP,1),fr_I_t(iP,2)) = true;
        sphi_out(fr_O_t(iP,1),fr_O_t(iP,2)) = true;
    end
end

% shift and mark...
AddingPixels = true;
nIt = 0;
while AddingPixels && (nIt <= 2*(nR+nC))
    % shift and mark UDLR
    next_sphi = sphi;
    for ixDim = [1 2] % Y/X
        for ixSense = [-1 1] % D/U, L/R
            % detect contour, keep only the inside portion
            next_sphi(bShift2DMask(sphi, ixDim, ixSense)) = true;
        end
    end
    % remove FrontOut
    next_sphi(sphi_out) = false;
    % detect activity
    AddingPixels = any(xor(sphi(:), next_sphi(:)));
    sphi = next_sphi;
    nIt = nIt + 1; % some crude dummy protection
end

end
function [front_In, front_Out] = uIni_Front(Arr, XbYb, ForceTrueInside)
% [front_In, front_Out] == [front_L front_R] if
% parses ONE DRAWN membrane, inits. the two I/O fronts separated by the
% membrane {i.e. Arr and their XbYb origin,(1-by-2)}
%
% use the classical sign conventions
%   direction (0,1) <=> (V,H), (y,x) a.k.a (1,2) in matrix indexes
%   sense (0,1) <=> intuitive, (-1,1)
%
%          ^  (0,1)     %          ^  1
%          |            %          |
% (1,0) <--+-->  (1,1)  %    2  <--+-->  3
%          |            %          |
%          V  (0,0)     %          V  0
%
% 1102.2011 - new, from older nMembrOrSphi2Dist.m | iniFrontOfMembrane
%             last updated 01.02.2011 | 20.05.2009 (?)
%           - discard rows 1 & 2 (distances, keep Ix only)
% 14.02.2011    - new, rewrite... scrap indices, use subindices :-)
% 15.02.2011    - works fine, for ForceTrueInside meaning see top

%% rewrite start
nPoints = size(Arr,1);
front_L = zeros(nPoints, 2); % alloc exact, no turns
front_R = zeros(nPoints, 2); % alloc exact, no turns
% figure out the pixel pair to start with
[front_L(1, 1:2), front_R(1, 1:2), YvXv] = uArrBase2AdjPix(fliplr(XbYb), Arr(1,:));

%% --- parse the rest of the arrows ---
for ixP = 2:nPoints
    [front_L(ixP, 1:2), front_R(ixP, 1:2), YvXv] = uArrBase2AdjPix(YvXv, Arr(ixP,:));
end

% so that decision L/R can be taken at end,
% depending on whether sum(turn_right) > sum(turn_left)

% select In/Out
if ForceTrueInside
    % check direction changes 1>0, 0>1
    % -------------------------------------
    dir_change = xor(Arr(1:end-1,1), Arr(2:end,1));
    dir_change_10 = dir_change & Arr(1:end-1,1);
    dir_change_01 = dir_change & ~Arr(1:end-1,1);
    sign_change = xor(Arr(1:end-1,2), Arr(2:end,2));
    turn_right = (dir_change_10 & sign_change) | ...
        (dir_change_01 & ~sign_change);
    turn_left = (dir_change_10 & ~sign_change) | ...
        (dir_change_01 & sign_change);

    if sum(turn_right) > sum(turn_left) % that is LeftOutside
        front_In = front_R;
        front_Out = front_L;
    else % if ==... brrr
        front_In = front_L;
        front_Out = front_R;
    end
else % if ==... brrr
    front_In = front_L;
    front_Out = front_R;
end

end
function [YpXp_L, YpXp_R, XbYb] = uArrBase2AdjPix(XbYb, Arr)
% find the pixel pair LR, given the binary Arrow and its base
% - a. find arrow center:
dirArrow = Arr(1)+1;
halfArrowOffs = (Arr(2)-0.5);
XbYb(dirArrow) = XbYb(dirArrow) + halfArrowOffs; % apply 1/2 shift on arrow direction
% - b. find 2x adj pixels:
YpXp_L = XbYb; YpXp_R = XbYb;
dirPerp = ~Arr(1,1)+1;
halfRightOffs = xor(Arr(1), Arr(2))-0.5; % binary to +/- 0.5
YpXp_L(dirPerp) = YpXp_L(dirPerp) - halfRightOffs;
YpXp_R(dirPerp) = YpXp_R(dirPerp) + halfRightOffs;
% - c. find arrow tip (next base)
XbYb(dirArrow) = XbYb(dirArrow) + halfArrowOffs;
end



