function cfh()
%CFH A GUI with most of the CFH Toolbox functionalities
handles.hFig = figure('Menubar','none','Units','pixels','Position', ...
    [100 100 655 600],'Name','CFH Toolbox','NumberTitle','off', ...
    'Visible','off','WindowKeyPressFcn',@keyShortcut);
    s = warning('off', 'MATLAB:uitabgroup:OldVersion');
    handles.TabGroup = uitabgroup('Parent',handles.hFig);
    warning(s);
    handles.Tab(1) = uitab('Parent',handles.TabGroup,'Title','General'); 
    handles.Tab(2) = uitab('Parent',handles.TabGroup,'Title','Drift/Variance');
    handles.Tab(3) = uitab('Parent',handles.TabGroup,'Title','Jump');
    set(handles.TabGroup, 'SelectedTab',handles.Tab(1));

initializeParameters;
makeTab1;
makeTab2;
makeTab3;
set(handles.hFig,'Visible','on');

%% buttons
%    function buttonHfromW(src,evt)
%    HfromWGUI();
%    end
    
    function buttonGreeks(src,evt)
    if~preCheck();errBox;return;end
    createCharFun;
    greeksGUI;
    end
function errBox();
    warndlg(['Unspecified or misspecified model. Please check ' ...
	'parameter matrices.'],'Missing Model','modal');
end
function buttonImpVol(src,evt)
    if~preCheck();errBox;return;end
    createCharFun;
    impliedVolGUI;
end
    function buttonOptionPrice(src,evt)
        if~preCheck();errBox;return;end
        createCharFun;
    optionPriceGUI;

    end
function buttonImpPdf(src,evt)
    if~preCheck();errBox;return;end
    createCharFun;
    impliedPdfGUI;
end
function buttonCalibrateCall(src,evt)
    'calibrate - to do '
end
function buttonGaby(src,evt)
    if~preCheck();errBox;return;end
    createCharFun;
    gabyGUI;
    
end
function buttonSpread(src,evt)
    'spread'
end
function buttonAsian(src,evt)
'asian'
end
    
function buttonYieldCurve(src,evt)
    if~preCheck();errBox;return;end
    createBondFun;
    createRiskyBondFun;
    bondGUI;
end
function buttonCDSCurve(src,evt)
    if~preCheck();errBox;return;end
    createBondFun;
    createBondFunEx;
    cdsGUI;
end
function buttonDivYield(src,evt)
    dividendGUI()
end

function buttonRiskNeutralize1(src,evt)
    if~preCheck();errBox;return;end
    createJumpFun;
    riskNeutralize();
    set(handles.buttonRiskNeutralize,'String','Revert', ...
    'Callback',@buttonRiskNeutralize2);
end
function buttonRiskNeutralize2(src,evt)
    deRiskNeutralize();
    set(handles.buttonRiskNeutralize,'String','Neutralize Dividends', ...
        'Callback',@buttonRiskNeutralize1);
end
%%
function buttonLoadData(src,evt)
    [fName,pName] = uigetfile('*.mat', 'Load data from file');
    if pName == 0, return; end
    data = load(fullfile(pName,fName), '-mat');
    for l =1:length(handles.ioSet)
        handles.(handles.ioSet{l}) = data.(handles.ioSet{l});
    end
    for l = 1:length(handles.tableSet)
        if isfield(handles,['table' handles.tableSet{l}])
        
            table = handles.(['table' handles.tableSet{l}]);
            input = handles.(handles.tableSet{l})(:,:,1);
            set(table,'Data',input);
        end
    end
    set(handles.popupJump,'Value',handles.jumpNum);
    for k = 1:8
        set(handles.checkLog{k},'Value',handles.isLog(k));
     end
    makeJumpTablesVisible();
    set(handles.buttonRiskNeutralize,'String','Neutralize Dividends', ...
        'Callback',@buttonRiskNeutralize1);
end
function buttonSaveData(src,evt)
    [fName,pName] = uiputfile('*.mat','Save data to file');
    if pName == 0, return; end
    for l = 1:length(handles.ioSet)
        data.(handles.ioSet{l}) = handles.(handles.ioSet{l});
    end
    save(fullfile(pName,fName),'-struct','data');
end
function buttonClearData(src,evt)
    close(handles.hFig);
    cfh;
end
function buttonPreferences(src,evt)
    preferencesGUI;
end
%% table edits, checkbox edits, popup edits
function editTableCallback(src,evt)
    % whenever a table is edited, its TAG field corresponds to an 
    % (hopefuly) already existing handles.TAG variable and writes into it
    data = get(src,'Data');
    handles.(get(src,'Tag')) = data;
    unHighlightTables(src);
end
function editTableH1Callback(src,evt)
    % when editing the H1 , we have to check which sub-matrix is selected
    handles.H1(:,:,get(handles.popupH1,'Value'))=get(src,'Data');
    unHighlightTables(src);
end
function editTableJumpCallback(src,evt)
    % the jump parameter tables get their very own edit callback, as these
    % correspond to different jump types (the handles.popupJump)
    tableNum = get(src,'Tag');
    tableNum = str2num(tableNum(isstrprop(tableNum,'digit')));
    switch get(handles.popupJump,'Value')
        case 2
            handles.jumpPar1 = get(handles.tableJump1,'Data');
            handles.jumpPar2 = get(handles.tableJump4,'Data');
        case 3
            handles.jumpPar3 = get(handles.tableJump1,'Data');
        case 4
            handles.jumpPar4 = get(handles.tableJump1,'Data');
            handles.jumpPar5 = get(handles.tableJump2,'Data');
            handles.jumpPar6 = get(handles.tableJump3,'Data');
        otherwise
    end
    unHighlightTables(src);   
end
function checkBoxCallback(src,evt)
    str = get(src,'Tag');
    varName = (str(isstrprop(str,'alpha')));
    str = str2num(str(isstrprop(str,'digit')));
    handles.(varName)(str) = get(src,'Value');
end
function popupH1Callback(hObject, eventdata)
    get(hObject,'Value');
    get(handles.tableH1,'Parent');
    set(handles.tableH1,'Data',handles.H1(:,:,get(hObject,'Value')));
end
function popupJumpCallback(src,evt)
    handles.jumpNum = get(src,'Value');
    handles.jumpName= handles.jumpList(get(src,'Value'));
    makeJumpTablesVisible();
end


function keyShortcut(in1,in2)
    if strcmp(in2.Character,'')*isempty(in2.Modifier)
        switch in2.Key
            case 'f2';buttonOptionPrice;
            case 'f3';buttonImpVol;
            case 'f4';buttonImpPdf;
            case 'f5';buttonGreeks;
            case 'f6';buttonGaby
            case 'f7';buttonYieldCurve;
            case 'f8';buttonCDSCurve;
            %case 'f9';'bond Option'
            otherwise
        end
    
	elseif isempty(in2.Modifier) & strcmp(in2.Key,'escape')
        close(in1);
    elseif strcmp(in2.Modifier,'control')
        switch in2.Key
            case '1';set(handles.TabGroup, 'SelectedTab',handles.Tab(1));
            case '2';set(handles.TabGroup, 'SelectedTab',handles.Tab(2));
            case '3';set(handles.TabGroup, 'SelectedTab',handles.Tab(3));
            case 's';buttonSaveData();
            case 'l';buttonLoadData();
            case 'k';buttonClearData();
            case 'p';buttonPreferences();
            otherwise;
        end
    else   
    end
