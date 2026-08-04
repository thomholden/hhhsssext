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

%Function to swap the rules being displayed between those ordered by LHS 
%size and those ordered by support & confidence, depending upon option chosen
function changeRuleAnalysisDisplay

option = get(gcbo,'Value');
full_rule_box = findobj(gcbf,'Tag','full_rule_box');
samp_rule_box = findobj(gcbf,'Tag','samp_rule_box');

%If option is 1 then rules displayed is ordered by support and confidence
if (option == 1)
   %change rules being displayed
   new_rules = get(gcbo,'UserData');
   set(full_rule_box,'String',new_rules{1});
   set(samp_rule_box,'String',new_rules{3});
%Else option is rules displayed ordered by LHS size
else
   %change rules being displayed
  	new_rules = get(gcbo,'UserData');
  	set(full_rule_box,'String',new_rules{2});  
   set(samp_rule_box,'String',new_rules{4}) ;  
end

%End----------------------------------------------------------------------