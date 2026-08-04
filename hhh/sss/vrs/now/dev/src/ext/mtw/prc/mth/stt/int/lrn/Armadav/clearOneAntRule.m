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

%Function to clear a selected antecedent goal from list
function clearOneAntRule()

rule_box = findobj(gcbf,'Tag','antec_list');
rules = get(rule_box,'UserData');
rule_selected = get(rule_box,'Value');

%If goals list is empty display error message
if size(rules,2) == 0
   msgbox('There are no rules to delete','Selection Error','warn');
   break;
end

%Display confirmation dialogue box
response = questdlg('Are you sure you wish to clear the selected rule?','Clear Rule','Yes','No','No');

switch response 
   %If yes button is pressed
	case 'Yes'
      %If there is only one item in goals list, set variable to empty
      if size(rules,2) == 1
         new_rules = [];
      %Otherwise if this part is reached there must be multiple items in list
      else   
      	j = 1;
      	%Copy all items over, excluding selected item which is to be deleted
      	for i = 1:size(rules,2)
         	if (i ~= rule_selected)
            	new_rules{j} = rules{i};
            	j = j + 1;
         	end  
         end
      end
      
   %Update variables and display
   set(rule_box,'Value',1);
   set(rule_box,'UserData',new_rules);
   set(rule_box,'String',new_rules);
end      

%End----------------------------------------------------------------------