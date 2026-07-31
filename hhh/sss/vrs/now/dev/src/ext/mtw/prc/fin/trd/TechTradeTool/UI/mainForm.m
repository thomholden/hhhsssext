function mainForm


global hFig fName st hFname hStat bGoOnOptimizing 

fName = '';

%hFrame = uicontrol ('Style', 'frame', 'String', 'Dimbeta Trading System', 'Position', [100 100 100 90], 'Callback', 'openFile');
%hFigure = figure;
scrsz = get(0,'ScreenSize');
hFig = figure('Position',[100 scrsz(4)-217-30 300 212]);
%h = dialog ('Position',[100 scrsz(4)-217-30 300 212]);
set (hFig, 'MenuBar', 'none');
set (hFig, 'NumberTitle', 'off');
set (hFig, 'Name', 'TechTradeTool');
%set (hFig, 'WindowStyle', 'modal');



hFname     = uicontrol (hFig, 'Style', 'text', 'String', 'File: ?', 'Position', [0 197 300 15], 'HorizontalAlignment', 'left');
hOpen      = uicontrol (hFig, 'Style', 'pushbutton', 'String', 'Open Security', 'Position', [0 167 300 30], 'Callback', 'openFile');
hPlotTrSys = uicontrol (hFig, 'Style', 'pushbutton', 'String', 'Plot Trading System', 'Position', [0 137 300 30], 'Callback', 'plotSystem');
hPlotProb  = uicontrol (hFig, 'Style', 'pushbutton', 'String', 'Probability of Ruin Analysis', 'Position', [0 107 300 30], 'Callback', 'plotProbRuin');
hCalcSys   = uicontrol (hFig, 'Style', 'pushbutton', 'String', 'Calculate System Performance', 'Position', [0 77 300 30], 'Callback', 'calcSystemPerf');
hOpt       = uicontrol (hFig, 'Style', 'pushbutton', 'String', 'Optimize Trading System', 'Position', [0 47 200 30], 'Callback', 'optimizeSystem');
hOptStop   = uicontrol (hFig, 'Style', 'pushbutton', 'String', 'Stop optimization', 'Position', [200 47 100 30], 'Callback', 'optimizeStop');
hClose     = uicontrol (hFig, 'Style', 'pushbutton', 'String', 'Exit Program', 'Position', [200 17 100 30], 'Callback', 'exitProgram');

%hTitle     = uicontrol (hFig, 'Style', 'text', 'FontSize', 10,'FontWeight', 'bold','String', 'Computational-Technical Trading Tool', 'Position', [0 17 200 33], 'HorizontalAlignment', 'center');
hStat      = uicontrol (hFig, 'Style', 'text', 'String', 'Status: Ready', 'Position', [0 0 300 15], 'HorizontalAlignment', 'left');

% saveas(hFig,'MainFig.fig')