end

function makeJumpTablesVisible()
    % when invoked, this function checks for the 'selected' jump type and
    % makes the corresponding tables visible and populates them accordingly
    switch handles.jumpNum
        case 1 % no jumps - kick the jump function
            set(handles.tableJump1,'Visible','off');
            set(handles.tableJump2,'Visible','off');
            set(handles.tableJump3,'Visible','off');
            set(handles.tableJump4,'Visible','off');
            set(handles.textJump1,'Visible','off');
            set(handles.textJump2,'Visible','off');
            set(handles.textJump3,'Visible','off');
        case 2 % - Merton style jumps
            set(handles.tableJump1,'Visible','on');
            set(handles.tableJump2,'Visible','off');
            set(handles.tableJump3,'Visible','off');
            set(handles.tableJump4,'Visible','on');
            set(handles.tableJump1,'Data',handles.jumpPar1);
            set(handles.tableJump4,'Data',handles.jumpPar2);
            set(handles.textJump1,'Visible','on','String','mean');
            set(handles.textJump2,'Visible','on','String','jump covariance');
            set(handles.textJump3,'Visible','off');
        case 3 % exponential
            set(handles.tableJump1,'Visible','on');
            set(handles.tableJump2,'Visible','off');
            set(handles.tableJump3,'Visible','off');
            set(handles.tableJump4,'Visible','off');
            set(handles.tableJump1,'Data',handles.jumpPar3);
            set(handles.textJump1,'Visible','on','String','mean');
            set(handles.textJump2,'Visible','off');
            set(handles.textJump3,'Visible','off');
        case 4 % double exponential
            set(handles.tableJump1,'Visible','on');
            set(handles.tableJump2,'Visible','on');
            set(handles.tableJump3,'Visible','on');
            set(handles.tableJump4,'Visible','off');
            set(handles.tableJump1,'Data',handles.jumpPar4);
            set(handles.tableJump2,'Data',handles.jumpPar5);
            set(handles.tableJump3,'Data',handles.jumpPar6);
            set(handles.textJump1,'Visible','on','String','P(up)');
            set(handles.textJump2,'Visible','on','String','mean (up)');
            set(handles.textJump3,'Visible','on','String','mean (down)');
        otherwise
    end
end
function closeRequest(src,evt)
    delete(src);
end
function unHighlightTables(hObject)
    temp            = get(hObject,'Data');
    set(hObject,'Data',{' '});
    set(hObject,'Data',temp);
end

%% gui related
function makeTab1
% initial value panel
    handles.panelInit  = uipanel('Parent',handles.Tab(1),'Units', ...
        'pixels','Position',[5 380 140 190],'Title','Initial conditions');
    textBox(handles.panelInit,[5 150 50 14],'name');
    textBox(handles.panelInit,[50 150 79 14],'initial value');
    textBox(handles.panelInit,[110 150 25 14],'LOG');
    handles.tableNames = niceTable(handles.panelInit, ...
        handles.Names,[5 5 44 140],'Names','Add a name to your process');
    set(handles.tableNames,'ColumnWidth',{40},'FontWeight','light');
    handles.tableX0 = niceTable(handles.panelInit, ...
        handles.X0,[50 5 54 140],'X0','Set initial values of your processes');
    for k = 1:8
        handles.checkLog{k} = uicontrol('Style','checkbox', ...
            'Parent',handles.panelInit, ...
            'Position',[73+41 131-(k-1)*18 14 14], ...
            'Callback',@checkBoxCallback, ...
            'Value',handles.isLog(k), ...
            'Tag',['isLog' num2str(k)],'TooltipString','Check if the process corresponds to the log of X');
    end
% discount rate panel    
    handles.panelDiscount  = uipanel('Parent',handles.Tab(1), ...
        'Units','pixels', ...
        'Position',[160 380 140 190],'Title','Discount rate loading');
    textBox(handles.panelDiscount,[5 150 54 14],'constant');
    textBox(handles.panelDiscount,[82 150 30 14],'affine');
    handles.tableR0 = niceTable(handles.panelDiscount, ...
        handles.R0,[8 124 54 21],'R0','Constant discount rate');
    handles.tableR1 = niceTable(handles.panelDiscount, ...
        handles.R1,[73 5 54 140],'R1',['Coefficients in the linear ' ...
        'relation between the discount rate and each process']);
    
% default intensity panel panel	
    handles.panelCDS= uipanel('Parent',handles.Tab(1), ...
        'Units','pixels', ...
        'Position',[315 380 140 190],'Title','Default intensity loadings')    ;
    textBox(handles.panelCDS,[5 150 54 14],'constant');
    textBox(handles.panelCDS,[82 150 30 14],'affine');
    textBox(handles.panelCDS,[5 80 54 14],'recovery');
    handles.tableCDS0 = niceTable(handles.panelCDS,handles.CDS0, ...
        [8 124 54 21],'CDS0','Constant default intensity');
    handles.tableRR = niceTable(handles.panelCDS,handles.RR, ...
        [8 54 54 21], 'RR','Recovery rate assumption');
	handles.tableCDS1 = niceTable(handles.panelCDS, handles.CDS1, ...
        [73 5 54 140],'CDS1',['Coefficients in the linear ' ...
        'relation between the default intensity and each process']);
% Tau panel    
    handles.panelTau= uipanel('Parent',handles.Tab(1), ...
        'Units','pixels', ...
        'Position',[470 500 140 70],'Title','Time to maturity')    ;  
    textBox(handles.panelTau,[70 27 30 15],'years');
    handles.tableTau= niceTable(handles.panelTau, handles.Tau, ...
    	[5 24 54 21],'Tau','Time to maturity in years');
% dividend panel (with buttons)
    handles.panelDividends  = uipanel('Parent',handles.Tab(1), ...
        'Units','pixels', ...
        'Position',[470 420 140 70],'Title','Dividends / Neutralize')    ;  
    niceButton(handles.panelDividends,[5 30 130 25], ...
        @buttonDivYield,'Add Dividends','Opens the dividend GUI');
    handles.buttonRiskNeutralize = niceButton(handles.panelDividends, ...
        [5 5 130 25],@buttonRiskNeutralize1,'Neutralize Dividends', ...
        'Press here to risk neutralize the dividend yielding asset processes');
