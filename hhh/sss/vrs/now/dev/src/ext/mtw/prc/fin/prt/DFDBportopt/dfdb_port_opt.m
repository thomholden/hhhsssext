function dfdb_port_opt(varargin)
% DFDB_PORT_OPT Database/Datafeed Portfolio Optimizer - Graphical User Interface.
% 	DFDB_PORT_OPT imports security time series data from Yahoo or a database,
%     plots it, and then computes the efficient frontier of a portfolio made up of
%     the securities.
% 
% Toolboxes Needed: Financial, Optimization, Statistics, Database, Datafeed
% 
% Setup:
% Set up a datasource though ODBC on Windows from the assets2000.mdb database 
% called DFDBsample. There is an explanation of how to do this in the Database 
% Toolbox User’s Guide.
% 
% Selecting Data Inport Method:
% Pull down the Filee menu, select Preferences, then Data Source. 
% Once inside Data Source, select either Datafeed or Database.
% 
% Importing Time Series Data:
% If using the Datafeed option:
% Type the Yahoo recognized symbols of the securities you wish to use in the 
% editable text box, labeled "Enter Symbols Separated by Commas." Enter as many 
% securities as you wish. Symbols need to be separated by commas.  Use the "Help ->
% Symbol Lookup" menu for assistance.
% 
% Example:
% ibm,msft,csco
% 
% Select a starting date for the time series to be imported. If on a PC, an 
% ActiveX calendar may be brought up to view and select a date. The time series 
% ends with the yesterday's closing price.
% 
% If using the Database option:
% Use the "Select Data" window to select the Data Source and fields from the 
% database. Clicking the "Apply" button will send the Date and Asset choices for 
% importing. The database option does not allow setting the startdate. Also, 
% the database set up to work with this tool is DFDBsample. The time series date 
% range stored in DFDBsample is from January 2, 1997 to December 8, 2000.
%     
% To import the time series data and plot it, press the button labeled, 
% "Get Time Series." To Scale the time series data to one, select the
% checkbox labelled "Scale Time Series."
% 
% Plotting Efficient Frontier:
% Press the button, "Generate Frontier." Make sure that the data has been loaded 
% before attempting to generate the frontier.
% 
% Find the Security Distribution Given a Desired Rate of Return:
% Enter the desired rate of return or desired risk in the appropriate editable 
% text box. The number entered needs to be within the upper and lower bounds 
% shown in red. The fraction of each security in your portfolio needed to reach 
% the desired rate of return or risk will then be shown underneath. This can also 
% be done graphically by dragging the green lines along the efficient frontier.

%   Author:  Brian Kiernan
%     Date:  May 21, 2001


if nargin == 0
    call = 'Setup';
    shh = get(0,'ShowHiddenHandles');
    set(0,'ShowHiddenHandles','on')
    F1 = findobj(0,'tag','dfdbportopt');
    set(0,'ShowHiddenHandles',shh);
    if ~isempty(F1)
        figure(F1)
        return
    end
else
    call = varargin{1};
end

if ~ispref('DFDBpref','datainput')
    setpref('DFDBpref','datainput','df')
end

if ~ispref('DFDBpref','scaling')
    setpref('DFDBpref','scaling','on')
end
    

persistent cal

switch call

case 'Setup'
    % Create GUI
    
    screenRect  = get(0,'screensize');

    F1=hgload('mymenufile.fig');
    fpos = get(F1,'pos');
    
    set(F1,'pos',[20 screenRect(4)-fpos(4)-50 fpos(3) fpos(4)],'defaultaxesunits','norm', ...
        'defaultuicontrolunits','norm','defaultuicontrolfontsize',9,'defaulttextfontsize',9, ...
        'defaulttextcolor','b','menubar','none','numbertitle','off','name', ...
        'Data Input Portfolio Optimization','tag','dfdbportopt','closerequestfcn', ...
        'dfdb_port_opt(''Closecall'')');
    
    prefmenu = uimenu(F1,'label','&Preferences','separator','on');
    datasourcemenu = uimenu(prefmenu,'label','&Data Source');
      dataf=uimenu(datasourcemenu,'label','datafeed','tag','dfmen','callback', ...
          'setpref(''DFDBpref'',''datainput'',''df''); dfdb_port_opt(''Datasource'');');
      datab=uimenu(datasourcemenu,'label','database','tag','dbmen','callback', ...
          'setpref(''DFDBpref'',''datainput'',''db''); dfdb_port_opt(''Datasource'')');
     
          pref = getpref('DFDBpref','datainput');
          if strcmp(pref,'df')
              set(findobj(gcf,'tag','dfmen'),'checked','on')
              set(findobj(gcf,'tag','dbmen'),'checked','off')
          elseif strcmp(pref,'db')
              set(findobj(gcf,'tag','dbmen'),'checked','on')
              set(findobj(gcf,'tag','dfmen'),'checked','off')
          end
    
          
    helpmenu = uimenu(F1,'label','Help');
      toolhelp = uimenu(helpmenu,'label','&DFDB_Port_Opt Help','callback', ...
        'dfdb_port_opt(''Helppage'')');
      symlookup = uimenu(helpmenu,'label','Symbol Lookup','callback','dfdb_port_opt(''Yahoosym'')');
      
