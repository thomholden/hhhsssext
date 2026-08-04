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

%Function to display a figure with a line graph of LHS size vs no. of rules
function displayAnalysisRuleLine()

rules = get(gcbf,'UserData');
full_object = findobj(gcbf,'Tag','full_no_rules_box');
full_no_rules = get(full_object,'String');
no_full = str2num(full_no_rules);
samp_object = findobj(gcbf,'Tag','samp_no_rules_box');
samp_no_rules = get(samp_object,'String');
no_samp = str2num(samp_no_rules);

%Convert counts to percentage for comparison of sample and full---------
for i=1:size(rules{1},2)
   %Store full data set mined rules
   full_count(i) = round((rules{1}(i)/no_full)*100);
   samp_count(i) = 0;
end  

%Convert counts to percentage for comparison----------------
for i=1:size(rules{2},2)
      %Store full sample mined rules
   samp_count(i) = round((rules{2}(i)/no_samp)*100);
end   
%-----------------------------------------------------------

Size_LHS_Window = figure('Name','Data Miner - Rule Count Line Graph','NumberTitle','Off');
set(gcf,'menubar','none');

%Plot line graph of full_count vs element number
plot(1:size(full_count,2),full_count,'r-*',1:size(samp_count,2),samp_count,'b-d');
xlabel('Size of LHS');
ylabel('No of Rules (%)');
title('Line Graph of No. of each size of LHS Rules');
legend('Full','Sample');
uicontrol(Size_LHS_Window,'Style','pushbutton','String','Print','Position',[10,50,40,30],'Callback','print'); 
uicontrol(Size_LHS_Window,'Style','pushbutton','String','Close','Position',[10,10,40,30],'Callback','close');

%End----------------------------------------------------------------------