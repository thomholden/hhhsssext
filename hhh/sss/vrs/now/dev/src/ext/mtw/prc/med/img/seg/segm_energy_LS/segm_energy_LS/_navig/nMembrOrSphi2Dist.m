function [dSQ, varargout] = nMembrOrSphi2Dist(mskSphi, varargin)
% two supported calls
% dSQ = nMembrOrSphi2Dist(SPHI)
% or 
% [dSQ, SPHI] = nMembrOrSphi2Dist(MEMBRANE, XBYB, nR, nC)
%
% calculation of the distance from each pixel to interface(membrane), 
% given the either the MEMBRANE collection or the boolean mask SPHI 
%
% 20.05.2009    - new, from older opSphi2Dist(sphi),that is : 
% 05-15.05.2009 - tCalcDist2Membrane + opSphi2Dist = this function
% next          - yet to merge(repack) in the Membr2Dist method later...
%
% 16.07.2009    - fixed bug in bounding factor of nMaxIt, 
%                 from 1/2* to 1 * max(nR, nC))
% 02.11.2010    - corrected bug in help
% 12.01.2011    - yet more room for bounding factor nMaxIt: nR+nC-1
% 01.02.2011    - output forced to single
% 09.03.2011    - change call from cryptic varargin to intelligible
% 

if ~isempty(mskSphi)
    if ~islogical(mskSphi) % later will call using structure m.
        mskSphi = mskSphi.sphi; 
    end
    [nR, nC] = size(mskSphi);
    InputAsMembr = false; %'mask'
    DoFull = true;
    if nargin > 1
        mskGate = varargin{1};
        DoFull = false;
    end
    
else
    errStr = 'nMembr2Dist : when mask empty pass ''size'' as 2nd arg. and values as 3rdm';
    if size(varargin,2) < 2
        error(errStr)
    end
    
    if strcmpi(varargin{1},'size')
        nR = varargin{2}(1);
        nC = varargin{2}(2);
        Arrows = m.Arrows;   
        XbYb = m.XbYb;
       InputAsMembr = true; %'membrane'
    else error(errStr)
    end    
end

OutputLong = max(nargout,1)-1;
if OutputLong > 1   % out length doesn't fit
    disp(' > opMembrOrSphi2Dist maximum 2 outputs: check help')    
end

%% grow : 1st 2 layers adjacent to the interface -> I/O or "just in, just out"
% -------------------------------------------------------------------------
if InputAsMembr    % ---> input is of type 'membrane'
    dR = zeros(nR, nC);
    dC = zeros(nR, nC);
    nM = size(Arrows,2);
    if size(XbYb,1) ~= nM
        error('opMembraneOrSphi2Dist > membrane lists don''t match origins XbYb!')
    end
    mskSphi = false(nR, nC); % will > mskSphi
    
    % find individual membrane lengths -> to place outputs of iniFront
    nP = zeros(1,nM);
    for i=1:nM
        nP(i) = size(Arrows{i},1);
    end
    front_In = zeros(3, sum(nP));
    front_Out = zeros(3, sum(nP));
    ptr_Pos = 0;
    
    % do each Membrane in the collection {Arrows}
    for i=1:nM
        [front_In_sub, front_Out_sub] = iniFrontOfMembrane(Arrows{i}, XbYb(i,:), nR, nC);
        % append to existing
        front_In(:,ptr_Pos+1:ptr_Pos+nP(i)) = front_In_sub;
        front_Out(:,ptr_Pos+1:ptr_Pos+nP(i)) = front_Out_sub;
        % write to dR, dC
        dR(front_In_sub(3,:)) = front_In_sub(1,:);
        dC(front_In_sub(3,:)) = front_In_sub(2,:);
        dR(front_Out_sub(3,:)) = front_Out_sub(1,:);
        dC(front_Out_sub(3,:)) = front_Out_sub(2,:);
        % update pointer
        ptr_Pos = ptr_Pos+nP(i);        
    end
    % update SPHI
    mskSphi(front_In(3,:)) = true;
    