% options panel
handles.panelOptions = uipanel('Parent',handles.Tab(1), ...
        'Units','pixels','Position',[5 300 605 70],'Title','Option Pricing');
    niceButton(handles.panelOptions,[5 5 95 50], ...
        @buttonOptionPrice,'<html><center>Option Pricing<br>[F2]', ...
        'Compute European style call and put options written on the first process');
    
    niceButton(handles.panelOptions,[105 5 95 50], ...
        @buttonImpVol,'<html><center>Implied Volatility<br>[F3]', ...
        'Create an implied volatility curve for options on the first process');
    niceButton(handles.panelOptions,[205 5 95 50],@buttonImpPdf, ...
        '<html><center>Implied Density<br>[F4]', ...
        'Obtain implied densitites for all processes');
    niceButton(handles.panelOptions,[305 5 95 50],@buttonGreeks, ...
        '<html><center>Greeks<br>[F5]', ...
        'Compute greeks for a call option written on the first process');
    %niceButton(handles.panelOptions,[305 5 95 50],@buttonCalibrateCall, ...
    %    '<html><center>Calibrate to Data<br>[F5]');
    niceButton(handles.panelOptions,[405 5 95 50],@buttonGaby, ...
        '<html><center>G(a,b,y)<br>[F6]','Compute extended conditional expectations');
    %niceButton(handles.panelOptions,[505 5 95 25],@buttonSpread, ...
    %    'Spread Options');
    %niceButton(handles.panelOptions,[505 30 95 25],@buttonAsian, ...
    %    'Asians');
    
handles.panelBond = uipanel('Parent',handles.Tab(1), ...
        'Units','pixels','Position',[5 220 605 70],'Title','Bonds');
    niceButton(handles.panelBond,[5 5 95 50], ...
        @buttonYieldCurve,'<html><center>Yield Curves<br>[F7]', ...
        'Risk free and risky yield curve computations');
    niceButton(handles.panelBond,[105 5 95 50],@buttonCDSCurve, ...
        '<html><center>CDS spreads<br>[F8]','Obtain CDS spreads');
    %niceButton(handles.panelBond,[200 5 95 50],'', ...
     %   '<html><center>Bond Options<br>[F9]');
% main functionality tools panel
    
% File I/O panel
    handles.panelIO  = uipanel('Parent',handles.Tab(1), ...
        'Units','pixels', ...
        'Position',[5 140 605 70],'Title','General');
    niceButton(handles.panelIO,[5 5 95 50],@buttonLoadData, ...
        '<html><center>Load Data<br>[CTRL+L]');
    niceButton(handles.panelIO,[105 5 95 50],@buttonSaveData, ...
        '<html><center>Save Data<br>[CTRL+S]');
    niceButton(handles.panelIO,[205 5 95 50],@buttonClearData, ...
        '<html><center>Clear Data<br>[CTRL+K]');
    niceButton(handles.panelIO,[305 5 95 50],@buttonPreferences, ...
        '<html><center>Preferences<br>[CTRL+P]');
    %niceButton(handles.panelIO,[400 5 95 50],'', ...
    %    '<html><center>Supply Charact.<br>Function');
end
function makeTab2
    handles.panelDrift = uipanel('Parent',handles.Tab(2), ...
        'Units','pixels', ...
        'Position',[5 380 504 190],'Title','Drift');  
    textBox(handles.panelDrift,[5 150 54 14],'constant');
    handles.tableK0 = niceTable(handles.panelDrift,handles.K0, ...
        [8 5 54 140],'K0','Constant terms in the process drift');
    textBox(handles.panelDrift,[84 150 54 14],'affine');
    handles.tableK1 = niceTable(handles.panelDrift, handles.K1, ...
        [73 5 404 140],'K1',['Each row i contains the coefficients in ' ...
        ' the linear relation between the drift of i and all variables']);
    handles.panelVariance = uipanel('Parent',handles.Tab(2), ...
        'Units','pixels','Position',[5 40 504 330],'Title','Variance');
    textBox(handles.panelVariance,[5 290 30 14],'H0');
    handles.tableH0 = niceTable(handles.panelVariance, handles.H0, ...
        [73 165 404 140],'H0',['Contains the state independent process' ...
        ' covariance matrix']);
    handles.tableH1 = niceTable(handles.panelVariance,handles.H1(:,:,1), ...
        [73 5 404 140],'H1', ['Each subtable i contains the covariance '...
        ' that corresponds to process i']);
    set(handles.tableH1,'CellEditCallback',@editTableH1Callback);
    handles.popupH1  = uicontrol('Style','popupmenu', ...
        'Parent',handles.panelVariance,'Position',[8 125 50 20], ...
        'String','(H1)1|(H1)2|(H1)3|(H1)4|(H1)5|(H1)6|(H1)7|(H1)8', ...
        'Tag','selectH1','Callback',@popupH1Callback);
    %niceButton(handles.Tab(2),[520 510 130 50],@buttonHfromW, ...
    %    ['<html><center>Create from<br>Loading Matrix'], ['Compute H0 ' ...
    %    'and H1 from loadings on the underlying Brownian motions']);
end
function makeTab3
    handles.panelJump = uipanel('Parent',handles.Tab(3), ...
        'Units','pixels', ...
        'Position',[5 380 620 190],'Title','Jump specification');  
    textBox(handles.panelJump,[8 150 50 14],'jump type');
	handles.popupJump =  uicontrol('Style','popupmenu', ...
    	'Units','pixels', ...
        'Position',[8 125 130 20], ...
        'Parent',handles.panelJump, ...
        'String','none|Merton|Exponential|Double-Exponential', ...
        'Callback', @popupJumpCallback, ...
        'Tag','selectJump','TooltipString','Select a jump distribution');
    handles.tableJump1 = niceTable(handles.panelJump, zeros(8,1), ...
        [145 5 54 140],'jumpPar1');
    set(handles.tableJump1,'CellEditCallback',@editTableJumpCallback, ...
        'Visible','off');
    handles.tableJump2 = niceTable(handles.panelJump, zeros(8,1), ...
        [205 5 54 140],'jumpPar2');
    set(handles.tableJump2,'CellEditCallback',@editTableJumpCallback, ...
        'Visible','off');
    handles.textJump1 = textBox(handles.panelJump,[145 150 50 14],'');
    handles.textJump2 = textBox(handles.panelJump,[205 150 100 14],'');
    handles.textJump3 = textBox(handles.panelJump,[265 150 100 14],'');
    handles.tableJump3 = niceTable(handles.panelJump, zeros(8,1), ...
        [265 5 54 140],'jumpPar3');
    set(handles.tableJump3,'CellEditCallback',@editTableJumpCallback, ...
        'Visible','off');
    handles.tableJump4 = niceTable(handles.panelJump, zeros(8), ...
        [205 5 404 140], 'jumpPar4');
    set(handles.tableJump4,'CellEditCallback',@editTableJumpCallback, ...
        'Visible','off');

    handles.panelIntensity  = uipanel('Parent',handles.Tab(3), ...
        'Units','pixels', ...
        'Position',[5 180 140 190],'Title','Jump intensity loadings');
    textBox(handles.panelIntensity,[5 150 54 14],'constant');
    textBox(handles.panelIntensity,[82 150 30 14],'affine');
    handles.tableL0 = niceTable(handles.panelIntensity,handles.L0, ...
        [8 124 54 21], 'L0','Constant jump intensity');
    handles.tableL1 = niceTable(handles.panelIntensity,handles.L1, ...
        [73 5 54 140],'L1',['Coefficients in the linear ' ...
        'relation between the system''s jump intensity and each process']);
    
    handles.panelJump2 = uipanel('Parent',handles.Tab(3), ...
        'Units','pixels', ...
        'Position',[160 180 140 190],'Title','Drift correction');  
    for k = 1:8
        textBox(handles.panelJump2,[40 131-(k-1)*18 80 14],['process ' num2str(k)]);
        handles.checkDrift{k} = uicontrol('Style','checkbox', ...
            'Parent',handles.panelJump2, ...
            'Position', [114 131-(k-1)*18 14 14], ...
            'Callback',@checkBoxCallback, ...
            'Value',handles.isLog(k), ...
            'Tag',['DriftCorrect' num2str(k)], ...
            'TooltipString',['Tick here if you want to compensate the ' ...
            'drift of process ' num2str(k) ' for potential jumps']);
    %'Position',[100 140-(k-1)*18 14 14], ...
    end
    niceButton(handles.panelJump2,[8 150 120 21],@driftCorrection, ...
        'correct drift',['Press here for adding a jump compensator to ' ...
        'the drifts of the selected processes']);

