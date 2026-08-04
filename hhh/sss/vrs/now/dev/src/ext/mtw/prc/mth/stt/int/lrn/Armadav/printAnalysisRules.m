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
function printAnalysisRules
%Dumps all rules to command window

%get rules
rules_object = findobj(gcbf,'Tag','support_button');
rules = get(rules_object,'UserData');
full_rules = rules{1};
samp_rules = rules{2};

fprintf('Listing full (unsampled) rules...\n');

for y=1:size(full_rules,2) 
   for x=1:size(full_rules{y},2) 
      fprintf(full_rules{y}{x}{1}); 
      fprintf(' \n');
   end
end

fprintf('\nListing sampled rules...\n');

for y=1:size(samp_rules,2) 
   for x=1:size(samp_rules{y},2) 
      fprintf(samp_rules{y}{x}{1}); 
      fprintf(' \n');
   end
end

fprintf('Finished listing all rules\n');