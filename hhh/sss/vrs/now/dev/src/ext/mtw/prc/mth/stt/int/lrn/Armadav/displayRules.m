%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			14/04/03
%Version:		1.2
%-------------------------------------------------------------------------------------

%-------------------------------------------------------------------------

%Function to display a figure with full extracted rules and mining report
function displayRules(formatted_rules,candidates,min_sup,min_con,time_taken,file,no_entries,method_summary)

%Create figure window
close all;
menu_title = strcat('ARMADA - File Mined: ',file);
Display_Window = figure('Name',menu_title,'NumberTitle','Off');
set(gcf,'menubar','none');

%If candidates above thresholds exist display them
if (candidates ~= 0)
	%Convert item counts to string for displaying and reverse order------
	%to display the highest first
	file_items = sortrows(candidates,[2,1]);
	%reverse order for biggest first
	y = size(file_items,1);
	for z = 1:size(file_items,1)
   	ordered_items(z,:) = file_items(y,:);
   	y = y - 1;
   end
   
   %For each item in candidates
   for a = 1:size(candidates,1)
      %Convert numbers to string and format for displaying purposes
   	item = num2str(ordered_items(a,1));
   	count = num2str(ordered_items(a,2));
   	disp_items{a} = strcat('"',item,'"',' -> Count: ',count);
	end
else
	disp_items = 'There are no file items above thresholds specified.'; 
end
%--------------------------------------------------------------------


FileMenu = uimenu(Display_Window,'Label','&File');
FileNewMenu = uimenu(FileMenu,'Label','&New Mine','Callback','closeDisplay','Accelerator','N');
   FileOpenMenu = uimenu(FileMenu,'Label','&Open','Callback','loadMiningResults','Accelerator','O');
   FileSaveMenu = uimenu(FileMenu,'Label','&Save','Callback','saveMiningResults','Accelerator','S');
   FileExitMenu = uimenu(FileMenu,'Label','E&xit','Separator','On','Callback','exitProgramSave','Accelerator','X');
GraphicMenu = uimenu(Display_Window,'Label','&Graphics');
	GraphicLineMenu = uimenu(GraphicMenu,'Label','Plot Rule Count &Line Chart','Callback','displayRuleLine');
	GraphicBarMenu = uimenu(GraphicMenu,'Label','Plot Rule Count &Bar Chart','Callback','displayRuleGraph');
	GraphicSupMenu = uimenu(GraphicMenu,'Label','Plot &Support Line Graph','Callback','displaySupportGraph');
   GraphicConfMenu = uimenu(GraphicMenu,'Label','Plot &Confidence Line Graph','Callback','displayConfGraph');
ResultsMenu = uimenu(Display_Window,'Label','&Results');
	ResultsPrintMenu = uimenu(ResultsMenu,'Label','Print All Rules In Command Window','Callback','printRules');
	ResultsPausedMenu = uimenu(ResultsMenu,'Label','Print Rules In Command Window (50 at time)','Callback','printPausedRules');
HelpMenu = uimenu(Display_Window,'Label','&Help');
	HelpContentsMenu = uimenu(HelpMenu,'Label','Help &Contents','Accelerator','H','Callback','helpContents');
	HelpAboutMenu = uimenu(HelpMenu,'Separator','On','Label','&About','Callback','displayAbout'); 
   
   
dispFrame = uicontrol(Display_Window,'Style','frame','Position',[20,70,330,330]);
	uicontrol(Display_Window,'Style','text','Position',[30,370,40,20],'String','RULES:','HorizontalAlignment','left');
   rule_box = uicontrol(Display_Window,'Style','listbox','Position',[30,265,310,110],'HorizontalAlignment','left','BackgroundColor','white','Tag','rule_box');
   uicontrol(Display_Window,'Style','text','Position',[30,240,60,15],'String','Order By:','HorizontalAlignment','left');
   disp_box = uicontrol(Display_Window,'Style','popupmenu','Position',[80,240,110,20],'String','Support & Conf|L.H.S. Size','BackgroundColor','white','Callback','changeRuleDisplay');
	uicontrol(Display_Window,'Style','text','Position',[30,212,100,15],'String','File Items:','HorizontalAlignment','left');   
   item_box = uicontrol(Display_Window,'Style','listbox','Position',[30,100,310,110],'HorizontalAlignment','left','BackgroundColor','white','String',disp_items,'Tag','item_box');