function driftCorrection(varargin)
    if~preCheck();errBox;return;end
    createJumpFun;
    if ~isempty(handles.jumpFun)
    m = handles.jumpFun(eye(handles.nx))-1;
    for l = 1:handles.nx
        chD = get(handles.checkDrift{l},'Value');
        handles.K0(l) = handles.K0(l) - chD*handles.L0*m(l);
        handles.K1(l,:) = handles.K1(l,:) - chD*handles.L1'*m(l);
    end
    for l = 1:8
    set(handles.checkDrift{l},'Value',0);
    end
    set(handles.tableK0,'Data',handles.K0);
    set(handles.tableK1,'Data',handles.K1);
    end
end    
end


function dividendGUI()
    posGUI = get(handles.hFig,'Position');
    handles.dividendGUI = figure('Menubar','none', ...
    'Units','pixels', ...
    'Position',[posGUI(1)+500 posGUI(2)+200 480 180], ...
    'Name','Dividend Yields', ...
    'NumberTitle','off','Visible','off', ...
    'WindowKeyPressFcn',@keyShortcut,'CloseRequestFcn',@closeRequest);
    uicontrol('Style','Text', 'Parent',handles.dividendGUI, ...
        'Units','pixels', ...
        'Position',[5 150 84 14],'String','constant');
    uicontrol('Style','Text', 'Parent',handles.dividendGUI, ...
        'Units','pixels', ...
        'Position',[100 150 30 14],'String','affine');
    handles.tableQ0 = niceTable(handles.dividendGUI, ...
        handles.Q0,[10 10 54 140],'Q0') ;
    handles.tableQ1 = niceTable(handles.dividendGUI, ...
        handles.Q1, [70 10 404 140],'Q1');
    niceButton(handles.dividendGUI,[300 155 150 20],'close(gcbf)', ...
        'close and save (ESC)');
    set(handles.dividendGUI,'Visible','on');
end
function bondGUI()
   % subGUI plotting the yield curve of our system
    % opens a figure and populates it with two tables and a close button
    % when the table XX is edited, the corresponding handles.XX is updated
    hTemp           = waitbar(0,'Computing yield curve...');
    handles.bondGUI = createGUI('Bond Yields');
    handles.bondPlot = axes('Parent',handles.bondGUI,'Units','pixels', ...
        'Position',[80 50 700 400],'Visible','off');
    Tau = [0:0.01:handles.Tau]';
    [P yields] = handles.bondFun(Tau);
    waitbar(0.2,hTemp);
    [P2 yields2] = handles.riskyBondFun(Tau);
    waitbar(0.5,hTemp);
    if isnan(P(1));P(1)=handles.R0;end
    if isnan(P2(1));P2(1)=handles.R0 + handles.CDS0;end
    yields = yields*10000;
    yields2 = yields2*10000;
    plot(handles.bondPlot,Tau,yields,'LineWidth',2);
    xlim([0 handles.Tau]);
    ylim([0 max(yields)*1.5]);
    title('Term structure of risk free yields derived from affine dynamics');
    if any( [(handles.CDS0~=0); handles.CDS1~=0])
    hold on;
    plot(handles.bondPlot,Tau,yields2,'r','LineWidth',2);
    plot(handles.bondPlot,Tau,yields2-yields,'k--','LineWidth',1);
    hold off;
    title('Term structures of risky and risk free yields derived from affine dynamics');
    ylim([0 max(yields2)*1.5]);
    legend('risk free','risky','risk premium');
    end
    xlabel('time to maturity in years');
    ylabel('yield to maturity in bps');
    waitbar(0.7,hTemp);
    pause(0.1)
    nicePlot(handles.bondPlot);
    grid(handles.bondPlot);
    set(handles.bondPlot,'Visible','on');
    set(handles.bondGUI,'Visible','on');
    waitbar(0.9,hTemp);
    close(hTemp);
end
function cdsGUI()
    handles.cdsGUI = createGUI('CDS spreads');
    handles.cdsPlot = axes('Parent',handles.cdsGUI,'Units','pixels', ...
        'Position',[80 50 700 400],'Visible','off');
    hTemp           = waitbar(0,'Computing CDS spreads...');
    Tau             = [0:handles.dt:handles.Tau];
    protection      = handles.bondFunE(Tau);
    waitbar(0.4,hTemp); 
    premium         = handles.bondFun(Tau);
    waitbar(0.8,hTemp); 
    
    spread          = (1-handles.RR)*cumtrapz(protection)./cumtrapz(premium);
    waitbar(0.9,hTemp); 
    plot(handles.cdsPlot,Tau,10000*spread,'LineWidth',2)
    xlim([0 max(Tau)]);
    title(handles.cdsPlot, ...
            ['CDS spread term structure @ recovery rate: ' num2str(handles.RR)]);
    xlabel(handles.cdsPlot,'time to maturity in years');
    ylabel(handles.cdsPlot,'CDS spread in bps');
    nicePlot(handles.cdsPlot);
    grid(handles.cdsPlot);
    set(handles.cdsPlot,'Visible','on');
    set(handles.cdsGUI,'Visible','on');
    close(hTemp)
