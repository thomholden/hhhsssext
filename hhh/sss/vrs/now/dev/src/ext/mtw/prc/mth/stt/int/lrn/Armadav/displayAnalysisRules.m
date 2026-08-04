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

%Function to display a figure with full and sampled rules and mining report
function displayAnalysisRules(full_formatted_rules,full_candidates,full_time_taken,full_no_entries,samp_formatted_rules,samp_candidates,samp_time_taken,samp_no_entries,min_sup,min_con,file,method_summary,date_mined)

%Create figure window
close all;
menu_title = strcat('ARMADA - File Mined: ',file);
Display_Window = figure('Name',menu_title,'NumberTitle','Off');
set(gcf,'menubar','none');

%If candidates above thresholds exist display them
if (full_candidates ~= 0)
	%Convert item counts to string for displaying and reverse order------
	%to display the highest first
	full_file_items = sortrows(full_candidates,[2,1]);
	%reverse order for biggest first
	y = size(full_file_items,1);
	for z = 1:size(full_file_items,1)
   	full_ordered_items(z,:) = full_file_items(y,:);
   	y = y - 1;
	end
   
   %For each item in full_candidates
   for a = 1:size(full_candidates,1)
      %Convert numbers to string and format for displaying purposes
   	item = num2str(full_ordered_items(a,1));
   	count = num2str(full_ordered_items(a,2));
   	full_disp_items{a} = strcat('"',item,'"',' -> Count: ',count);
	end
else
	full_disp_items = 'There are no file items above thresholds specified.'; 
end
%--------------------------------------------------------------------

%If candidates above thresholds exist display them
if (samp_candidates ~= 0)
	%Convert item counts to string for displaying and reverse order------
	%to display the highest first
	samp_file_items = sortrows(samp_candidates,[2,1]);
	%reverse order for biggest first
	y = size(samp_file_items,1);
	for z = 1:size(samp_file_items,1)
   	samp_ordered_items(z,:) = samp_file_items(y,:);
   	y = y - 1;
	end
   
   %For each item in samp_candidates
   for a = 1:size(samp_candidates,1)
      %Convert numbers to string and format for displaying purposes
   	item = num2str(samp_ordered_items(a,1));
   	count = num2str(samp_ordered_items(a,2));
   	samp_disp_items{a} = strcat('"',item,'"',' -> Count: ',count);
   end
%Otherwise there are no items
else
	samp_disp_items = 'There are no file items above thresholds specified.'; 
end
%--------------------------------------------------------------------


FileMenu = uimenu(Display_Window,'Label','&File');
	FileNewMenu = uimenu(FileMenu,'Label','&New Mine','Callback','closeAnalysisDisplay','Accelerator','N');
   FileOpenMenu = uimenu(FileMenu,'Label','&Open','Callback','loadMiningResults','Accelerator','O');
   FileSaveMenu = uimenu(FileMenu,'Label','&Save','Callback','saveMiningResultsDual','Accelerator','S');
   FileExitMenu = uimenu(FileMenu,'Label','E&xit','Separator','On','Callback','exitProgramSaveDual','Accelerator','X');
GraphicMenu = uimenu(Display_Window,'Label','&Graphics');
	GraphicLineMenu = uimenu(GraphicMenu,'Label','Plot Rule Count &Line Graph','Callback','displayAnalysisRuleLine');
	GraphicBarMenu = uimenu(GraphicMenu,'Label','Plot Rule Count &Bar Chart','Callback','displayAnalysisRuleGraph');
	GraphicSupMenu = uimenu(GraphicMenu,'Label','Plot &Support Line Graph','Callback','displayAnalysisSupportGraph');
 	GraphicConfMenu = uimenu(GraphicMenu,'Label','Plot &Confidence Line Graph','Callback','displayAnalysisConfGraph');
ResultsMenu = uimenu(Display_Window,'Label','&Results');
	ResultsPrintMenu = uimenu(ResultsMenu,'Label','Print All Rules In Command Window','Callback','printAnalysisRules');
	ResultsPausedMenu = uimenu(ResultsMenu,'Label','Print Rules In Command Window (50 at time)','Callback','printPausedAnalysisRules');
HelpMenu = uimenu(Display_Window,'Label','&Help');
	HelpContentsMenu = uimenu(HelpMenu,'Label','Help &Contents','Accelerator','H','Callback','helpContents');
	HelpAboutMenu = uimenu(HelpMenu,'Separator','On','Label','&About','Callback','displayAbout'); 
   
   