%     C = yahoo;
%     if ~isconnection(C)
%         set(symlookup,'enable','off')
%     end
%     clear C
    
    closemenu = uimenu(findobj(F1,'label','&File'),'label','Close', ...
        'callback','dfdb_port_opt(''Closecall'')');
    
    
	Tseries = axes('pos',[.4 .57 .52 .39],'tag','tsax');
    set(Tseries,'xtick',0:.2:1,'ytick',0:.2:1);
    set(gca,'fontsize',8,'xticklabel','','yticklabel','')
    xlabel('Time')
	Ylabel('Price')
	title('Time Series','color','k')
    grid on
   	
	Effront = axes('units','norm','pos',[.4 .07 .52 .39],'tag','efax');
	set(Effront,'xtick',0:.2:1,'ytick',0:.2:1);
    set(gca,'fontsize',8,'xticklabel','','yticklabel','')
    xlabel('Volatility (\sigma)')
	ylabel('Rate of Return')
	title('Efficient Frontier','color','k')
    grid on
      
    axes(Tseries)
    Symbolprompt = uicontrol('style','text','pos',[.01 .95 .33 .03],'fontsize',9, ...
        'string','Enter Symbols Separated by Commas','backgroundcolor',[.8 .8 .8], ...
        'foregroundcolor','b','tag','symp');
	Symbols = uicontrol('style','edit','string','','pos',[.02 .9 .18 .04], ...
        'horizontalalignment','left','backgroundcolor','w','tag','symstr');
    
    Dscall = uicontrol('pos',[.21 .9 .12 .04],'string','Select Data','tag','dsbut', ...
        'callback','DFDB_port_opt(''SelectData'')');
	
    % Starting date of time series
    axes(Tseries)
    
    Startdateprompt = uicontrol('style','text','pos',[.05 .8 .25 .03],'fontsize',9, ...
           'string','Enter Starting Date  (m/d/yyyy)','backgroundcolor',[.8 .8 .8], ...
           'foregroundcolor','b','tag','sdp');
    
    if ispc
        
        Startdatecal = uicontrol('string','View Calendar','pos',[.045 .73 .13 .05], ...
            'callback','dfdb_port_opt(''Calendar'')','tag','calbut');

        Startdatebox = uicontrol('style','edit','string','','pos',[.185 .735 .12 .04], ...
           'backgroundcolor','w','tag','sdstr','callback','dfdb_port_opt(''Datecheck'')');
        
        if isequal(getpref('DFDBpref','datainput'),'db')
            set(Startdatecal,'enable','off')
        end
        
    else
                  
        Startdatebox = uicontrol('style','edit','string','','pos',[.09 .753 .12 .04], ...
           'backgroundcolor','w','tag','sdstr');
    end
    
    if isequal(getpref('DFDBpref','datainput'),'db')
        set(Startdateprompt,'enable','off')
        set(Startdatebox,'string','1/2/1997','enable','off')
    else
        set(Dscall,'enable','off')
    end
        
        
    % scale time series checkbox
    TSscale = uicontrol('style','check','string','Scale Time Series','pos',[.09 .66 .18 .02], ...
        'backgroundcolor',[.8 .8 .8],'callback','dfdb_port_opt(''ScaleTS'')','tag','scalechk', ...
        'foregroundcolor','b');
    
    if strcmp(getpref('DFDBpref','scaling'),'on') == 1
        set(TSscale,'value',1)
    else
        set(TSscale,'value',0)
    end
    
    
    % time series generator button
	TScall = uicontrol('string','Get Time Series','pos',[.07 .57 .2 .05], ...
        'callback','dfdb_port_opt(''GetData'')','tag','tsbut');
	
    % efficient frontier generator button
	Frontiercall = uicontrol('string','Generate Frontier','pos',[.07 .41 .2 .05], ...
        'callback','dfdb_port_opt(''EffFront'')','tag','efbut','enable','off');
	
    % Rate of Return
	axes(Effront);
	Rateofreturnprompt = uicontrol('style','text','pos',[.005 .37 .13 .03],'string', ...
        'Rate of Return','foregroundcolor','b','backgroundcolor',[.8 .8 .8],'tag', ...
        'rorp','enable','off');
    Rateofreturn = uicontrol('style','edit','string','','pos',[.03 .33 .08 .04], ...
        'callback','dfdb_port_opt(''WeightCalcRoR'')','backgroundcolor','w','tag','rorstr', ...
        'enable','off');
    
    Riskprompt = uicontrol('style','text','pos',[.235 .37 .05 .03],'string', ...
        'Risk','foregroundcolor','b','backgroundcolor',[.8 .8 .8],'tag', ...
        'riskp','enable','off');
    
    Risk = uicontrol('style','edit','string','','pos',[.22 .33 .08 .04], ...
        'callback','dfdb_port_opt(''WeightCalcRisk'')','backgroundcolor','w','tag','riskstr', ...
        'enable','off');

        
    % Securites list with corresponding weights
    Securtext = uicontrol('style','text','backgroundcolor',[.8 .8 .8],'foregroundcolor',[.66 0 .11], ...
        'pos',[.06 .295 .1 .028],'string','Securites','fontsize',9,'tag','securtxt','enable','off');
    Securweights = uicontrol('style','text','backgroundcolor',[.8 .8 .8],'foregroundcolor',[.66 0 .11], ...
        'pos',[.17 .295 .1 .028],'string','Weights','fontsize',9,'tag','securwts','enable','off');

    set(F1,'handlevis','callback');

    pref = getpref('DFDBpref','datainput');
    if strcmp(pref,'db')
       DFDB_port_opt('SelectData','start')
    end
    
    
     
    
case 'Datecheck'
    % check for correct date format
    
    Startdatebox = findobj(gcf,'tag','sdstr');
    startdate = get(Startdatebox,'string');
    
    slash = find(startdate == '/');
    
    if length(startdate(slash(end)+1:end)) ~= 4
       err = errordlg('Invalid Date','Enter Starting Date');
       set(err,'windowstyle','modal')
       return
    end
    
    try 
        datenum(startdate);
    catch
        err = errordlg('Invalid Date','Enter Starting Date');
        set(err,'windowstyle','modal')
        return
    end

    
case 'GetData'
    % Retrieve time series from the Yahoo server or from local database.
    
    % clear plots and data from of earlier runs
    %%%%%%%%%%
    Tseries = findobj(gcf,'tag','tsax');
    Effront = findobj(gcf,'tag','efax');
        
    axes(Effront)
    cla(Effront)
    axes(Tseries)
    cla(Tseries)
       
    drawnow

    Rateofreturn = findobj(gcf,'tag','rorstr');
    Rateofreturnprompt = findobj(gcf,'tag','rorp');
    Risk = findobj(gcf,'tag','riskstr');
    Riskprompt = findobj(gcf,'tag','riskp');
    Frontiercall = findobj(gcf,'tag','efbut');
    Securtext = findobj(gcf,'tag','securtxt');
    Securweights = findobj(gcf,'tag','securwts');
    WtText = findobj(gcf,'tag','wttxt');
    WtWeight = findobj(gcf,'tag','wtwt');
    leg = findobj(gcf,'tag','legend');
    Frontleg = findobj(gcf,'tag','frleg');
    
    set(Rateofreturn,'string','')
    set(Risk,'string','')
    delete(WtText)
    delete(WtWeight)
    delete(leg)
    delete(Frontleg)
    clear WtText WtWeight leg Frontleg
    drawnow
    %%%%%%%%%
    
    pref=getpref('DFDBpref','datainput');
    