end
function impliedVolGUI()
    % subGUI plotting the yield curve of our system
    % opens a figure and populates it with two tables and a close button
    % when the table XX is edited, the corresponding handles.XX is updated
    handles.impliedVolGUI = createGUI('Implied Volatility');
    hTemp           = waitbar(0,'Step 1: Find option prices...');
    %K               = handles.X0(1)*linspace(0.5,2,nStrikes)';
    nStrikes        = 100;
    xRange          = exp(handles.logXRange);
    xRange          = linspace(1/xRange,xRange,nStrikes);
    K               = handles.X0(1)*xRange;
    idV             = [1;zeros(handles.nx-1,1)];
    [C,K]           = cf2call(@(u) handles.charFun(idV*u), ...
                        struct('x0',handles.coeff.X0(1), ...
                        'K',K,'N',handles.fftN, ...
                        'uMax',handles.uMax));
    temp            = handles.charFun(idV*[0 -i]);
    r               = -log(temp(1))./handles.Tau;
    S0q             = temp(2);
    % employ line search - most robust, requiers ~ 36 steps for tol 1e-10.
    f               = @(s) blsprice(S0q,K,r,handles.Tau,s);
    sL              = 0.00001*ones(nStrikes,1);
    sR              = 5*ones(nStrikes,1);
    sM              = 0.5*(sL+sR);
    for k = 1:600
       waitbar(0.5+0.5*(k/600),hTemp,'Step 2: Find IVs...'); 
     pause(0.01);
        err = f(sM)-C;
        if max(abs(err))<1e-10;break;end
        sL = (err>0).*sL + (err<0).*sM ;
        sR = (err>0).*sM + (err<0).*sR;
        sM = 0.5*(sL+sR);
    end
    handles.impliedVolPlot = axes('Parent',handles.impliedVolGUI, ...
        'Units','pixels','Position',[80 50 700 400],'Visible','off');
    plot(handles.impliedVolPlot,K,sM,'LineWidth',2);
    xlim(handles.impliedVolPlot,[K(1)*0.90  K(end)*1.05]);
    ylim(handles.impliedVolPlot,[0.25*min(sM) 1.5*max(sM)]);
    title(handles.impliedVolPlot, ...
        ['Implied Volatility of options written on ' handles.Names{1}]);
    xlabel(handles.impliedVolPlot,'strike');
    ylabel(handles.impliedVolPlot,'implied volatility');
    nicePlot(handles.impliedVolPlot);
    grid(handles.impliedVolPlot);
    set(handles.impliedVolPlot,'Visible','on');
    set(handles.impliedVolGUI,'Visible','on');
    close(hTemp)
    if max(abs(err))>1e-8;
        %errordlg('No convergence. Assets not risk neutralized?','Error');
    end
end
function optionPriceGUI()
    % subGUI plotting the yield curve of our system
    % opens a figure and populates it with two tables and a close button
    % when the table XX is edited, the corresponding handles.XX is updated
    handles.optionPriceGUI = createGUI('Option Prices');
    hTemp           = waitbar(0,'Step 1: Find option prices...');
    nStrikes        = 100;
    xRange          = exp(handles.logXRange);
    xRange          = linspace(1/xRange,xRange,nStrikes);
    K               = handles.X0(1)*xRange;
    idV             = [1;zeros(handles.nx-1,1)];
    [C,K]           = cf2call(@(u) handles.charFun(idV*u), ...
                        struct('x0',handles.coeff.X0(1), ...
                        'K',K,'N',handles.fftN, ...
                        'uMax',handles.uMax));
    temp            = handles.charFun(idV*[0 -i]);
    P               = C + K*temp(1) - temp(2);
    
    handles.optionPricePlot = axes('Parent',handles.optionPriceGUI, ...
        'Units','pixels','Position',[80 50 700 400],'Visible','off');
    plot(handles.optionPricePlot,K,[C P],'LineWidth',2);
    xlim(handles.optionPricePlot,[K(1)*0.90  K(end)*1.05]);
        title(handles.optionPricePlot, ...
        ['Prices of options written on ' handles.Names{1}]);
    legend('Call','Put');
    xlabel(handles.optionPricePlot,'strike');
    ylabel(handles.optionPricePlot,'Option price');
    nicePlot(handles.optionPricePlot);
    grid(handles.optionPricePlot);
    set(handles.optionPricePlot,'Visible','on');
    set(handles.optionPriceGUI,'Visible','on');
    close(hTemp)
    
end
function greeksGUI()
    hTemp           = waitbar(0,'Creating characteristic function...');
    nStrikes        = 200;
	xRange          = exp(handles.logXRange);
    xRange          = linspace(1/xRange,xRange,nStrikes);
    K               = handles.X0(1)*xRange;
               
               [~,idx] = min(abs(K-handles.X0(1)));
    K(idx) = handles.X0(1);
    idV = [1;zeros(handles.nx-1,1)];
    for l = 1:handles.nx
        Delta{l} = cf2call(@(u)greekFun(handles.charFun,idV*u,l),...
                    struct('x0',handles.coeff.X0(1), ...
                    'K',K,'N',handles.fftN,...
                    'uMax',handles.uMax));
    if handles.isLog(l)==1
        Delta{l} = Delta{l}/handles.X0(l);
    end
    waitbar(0.25+0.75*(l/handles.nx),hTemp,'Computing Greeks...'); 
    end
    for l = 1:handles.nx
       h = figure('Menubar','none','Units','pixels','Position', ...
           [50+l*(10) 50+l*10 800 500],'Name', ...
         ['Sensitivity of call option with respect to ' ...
         handles.Names{l} ' (close: ESC)'],'NumberTitle','off', ...
         'WindowKeyPressFcn',@keyShortcut,'CloseRequestFcn',@closeRequest);
        h = axes('Parent',h);
       plot(h,K,Delta{l},'k', ...
       [handles.X0(1) handles.X0(1)],[0 Delta{l}(idx)], 'k.', ...
              [0 handles.X0(1)],[Delta{l}(idx) Delta{l}(idx)],'k.');
        legend('Sensitivity vs. strike','ATM sensitivity');
        xlabel('Strike level');
        ylabel(['Sensitivity with respect to ' handles.Names{l}]);
    end
    close(hTemp);
    end