else        % ---> input is of type % 'boolean mask'
    if DoFull
        [front, dR, dC] = iniFrontOfSphi(mskSphi);
    else
        [front, dR, dC] = iniFrontOfSphi(mskSphi, mskGate);
    end
end

%% grow : the rest of the layers
% ------------------------------
%nMaxIt = max(nR, nC)-1; % in case degenerated membrane is a 1-pixel corner
nMaxIt = nR+nC-1; % in case degenerated membrane is a 1-pixel corner

if InputAsMembr    % ---> input is of type 'membrane'
    
    % - inside layers :
    nIt = 0;
    while ~isempty(front_In) && nIt <= nMaxIt
        nIt = nIt+1;
        [front_In, dR, dC] = uEvolve(front_In, dR, dC);
        mskSphi(front_In(3,:)) = true;
    end
    
    % - outside layers :
    nIt = 0;
    while ~isempty(front_Out) && nIt <= nMaxIt
        nIt = nIt+1;
        [front_Out, dR, dC] = uEvolve(front_Out, dR, dC);
    end
    
else            % ---> input is of type % 'boolean mask'
    nIt = 0;
    while ~isempty(front) && nIt <= nMaxIt
        nIt = nIt+1;
        if DoFull
            [front, dR, dC] = uEvolve(front, dR, dC);
        else
            [front, dR, dC] = uEvolve(front, dR, dC, mskGate);
        end
    end
end

%% finalize distance
dSQ = single(sqrt(dR.^2 + dC.^2));
ixOutside = mskSphi==0;
dSQ(ixOutside) = -dSQ(ixOutside);

%% output handling section
% -------------------------
%  dSQ always, mskSphi conditional :
if OutputLong > 0 % 2nd argument : mskSphi
    varargout(1) = {mskSphi};
end

end

function [front, dR, dC] = iniFrontOfSphi(mskSphi, mskGate)
% initializes the interface front  defined by 
% the binary matrix SPHI (also the distances)
DoGate = false;
if nargin == 2, DoGate = true; end
if nargin > 2, error('only need sign of PHI'); end % default erode a normal step

if DoGate
    Contour{4} = [];
    for ixDim = 1:2 % Y/X
        for ixSense = [0 1] % D/U, L/R
            % detect contours, store them DULR 1:4
            thisContour = mskGate & ...
                xor(mskGate, bShift2DMask(mskGate, ixDim, ~ixSense));
            Contour{2*(ixDim-1) + ixSense+1} = thisContour;
        end
    end
end

[nR, nC ] = size(mskSphi);

% shift Right, Left
% -----------------
mskR = false(nR, nC);
mskL = false(nR, nC);
mskR(:,2:end) = xor(mskSphi(:,2:end),mskSphi(:,1:end-1));
mskL(:,1:end-1) = mskR(:,2:end);
% test erasing contours:
if DoGate
    mskR_c = false(nR, nC);
    mskR_c(:,2:end) = xor(mskGate(:,2:end),mskGate(:,1:end-1));
    mskR(mskR_c) = false;
    mskL_c = false(nR, nC);
    mskL_c(:,1:end-1) = mskR_c(:,2:end);
    mskL(mskL_c) = false;
    clear mskR_c mskL_c
end

% shift Up, Down
% -----------------
mskU = false(size(mskSphi));
mskD = false(size(mskSphi));
mskU(2:end,:) = xor(mskSphi(2:end,:),mskSphi(1:end-1,:));
mskD(1:end-1,:) = mskU(2:end,:);
% test erasing contours:
if DoGate
    mskU_c = false(nR, nC);
    mskU_c(2:end,:) = xor(mskGate(2:end,:),mskGate(1:end-1,:));
    mskU(mskU_c) = false;
    mskD_c = false(nR, nC);
    mskD_c(1:end-1,:) = mskU_c(2:end,:);
    mskD(mskD_c) = false;
    clear mskU_c mskD_c
end