dispFrame = uicontrol(Display_Window,'Style','frame','Position',[20,50,320,360]);
	uicontrol(Display_Window,'Style','text','Position',[30,380,90,20],'String','FULL MINE RULES:','HorizontalAlignment','left');
   full_rule_box = uicontrol(Display_Window,'Style','listbox','Position',[30,325,300,60],'HorizontalAlignment','left','BackgroundColor','white','Tag','full_rule_box');
  	uicontrol(Display_Window,'Style','text','Position',[30,300,130,20],'String','SAMPLING MINE RULES:','HorizontalAlignment','left');
   samp_rule_box = uicontrol(Display_Window,'Style','listbox','Position',[30,245,300,60],'HorizontalAlignment','left','BackgroundColor','white','Tag','samp_rule_box');
   uicontrol(Display_Window,'Style','text','Position',[30,220,60,15],'String','Order By:','HorizontalAlignment','left');
   disp_box = uicontrol(Display_Window,'Style','popupmenu','Position',[80,220,110,20],'String','Support & Conf|L.H.S. Size','BackgroundColor','white','Callback','changeRuleAnalysisDisplay');
	uicontrol(Display_Window,'Style','text','Position',[30,202,100,15],'String','All File Items:','HorizontalAlignment','left');   
   full_item_box = uicontrol(Display_Window,'Style','listbox','Position',[30,140,300,60],'HorizontalAlignment','left','BackgroundColor','white','String',full_disp_items,'Tag','full_item_box');
   uicontrol(Display_Window,'Style','text','Position',[30,122,100,15],'String','Sample File Items:','HorizontalAlignment','left');   
   samp_item_box = uicontrol(Display_Window,'Style','listbox','Position',[30,60,300,60],'HorizontalAlignment','left','BackgroundColor','white','String',samp_disp_items,'Tag','samp_item_box');
   
sumFrame = uicontrol(Display_Window,'Style','frame','Position',[360,10,190,400]);
	uicontrol(Display_Window,'Style','text','Position',[370,380,100,20],'String','MINING CRITERIA:','HorizontalAlignment','left');
   uicontrol(Display_Window,'Style','text','Position',[370,359,100,20],'String','Min Support:','HorizontalAlignment','left');
   sup_box = uicontrol(Display_Window,'Style','edit','Position',[455,362,40,18],'HorizontalAlignment','left','String',min_sup,'Enable','inactive','Tag','sup_box');
	uicontrol(Display_Window,'Style','text','Position',[370,334,100,20],'String','Min Confidence:','HorizontalAlignment','left');
   con_box = uicontrol(Display_Window,'Style','edit','Position',[455,337,40,18],'HorizontalAlignment','left','String',min_con,'Enable','inactive','Tag','con_box');
   uicontrol(Display_Window,'Style','text','Position',[370,309,100,20],'String','File Mined:','HorizontalAlignment','left');
   file_box = uicontrol(Display_Window,'Style','edit','Position',[455,312,80,18],'HorizontalAlignment','left','String',file,'Enable','inactive','Tag','file_box');
   uicontrol(Display_Window,'Style','text','Position',[370,282,100,20],'String','MINING REPORT:','HorizontalAlignment','left');
   uicontrol(Display_Window,'Style','text','Position',[445,267,50,20],'String','Full:','HorizontalAlignment','left');
   uicontrol(Display_Window,'Style','text','Position',[490,267,50,20],'String','Sample:','HorizontalAlignment','left');
   uicontrol(Display_Window,'Style','text','Position',[370,250,100,20],'String','Time(sec):','HorizontalAlignment','left');
   full_time_box = uicontrol(Display_Window,'Style','edit','Position',[445,253,40,18],'HorizontalAlignment','left','String',full_time_taken,'Enable','inactive','Tag','full_time_box');
   samp_time_box = uicontrol(Display_Window,'Style','edit','Position',[490,253,40,18],'HorizontalAlignment','left','String',samp_time_taken,'Enable','inactive','Tag','samp_time_box');
   uicontrol(Display_Window,'Style','text','Position',[370,225,80,20],'String','File Size:','HorizontalAlignment','left');
   full_no_entries_box = uicontrol(Display_Window,'Style','edit','Position',[445,228,40,18],'HorizontalAlignment','left','String',full_no_entries,'Enable','inactive','Tag','full_no_entries_box');
   samp_no_entries_box = uicontrol(Display_Window,'Style','edit','Position',[490,228,40,18],'HorizontalAlignment','left','String',samp_no_entries,'Enable','inactive','Tag','samp_no_entries_box');
   uicontrol(Display_Window,'Style','text','Position',[370,200,100,20],'String','Time per Entry:','HorizontalAlignment','left');
   uicontrol(Display_Window,'Style','edit','Position',[445,203,40,18],'HorizontalAlignment','left','String',full_time_taken/full_no_entries,'Enable','inactive');
   uicontrol(Display_Window,'Style','edit','Position',[490,203,40,18],'HorizontalAlignment','left','String',samp_time_taken/samp_no_entries,'Enable','inactive');
   uicontrol(Display_Window,'Style','text','Position',[370,175,100,20],'String','No. Rules:','HorizontalAlignment','left');
	full_no_rules_box = uicontrol(Display_Window,'Style','edit','Position',[445,178,40,18],'HorizontalAlignment','left','Enable','inactive','Tag','full_no_rules_box');
   samp_no_rules_box = uicontrol(Display_Window,'Style','edit','Position',[490,178,40,18],'HorizontalAlignment','left','Enable','inactive','Tag','samp_no_rules_box');
   
   uicontrol(Display_Window,'Style','text','Position',[370,150,130,20],'String','MINING STRATEGY:','HorizontalAlignment','left');
   mine_description = uicontrol(Display_Window,'Style','listbox','Position',[370,130,170,20],'HorizontalAlignment','left','String',method_summary,'Tag','mine_description');