%     try
        % Read in time series data for entered symbols and separate
        %%%%%%%%%
        Symbols = findobj(gcf,'tag','symstr');
        Strings = get(Symbols,'string');
        wtspace = find(Strings == ' ');
        Strings(wtspace) = [];
        
        commas = find(Strings == ',');
        commas = [0, commas, length(Strings)+1];
        
        symcell = cell(length(commas)-1,1);
        data = cell(length(symcell),1);
        
        for i=1:length(commas)-1
            symcell{i}=Strings(commas(i)+1:commas(i+1)-1);
        end
        %%%%%%%%%
        
        Startdatebox = findobj(gcf,'tag','sdstr');
       
        % test for data source
        if strcmp(pref,'df')
            %
            % Datafeed data input option
            %
            
            try
                C=yahoo;
            catch
                err = errordlg('Connection to Yahoo Failed','Datafeed Connection');
                set(err,'windowstyle','modal')
                return
            end
            
            setappdata(Tseries,'Connection',C);
            
            yesterday = datestr(datenum(date)-1);
            startdate = get(Startdatebox,'string');
            
            if isempty(get(Symbols,'string'))
                err = errordlg('First enter symbols','Get Time Series');
                set(err,'windowstyle','modal')
                return
            end
            
            if isempty(startdate)
                err = errordlg('First enter starting date.','Get Time Series');
                set(err,'windowstyle','modal')
                return
            end
            
            quitcase = 'no';
            Wtbardf = waitbar(0,'Retrieving Data From Yahoo');      
            for i=1:length(symcell)
               try
                  data{i} = fetch(C,symcell(i),'Close',startdate,yesterday);
               catch
                  err = errordlg('Invalid Symbol','Symbol Selection');
                  set(err,'windowstyle','modal')
                  quitcase = 'yes';
                  break
               end
                   waitbar(i/length(symcell),Wtbardf)
            end
            close(Wtbardf)
            
            if strcmp(quitcase,'yes')
                return
            end
                        
            % Preprocess data for plotting
            maxlength = max(cellfun('length',data));
            for i=1:length(data)
                if length(data{i}(:,1)) == maxlength
                    timevector = data{i}(:,1);
                    break
                end
            end
            
            pricearray = ones(maxlength,length(data));
            for k=1:length(data)
                if cellfun('length',data(k)) == maxlength
                    pricearray(:,k) = data{k}(:,2);
                else
                    pricearray(:,k) = [data{k}(:,2);NaN*ones(diff([cellfun('length',data(k)),maxlength]),1)];
                end
            end
            
        else
            %
            % database data input option
            %
            
%             try
            conn = getappdata(Symbols,'connection');

            if  isempty('conn')
                err = errordlg('First Select Data Source','Get Time Series');
                set(err,'windowstyle','modal')
                return
            end
            
%             conn = getappdata(Symbols,'connection');
            dates = getappdata(Symbols,'dates');
            tablelist = getappdata(Symbols,'Tables');
            
            
%             conn = database('DFDBsample','','');
            cursorA=exec(conn,['select ',dates,' from ', tablelist{1}]);
%             cursorA=exec(conn,['select ',dates,' from ', tablelist]);
            cursorA=fetch(cursorA);
            Dates=cursorA.data;
%             Dates=datenum(Dates);
            
            Wtbardb = waitbar(0,'Retrieving Data From Database');
            for j=1:length(symcell)
                selectstring = ['select ',symcell{j},' from ', tablelist{1}];
                cursor = exec(conn,selectstring);
                cursor = fetch(cursor);
                data{j} = cursor.data;
                waitbar(i/length(symcell),Wtbardb)
            end
            close(Wtbardb)
            
            timevector = cat(1,Dates{:});
            pricearray = ones(length(Dates),length(data));
            
            for k = 1:length(data)
                for m=1:length(data{k})
                    pricearray(m,k)=data{k}{m};
                    
                end
            end
            
            startdate = [];
            
%         catch
%             err = errordlg('Invalid Date and/or Asset','Get Time Series');
%             set(err,'windowstyle','modal')
%             return
%         end
        
    end
        
        
        % Plot time series
        axes(Tseries)
        hold off
        
        if strcmp(getpref('DFDBpref','scaling'),'off') == 1
            plot(timevector,pricearray)
            xlabel('Time','fontsize',8)
            ylabel('Price','fontsize',8)
            title('Time Series','color','k')
            set(Tseries,'tag','tsax')
            
            dateaxis('x',12);
            leg = legend(symcell,2);
            set(leg,'tag','legend')
            grid on
        
       else
           [m,n]=size(pricearray);
           
           scaledpricearray = ones(size(pricearray));
           
           pref=getpref('DFDBpref','datainput');
        
           if strcmp(pref,'db') == 1
               for i = 1:n
                   scaledpricearray(:,i) = pricearray(:,i)./pricearray(1,i);
               end
           else
               
               indivprices = ones(m,1);
               for i = 1:n
                   indivprices = pricearray(:,i);
                   scaledpricearray(:,i) = pricearray(:,i)./indivprices(max(find(~isnan(indivprices))));
               end
               clear indivprices
               
           end
           
           axes(Tseries)
           hold off
           
           plot(timevector,scaledpricearray)
           xlabel('Time','fontsize',8)
           ylabel('Worth of $1 Invested','fontsize',8)
           title('Time Series','color','k')
           set(Tseries,'tag','tsax')
           
           dateaxis('x',12);
           leg = legend(symcell,2);
           set(leg,'tag','legend')
           grid on
       end
    
        
        
        % Set appdata to be used later in the code
        setappdata(Effront,'data',data);
        setappdata(Effront,'symcell',symcell);
        setappdata(Tseries,'TickTimes',timevector);
        setappdata(Tseries,'TickSeries',pricearray);
        setappdata(Tseries,'SymCell',symcell);
        setappdata(Startdatebox,'startdate',startdate);
        
        set(Rateofreturn,'enable','on')
        set(Rateofreturnprompt,'enable','on')
        set(Risk,'enable','on')
        set(Riskprompt,'enable','on')
        set(Frontiercall,'enable','on')
        set(Securtext,'enable','on')
        set(Securweights,'enable','on')
        
        axes(Effront)
        percent = text('units','norm','pos',[-.55 .72 0],'string','%','color','b');
        sigma = text('units','norm','pos',[-.18 .72 0],'string','\sigma','color','b');
        
