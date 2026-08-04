%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			14/04/03
%Modified:      20/03/06
%Version:		1.3.2
%-------------------------------------------------------------------------------------

clear all;
close all;
warning off;

%Create main window
Start_Window = figure('Name','ARMADA v1.3.2 Criteria Window','NumberTitle','Off','WindowStyle','Normal','menubar','none');

%Create menu bar
FileMenu = uimenu(Start_Window,'Label','&File','Accelerator','F');
	FileNewMenu = uimenu(FileMenu,'Label','&New','Accelerator','N','Callback','close; ARMADA');
   FileOpenMenu = uimenu(FileMenu,'Label','&Open','Accelerator','O','Callback','loadMiningResults');
   FileExitMenu = uimenu(FileMenu,'Separator','On','Label','E&xit','Accelerator','x','Callback','exitProgram');
MiningMenu = uimenu(Start_Window,'Label','&Mining');
	MiningBeginMenu = uimenu(MiningMenu,'Label','&Begin Mining','Accelerator','B','Callback','evaluateCriteria');   
HelpMenu = uimenu(Start_Window,'Label','&Help');
	HelpContentsMenu = uimenu(HelpMenu,'Label','Help &Contents','Accelerator','H','Callback','helpContents');
	HelpAboutMenu = uimenu(HelpMenu,'Separator','On','Label','&About','Callback','displayAbout'); 
   
%Create buttons for mining and exiting
uicontrol(Start_Window,'Style','pushbutton','String','Begin Mining','Position',[30,20,70,30],'Callback','evaluateCriteria'); 
uicontrol(Start_Window,'Style','pushbutton','String','Exit','Position',[110,20,70,30],'Callback','exitProgram'); 

%Create File for mining details frame
uicontrol(Start_Window,'Style','frame','Position',[20,340,510,70]);
	uicontrol(Start_Window,'Style','text','Position',[30,380,190,20],'String','FILE DETAILS','HorizontalAlignment','left');
	uicontrol(Start_Window,'Style','edit','Position',[30,360,250,20],'BackgroundColor','white','HorizontalAlignment','left','Tag','edit_file_name');
	uicontrol(Start_Window,'Style','pushbutton','Position',[300,360,60,20],'String','Browse','Callback','openDataFile');
   uicontrol(Start_Window,'Style','text','Position',[375,350,50,30],'String','Delimiting Character:','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','popupmenu','Position',[430,350,90,30],'String',', (comma)| ; (semi-colon)|: (colon)|. (full-stop)|-SPACE-','BackgroundColor','white','Tag','delimiter');   
   
%Create criteria for mining frame
uicontrol(Start_Window,'Style','frame','Position',[20,250,510,80]);
	uicontrol(Start_Window,'Style','text','Position',[30,300,110,20],'String','MINING CRITERIA','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','text','Position',[30,285,110,15],'String','Minimum Confidence:','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','slider','Position',[140,285,100,20],'Value',0,'Callback','alterConfBox','Tag','conf_slider');
   uicontrol(Start_Window,'Style','edit','Position',[255,285,30,20],'String','1','BackGroundColor','White','HorizontalAlignment','left','Tag','conf_edit','Callback','changeConfSlider');
   uicontrol(Start_Window,'Style','text','Position',[155,260,130,20],'String','1%','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','text','Position',[205,260,130,20],'String','100%','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','text','Position',[310,285,110,15],'String','Minimum Support:','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','edit','Position',[400,285,40,20],'BackGroundColor','White','HorizontalAlignment','left','Tag','support_edit');
   uicontrol(Start_Window,'Style','text','Position',[447,285,15,15],'String','as:','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','popupmenu','Position',[470,275,50,30],'String','No.|%','BackgroundColor','white','Tag','sup_type');   
  
%Create goal builder frame
conFrame = uicontrol(Start_Window,'Style','frame','Position',[20,160,340,80]);
	uicontrol(Start_Window,'Style','text','Position',[30,210,160,20],'String','RULE GOAL BUILDER','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','popupmenu','Position',[30,180,140,30],'String','Mine all goals|Mine using built goals','BackgroundColor','white','Tag','mine_method','UserData',[]);
   uicontrol(Start_Window,'Style','pushbutton','Position',[190,180,70,30],'String','Build Goals','Callback','ruleBuilder');
   uicontrol(Start_Window,'Style','pushbutton','Position',[270,180,70,30],'String','View Goals','Callback','viewGoals');
   
%Create sampling frame
uicontrol(Start_Window,'Style','frame','Position',[20,70,340,80]);
	uicontrol(Start_Window,'Style','text','Position',[30,120,150,20],'String','DATA SAMPLER','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','popupmenu','Position',[30,90,140,30],'String','Mine Using Entire File|Mine Using File Sampling|Mine Full & Sample','BackgroundColor','white','Tag','sampler_switch','Callback','alterRateMenu');
   uicontrol(Start_Window,'Style','text','Position',[190,120,150,20],'String','Sampling Rate:','HorizontalAlignment','left');
   uicontrol(Start_Window,'Style','popupmenu','Position',[190,90,140,30],'String','Every 2nd Item (1/2 file)|Every 3rd Item (1/3 file)|Every 4th Item (1/4 file)','BackgroundColor','white','Tag','sampler_rate','Enable','Off');
   
%End-------------------------------------------------------------------------------------