% now alloc. the output variables
dR = zeros(nR, nC);
dC = zeros(nR, nC);
ixR = find(mskR);
ixL = find(mskL);
ixU = find(mskU);
ixD = find(mskD);
front = zeros(3, length(ixR)+ length(ixL)+ length(ixU)+ length(ixD));
% front will store on rows 1&2 the dR and dC local to the active point
% on 3rd row the 1d index in the mskSphi matrix

% the StepSize is 0.5, since this function is called only 
% for initialization; the +/- sign for "inside" / "outside"
% will be done at the end 
% will do R/L (cols), U/D (rows), will do reset rows or cols to 0
% as going through, as in case of overlapping there is no
% danger of smaller distances

dR(mskR) = 0; % clarity
dC(mskR) = 0.5;
front(1, 1:length(ixR)) = 0;
front(2, 1:length(ixR)) = 0.5;
ptrHere = length(ixR);
% --- left ---
dR(mskL) = 0; % overwrite if needed
dC(mskL) = 0.5;
front(1, ptrHere+1:ptrHere+length(ixL)) = 0;
front(2, ptrHere+1:ptrHere+length(ixL)) = 0.5;
ptrHere = ptrHere + length(ixL);
% --- Down ---
dR(mskD) = 0.5;
dC(mskD) = 0; % overwrite if needed
front(1, ptrHere+1:ptrHere+length(ixD)) = 0.5;
front(2, ptrHere+1:ptrHere+length(ixD)) = 0;
ptrHere = ptrHere + length(ixD);
% --- Up ---
dR(mskU) = 0.5;
dC(mskU) = 0; % overwrite if needed
front(1, ptrHere+1:ptrHere+length(ixU)) = 0.5;
front(2, ptrHere+1:ptrHere+length(ixU)) = 0;

% 3rd row: store the 1d indexes of all modified points
front(3,:) = [ixR' ixL' ixD' ixU'];

% used for control of growing, debug only
%sphi_check = mskSphi & not(mskL) & not(mskR) & not(mskU) & not(mskD);
end

function [front, dR, dC] = uEvolve(front, dR, dC, mskGate)
% dR and dC are both 0(when unexplored) or the optimal found until now
% front: 3-by-nP array, row (1:2) is [dR dC] of the pixel at ix1D in row 3
% sphi_check: used in debug for navigation/exploration end
% evolve this front LRUD, compare at each step, update dR dC when d<,
% discard pixel when d> (but keep when == !)

DoGate = false;
if nargin > 3, DoGate = true; end

[nR, nC ] = size(dR);

% --- do Right --- R 
shiftBy = nR;
tent_ix1D_next = front(3,:) +shiftBy;
ixInFrame = find(tent_ix1D_next < nR*nC);
if DoGate 
   ixInGate = mskGate(tent_ix1D_next(ixInFrame)); % true when inside GATE
   ixInFrame = ixInFrame(ixInGate);
end
tent_front = zeros(3,size(ixInFrame,2));
tent_front(3,:) = front(3,ixInFrame) + shiftBy;
tent_front(1,:) = front(1,ixInFrame);
tent_front(2,:) = front(2,ixInFrame)+1; % add to columns
% actual dR dC update & concat
[ixKeep, dR, dC] = uCompareUpdate(tent_front, dR, dC);
front_out = tent_front(:,ixKeep);

% --- do Left --- L
shiftBy = -nR;
tent_ix1D_next = front(3,:) +shiftBy;
ixInFrame = find(tent_ix1D_next > 1);
if DoGate 
   ixInGate = mskGate(tent_ix1D_next(ixInFrame)); % true when inside GATE
   ixInFrame = ixInFrame(ixInGate);
end
tent_front = zeros(3,size(ixInFrame,2));
tent_front(3,:) = front(3,ixInFrame) +shiftBy;
tent_front(1,:) = front(1,ixInFrame);
tent_front(2,:) = front(2,ixInFrame)+1; % add to columns

% actual dR dC update & concat
[ixKeep, dR, dC] = uCompareUpdate(tent_front, dR, dC);
front_out = [front_out tent_front(:,ixKeep)];


