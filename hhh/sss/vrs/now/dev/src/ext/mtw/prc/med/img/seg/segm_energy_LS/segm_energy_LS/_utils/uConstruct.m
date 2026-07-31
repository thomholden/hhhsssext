function obj = uConstruct(what)
% obj = uConstruct(WHAT)
%
% initialize objects 
% WHAT  - 'collection', 'gate', 'blob', 'param', 'opt', 'res', etc...
%
% 27.06.2011    - slimmed-down version of top uConstruct, v.of 23.05.2011 

switch lower(what)
    case {'collection', 'all', 'prj'} % recursive call to create all data used in iterative hunting
        obj.g = {};         % function to approx
        obj.gOffset = [];   % undersampling offsets, used when predicting (opUp)
        obj.gTile = [];    % img.sub-matrix being segmented, updated at scale changes and pass advances
        
        obj.Edges = [];     % "border" info (setlets), will eventually be a cell too?
        
        obj.fn = [];        % approximating function
        obj.fn_prev = [];
        obj.sphi = [];      % two boolean masks used for membrane-free plots,
        obj.sphi_prev = []; % resetting Fn to dist.func. or multi-phase passes
        
        obj.m = uConstruct('m'); % membranes to plot
        obj.err = [];       % empty ! later uConstruct('err');
        
        obj.par = uConstruct('par');    % the fields that belong to the
        obj.res = uConstruct('res');    % six panels in the top figure
        obj.it = uConstruct('it');
        obj.opt = uConstruct('opt'); % pass?
        
        obj.loc = uConstruct('loc');
        obj.flag = uConstruct('flag') ;
        obj.count = uConstruct('count') ;
        
        obj.evol = uConstruct('evol'); % to comment out at end :-)
        
%     case 'gate'     % Gating information -- will only segment inside
%         obj.Box = [0 0 0 0];    % GlobalPosition := [ri ro ci co]
%         obj.fnOff_DwUp = [9 -9; -9 9];  % 2-by-2 parity, not as global!
%         % used to obtain Fn matching size of gTile
%         obj.IdxLocal = [];      % ref. to MaskLocal, inh. from parent Blob
%         obj.IxEvenOddAll = {};  % 1D indices (use in Even-Odd)
%         obj.IxContours = {};    % contours of the mask at each res level
%         obj.m = uConstruct('membrane'); % 1:kMax+1, new style, .sphi, etc
%         obj.MaskGlobal = [];    % boolean mask, to phase out
%         obj.MaskLocal = [];     % tight to gate, N-pix larger mask
%         
    case {'membrane', 'm'}
        obj.mask = [];      % boolean matrix
        obj.YvXv = {};      % points to plot -- OPTIMIZED!
        obj.Stale = false;
        obj.Arrows = {};    % arrows of membrane(s) - do NOT phase out
        obj.XbYb = [];      % their origins (bases) - do NOT phase out
        obj.XvYv = {};      % points to plot cheap - phase out
        obj.YsXs = {};      % points to plot 'safe', cool order, 1/2
        obj.YcXc = {};      % arrow centers, use in NB contour parsing
        
    case {'par', 'param'} 	% ---> overwritten in panel 'par'
        % Mumford-Shah minimizer parameters ----------------
        obj.dt = 1;
        obj.eps = 1;    % epsilon, for regularization
        obj.GRange = 255^2;     % will scale Miu by both GRange and k(scale)
        obj.Lp = 1;     % lambda P or +, White
        obj.Lm = 1;     % lambda N or -, Black
        obj.Miu = 1 ;        % roughness, contour (*255^2 out)
        obj.Niu = 0;            % roughness, area
        % obj.RegStyle = 'atan';  % regularization ('sine' is narrow)
               
    case {'resol', 'res'}   % ---> updated in panel 'res'
        obj.kLevel = 0;         % it's really an output (flag)
        obj.kMax = 3;           % set instead of CoarseSize
        obj.kGridSize = [0 0];  % same, will update using nR, nC
        obj.kZYX = [0 0 0];     % use kMax Z,Y,X in 
        obj.hZYX = [1 1 1];     % 3D anisotropical segm.
        obj.offsets = {};       % migrate the decimation offsets here
        
    case {'it', 'iter'}  	 % ---> updated in panel 'it'
        obj.Method = 'jacobi';
        obj.nSteps = 4;
        obj.nItPerStep = 8;

    case {'opt', 'options'}
        % membrane auto-initializing
        obj.MembrIniMethod = 'circles';
        obj.nCircles = 1;
        obj.DistMethod = 'bwdist'; % or 'built in', Method for redistancing
        obj.DwnMethod = 'vertex-full'; % or 'cell-full' ...for opDwn

        obj.ShowErr = true; % for now always on, later to set in gui
        obj.Rsphere = 5;        
        obj.RegStyle = 'atan'; % regularization ('sine' is narrow, -eps:eps)
        
    case 'count'    % 'out', set while iterating
        obj.It = 0;       % iterations total
        obj.Steps = 0;    % steps (of contour, n->n+1)
        obj.Frame = 0;    % movie frames

    case {'loc', 'locations', 'file', 'f'}
        % obj.CurrDir = 'C:\Users\tudor\_home\m2007b\segmentation';
        obj.CurrDir = pwd;
        obj.LogDir = '\log_data';
        obj.LogName = '_default.txt';
        obj.ImageDir = [obj.CurrDir]; % pad with obj.CurrDir at top
        obj.ImageSrcName = 0;
        obj.GateDir = [obj.CurrDir];
        obj.GateFileName = 0;
        obj.MembraneFileName = '_default';
        obj.CommentLine = 'for comparative error plots';

    case 'flag'
        obj.StartedPred = 0;
        obj.InitDone = 0;
        obj.ForceReload = 1;

    case {'err', 'error'}
        obj.Cp = [];     % averages in piecewise flat regions
        obj.Cm = [];        
        % --- RMS part --- P, M, total :
        obj.Ep = 0;       % p, m -> raw values
        obj.Em = 0;       % total -> scaled
        obj.E_pix = 0; % by nR x nC (was scale_f)
        % --- perimeter, area part ---
        obj.Interface_raw = 0;    % == sum(gradHvi(:));
        obj.Interface_adj = 0;   % later obj.Per_raw*Miu;
        % evolution, #Pix
        %obj.nPixPMGL = zeros(1,4, 'uint32'); % #Pix P/M, Gained/Lost
        % --- regions, P and M, their ratio
        obj.Region_P = 0;     
        obj.Region_M = 0;       %
        obj.Region_ratio = 0;   % P/M :-)
        % standard deviations
        obj.Sp = 0;     
        obj.Sm = 0;
        % all
        obj.total = 0;  % SQ_raw + Per_corr = Area_corr;
        obj.total_corr = 0;

    case 'evol'
        obj.gradFnMag = [];
        obj.gradFnPhase = [];
        obj.Hvi = [];
        obj.gradHviMag = [];
        obj.gradHviPhase = [];
        obj.Dirac = [];
        obj.gradG = [];
        obj.Residue = [];
        

    otherwise
        disp('segm > uConstruct > unknown object type passed')
end