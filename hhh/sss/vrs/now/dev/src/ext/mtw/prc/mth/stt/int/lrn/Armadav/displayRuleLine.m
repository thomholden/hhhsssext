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

%Function to display a window with a line graph of size of LHS vs no. of rules 
function displayRuleLine()

rules = get(gcbf,'UserData');

Size_LHS_Window = figure('Name','Data Miner - Rule Count Line Graph','NumberTitle','Off');
set(gcf,'menubar','none');

%Plot line graph of LHS size vs no. of rules
plot(rules,'r-*');
xlabel('Size of LHS');
ylabel('No of Rules');
title('Line Graph of No. of each size of LHS Rules');
uicontrol(Size_LHS_Window,'Style','pushbutton','String','Print','Position',[10,50,40,30],'Callback','print'); 
uicontrol(Size_LHS_Window,'Style','pushbutton','String','Close','Position',[10,10,40,30],'Callback','close');

%End----------------------------------------------------------------------