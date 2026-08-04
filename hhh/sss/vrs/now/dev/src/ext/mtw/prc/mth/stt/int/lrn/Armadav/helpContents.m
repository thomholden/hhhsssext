%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			10/04/03
%Version:		1.2
%-------------------------------------------------------------------------------------

function helpContents

help_window = figure('Name','ARMADA Help Contents','NumberTitle','Off','WindowStyle','Normal','menubar','none');

%Place help topics in help_topics variable for displaying in list box
help_topics = 'Getting Started|Selecting A File To Mine|Selecting Appropriate Criteria|Using Rule Builder|';
help_topics = strcat(help_topics,'Data Sampling|Using Sampling & Full File|Results Display Screen|');
help_topics = strcat(help_topics,'Graphical Analysis|Saving Results To File|Opening Results From File|WHAT''S NEW TO VERSION 1.2?');

uicontrol(help_window,'Style','frame','Position',[10,80,480,320]);
	uicontrol(help_window,'Style','text','String','Help Contents:','Position',[30,360,120,20],'HorizontalAlignment','left');
	uicontrol(help_window,'Style','listbox','Position',[30,130,210,230],'HorizontalAlignment','left','BackGroundColor','White','Tag','help_list','String',help_topics);
   uicontrol(help_window,'Style','pushbutton','String','Display','Position',[30,90,70,25],'Callback','displayTopic'); 
  	uicontrol(help_window,'Style','text','Position',[260,90,220,300],'HorizontalAlignment','left','BackGroundColor','White','Tag','help_display');
   
   
uicontrol(help_window,'Style','pushbutton','String','Close','Position',[30,20,70,30],'Callback','close'); 

