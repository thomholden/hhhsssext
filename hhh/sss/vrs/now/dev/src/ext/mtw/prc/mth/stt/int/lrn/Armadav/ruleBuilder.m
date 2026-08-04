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

%Function to display rule builder window to allow goals to be built or 
%removed by which rules are built on
function ruleBuilder

%Open new window
builder_window = figure('Name','Rule Builder','NumberTitle','Off','WindowStyle','Normal');
set(gcf,'menubar','none');

uicontrol(builder_window,'Style','pushbutton','String','Save Rules','Position',[30,20,70,30],'Callback','saveRuleBuilder'); 
uicontrol(builder_window,'Style','pushbutton','String','Cancel','Position',[110,20,70,30],'Callback','close'); 

%Get any goals that may have been defined already
item_box = findobj(gcbf,'Tag','mine_method');
rules = get(item_box,'UserData');
%If there are rules store them in 
if (~isempty(rules))
   antec_rules = rules{1};
   conse_rules = rules{2};
else
   %Initialise to blank
   antec_rules = [];
   conse_rules = [];
end

uicontrol(builder_window,'Style','frame','Position',[20,80,420,330]);
	uicontrol(builder_window,'Style','text','String','Enter item to search for:','Position',[30,380,150,20],'HorizontalAlignment','left');
	uicontrol(builder_window,'Style','edit','Position',[30,360,150,20],'HorizontalAlignment','left','BackgroundColor','white','Tag','rule_box');
	uicontrol(builder_window,'Style','text','String','As:','Position',[200,380,50,20],'HorizontalAlignment','left');
   uicontrol(builder_window,'Style','popupmenu','Position',[200,360,100,20],'String','Antecedent|Consequent','BackgroundColor','white','Tag','rule_part');
   uicontrol(builder_window,'Style','pushbutton','String','New Rule','Position',[30,320,70,30],'Callback','builderNewRule'); 
   uicontrol(builder_window,'Style','pushbutton','String','Replace','Position',[110,320,70,30],'Callback','builderAddToRule'); 
   uicontrol(builder_window,'Style','text','String','Antecedents:','Position',[30,280,80,20],'HorizontalAlignment','left');
	uicontrol(builder_window,'Style','listbox','Position',[30,140,170,140],'HorizontalAlignment','left','Tag','antec_list','String',antec_rules,'BackgroundColor','white','UserData',antec_rules);
   uicontrol(builder_window,'Style','text','String','Consequents:','Position',[240,280,80,20],'HorizontalAlignment','left');
   uicontrol(builder_window,'Style','listbox','Position',[240,140,170,140],'HorizontalAlignment','left','Tag','conse_list','String',conse_rules,'BackgroundColor','white','UserData',conse_rules);
   uicontrol(builder_window,'Style','pushbutton','String','Delete Rule','Position',[30,100,70,30],'Callback','clearOneAntRule'); 
   uicontrol(builder_window,'Style','pushbutton','String','Clear All Ant.','Position',[110,100,70,30],'Callback','clearAntRules;');
   uicontrol(builder_window,'Style','pushbutton','String','Delete Rule','Position',[240,100,70,30],'Callback','clearOneConRule'); 
   uicontrol(builder_window,'Style','pushbutton','String','Clear All Con.','Position',[320,100,70,30],'Callback','clearConRules;');
   
%End----------------------------------------------------------------------