% --- do UP --- U
% funny roll to get outside points...
shiftBy = 1;
tent_ix1D_next = front(3,:) +shiftBy;
ixInFrame = find(rem(tent_ix1D_next,nR) ~=1);
if DoGate 
   ixInGate = mskGate(tent_ix1D_next(ixInFrame));
   ixInFrame = ixInFrame(ixInGate);
end
tent_front = zeros(3,size(ixInFrame,2));
tent_front(3,:) = front(3,ixInFrame)+shiftBy;
tent_front(1,:) = front(1,ixInFrame)+1; % add to Rows
tent_front(2,:) = front(2,ixInFrame);

% actual dR dC update & concat
[ixKeep, dR, dC] = uCompareUpdate(tent_front, dR, dC);
front_out = [front_out tent_front(:,ixKeep)];

% --- do Down --- D
% funny roll to get outside points...
shiftBy = -1;
tent_ix1D_next = front(3,:) +shiftBy;
ixInFrame = find(rem(tent_ix1D_next,nR)~= 0);
if DoGate 
   ixInGate = mskGate(tent_ix1D_next(ixInFrame));
   ixInFrame = ixInFrame(ixInGate);
end
tent_front = zeros(3,size(ixInFrame,2));
tent_front(3,:) = front(3,ixInFrame)+shiftBy;
tent_front(1,:) = front(1,ixInFrame)+1; % add to Rows
tent_front(2,:) = front(2,ixInFrame);

% actual dR dC update & concat
[ixKeep, dR, dC] = uCompareUpdate(tent_front, dR, dC);
front_out = [front_out tent_front(:,ixKeep)];

% --- new front ready, export it
front = front_out;
end

function [ixKeep, dR, dC] = uCompareUpdate(tent_front, dR, dC)

% - check overlap of ixTent with existing (dR, dC)
% (and later against front points)
% forget for now funny indexing and boolean masks, do a nice 'for'
% update explored points
%[nR, nC] = size(dR);
%msk_tFront = false(nR, nC);
%msk_tFront(tent_front(3,:)) = true;
mskExplored = (dR>0) | (dC>0);

nTP = size(tent_front,2);
ixKeep = true(1, nTP);
for i = 1:nTP
    ix1D = tent_front(3,i); % shortwrite later...
    %[r, c] = ind2sub([nR nC], ix1D);    % help in debug    
    if mskExplored(ix1D)
        % check distance
        dist_before = dR(ix1D)^2 + dC(ix1D)^2;
        dist_tent = tent_front(1,i).^2 + tent_front(2,i).^2;
        if dist_tent > dist_before % discard point
            ixKeep(i) = false;
        elseif dist_tent == dist_before % check if on a different path
            if dR(ix1D) == tent_front(1,i)
                ixKeep(i) = false;
            end
        end
    end % fresh !
    if ixKeep(i)
        dR(ix1D) = tent_front(1,i);
        dC(ix1D) = tent_front(2,i);
    end
end
end

function [front_In, front_Out] = iniFrontOfMembrane(m, xbyb, nR, nC)
% 
% [front_In, front_Out] = iniFrontOfMembrane(MList, xbyb, nR, nC)
%
% initializes two I/O fronts given the separating membrane MList,
% XbYb  - first vertex, 1-by-2, to merge at step 2 in dist2sphi...
% tested originally as uSubMembrane2IOlayers inside nMembrane2SphiSeed
% - then (20.05.2009) added dR, dC, to jive with iniFrontOfSphi :-)
%
% use the classical sign conventions (valid since at least
% ...v.03 08.05.2008, uMembrane2Vertices, plMembrane etc)
%
% definition of increment signs  
%   direction (0,1) <=> (V,H), (y,x) a.k.a (1,2) in matrix indexes
%   sense (0,1) <=> intuitive, (-1,1)
%
%          ^  (0,1)     %          ^  1  
%          |            %          |        
% (1,0) <--+-->  (1,1)  %    2  <--+-->  3
%          |            %          |
%          V  (0,0)     %          V  0
%
% no use of pix_at_left

