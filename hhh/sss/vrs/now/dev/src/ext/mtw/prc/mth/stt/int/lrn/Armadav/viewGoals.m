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

%Function to display (read only) any goals that have been saved
function viewGoals

%Create new window
builder_window = figure('Name','Goals Built','NumberTitle','Off','WindowStyle','Normal');
set(gcf,'menubar','none');

uicontrol(builder_window,'Style','pushbutton','String','Close','Position',[30,20,70,30],'Callback','close'); 

%Get rules that are currently in use
item_box = findobj(gcbf,'Tag','mine_method');
rules = get(item_box,'UserData');
%If there are rules store them in 
if (~isempty(rules))
   antec_rules = rules{1};
   conse_rules = rules{2};
   no_ant_goals = size(antec_rules,2);
   no_con_goals = size(conse_rules,2);
else
   %Initialise to blank
   antec_rules = [];
   conse_rules = [];
   no_ant_goals = 0;
   no_con_goals = 0;
end

uicontrol(builder_window,'Style','frame','Position',[20,80,450,320]);
   uicontrol(builder_window,'Style','text','String','Antecedents:','Position',[30,360,140,20],'HorizontalAlignment','left');
   uicontrol(builder_window,'Style','listbox','Position',[30,140,200,220],'HorizontalAlignment','left','Tag','conse_list','String',antec_rules,'UserData',conse_rules);
   uicontrol(builder_window,'Style','text','Position',[30,100,100,20],'String','Total No:','HorizontalAlignment','left');
   uicontrol(builder_window,'Style','edit','Position',[90,105,50,18],'HorizontalAlignment','left','Enable','inactive','String',no_ant_goals);
   uicontrol(builder_window,'Style','text','String','Consequents:','Position',[260,360,140,20],'HorizontalAlignment','left');
   uicontrol(builder_window,'Style','listbox','Position',[260,140,200,220],'HorizontalAlignment','left','Tag','conse_list','String',conse_rules,'UserData',conse_rules);
   uicontrol(builder_window,'Style','text','Position',[260,100,100,20],'String','Total No:','HorizontalAlignment','left');   
   uicontrol(builder_window,'Style','edit','Position',[320,105,50,18],'HorizontalAlignment','left','Enable','inactive','String',no_con_goals);
   
%End----------------------------------------------------------------------