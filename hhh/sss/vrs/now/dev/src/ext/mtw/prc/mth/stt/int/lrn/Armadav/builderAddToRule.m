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

%Function to replace a rule to the goals as either consequent or antecedent
function builderAddToRule

%Get data from objects
item_box = findobj(gcbf,'Tag','rule_box');
item = get(item_box,'String');
rule_part = findobj(gcbf,'Tag','rule_part');
rule_side = get(rule_part,'Value');

%convert entered item to 
item_as_num = str2num(item);

if (~isempty(item_as_num))
	%If rule_side is 1 then add to antecedents box and UserData
	if rule_side == 1
   	rule_box = findobj(gcbf,'Tag','antec_list');
	%Otherwise it is consequent add to consequent box and UserData
	else
   	rule_box = findobj(gcbf,'Tag','conse_list');
   end
   %Replace goal selected with entered value
   rule_selected = get(rule_box,'Value');
   rules = get(rule_box,'UserData');
  	rules{rule_selected} = item;
  	set(rule_box,'UserData',rules);
   set(rule_box,'String',rules);
   set(item_box,'String','');
%Otherwise if there is no item entered display error message
else
   questdlg('Please enter a vaild item first','Entry Error','OK','OK');
end

%End----------------------------------------------------------------------