if nargin < 2
    xbyb = [ 2.5 2.5 ]; 
    disp('> iniFrontOfMembrane: warning : base vertex defaulted to (2.5,2.5)')
end;

% figure out a pixel pair to start with    
        
% figure out direction changes 1>0, 0>1
% -------------------------------------
dir_change = xor(m(1:end-1,1), m(2:end,1));
dir_change_10 = dir_change & m(1:end-1,1);
dir_change_01 = dir_change & ~m(1:end-1,1);
sign_change = xor(m(1:end-1,2), m(2:end,2));
turn_right = (dir_change_10 & sign_change) | ...
    (dir_change_01 & ~sign_change);
turn_left = (dir_change_10 & ~sign_change) | ...
    (dir_change_01 & sign_change);

% so that decision L/R can be taken at end, 
% depending on whether sum(turn_right) > sum(turn_left) 

nPoints = size(m,1);

front_L = zeros(3,nPoints); % alloc exact, no turns
front_R = zeros(3,nPoints); % alloc exact, no turns

%% --- all arrows
for i = 1:nPoints
    [xy_L, xy_R, xvyv] = uArrToAdjPix(xbyb, m(i,:));
    xbyb = xvyv;
      
    % assign the absolute half-pix distances to the FRONT_* 
    % the sign will figured out at top of this function (using names, _In, _Out)
    % the distance calculation can then proceed (will later merge it in 
    % opSphi2Dist @ step2)
    front_L(3,i) = sub2ind([nR nC], xy_L(2), xy_L(1));
    front_R(3,i) = sub2ind([nR nC], xy_R(2), xy_R(1));
    ixDirThis = ~m(i,1)+1; % 1/0-> 2/1; since one has to add the delta
    % on the perpendicular direction its meaning in front_* will be 1/2 dR/dC
    front_L(ixDirThis,i) = front_L(ixDirThis,i) + 0.5; % here only modulus, will
    front_R(ixDirThis,i) = front_R(ixDirThis,i) + 0.5; % add the sign at top        
    
end;

% trim outliers, L/R
ixBound = front_L(3,:)>0 & (front_L(3,:) <= nC*nR);
front_L = front_L(:,ixBound);
ixBound = front_R(3,:)>0 & (front_R(3,:) <= nC*nR);
front_R = front_R(:,ixBound);
% apply to dR, dC

% select In/Out
if sum(turn_right) > sum(turn_left) % that is LeftOutside
    front_In = front_R;
    front_Out = front_L;
else % if ==... brrr
    front_In = front_L;
    front_Out = front_R;    
end

end

function [xy_L, xy_R, xvyv] = uArrToAdjPix(xbyb, mEl)
% find the L/R pixel pair, adjacent to arrow mEl based in xbyb
% called in iniFrontOfMembrane
% 
% ------------------------------------------------------
pix_ini = xbyb; % xbyb's meaning here is really xbyb;
% find center of arrow :
half_arrow = (mEl(1,2)-0.5); % add it on the same direction !
ixArDir = ~mEl(1,1)+1;
pix_ini(ixArDir) = pix_ini(ixArDir) + half_arrow; % now this is the arrow's center
% apply +/- 0.5 to this center
pix_ini = repmat(pix_ini, [2 1]);
% add it on the perpendicular direction; easy, swap it
% so that 0/1 (V/H) -> becomes -> H/V==1/2 (index,x,y) !
ixPerpDir = mEl(1,1)+1;
displacement = (not(xor(mEl(1,2),[1 0]))-0.5)*2 * (mEl(1,1)-0.5)*2 /2;  % L/R

 % choose L, R !
pix_ini(1,ixPerpDir) = pix_ini(1,ixPerpDir) + displacement(1);
pix_ini(2,ixPerpDir) = pix_ini(2,ixPerpDir) + displacement(2);
xy_L = pix_ini(1,:);
xy_R = pix_ini(2,:);

xvyv = xbyb;
xvyv(ixArDir) = xvyv(ixArDir) + 2*half_arrow;
end



