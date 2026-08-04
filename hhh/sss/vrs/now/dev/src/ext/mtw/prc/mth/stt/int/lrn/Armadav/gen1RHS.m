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

%Function to generate 1 RHS part of association rule.  Takes rules as arg
%and returns new_rules{1} as LHS, new_rules{2} as RHS and new_rules{3} as
%support of rule
function new_rules = gen1RHS(rules)

%Copy without support (last element in array)
rules_only = rules(:,1:size(rules,2)-1);

%Take size to be length - 1 as last element is support
cand_length = (size(rules,2) -1);
next_element = 1;

%Check to make sure array has more than one part to it (error check)
if 1 < cand_length
   %For each rule in array
   for a=1:(size(rules,1))
      %For each element in rules
      for j=1:cand_length
        	%Store RHS
         new_rules{2}(next_element,1) = rules(a,j);
         %Store LHS
         new_rules{1}(next_element,:) = setdiff(rules_only(a,:),new_rules{2}(next_element,1));
         %Store support of rule which is store in last element of current rules element 
         new_rules{3}(next_element,1) = rules(a,size(rules,2));
         next_element = next_element + 1;
     	end 
  	end 
%Otherwise return empty variable
else
 	new_rules = [];
end

%End----------------------------------------------------------------------