function impliedPdfGUI()
    % subGUI plotting the yield curve of our system
    % opens a figure and populates it with two tables and a close button
    % when the table XX is edited, the corresponding handles.XX is updated
    
    %handles.impliedPdfGUI = createGUI( ...
    %'implied risk neutral probability density function of return');
    hTemp           = waitbar(0,'Compute probability density function...');
    
    for l = 1:handles.nx
        idV             = zeros(handles.nx,1);
        idV(l)          = 1;
        if handles.isLog(l) ==1
            xRange          =handles.logXRange*linspace(-1,1,handles.fftN); 
            xRange          = handles.coeff.X0(l)+xRange;
        else
            xRange          = exp(handles.logXRange);
            xRange          = linspace(1/xRange,xRange,handles.fftN);
            xRange          = handles.coeff.X0(l)*xRange;
        end

        [f x]           = cf2pdf(@(u) handles.charFun(idV*u), ...
                         struct('x',xRange,'uMax',handles.uMax));
        if handles.isLog(l) ==1
        f               = f.*exp(x);
        f               = f/sum(f);
        x               = exp(x);
        end
        h               = figure('Menubar','none','Units','pixels', ...
                        'Position',[50+l*(10) 50+l*10 800 500],'Name', ...
                        ['Implied probability density of '  ...
                        handles.Names{l} ' (close: ESC)'],...
                        'NumberTitle','off','WindowKeyPressFcn', ...
                        @keyShortcut, 'CloseRequestFcn',@closeRequest);
        h               = axes('Parent',h);
        plot(h,x,f,'k','LineWidth',2);
        legend(h,'normalized implied density');
        title(h,['Implied probability density of ' handles.Names{l}]);
        xlabel(h,['Level of ' handles.Names{l} ' in ' ...
            num2str(handles.Tau) ' years from now']);
        ylabel('Normalized density');
        nicePlot(h);
        grid(h);
        waitbar(l/handles.nx,hTemp);
        
    end
    close(hTemp)
          
    

%      xlabel(handles.impliedPdfPlot,'log return');
%     nicePlot(handles.impliedPdfPlot);
% grid(handles.impliedPdfPlot);
%     set(handles.impliedPdfPlot,'Visible','on');
%     set(handles.impliedPdfGUI,'Visible','on');
end
function gabyGUI()
    handles.gabyGUI= createGUI( ...
    'G(a,b,y)');
    pos = get(handles.gabyGUI,'Position');
    set(handles.gabyGUI,'Position',[pos(1) pos(2) 270 410]);
    handles.panelGab3 = uipanel('Parent',handles.gabyGUI,'Units','pixels',...
    'Position',[5 350 260 50],'Title','');
    handles.gabFig = axes('Parent',handles.panelGab3,'Units','pixels', ...
        'Position',[5 5 248 36]);
    axes(handles.gabFig);
    imshow('html/figGaby.jpg');
    handles.panelGaby=uipanel('Parent',handles.gabyGUI,'Units','pixels',...
    'Position',[5 125 260 220],'Title','Parameters');
    textBox(handles.panelGaby,[90 180 54 20],'a');
    handles.tableGabyA = niceTable(handles.panelGaby,handles.GabyA, ...
        [65 40 54 140],'GabyA');
    textBox(handles.panelGaby,[155 180 54 20],'b');
    handles.tableGabyB = niceTable(handles.panelGaby,handles.GabyB, ...
        [130 40 54 140],'GabyB');
    textBox(handles.panelGaby,[55 10 10 20],'y');
    handles.editGabyY = uicontrol('Style','Edit', ...
        'Parent',handles.panelGaby,'Units','pixels','Position', ...
        [65 10 119 21],'BackgroundColor','white','Callback', ...
        @editCallback, 'String',handles.GabyY,'Tag','GabyY');
     handles.panelGab2=uipanel('Parent',handles.gabyGUI,'Units','pixels',...
    'Position',[5 75 260 50],'Title','Output');
    textBox(handles.panelGab2,[10 8 48 20],'G(a,b,y)=');    
    handles.outGaby = uicontrol('Style','Edit','Enable','inactive', ...
        'Parent',handles.panelGab2,'Units','pixels','Position', ...
        [65 10 119 21],'Callback','','String','');
    handles.b1 = niceButton(handles.gabyGUI,[5 45 260 25],@goGaby,'Go');
    niceButton(handles.gabyGUI,[5 5 260 20],'close(gcbf)','close (ESC)');
    function goGaby(varargin)
        hTemp = waitbar(0.5,'Computing G(a,b,y)');
        set(handles.b1,'Enable','off');
        val = cf2gaby(handles.charFun,handles.GabyA(1:handles.nx), ...
        handles.GabyB(1:handles.nx),eval(handles.GabyY), ...
        struct('N',handles.fftN,'u0',1e-8,'uMax',handles.uMax, ...
        'x0',0,'quad',handles.useQuad(1)));
        waitbar(0.8,hTemp);
        pause(0.1)
        set(handles.outGaby,'String',num2str(val));
        set(handles.b1,'Enable','on');
        close(hTemp);
    end
end
function editCallback(in1,in2)
    handles.(get(in1,'Tag')) = get(in1,'String');
end
%function HfromWGUI()
%    handles.HfromWGUI = createGUI('Compute H0 and H1 from Loading Matrix');
%    set(handles.HfromWGUI,'Visible','on')
%end
function preferencesGUI()
  % subGUI for setting dividend parameters for each asset process
    % opens a figure and populates it with two tables and a close button
    % when the table XX is edited, the corresponding handles.XX is updated
    posGUI = get(handles.hFig,'Position');
    handles.preferencesGUI = createGUI('Settings');
    set(handles.preferencesGUI,'Position', ...
        [posGUI(1)+500 posGUI(2)+200 320 380]);
    

    textBox(handles.preferencesGUI,[10 340 180 21],'Number of FFT nodes');
    handles.tablefftN = niceTable(handles.preferencesGUI, ...
        handles.fftN, [255 340 54 21],'fftN');
    textBox(handles.preferencesGUI,[10 310 180 21], ...
        'Time step for CDS integrals');
    handles.tabledt = niceTable(handles.preferencesGUI, ...
        handles.dt, [255 310 54 21],'dt');
    textBox(handles.preferencesGUI,[10 280 180 21], ...
            'Upper bound of complex integration');
    handles.tableuMax = niceTable(handles.preferencesGUI, ...
        handles.uMax, [255 280 54 21],'uMax');
    textBox(handles.preferencesGUI,[10 250 180 21], ...
        'range of log asset around log level');
    handles.tableLogXRange = niceTable(handles.preferencesGUI, ...
        handles.logXRange, [255 250 54 21],'logXRange');
    textBox(handles.preferencesGUI,[10 220 180 21], ...
        'Use quadrature methods for G(a,b,y)');
    handles.tableuseQuad = uicontrol('Style','checkbox','Position', ...
                    [280 225 14 14],'Value',handles.useQuad(1), ...
                    'Callback',@checkBoxCallback,'Tag','useQuad1');

    niceButton(handles.preferencesGUI,[5 5 150 20],'close(gcbf)', ...
        'close and save (ESC)');
set(handles.preferencesGUI,'Visible','on');
    end

%% utility functions
function findNX()
    % find the number of state variables from input matrices
    % cycles through all variables (tables) and find the greatest size
    % this size is then set as nx
    % this function has to be invoked before any serious business begins
    testSet         ={'K0','K1','H0','H1','X0','R1','L1'};
    nxi            = zeros(length(testSet),1);
    for k = 1:length(testSet)
        op             = handles.(testSet{k});
        if size(op,3)>1
            r = zeros(8,1);
            for l = 1:size(op,3)
            r(l) = any(any(op(:,:,l)~=0));
            end
            r = max(find(r~=0));
        else
            [r c]          = find(op~=0);
        end
        if isempty(r);r=0;end
        nxi(k) = max(r);
    end
    handles.nx = max(nxi);
