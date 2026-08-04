%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			14/04/03
%Version:		1.2
%-------------------------------------------------------------------------------------

%New to version 1.2-------------------------------------------------------------------
function printPausedRules
%Dumps rules to command window, 50 at a time

%get rules
rules_object = findobj(gcbf,'Tag','support_button');
rules = get(rules_object,'UserData');

fprintf('Listing all rules...\n');

count = 1;

for y=1:size(rules,2) 
   for x=1:size(rules{y},2) 
      fprintf(rules{y}{x}{1}); 
      fprintf(' \n');
      count=count+1;
      if count == 50
         fprintf('Press a key to continue...\n');
         pause;
         fprintf('\n');
         count = 1;
      end   
   end
end

fprintf('Finished listing all rules\n');