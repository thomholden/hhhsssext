function ShowError(err, LastSteps, figNo)
% display accumulated error
if nargin < 3 %
    figNo = 600;
end
if nargin < 2 % should be in a 2-deep menu
    LastSteps = 4; % bull
end
% test existence of figure, only replace when new
ReplaceFigWhenNew(figNo, [10 10 565 610]); % was [108 72 560 786]

DoLastSteps = nargin >= 2;
nP = size(err.total,2);
if ~DoLastSteps
    LastSteps = nP;
else % protect
    LastSteps = min(LastSteps, nP);
end
xgrid = nP-LastSteps+1:nP;
ixWtd = nP-LastSteps+1:nP;
set(figNo, 'menubar', 'none', 'numbertitle', 'off', 'name', ...
    ['seg::error, last ' num2str(numel(ixWtd)) ' steps' ])

E_pix = err.E_pix(ixWtd);
ErrTotal = err.total(ixWtd);

Ep = err.Ep(ixWtd);
Em = err.Em(ixWtd);
SplitPlots = [1 1 1 1 1];
Show_NoneLastVar = [2 2 2 1 1];
TitleList = {{'ERR_{TOT}', 'ERR_{SQ}'}, ...
    {'ERR_{SQ} P', 'M'}, ...
    {'Interface', 'Region ratio'}, ...
    {'C_P', 'C_M'}};

if ~isfield(err, 'Cp_H')
    TraceList = {{ErrTotal, E_pix}, {Ep, Em}, ...
        {err.Interface_raw(ixWtd), err.Region_ratio(ixWtd)}, ...
        {err.Cp(ixWtd), err.Cm(ixWtd)}};
else
    TraceList = {{ErrTotal, E_pix}, {Ep, Em}, ...
        {err.Interface_raw(ixWtd), err.Region_ratio(ixWtd)}, ...
        {err.Cm(ixWtd), err.Cp(ixWtd)}, ...
        {err.Cp_H(ixWtd), err.Cm_H(ixWtd)} };
    TitleList{4} = {'C^L_M', 'C^L_P'};
    TitleList{5} = {'C^H_P', 'C^H_M'};
end

nSubPlots = size(TraceList,2);
for i=1:nSubPlots
    subplot(nSubPlots,1,i)
    uSub(xgrid, TraceList{i}, TitleList{i}, ...
        SplitPlots(i), Show_NoneLastVar(i))
end
% and a concatenated, all Error !!!
tfh = ReplaceFigWhenNew(figNo+2, [115 10 565 620]);
set(tfh, 'menubar', 'none', 'numbertitle', 'off', ...
    'name', 'seg::error evolution');

xgrid = 1:nP; % ALL
TraceList = {...
    {log10(err.total_corr)}, {err.Ep, err.Em, err.E_pix}, ...
    {err.Interface_raw}, {err.Region_P}};
TitleList = {{'log_{10}(ERR_{TOTAL}), corr'}, ...
    {'RMS_{SQ}, P-r', 'M-b', 'A-y'}, ...
    {'Perim <pixels>'}, {'Area<reg.> '}};
SplitPlots = [0 0 0 0];
Show_NoneLastVar = [1 1 1 1];
nSubPlots = size(TraceList,2);
for i=1:nSubPlots
    subplot(nSubPlots,1,i)
    uSub(xgrid, TraceList{i}, TitleList{i}, ...
        SplitPlots(i), Show_NoneLastVar(i), 7)
end
end

function uSub(xgrid, Traces, StrList, SplitPlots, Show_NoneLastVar, nDigits)
nTraces = size(Traces,2);
if nargin < 6, nDigits = 3; end
%if nargin < 6, nDigits = 3*ones(1, nTraces); end
Ticks = {'r', 'b', 'y'}; % hard

if SplitPlots
    plotyy(xgrid, Traces{1}, xgrid, Traces{2})
else
    for i = 1:nTraces
        plot(xgrid, Traces{i}, Ticks{i});
        hold on
    end
    hold off
end

% add trace-derived info to the received strings
TitleStr = '';
for i = 1:nTraces
    switch Show_NoneLastVar
        case 1 % last
            thisVar = Traces{i}(end);
            thisStrTag = num2str(thisVar, nDigits);
        case 2 % variation
            thisVar = (max(Traces{i})/min(Traces{i}) - 1)*100;
            nD = min(3,nDigits); % don't show % with many digits
            thisStrTag = [num2str(thisVar,nD) ' %'];
        case 0 % none
            thisStrTag = '';
    end
    TitleStr = [TitleStr StrList{i} ' ' thisStrTag ', '];
end
TitleStr = TitleStr(1:end-2);

title(TitleStr), zoom on, grid on
end