sumFrame = uicontrol(Display_Window,'Style','frame','Position',[370,20,180,390]);
	uicontrol(Display_Window,'Style','text','Position',[380,370,100,20],'String','MINING CRITERIA:','HorizontalAlignment','left');
   uicontrol(Display_Window,'Style','text','Position',[380,349,100,20],'String','Min Support:','HorizontalAlignment','left');
   sup_box = uicontrol(Display_Window,'Style','edit','Position',[465,352,40,18],'HorizontalAlignment','left','String',min_sup,'Enable','inactive','Tag','sup_box');
	uicontrol(Display_Window,'Style','text','Position',[380,324,100,20],'String','Min Confidence:','HorizontalAlignment','left');
   con_box = uicontrol(Display_Window,'Style','edit','Position',[465,327,40,18],'HorizontalAlignment','left','String',min_con,'Enable','inactive','Tag','con_box');
   uicontrol(Display_Window,'Style','text','Position',[380,299,100,20],'String','File Mined:','HorizontalAlignment','left');
   file_box = uicontrol(Display_Window,'Style','edit','Position',[465,302,80,18],'HorizontalAlignment','left','String',file,'Enable','inactive','Tag','file_box');
   uicontrol(Display_Window,'Style','text','Position',[380,272,100,20],'String','MINING REPORT:','HorizontalAlignment','left');
   uicontrol(Display_Window,'Style','text','Position',[380,250,100,20],'String','Mining Time(sec):','HorizontalAlignment','left');
   time_box = uicontrol(Display_Window,'Style','edit','Position',[465,253,50,18],'HorizontalAlignment','left','String',time_taken,'Enable','inactive','Tag','time_box');
   uicontrol(Display_Window,'Style','text','Position',[380,225,100,20],'String','File Size:','HorizontalAlignment','left');
   no_entries_box = uicontrol(Display_Window,'Style','edit','Position',[465,228,50,18],'HorizontalAlignment','left','String',no_entries,'Enable','inactive','Tag','no_entries_box');
   uicontrol(Display_Window,'Style','text','Position',[380,200,100,20],'String','Time per Entry:','HorizontalAlignment','left');
   uicontrol(Display_Window,'Style','edit','Position',[465,203,50,18],'HorizontalAlignment','left','String',time_taken/no_entries,'Enable','inactive');
   uicontrol(Display_Window,'Style','text','Position',[380,175,100,20],'String','No. Rules:','HorizontalAlignment','left');
   no_rules_box = uicontrol(Display_Window,'Style','edit','Position',[465,178,50,18],'HorizontalAlignment','left','Enable','inactive','Tag','no_rules_box');
   
   uicontrol(Display_Window,'Style','text','Position',[380,150,130,20],'String','MINING STRATEGY:','HorizontalAlignment','left');
   mine_description = uicontrol(Display_Window,'Style','listbox','Position',[380,130,160,20],'HorizontalAlignment','left','String',method_summary,'Tag','mine_description');
   
graphicsFrame = uicontrol(Display_Window,'Style','frame','Position',[380,30,160,90]);  
   uicontrol(Display_Window,'Style','text','Position',[385,95,110,20],'String','Graphical Analysis:','HorizontalAlignment','left');
	line_button = uicontrol(Display_Window,'Style','pushbutton','Position',[385,70,70,30],'String','No Rule Line','Callback','displayRuleLine');
	bar_button = uicontrol(Display_Window,'Style','pushbutton','Position',[465,70,70,30],'String','No Rule Bar','Callback','displayRuleGraph');
	support_button = uicontrol(Display_Window,'Style','pushbutton','Position',[385,35,70,30],'String','Rule Supp','Callback','displaySupportGraph','Tag','support_button');
	conf_button = uicontrol(Display_Window,'Style','pushbutton','Position',[465,35,70,30],'String','Rule Conf','Callback','displayConfGraph','Tag','conf_button');
   
uicontrol(Display_Window,'Style','pushbutton','String','Main Menu','Position',[20,20,70,30],'Callback','closeDisplay'); 
uicontrol(Display_Window,'Style','pushbutton','String','Exit','Position',[100,20,70,30],'Callback','exitProgramSave'); 
uicontrol(Display_Window,'Style','pushbutton','String','Dump To Cmd Win','Position',[240,20,110,30],'Callback','printRules'); 


%If rules not empty, i.e. rules exist beyond thresholds specified then display them
if (~isempty(formatted_rules))
   disp_rules2 = orderByLHS(formatted_rules);
   disp_rules = orderBySupConf(formatted_rules);
   no_rules = size(disp_rules,2);
   LHS_count = getLHSCount(formatted_rules);
else 
   disp_rules2 = 'No rules were extracted';   
   disp_rules = disp_rules2;
   %set variables to null for saving file purposes
   LHS_count = 0;
   formatted_rules = [];
   no_rules = 0;
   set(disp_box,'Enable','Off');
   %Disable all graphics button and menu graphics options
   set(support_button,'Enable','Off');
   set(conf_button,'Enable','Off');
   set(line_button,'Enable','Off');
   set(bar_button,'Enable','Off');
   set(GraphicLineMenu,'Enable','Off');
   set(GraphicBarMenu,'Enable','Off');
   set(GraphicSupMenu,'Enable','Off');
   set(GraphicConfMenu,'Enable','Off');  
end

%Update displays
set(rule_box,'String',disp_rules);
set(no_rules_box,'String',no_rules); 
   
%set UserData for callback purposes
set(Display_Window,'UserData',LHS_count);
u{1}=disp_rules;
u{2}=disp_rules2;
set(disp_box,'UserData',u);
set(support_button,'UserData',formatted_rules);
set(conf_button,'UserData',formatted_rules);
set(item_box,'UserData',candidates);
set(sup_box,'UserData',min_sup);
set(con_box,'UserData',min_con);
set(time_box,'UserData',time_taken);
set(file_box,'UserData',file);
set(no_entries_box,'UserData',no_entries);
set(mine_description,'UserData',method_summary);

%End----------------------------------------------------------------------