%     catch
%         err = errordlg('Invalid Symbol','Symbol Selection');
%         set(err,'windowstyle','modal')
%         return
%     end
    

case 'ScaleTS'
    Tseries = findobj(gcf,'tag','tsax');
    timevector = getappdata(Tseries,'TickTimes');
    pricearray = getappdata(Tseries,'TickSeries');
    symcell = getappdata(Tseries,'SymCell');

    TSscale = findobj(gcf,'tag','scalechk');
    
    if get(TSscale,'value') == 1
        setpref('DFDBpref','scaling','on')
        [m,n]=size(pricearray);
        
        scaledpricearray = ones(size(pricearray));
        
        pref=getpref('DFDBpref','datainput');
        
        if strcmp(pref,'db') == 1
            for i = 1:n
              scaledpricearray(:,i) = pricearray(:,i)./pricearray(1,i);
            end
        else
            
            indivprices = ones(m,1);
            for i = 1:n
              indivprices = pricearray(:,i);
              scaledpricearray(:,i) = pricearray(:,i)./indivprices(max(find(~isnan(indivprices))));
            end
            clear indivprices
        
        end
        
        axes(Tseries)
        hold off
        
        plot(timevector,scaledpricearray)
        xlabel('Time','fontsize',8)
        ylabel('Worth of $1 Invested','fontsize',8)
        title('Time Series','color','k')
        set(Tseries,'tag','tsax')
        
        dateaxis('x',12);
        leg = legend(symcell,2);
        set(leg,'tag','legend')
        grid on
               
    else 
        setpref('DFDBpref','scaling','off')
        axes(Tseries)
        hold off
        
        plot(timevector,pricearray)
        xlabel('Time','fontsize',8)
        ylabel('Price','fontsize',8)
        title('Time Series','color','k')
        set(Tseries,'tag','tsax')
        
        dateaxis('x',12);
        leg = legend(symcell,2);
        set(leg,'tag','legend')
        grid on
        
    end
    
    
case 'EffFront'
    % Calculate and plot efficient frontier of a portfolio of given securities
    
    Effront=findobj(gcf,'tag','efax');
    tempdat = getappdata(Effront);
    Tseries = findobj(gcf,'tag','tsax');
    
    symcell = tempdat.symcell;
    data = tempdat.data;
    
    warning off
        
    % check for time series data first
    if isempty(data)
       err = errordlg('Get time series first');
       set(err,'windowstyle','modal')
       return
    end
  
    % test for Data Source
    if isequal(getpref('DFDBpref','datainput'),'df')  % Datafeed scenario
        
     
        % Put times and prices of securities into the order of oldest to most recent,
        % and make the length of all time series (TS) vectors equal to the TS length
        % of the security with the minimum amount of data.
        
        %%%%%%%%
        secur=cell(1,length(data));
        for i=1:length(data)
            secur{i} = data{i}(:,2);
        end
        
        lengths = cellfun('length',data);
        minlength = min(lengths);
        maxlength = max(lengths);
        
        for i=1:length(data)
            if length(data{i}(:,1)) == minlength
                [TickTimes, index]=sort(data{i}(:,1));
                break
            end
        end
        
        
        for k=1:length(data)
            empty = rem(lengths(k),minlength);
            
            if empty ~= 0
                secur{k}(1:empty) = [];
            end
            
            secur{k} = secur{k}(index);
        end
        %%%%%%%%%

        TickSeries = ones(length(secur{1}),length(data));
        
        for j=1:length(data)
            TickSeries(:,j) = secur{j};
        end
    
	
    else %Database scenario
    
        TickSeries = getappdata(Tseries,'TickSeries');
        TickTimes = getappdata(Tseries,'TickTimes');
        
    end
    
            
    % Generate expected return of each security and the covariance matrix 
        
    RetSeries=tick2ret(TickSeries, TickTimes);
	[ExpReturn, ExpCovariance]=ewstats(RetSeries);
	
	
    % Convert daily rate of return to annual by 
	% assuming number of business days per year is 253
	ExpReturn=ExpReturn*253;
	

    % Generate Efficient Frontier
	[PortRisk,PortReturn,PortWts]=portopt(ExpReturn,ExpCovariance,30);
	
    axes(Effront)
	
    frontierline = plot(PortRisk,PortReturn,'tag','frontline');
	xlabel('Volatility (\sigma)','fontsize',8)
	ylabel('Annual Rate of Return (%)','fontsize',8)
%     ticks = get(gca,'yticklabel');
%     nticks=num2str(100*str2num(ticks));
%     set(gca,'yticklabel',nticks)
	title('Efficient Frontier','color','k')
    grid on
    
    
    % Display rate of return corresponding to minimun risk, and place weights of
    % each security needed to reach that rate next to the security name.
    
    %%%%%%%%%
    [MinRisk,idx] = min(PortRisk);
	RoR = PortReturn(idx);
    
    Rateofreturn = findobj(gcf,'tag','rorstr');
    Risk = findobj(gcf,'tag','riskstr');
    
    maxRoR = max(PortReturn);
    minRoR = min(PortReturn);
    maxRisk = max(PortRisk);
    minRisk = min(PortRisk);
    
    plotrisk = minRisk + 0.5*(maxRisk - minRisk);
    plotror = interp1(PortRisk,PortReturn,plotrisk);
    
    set(Rateofreturn,'string',sprintf('%1.2f',100*plotror));
	set(Risk,'string',sprintf('%1.4f',plotrisk));
    
    PortReturn = round(PortReturn*10000)/10000;
