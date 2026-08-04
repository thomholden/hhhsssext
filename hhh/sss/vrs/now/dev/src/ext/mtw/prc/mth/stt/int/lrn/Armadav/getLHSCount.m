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

%Function to generate 2 item sets
function LHS_count = getLHSCount(order_rules)

%For each set of rules in order_rules get the no of rules 
for x=1:size(order_rules,2)
 	LHS_count(x) = size(order_rules{x},2);
end
 
%End----------------------------------------------------------------------
