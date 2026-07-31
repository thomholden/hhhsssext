function prjData = opNextStep(prjData, nSteps, nItPerStep)
% attData = opNextStepNew(attData, nSteps, nItPerStep)
% 
% iterate Fn nSteps (x nIterPerStep iterations)
%
% used in GUI by wrapper opNextStep_W and next in scripting !
%   nSteps, nItPerStep can be passed from top 
%   a 0 value will default to values stored in prjData .it
% prjData = opNextStep(prjData, 4, 0) % 4 steps of default iterations
%
% 2010.11.03    - protection for emtpy error strings (after 0 iterations :-))
% 17.02.2011    - start major rehaul, properly split between Relax and Reset
%                 stages, will ease Lipschitz
% 13.06.2011    - call opReset_Wrap, try to clean up the many-tries mess
%                 caused by resetting based on edges, multi-vars...

if nargin < 3, nItPerStep = 0; end
if nItPerStep == 0
    nItPerStep = prjData.it.nItPerStep;
end
if nargin < 2, nSteps = 0; end
if nSteps == 0
    nSteps = prjData.it.nSteps;
end

DebugLevel = 0; %1, 2

% some local vars, to make it short and fast :-)
fn = prjData.fn;     % it could be large ... use single precision ?
g = prjData.gTile;
k = prjData.res.kLevel;
cSteps = prjData.count.Steps;
cIt = prjData.count.It;
dT = prjData.par.dt;
err = prjData.err;
thisPar = prjData.par;

thisMask = true(size(fn));
thisRange = (max(g(:))-min(g(:))) ^2; % thisRange to be in .. .pass?

% --- scale Miu depending on GData (initially uint8^2)
% and current scale (k) -> will+ as res+
thisPar.Miu = prjData.par.Miu * thisRange *2^(-2*k);
% it was 2^(-k) before, but now Fn is adjusted at Up /Down by 2 / 0.5

if DebugLevel > 1
    disp(['Miu ' num2str(thisPar.Miu) ', next ' num2str(nSteps) ' steps ']);
end

% --- 1. load results of previous RESET ---
Dirac = prjData.evol.Dirac;
Residue = prjData.evol.Residue;

% build a g+edge nR x nC x 2
if ~isempty(prjData.Edges)
    g(:,:,2) = prjData.Edges;
end

% 2. --- RELAX & RESET ---
for i = 1:nSteps
    fn = opRelax(fn, Residue, Dirac, thisPar.Miu, nItPerStep, dT);
    % funky 1pix reset... in test
    %fn = uRst1Pix(fn);
    msk_curr = fn > 0 & thisMask;
    [thisErr, Residue, Dirac, Hvi, gHvi] = opReset_Wrap(fn, g, thisPar, ...
        prjData.opt.RegStyle);
    
    % update counters
    cSteps = cSteps + 1;
    cIt = cIt + nItPerStep;
    % plot error evolution inside this, i.e. after each step ?
    err = uConcatFlattenErr(err, thisErr);
end
% reset mask outside, just once
fn(~thisMask) = 0;

if ~isempty(err)
    if err.Cp(end) < err.Cm(end) % seldom, max. once after reinit
        % flip .sphi, .fn, .MG_fnk{1:k+1}
        fn = -fn;
        % do the same if using prjData.MG_fnk{:} = - prjData.MG_fnk{:};
    end
end

% --- store previous boolean mask & Fn
prjData.sphi_prev = prjData.sphi;
prjData.fn_prev = prjData.fn;
% --- check sign change ! ---
[fn, DidRescale] = RescaleFn(fn, thisMask);
if DidRescale,  msk_curr = fn > 0 & thisMask; end
% --- update current

prjData.sphi = msk_curr; % fn>0;
prjData.fn = fn;
% --- calc/store gradient ---
%dY = opDiffCentered(fn, 1); % get it later from inside opReset...
%dX = opDiffCentered(fn, 2);
dY = opFD(fn, 1, 0);
dX = opFD(fn, 2, 0);
prjData.evol.gradFnMag = sqrt(dX.^2 + dY.^2);
prjData.evol.gradFnPhase = atan2(dY, dX)/pi;
clear fn 
% --- slot the other results from opReset ---
prjData.evol.Hvi = Hvi;
% reshape gHvi
prjData.evol.gradHviMag = gHvi; % angle later
prjData.evol.Dirac = Dirac;
prjData.evol.Residue = Residue;

% concatenate error to existing
prjData.err = err ;
prjData.count.Steps = cSteps;
prjData.count.It = cIt;

% set shift current Membrane to prev, set status of new to stale
prjData.m(2) = prjData.m(1);
prjData.m(1).Stale = true;

end