%     PortWts = str2num(sprintf('%1.4f',PortWts));
%     PortRisk = str2num(sprintf('%1.4f',PortRisk));
    setappdata(Rateofreturn,'PortReturn',PortReturn);
    setappdata(Rateofreturn,'PortWts',PortWts);
    setappdata(Rateofreturn,'PortRisk',PortRisk);
    
    Securtext = findobj(gcf,'tag','securtxt');
    Securweights = findobj(gcf,'tag','securwts');
    Securtextpos = get(Securtext,'pos');
    Securweightspos = get(Securweights,'pos');

    WtText = findobj(gcf,'tag','wttxt');
    WtWeight = findobj(gcf,'tag','wtwt');
    
    delete(WtText)
    delete(WtWeight)
    clear WtText WtWeight
            
    for i=1:length(data)
		WtText(i) = uicontrol('style','text','pos',[Securtextpos(1) Securtextpos(2)-.03*i .1 .03], ...
            'string',symcell(i),'backgroundcolor',[.8 .8 .8],'tag','wttxt');
		WtWeight(i) = uicontrol('style','text','pos',[Securweightspos(1) Securweightspos(2)-.03*i .1 .03], ...
            'string',sprintf('%1.4f',PortWts(idx,i)),'backgroundcolor',[.8 .8 .8],'tag','wtwt');
    end
    %%%%%%%%%%
    
    
    % Display maximum and minimum possible rates of return and plot red line
    % corresponding to these values
    
    hold on
    xaxislims = get(gca,'xlim');
    yaxislims = get(gca,'ylim');
    
    plot(xaxislims,[maxRoR maxRoR],'r--',xaxislims,[minRoR minRoR],'r--','linewidth',.1)
    plot([minRisk,minRisk],yaxislims,'r--',[maxRisk, maxRisk],yaxislims,'r--','linewidth',.1)
    set(gca,'xlim',xaxislims)
    set(gca,'ylim',yaxislims)
    
    ticks = get(gca,'yticklabel');
    nticks=num2str(100*str2num(ticks));
    set(gca,'yticklabel',nticks)
    
    maxRoRtxt = text(xaxislims(2),maxRoR,[' ',sprintf('%1.2f',100*maxRoR)],'color','r', ...
        'tag','mxRotxt');
    minRoRtxt = text(xaxislims(2),minRoR,[' ',sprintf('%1.2f',100*minRoR)],'color','r', ...
        'tag','mnRotxt');
    minRisktxt = text(minRisk,yaxislims(1) - 0.12*diff(yaxislims),sprintf('%1.4f',minRisk), ...
        'tag','mnRitxt','color','r');
    maxRisktxt = text(maxRisk,yaxislims(1) - 0.12*diff(yaxislims),sprintf('%1.4f',maxRisk), ...
        'tag','mxRitxt','color','r');
    
    vert = plot([plotrisk plotrisk],[yaxislims(1) plotror],'g','tag','vertlin','ButtonDownFcn', ...
        'dfdb_port_opt(''Animatevline'',''start'')','erasemode','xor','linewidth',2);
    horz = plot([xaxislims(1),plotrisk],[plotror plotror],'g','tag','horzlin','ButtonDownFcn', ...
        'dfdb_port_opt(''Animatehline'',''start'')','erasemode','xor','linewidth',2);
    Frontleg = legend('Frontier','Min/Max Risk/Return',2);
    set(Frontleg,'tag','frleg');
    hold off
    set(Effront,'tag','efax')
    percent = text('units','norm','pos',[-.55 .72 0],'string','%','color','b');
    sigma = text('units','norm','pos',[-.18 .72 0],'string','\sigma','color','b');
    
    if length(data) > 10
        err = errordlg('Warning: Only 10 asset weights can be viewed','Generate Frontier');
        set(err,'windowstyle','modal')    
    end
    
case 'Animatevline'
    
    F1 = findobj('tag','dfdbportopt');
    Rateofreturn = findobj(gcf,'tag','rorstr');
    Risk = findobj(gcf,'tag','riskstr');
    vert = findobj(gcf,'tag','vertlin');
    horz = findobj(gcf,'tag','horzlin');
    frontierline = findobj(gcf,'tag','frontline');
    x = get(frontierline,'xdata');
    y = get(frontierline,'ydata');
    
    xaxislims = get(gca,'xlim');
    yaxislims = get(gca,'ylim');
    
    switch varargin{2}
        
        case 'start'
            
            set(F1,'WindowButtonMotionFcn','DFDB_port_opt(''Animatevline'',''move'')')
            set(F1,'WindowButtonUpFcn','DFDB_port_opt(''Animatevline'',''stop'')')
            
        case 'move'
            
            currPt = get(gca,'CurrentPoint');
            
            if currPt(1,1) - min(x) < -0.000001
                currPt(1,1) = min(x);
            end
            if currPt(1,1) - max(x) > 0.000001
                currPt(1,1) = max(x);
            end
            
            newRisk = currPt(1,1);
            newRoR = interp1(x,y,currPt(1,1));
            set(vert,'xdata',[newRisk newRisk],'ydata',[yaxislims(1) newRoR],'tag','vertlin','linewidth',2)
            set(horz,'xdata',[xaxislims(1) newRisk],'ydata',[newRoR newRoR],'tag','horzlin','linewidth',2)
            set(Rateofreturn,'string',sprintf('%1.2f',100*newRoR));
            set(Risk,'string',sprintf('%1.4f',newRisk));
            
        case 'stop'
            
            set(F1,'WindowButtonMotionFcn','')
            set(F1,'WindowButtonUpFcn','')
            DFDB_port_opt('WeightCalcRoR')
    end

    
case 'Animatehline'
    
    F1 = findobj('tag','dfdbportopt');
    Rateofreturn = findobj(gcf,'tag','rorstr');
    Risk = findobj(gcf,'tag','riskstr');
    vert = findobj(gcf,'tag','vertlin');
    horz = findobj(gcf,'tag','horzlin');
    frontierline = findobj(gcf,'tag','frontline');
    x = get(frontierline,'xdata');
    y = get(frontierline,'ydata');
    
    xaxislims = get(gca,'xlim');
    yaxislims = get(gca,'ylim');
    
    switch varargin{2}
        
        case 'start'
            
            set(F1,'WindowButtonMotionFcn','DFDB_port_opt(''Animatehline'',''move'')')
            set(F1,'WindowButtonUpFcn','DFDB_port_opt(''Animatehline'',''stop'')')
            
        case 'move'
            
            currPt = get(gca,'CurrentPoint');
            
            if currPt(1,2) - y(find(x==min(x))) < -0.000001
                currPt(1,2) = y(find(x==min(x)));
            end
            if currPt(1,2) - y(find(x==max(x))) > 0.000001
                currPt(1,2) = y(find(x==max(x)));
            end
            
            newRoR = currPt(1,2);
            newRisk = interp1(y,x,currPt(1,2));
            set(vert,'xdata',[newRisk newRisk],'ydata',[yaxislims(1) newRoR],'tag','vertlin','linewidth',2)
            set(horz,'xdata',[xaxislims(1) newRisk],'ydata',[newRoR newRoR],'tag','horzlin','linewidth',2)
            set(Rateofreturn,'string',sprintf('%1.2f',100*newRoR));
            set(Risk,'string',sprintf('%1.4f',newRisk));
            
        case 'stop'
            
            set(F1,'WindowButtonMotionFcn','')
            set(F1,'WindowButtonUpFcn','')
            DFDB_port_opt('WeightCalcRoR')
    end

    
    
