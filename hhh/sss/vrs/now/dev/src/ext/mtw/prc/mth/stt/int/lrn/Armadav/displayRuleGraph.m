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

%Function to display a window with a bar chart of size of LHS vs no. of rules 
function displayRuleGraph()

rules = get(gcbf,'UserData');

Bar_Window = figure('Name','Data Miner - Rule Count Bar Graph','NumberTitle','Off');
set(gcf,'menubar','none');

%Plot bar chart of LHS size vs no. of rules 
bar(rules);
title('Graph of No of Rules');
xlabel('Size of LHS');
ylabel('No of Rules');
uicontrol(Bar_Window,'Style','pushbutton','String','Print','Position',[10,50,40,30],'Callback','print'); 
uicontrol(Bar_Window,'Style','pushbutton','String','Close','Position',[10,10,40,30],'Callback','close');

%End----------------------------------------------------------------------