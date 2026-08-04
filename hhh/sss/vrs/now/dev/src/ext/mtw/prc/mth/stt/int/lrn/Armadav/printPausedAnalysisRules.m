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
function printPausedAnalysisRules
%Dumps rules to command window, 50 at a time

%get rules
rules_object = findobj(gcbf,'Tag','support_button');
rules = get(rules_object,'UserData');
full_rules = rules{1};
samp_rules = rules{2};

fprintf('Listing full (unsampled) rules...\n');

count = 1;

for y=1:size(full_rules,2) 
   for x=1:size(full_rules{y},2) 
      fprintf(full_rules{y}{x}{1}); 
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

fprintf('\nListing sampled rules...\n');
fprintf('Press a key to continue...\n');
pause;

count = 1;

for y=1:size(samp_rules,2) 
   for x=1:size(samp_rules{y},2) 
      fprintf(samp_rules{y}{x}{1}); 
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