graphicsFrame = uicontrol(Display_Window,'Style','frame','Position',[370,30,170,90]);  
   uicontrol(Display_Window,'Style','text','Position',[380,95,110,20],'String','Graphical Analysis:','HorizontalAlignment','left');
	line_button = uicontrol(Display_Window,'Style','pushbutton','Position',[380,70,70,30],'String','No Rule Line','Callback','displayAnalysisRuleLine');
	bar_button = uicontrol(Display_Window,'Style','pushbutton','Position',[460,70,70,30],'String','No Rule Bar','Callback','displayAnalysisRuleGraph');
	support_button = uicontrol(Display_Window,'Style','pushbutton','Position',[380,35,70,30],'String','Rule Supp','Callback','displayAnalysisSupportGraph','Tag','support_button');
	conf_button = uicontrol(Display_Window,'Style','pushbutton','Position',[460,35,70,30],'String','Rule Conf','Callback','displayAnalysisConfGraph','Tag','conf_button');
   
       
uicontrol(Display_Window,'Style','pushbutton','String','Main Menu','Position',[20,10,70,30],'Callback','closeAnalysisDisplay'); 
uicontrol(Display_Window,'Style','pushbutton','String','Exit','Position',[100,10,70,30],'Callback','exitProgramSaveDual'); 
uicontrol(Display_Window,'Style','pushbutton','String','Dump To Cmd Win','Position',[230,10,110,30],'Callback','printAnalysisRules'); 


%FULL MINE: If rules not empty, i.e. rules exist beyond thresholds specified then display them
if (~isempty(full_formatted_rules))
   full_disp_rules2 = orderByLHS(full_formatted_rules);
   full_disp_rules = orderBySupConf(full_formatted_rules);
   full_no_rules = size(full_disp_rules,2);
   LHS_count{1} = getLHSCount(full_formatted_rules);
else 
   full_disp_rules2 = 'No rules were extracted';   
   full_disp_rules = full_disp_rules2;
   full_no_rules = 0;
   LHS_count{1} = 0;
   set(disp_box,'Enable','Off');
end

set(full_rule_box,'String',full_disp_rules);
set(full_no_rules_box,'String',full_no_rules); 
%---------------------------------------------------------------------------------

%SAMP MINE: If rules not empty, i.e. rules exist beyond thresholds specified then display them
if (~isempty(samp_formatted_rules))
   samp_disp_rules2 = orderByLHS(samp_formatted_rules);
   samp_disp_rules = orderBySupConf(samp_formatted_rules);
   samp_no_rules = size(samp_disp_rules,2);
   LHS_count{2} = getLHSCount(samp_formatted_rules); 
else 
   samp_disp_rules2 = 'No rules were extracted';   
   samp_disp_rules = samp_disp_rules2;
   samp_no_rules = 0;
   LHS_count{2} = 0;
   set(disp_box,'Enable','Off');
end

set(samp_rule_box,'String',samp_disp_rules);
set(samp_no_rules_box,'String',samp_no_rules); 
%---------------------------------------------------------------------------------

if (isempty(full_formatted_rules)) | (isempty(samp_formatted_rules))
	%Disable all graphics button and menu options because there are no rules
   set(support_button,'Enable','Off');
   set(conf_button,'Enable','Off');
   set(line_button,'Enable','Off');
   set(bar_button,'Enable','Off');
   set(GraphicLineMenu,'Enable','Off');
   set(GraphicBarMenu,'Enable','Off');
   set(GraphicSupMenu,'Enable','Off');
   set(GraphicConfMenu,'Enable','Off');
end

%set UserData for callback purposes
set(Display_Window,'UserData',LHS_count);
u{1}=full_disp_rules;
u{2}=full_disp_rules2;
u{3}=samp_disp_rules;
u{4}=samp_disp_rules2;
set(disp_box,'UserData',u);
f{1} = full_formatted_rules;
f{2} = samp_formatted_rules;
set(support_button,'UserData',f);
set(conf_button,'UserData',f);
set(full_item_box,'UserData',full_candidates);
set(samp_item_box,'UserData',samp_candidates);
set(sup_box,'UserData',min_sup);
set(con_box,'UserData',min_con);
set(full_time_box,'UserData',full_time_taken);
set(samp_time_box,'UserData',samp_time_taken);
set(file_box,'UserData',file);
set(full_no_entries_box,'UserData',full_no_entries);
set(samp_no_entries_box,'UserData',samp_no_entries);
set(mine_description,'UserData',method_summary);

%End----------------------------------------------------------------------