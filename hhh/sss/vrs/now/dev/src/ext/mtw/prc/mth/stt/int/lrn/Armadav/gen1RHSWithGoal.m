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

%Function to generate rules 1 RHS if they meet either goal criteria 
function new_rules = gen1RHSWithGoal(rules,RHS_goal,LHS_goal)

%Initiate variable to meet return contract in case no rules are generated
new_rules = [];

%Copy without support (last element in array)
rules_only = rules(:,1:size(rules,2)-1);

%Take size to be length - 1 as last element is support
cand_length = (size(rules,2) -1);
next_element = 1;

%Check to make sure array has more than one part to it (error check)
if 1 < cand_length
   %For each rule in array
   for a=1:(size(rules,1))
     	%For each element in rule
      for j=1:cand_length
        	match = checkIfGoal(rules(a,j),RHS_goal);
         %if rule is not goal, check to see if LHS is
         if match == 0
            LHS_rule = setdiff(rules_only(a,:),rules(a,j));
            %Check to see if LHS is a goal if RHS isn't
            match = checkIfLHSGoal(LHS_rule,LHS_goal);
         end  
         
         %If either check has resulted in a match, then match = 1
         if match == 1
         	%Store RHS
           	new_rules{2}(next_element,1) = rules(a,j);
            %Store LHS
            new_rules{1}(next_element,:) = setdiff(rules_only(a,:),new_rules{2}(next_element,1));
            %Store coverage of rule which is store in last element of current rules element 
            new_rules{3}(next_element,1) = rules(a,size(rules,2));
            next_element = next_element + 1;
         end      
    	end %end for
 	end %end for
%Otherwise return empty variable
else
 	new_rules = [];
end %end if

%End----------------------------------------------------------------------