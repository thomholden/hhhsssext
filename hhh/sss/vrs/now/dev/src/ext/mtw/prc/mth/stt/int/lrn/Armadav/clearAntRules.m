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

%Function to  clear antecedent goals
function clearAntRules()

%Display confirmation dialogue box
response = questdlg('Are you sure you wish to clear all the rules?','Clear Rules','Yes','No','No');

switch response 
   %If yes button is pressed
	case 'Yes'
   	%Clear all antec goals
 		rule_box = findobj(gcbf,'Tag','antec_list');
		set(rule_box,'UserData',[]);
   	set(rule_box,'String',[]);	
end

%End----------------------------------------------------------------------