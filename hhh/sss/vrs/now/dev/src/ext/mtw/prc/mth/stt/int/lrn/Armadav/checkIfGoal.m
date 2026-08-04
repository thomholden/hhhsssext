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

%Function to identify those candidates that match goals specified
%Returns match = 1 if match is found, otherwise match = 0 if not a match
function match = checkIfGoal(candidate,goal)

%Initiate variables
match = 0;
i = 1;

%while goal has not been matched and end of RHS_goal has not been reached 
while (match == 0 & i <= size(goal,2))

   %Convert string to number for comparison
   goal_as_num = str2num(goal{i});
   
   %If goal is a valid number then goal_as_num will not be empty
   if (~isempty(goal_as_num))
      %If goal is a member of rule set match to 1
      if ismember(candidate,goal_as_num)
         match = 1;
     	end 
  	end
   i = i + 1;   
end 

%End----------------------------------------------------------------------