end

function createCoeff()
    % this function creates those parameter coefficients that will go into
    % the final functions. 
    % must be invoked before any serious business
    nx              = handles.nx;
    handles.coeff.X0= handles.X0(1:nx);
    logX            = log(handles.coeff.X0(handles.isLog==1));
    handles.coeff.X0(handles.isLog==1) = logX;
    handles.coeff.R0= handles.R0;
    handles.coeff.R1= handles.R1(1:nx);
    handles.coeff.L0= handles.L0;
    handles.coeff.L1= handles.L1(1:nx);
    handles.coeff.K0= handles.K0(1:nx);
    handles.coeff.K1= handles.K1(1:nx,1:nx);
    handles.coeff.H0= handles.H0(1:nx,1:nx);
    handles.coeff.H1= handles.H1(1:nx,1:nx,1:nx);
    handles.coeff.CDS0 = handles.CDS0;
    handles.coeff.CDS1 = handles.CDS1(1:nx);
    handles.coeff.Q0= handles.Q0(1:nx);
    handles.coeff.Q1= handles.Q1(1:nx,1:nx)'; % compatibility. YAY!
end    




function createCharFun()
    % create characteristic function and store it in handles.charFun
    % 1. find nx , 2. create coefficeints, 3. find the jump function
    
    createJumpFun;
    handles.charFun = @(u) cfaffine(u,handles.coeff.X0, handles.Tau, ...
        handles.coeff.K0, ...
        handles.coeff.K1, ...
        handles.coeff.H0, ...
        handles.coeff.H1, ...
        handles.coeff.R0, ...
        handles.coeff.R1, ...
        handles.coeff.L0, ...
        handles.coeff.L1, ...
        handles.jumpFun,1);
end
function createBondFun()
    % create yield curve function and store it in handles.bondFun
    % 1. find nx , 2. create coefficeints, 3. find the jump function
    createJumpFun;
    handles.bondFun = @(Tau) cf2bond(Tau, ...
        handles.coeff.X0, ...
        handles.coeff.K0, ...
        handles.coeff.K1, ...
        handles.coeff.H0, ...
        handles.coeff.H1, ...
        handles.coeff.R0, ...
        handles.coeff.R1, ...
        handles.coeff.L0, ...
        handles.coeff.L1, ...
        handles.jumpFun);
end

function createRiskyBondFun()
    % create yield curve function and store it in handles.bondFun
    % 1. find nx , 2. create coefficeints, 3. find the jump function
    
    createJumpFun;
    handles.riskyBondFun = @(Tau) cf2bond(Tau, ...
        handles.coeff.X0, ...
        handles.coeff.K0, ...
        handles.coeff.K1, ...
        handles.coeff.H0, ...
        handles.coeff.H1, ...
        handles.coeff.R0 + handles.coeff.CDS0, ...
        handles.coeff.R1 + handles.coeff.CDS1, ...
        handles.coeff.L0, ...
        handles.coeff.L1, ...
        handles.jumpFun);
end

function createBondFunEx()
    % create yield curve function and store it in handles.bondFun
    % 1. find nx , 2. create coefficeints, 3. find the jump function
    createJumpFun;
    handles.bondFunE= @(Tau) cf2bondEx(handles.coeff.CDS0, ...
        handles.coeff.CDS1, ...
        Tau, ...
        handles.coeff.X0, ...
        handles.coeff.K0, ...
        handles.coeff.K1, ...
        handles.coeff.H0, ...
        handles.coeff.H1, ...
        handles.coeff.R0+handles.coeff.CDS0, ...
        handles.coeff.R1+handles.coeff.CDS1, ...
        handles.coeff.L0, ...
        handles.coeff.L1, ...
        handles.jumpFun,handles.jumpGradFun);
end
function createJumpFun()
    % create jump function and store it in handles.jumpFun
    % 1. find nx, 2. converge on jump function
    findNX;
    nx = handles.nx;
    switch handles.jumpNum
        case 1
            handles.jumpFun = [];
            handles.jumpGradFun = [];
        case 2
            par             = struct('MuJ',handles.jumpPar1(1:nx), ...
                                  'SigmaJ',handles.jumpPar2(1:nx,1:nx));
            handles.jumpFun = @(c) cfjump(c,par,'Merton');
            handles.jumpGradFun = @(c) cfjump(c,par,'MertonGrad');
        case 3
            par             = struct('MuJ',handles.jumpPar3(1:nx));
            handles.jumpFun = @(c) cfjump(c,par,'Exponential');
            handles.jumpGradFun = @(c) cfjump(c,par,'ExponentialGrad');
        case 4
            par             = struct('pUp',handles.jumpPar4(1:nx), ...
                                     'mUp',handles.jumpPar5(1:nx), ...
                                     'mDown',handles.jumpPar6(1:nx));
            handles.jumpFun = @(c) cfjump(c,par,'DoubleExponential');
            handles.jumpGradFun =@(c)cfjump(c,par,'DoubleExponentialGrad');
    end
end
function riskNeutralize()
    % if the Q-dynamics of dividend yields are known, we can
    % risk-neutralize the asset drifts with cfneutralize
    % after updating K0,K1 such that the corresponding asset drifts are
    % risk-neutral, delete the variables Q0 and Q1, as these are now 
    % incorporated in K0, K1.
    %!!I guess there are still some bugs regarding the size of Q0, Q1...!!
    handles.oldQ0   = handles.Q0;
    handles.oldQ1   = handles.Q1;
    handles.oldK0   = handles.K0;
    handles.oldK1   = handles.K1;
   
    nx = handles.nx;
    [K0 K1]         = cfneutralize( ...
        handles.coeff.K0, ...
        handles.coeff.K1, ...
        handles.coeff.H0, ...
        handles.coeff.H1, ...
        handles.coeff.R0, ...
        handles.coeff.R1, ...
        handles.coeff.Q0, ...
        handles.coeff.Q1, ...
        handles.coeff.L0, ...
        handles.coeff.L1, ...
        handles.jumpFun);
	handles.K0(1:nx)= K0;
    handles.K1(1:nx,1:nx) = K1;
    handles.Q0      =zeros(8,1);
    handles.Q1      = zeros(8);
    set(handles.tableK0,'Data',handles.K0);
    set(handles.tableK1,'Data',handles.K1);
    
    
    if isfield(handles,'tableQ0') 
        if ishandle(handles.tableQ0)
        set(handles.tableQ0,'Data',handles.Q0);
        set(handles.tableQ1,'Data',handles.Q1);
        end
    end
    
