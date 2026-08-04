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

%Function to order rules by size of LHS part of rule
function resorted_rules = orderByLHS(order_rules)

%Convert formatted_rules into one aray of strings for-----------------
%display purposes - stored in dispRules
a=1;
%For each set of a size of LHS
for i=1:size(order_rules,2)
   %For each rule within that size set
   for j=1:size(order_rules{i},2)
      resorted_rules{a} = order_rules{i}{j}{1};
   	a = a+1;
   end
end

%End----------------------------------------------------------------------