case 'WeightCalcRoR'
    % Find and display the fraction of each asset needed to reach a desired
    % rate of return of a portfolio of the entered assets.
    
   
    Rateofreturn = findobj(gcf,'tag','rorstr');
    Risk = findobj(gcf,'tag','riskstr');
    Effront=findobj(gcf,'tag','efax');
    Frontleg = findobj(gcf,'tag','frleg');
    minRoRtxt = findobj(gcf,'tag','mnRotxt');
    maxRoRtxt = findobj(gcf,'tag','mxRotxt');
    
    if isempty(findobj(Effront,'type','line'))
        err = errordlg('First generate frontier','Rate of Return');
        set(err,'windowstyle','modal')
        set(Rateofreturn','string','')
        return
    end
    
    
    % Keep weights from displaying as NANs and keep green lines on plot
    desiredRoR=str2num(get(Rateofreturn,'string'))/100;
    F1 = findobj(0,'tag','dfdbportopt');
    
    Portdata = getappdata(Rateofreturn);
    
    if (isequal([' ',num2str(desiredRoR*100)],get(minRoRtxt,'string'))) & (desiredRoR < min(Portdata.PortReturn))
        desiredRoR = min(Portdata.PortReturn);
    end
   
    if (isequal([' ',num2str(desiredRoR*100)],get(maxRoRtxt,'string'))) & (desiredRoR > max(Portdata.PortReturn))
        desiredRoR = max(Portdata.PortReturn);
    end
    
    if (desiredRoR - max(Portdata.PortReturn) > 0.000001) | (desiredRoR - min(Portdata.PortReturn) < -0.000001)
        err = errordlg('Desired return is outside the range of possible values.');
        set(err,'windowstyle','modal')
        return
    end
	
    
    weights = interp1(Portdata.PortReturn,Portdata.PortWts,desiredRoR);
    risk = interp1(Portdata.PortReturn,Portdata.PortRisk,desiredRoR);
    
    set(Risk,'string',sprintf('%1.4f',risk));
    WtWeight=sort(findobj(gcf,'tag','wtwt'));

    
	for i=1:length(weights) 
        set(WtWeight(i),'string',sprintf('%1.4f',weights(i)));
    end
    
    axes(Effront)
    RRlines = findobj(gcf,'type','line','color','g');
    hold on
    delete(RRlines)
    clear RRlines
    xaxislims = get(gca,'xlim');
    yaxislims = get(gca,'ylim');
    vert = plot([risk risk],[yaxislims(1) desiredRoR],'g','tag','vertlin','ButtonDownFcn', ...
        'dfdb_port_opt(''Animatevline'',''start'')','erasemode','xor','linewidth',2);
    horz = plot([xaxislims(1),risk],[desiredRoR desiredRoR],'g','tag','horzlin','ButtonDownFcn', ...
        'dfdb_port_opt(''Animatehline'',''start'')','erasemode','xor','linewidth',2);
    hold off
    axes(Frontleg)
    set(Effront,'tag','efax')
    
        
    
case 'WeightCalcRisk'
    % Find and display the fraction of each asset needed to assume a desired
    % risk given the entered assets.
    
    Rateofreturn = findobj(gcf,'tag','rorstr');
    Risk = findobj(gcf,'tag','riskstr');
    Effront=findobj(gcf,'tag','efax');
    Frontleg = findobj(gcf,'tag','frleg');
    minRisktxt = findobj(gcf,'tag','mnRitxt');
    maxRisktxt = findobj(gcf,'tag','mxRitxt');
    
    if isempty(findobj(Effront,'type','line'))
        err = errordlg('First generate frontier','Risk');
        set(err,'windowstyle','modal')
        set(Rateofreturn','string','')
        return
    end
    
    desiredRisk=str2num(get(Risk,'string'));
    F1 = findobj(0,'tag','dfdbportopt');
    
    Portdata = getappdata(Rateofreturn);
    
    if (isequal(num2str(desiredRisk),get(minRisktxt,'string'))) & (desiredRisk < min(Portdata.PortRisk))
        desiredRisk = min(Portdata.PortRisk);
    end
    
    if (isequal(num2str(desiredRisk),get(maxRisktxt,'string'))) & (desiredRisk > max(Portdata.PortRisk))
        desiredRisk = max(Portdata.PortRisk);
    end

    if (desiredRisk - max(Portdata.PortRisk) > 0.000001) | (desiredRisk - min(Portdata.PortRisk) < -0.000001)
        err = errordlg('Desired return is outside the range of possible values.');
        set(err,'windowstyle','modal')
        return
    end
	
    weights = interp1(Portdata.PortRisk,Portdata.PortWts,desiredRisk);
    RoR = interp1(Portdata.PortRisk,Portdata.PortReturn,desiredRisk);
    
    set(Rateofreturn,'string',sprintf('%1.2f',100*RoR));
    WtWeight=sort(findobj(gcf,'tag','wtwt'));

    
	for i=1:length(weights) 
        set(WtWeight(i),'string',sprintf('%1.4f',weights(i)));
    end
    
    axes(Effront)
    RRlines = findobj(gcf,'type','line','color','g');
    hold on
    delete(RRlines)
    clear RRlines
    xaxislims = get(gca,'xlim');
    yaxislims = get(gca,'ylim');
    vert = plot([desiredRisk desiredRisk],[yaxislims(1) RoR],'g','tag','vertlin','ButtonDownFcn', ...
        'dfdb_port_opt(''Animatevline'',''start'')','erasemode','xor','linewidth',2);
    horz = plot([xaxislims(1),desiredRisk],[RoR RoR],'g','tag','horzlin','ButtonDownFcn', ...
        'dfdb_port_opt(''Animatehline'',''start'')','erasemode','xor','linewidth',2);
    hold off
    axes(Frontleg)
    set(Effront,'tag','efax')
    
  case 'Calendar'
    % Bring up an ActiveX calendar to view and select a starting date for time series
    
  if ~exist('cal') | isempty(cal)
      F1 = findobj(0,'tag','dfdbportopt');
      mainfigpos = get(F1,'pos');
    
      calfig=figure('pos',[mainfigpos(1)+300 mainfigpos(2)+300 200 185],'menubar','none', ...
          'name','Calendar','numbertitle','off','tag','calenfig','closerequestfcn', ...
          'dfdb_port_opt(''Calclosereqfcn'')');
      cal=actxcontrol('MSCAL.Calendar.7',[0 35 200 150],calfig);
      drawnow
      set(cal,'showtitle',0);

      OKbut = uicontrol('pos',[6 4 93 27],'string','OK','callback','dfdb_port_opt(''CalClose'')');
      Cancelbut = uicontrol('pos',[104 4 93 27],'string','Cancel','callback', ...
          'dfdb_port_opt(''Calcancel'')');
      
  else
      calfig = findobj(0,'tag','calenfig');
      figure(calfig)
      
  end
    
    
case 'Calcancel'
    
    delete(get(0,'CurrentFigure'));
    clear cal
    
case 'CalClose'
    % Close ActiveX calendar
    
    F1 = findobj(0,'tag','dfdbportopt');
    Startdatebox = findobj(F1,'tag','sdstr');
    
    if get(cal,'day') == 0
        close(findobj('tag','calenfig'))
        err = errordlg('A day has to be selected','Date Selection');
        close(findobj(0,'tag','calenfig'))
        clear cal
        dfdb_port_opt('Calendar')
        set(err,'windowstyle','modal')
        figure(err)
        
    else
        m = get(cal,'month');
        y = get(cal,'year');
        d = get(cal,'day');
        startdate = [num2str(double(m)),'/',num2str(double(d)),'/',num2str(double(y))];
        %startdate = get(cal,'value');
        if datenum(startdate) > datenum(date)-2
            err = errordlg('Starting Date must be at least two days ago.','Date Selection');
            close(findobj(0,'tag','calenfig'))
            clear cal
            dfdb_port_opt('Calendar')
            set(err,'windowstyle','modal')
            figure(err)
        
        else
            set(Startdatebox,'string',startdate);
            close(findobj('tag','calenfig'))
            clear cal
        end
    end
    
    setappdata(Startdatebox,'startdate',startdate);

    
case 'Calclosereqfcn'
    
    shh = get(0,'ShowHiddenHandles');
    set(0,'ShowHiddenHandles','on');
    currFig = get(0,'CurrentFigure');
    set(0,'ShowHiddenHandles',shh);
    clear cal
    delete(currFig);
    
case 'Helppage'
    % Open help page for DFDB_PORT_OPT in the MATLAB Help Browser
    
    HelpPath = which('dfdbportopthelp.html');
    web(HelpPath);
    
case 'Yahoosym'
    % Open the Yahoo symbol lookup web page in the MATLAB Help Browser
    
    web('http://finance.yahoo.com/l');
        
    
case 'Closecall'
    % Close function of DFDB_PORT_OPT figure
    
    FF1 = findobj('type','figure','tag','calenfig');
    shh=get(0,'ShowHiddenHandles');
    set(0,'ShowHiddenHandles','on');
    currFig=get(0,'CurrentFigure');
    datafigure = findobj('type','figure','tag','datfig');
    set(0,'ShowHiddenHandles',shh);

    if isruntime
        FF1 = findobj('type','figure','tag','calenfig');
        if ishandle(FF1)
            delete(FF1)
        end
        
        if ishandle(datafigure)
            delete(datafigure)
        end
        
        delete(currFig)
        quit force
    else
        if ishandle(FF1)
            delete(FF1)
        end
        
        if ishandle(datafigure)
            delete(datafigure)
        end
        
        delete(currFig);
        clear datafigure FF1 currFig
        
    end

    
case 'Datasource'
    % Date Source preferences menu code.
    
    pref = getpref('DFDBpref','datainput');
    Startdatecal = findobj(gcf,'tag','calbut');
    Startdatebox = findobj(gcf,'tag','sdstr');
    Startdateprompt = findobj(gcf,'tag','sdp');
    DScall = findobj(gcf,'tag','dsbut');
    Symbols = findobj(gcf,'tag','symstr');
    
    datafigure = findobj('type','fig','tag','datfig');
    
    if strcmp(pref,'df')
        set(findobj(gcf,'tag','dfmen'),'checked','on')
        set(findobj(gcf,'tag','dbmen'),'checked','off')
        set(Startdatecal,'enable','on')
        set(Startdateprompt,'enable','on')
        set(Startdatebox,'enable','on','string','')
        set(DScall,'enable','off')
        set(Symbols,'string','')
        
        if ishandle(datafigure)
            delete(datafigure)
        end
        clear datafigure
        
    elseif strcmp(pref,'db')
        set(findobj(gcf,'tag','dbmen'),'checked','on')
        set(findobj(gcf,'tag','dfmen'),'checked','off')
        set(Startdatecal,'enable','off')
        set(Startdateprompt,'enable','off')
        set(Startdatebox,'string','01/02/97','enable','off')
        set(DScall,'enable','on')
        DFDB_port_opt('SelectData','start')
        set(Symbols,'string','')
    end
    
    if isequal(getpref('DFDBpref','datainput'),'db')
            
        end
   
       
case 'SelectData'

    datas = getdatasources;
    
    
    if nargin == 1 | (nargin > 1 & strcmp(varargin{2},'start'))
        option = 'start';
        shh = get(0,'ShowHiddenHandles');
        set(0,'ShowHiddenHandles','on')
        datafigure = findobj(0,'tag','datfig');
        set(0,'ShowHiddenHandles',shh);
        if ~isempty(datafigure)
            figure(datafigure)
            return
        end
        
	else
        option = varargin{2};
	end
    
    F1=findobj('type','fig','tag','dfdbportopt');
    
    
    switch option
        
    case 'start'
        
        datafigure = figure('name','Select Data','numbertitle','off','tag','datfig','menubar','none');
        
        frame = uicontrol('style','frame','units','norm','pos',[.05 .12 .9 .82]);
        
        DBselectprompt = uicontrol('style','text','units','norm','pos',[.07 .905 .28 .03],'string', ...
            'Data Sources','foregroundcolor','b','fontsize',10);
        DBlist=uicontrol('style','list','units','norm','pos',[.07 .14 .28 .76],'tag','dblist','max',1000, ...
            'min',1,'string',datas,'backgroundcolor','w','callback','DFDB_port_opt(''SelectData'',''DBselect'')');
        
        
        Tableprompt = uicontrol('style','text','units','norm','pos',[.36 .905 .28 .03],'string', ...
            'Tables','foregroundcolor','b','fontsize',10);
        Tablelist = uicontrol('style','list','units','norm','tag','tables','pos',[.36 .14 .28 .76], ...
            'max',1000,'min',1,'callback','DFDB_port_opt(''SelectData'',''Tableselect'')','backgroundcolor','w');
        
        
        Fieldprompt = uicontrol('style','text','units','norm','pos',[.65 .905 .28 .03],'string', ...
            'Assets','foregroundcolor','b','fontsize',10);
        
        Fieldlist = uicontrol('style','list','units','norm','pos',[.65 .14 .28 .76],'max',1000,'min', ...
            1,'tag','fields','backgroundcolor','w','callback','DFDB_port_opt(''SelectData'',''Fieldselect'')');

        Assettext = uicontrol('style','text','units','norm','pos',[.3 .005 .35 .052],'string', ...
            'Send Symbols for Importing  -->','fontsize',10,'backgroundcolor',[.8 .8 .8], ...
            'foregroundcolor','b');
        Applybut = uicontrol('string','Apply','units','norm','pos',[.65 .01 .3 .06], ...
            'callback','DFDB_port_opt(''SelectData'',''Sendsymbols'')','fontsize',10);
                
        set(datafigure,'handlevis','callback');
        
    case 'DBselect'
        
        DBlist = findobj(gcf,'tag','dblist');
        Tablelist = findobj(gcf,'tag','tables');
        Fieldlist = findobj(gcf,'tag','fields');
        Symbols = findobj(F1,'tag','symstr');
        
        dbnum = get(DBlist,'value');
        selectedDB = datas{dbnum};
        setappdata(DBlist,'database',selectedDB);
        
        if ~isequal(selectedDB,'DFDBsample')
            err = errordlg('Invalid Data Source','Source Selection');
            set(err,'windowstyle','modal')
            return
        end
        
%         conn = getappdata(Symbols,'connection');
        if exist('conn') 
            close(conn)
            clear conn
        end

            conn = database(selectedDB,'','');
            Symbols = findobj(F1,'tag','symstr');
            setappdata(Symbols,'connection',conn);
            %setappdata(Tablelist,'connection',conn);
            
            d = dmd(conn);
            ctg = get(conn,'Catalog');
            tinfo = tables(d,ctg,'');
            tableType = tinfo(:,2);
            tableName = tinfo(:,1);
            
            %Table types of TABLE are desired tables
            i = find(~(strcmp({'SYSTEM TABLE'},tableType) | ...
                strcmp({'SYNONYM'},tableType)));
            tbllist = tableName(i);
            

            set(Tablelist,'string',tbllist,'value',[]);
            set(Fieldlist,'string','');
       
        
    case 'Tableselect'
        
        Fieldlist = findobj(gcf,'tag','fields');
        Tablelist = findobj(gcf,'tag','tables');
        Symbols = findobj(F1,'tag','symstr');
        
        conn = getappdata(Symbols,'connection');
        
        %Get selected tables
        tval = get(Tablelist,'value');
        tbllist = get(Tablelist,'string');
        tablez = tbllist(tval);
        setappdata(Symbols,'Tables',tablez);
        
        %Get metadata of connection and get column names
        d = dmd(conn);
        L = length(tablez);
        fields = {};
        
        for i = 1:L
            table = tablez{i};  %Columns method returns more info, but is much slower
            ex = exec(conn,['select * from ' table]);
            ex = fetch(ex,1);
            tmp = columnnames(ex);
            eval(['tabfields = {' tmp '};'])
            close(ex); 
            
            %Prepend tablename if JOIN operation
            if length(tval) > 1
                for j = 1:length(tabfields)
                    tabfields{j} = [table '.' tabfields{j}];
                end
                fields = [fields;tabfields'];
            else
                fields = tabfields';
            end
        end
        
        fields(1)=[];
        %Display fieldnames
        set(Fieldlist,'String',fields,'value',[]);
        
        
    case 'Fieldselect'
        
        Fieldlist = findobj(gcf,'tag','fields');
        Tablelist = findobj(gcf,'tag','tables');
        Symbols = findobj(F1,'tag','symstr');
        
        fields = get(Fieldlist,'string');
        fval = get(Fieldlist,'value');
        
        fieldcell = fields(fval);
        fieldstr = fieldcell{1};
        for i=2:length(fieldcell)
            fieldstr=[fieldstr,', ',fieldcell{i}];
        end
        
        setappdata(Fieldlist,'symbols',fieldstr);
        setappdata(Fieldlist,'symbolcell',fieldcell);

    case 'Sendsymbols'

        Symbols = findobj(F1,'tag','symstr');
        Fieldlist = findobj(gcf,'tag','fields');
        DBlist = findobj(gcf,'tag','dblist');
        selectedDB = getappdata(DBlist,'database');
        
        fieldcell = getappdata(Fieldlist,'symbolcell');
        
        assets = getappdata(Fieldlist,'symbols');
        if isempty(assets)
            err = errordlg('No assets selected','Send symbols for Importing');
            set(err,'windowstyle','modal')
            return
        end
        
        dates = 'TS_Dates';
        
        set(Symbols,'string',assets)
        setappdata(Symbols,'dates',dates)
        figure(F1)
        
    end
    

    otherwise 
    err = error('Invalid input argument.  DFDB_PORT_OPT takes no inputs.');
    set(err,'windowstyle','modal')
  
end