end
function deRiskNeutralize()
    handles.K0      = handles.oldK0;
    handles.K1      = handles.oldK1;
    handles.Q0      = handles.oldQ0;
    handles.Q1      = handles.oldQ1;
    set(handles.tableK0,'Data',handles.K0);
    set(handles.tableK1,'Data',handles.K1);
    if isfield(handles,'tableQ0') 
        if ishandle(handles.tableQ0)
        set(handles.tableQ0,'Data',handles.Q0);
        set(handles.tableQ1,'Data',handles.Q1);
        end
    end
end
function nicePlot(in)
    set(in,'FontSize',14);
    set(findall(in,'type','text'),'FontSize',14)
end
function out = niceTable(varargin)
    parent = varargin{1};
    data = varargin{2};
    position = varargin{3};
    tag = varargin{4};
    if length(varargin)>4
        tooltipstring = varargin{5};
    else
        tooltipstring = '';
    end
    out = uitable('Parent',parent, ...
        'Data',data,'Units','pixels','Position',position, ...
        'CellEditCallback',@editTableCallback, ...
        'CellSelectionCallback','','ColumnEditable',[true],  ...
        'ColumnFormat',{'numeric'},'ColumnName',([]), ...
        'ColumnWidth',{50},'Enable', 'on','RowName',[], ...
        'RowStriping','off','SelectionHighlight','off','Tag',tag, ...
        'TooltipString',tooltipstring);
end
function out = niceButton(varargin)
    parent = varargin{1};
    position = varargin{2};
    callback = varargin{3};
    string = varargin{4};
    if length(varargin)>4
    tooltipstring = varargin{5};
    else
    tooltipstring = '';
    end
    out = uicontrol('Style','pushbutton', ...
        'Units','pixels', ...
        'Position',position, ...
        'String',string, ...
        'Parent',parent, ...
        'Callback',callback,'TooltipString',tooltipstring);    
end
function out = textBox(parent,position,text)
	out = uicontrol('Style','Text', 'Parent',parent, ...
    	'Units','pixels', 'HorizontalAlignment','Left',...
        'Position',position,'String',text);
end
function out =  createGUI(in)
    posGUI = get(handles.hFig,'Position');
	out = figure('Menubar','none', ...
        'Units','pixels', ...
        'Position',[posGUI(1)+100 posGUI(2)+100 800 500], ...
        'Name',in, ...
        'NumberTitle','off','Visible','off', ...
        'WindowKeyPressFcn',@keyShortcut,'CloseRequestFcn',@closeRequest);
end
function out = blsprice(S,X,r,tau,s)
    d1 = (log(S./X)+(r+0.5.*s.^2).*tau)./(s.*sqrt(tau));
    d2 = d1-s.*sqrt(tau);
    out = S.*normcdf(d1)-X.*exp(-r.*tau).*normcdf(d2);
end
function out = greekFun(cf,u,k)
[out1, ~, out2]  = cf(u);
out = out1.*out2(k,:);
end

function out = preCheck()
    % test: nx>0 ; symmetric matrices; positive definiteness; Feller
    out             = 0;
    findNX;
    nx              = handles.nx;
    if handles.nx == 0; return; end
    createCoeff;
    % symmetry check
    diffuse1        = all(eig(handles.H0(1:nx,1:nx))>=0);
    for l = 1:handles.nx
        diffuse2(l)     = all(eig(handles.H1(1:nx,1:nx,l))>=0);
    end
    diffuseTest     = all([diffuse1 diffuse2]);
    
    % Feller condition for CIR like processes ('own' variance considered)
    c1              = [0:nx-1];
    c2              = [1:nx];
    sig             = handles.H1(c1*nx^2+c1*nx+c2)';
    fellerTest      = all(2*handles.K0(sig>0) > sig(sig>0));
    
    X0              = handles.X0(1:nx);
    isLog           = handles.isLog(1:nx);
    initTest        = all( X0(isLog==1)>0);
    
    tauTest         = handles.Tau>=0;
    RRTest          = (1>=handles.RR)*(handles.RR>=0);
                    
    jumpTest(1)     = all(eig(handles.jumpPar2)>=0);
    jumpTest(2)     = all(handles.jumpPar3>=0);
    jumpTest(3)     = all( (handles.jumpPar4>=0).*(handles.jumpPar4<=1));
    jumpTest(4)     = all((handles.jumpPar5>=0).*(handles.jumpPar6>=0));
    jumpTest        = all(jumpTest);
    
    out = all([diffuseTest fellerTest initTest tauTest RRTest jumpTest]);

end
function initializeParameters();
    handles.fftN    = 4096;
    handles.useQuad(1) = 1;
    handles.dt      = 0.01;
    handles.uMax    = 1000;
    handles.logXRange= 0.7;
    handles.Names   = {'x1';'x2';'x3';'x4';'x5';'x6';'x7';'x8'};
    handles.X0      = zeros(8,1);
    handles.isLog   = [0 ; zeros(7,1)];
    handles.nx      = 0;
    handles.Tau     = 1;
    handles.charFun = [];
    handles.GabyA   = zeros(8,1);
    handles.GabyB   = zeros(8,1);
    handles.GabyY   = 'log(1)';
    handles.charFunE= [];
    handles.bondFun = [];
    handles.bondFunE= [];
    handles.RR      = 0.40;
    handles.CDS0    = 0;
    handles.CDS1    = zeros(8,1);
    handles.K0      = zeros(8,1);
    handles.K1      = zeros(8);
    handles.H0      = zeros(8);
    handles.H1      = zeros(8,8,8);
    handles.R0      = 0;
    handles.R1      = zeros(8,1);
    handles.L0      = 0;
    handles.L1      = zeros(8,1);
    handles.Q0      = zeros(8,1) ;
    handles.Q1      = zeros(8,8);
    handles.coeff   = struct;
    handles.jumpFun = [];
    handles.jumpGradFun = [];
    handles.jumpPar1 = zeros(8,1); % corresponds to Merton style mean
    handles.jumpPar2 = zeros(8,8); % corresponds to Merton style cov
    handles.jumpPar3 = zeros(8,1); % corresponds to Exponential MU
    handles.jumpPar4 = zeros(8,1); % corresponds to Double-Exp Prob
    handles.jumpPar5 = zeros(8,1); % corresponds to Double-Exp MU_UP
    handles.jumpPar6 = zeros(8,1); % corresponds to Double-Exp MU_DOWN
    handles.jumpList= {'none','Merton','Exponential','DoubleExponential'};
    handles.jumpName= 'none';
    handles.jumpNum = 1;
    handles.ioSet   = {'X0','Names','isLog', ...
                     'Tau', ...
                     'R0','R1','L0','L1', ...
                     'Q0','Q1','K0','K1','H0','H1', ...
                     'jumpNum','jumpPar1','jumpPar2','jumpPar3', ...
                     'jumpPar4','jumpPar5','jumpPar6','CDS0','CDS1', ...
                     'RR'};
    handles.tableSet ={'X0','Names','Tau','R0','R1','L0','L1', ...
                     'Q0','Q1','K0','K1','H0','H1','CDS0','CDS1','RR'};
end

end