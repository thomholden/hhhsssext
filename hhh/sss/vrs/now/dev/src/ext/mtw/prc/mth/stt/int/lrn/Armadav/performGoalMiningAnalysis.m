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
%performGoalMiningAnaysis.m
%
%Used for mining with rule builder when mining full and sample data set.  
%Control module to call different functions to perfrom mining then returns
%report in parameter mine_data
function mine_data = performGoalMiningAnalysis(file_data,min_confidence,min_support,file_to_mine,LHS_goal,RHS_goal,sup_type)

%Start timer
tic;

%If min support is as percentage convert to number for calc.
if sup_type == 2
   no_sets = size(file_data,1);
   min_support = (no_sets/100)* min_support;
end

%Sort stored file to increase speed of mining----------------
no_sets = size(file_data,1);
max_length = size(file_data,2);
for a = 1:no_sets
   file_data(a,:) = sort(file_data(a,:));
end
%------------------------------------------------------------

%Initiate variables in case an error occurs during try statement
%because they are used later in program
candidates = 0;  
ordered_rules = [];

%Perform error check to see if file_data is empty - if it is set 
%variables and blank and report, otherwise begin mining process
if (~isempty(file_data))
	try
		fprintf('Beginning mining...\n')
      
      %Get first elements to begin comparisons - read in first line
		candidates = readFirstLine(file_data,max_length);
		%------------------------------------------------------------

		%Count instances of one set----------------------------------
		candidates = genOneCand(file_data,candidates,no_sets,max_length,min_support);
      cand_length = size (candidates,1);
      %If there are no candidates or only 1 then halt mining, as there 
      %will be no rules from only one item
      if (candidates == 0 | cand_length == 1) 
         fprintf('No rules');
         return;
      end
      %------------------------------------------------------------

		%For generating 2 item sets----------------------------------
      rules{1} = genTwoCand(file_data,candidates,cand_length,min_support);
      %Remove counts from end of array for next comparisons if there are any
      if (rules{1} ~= 0)
         new_candidates = rules{1}(:,1:2);
      else
         %Break out of loop if there are no two LHS rules because possible
         %RHS values do not need to be generated
         return;
      end   
      %------------------------------------------------------------
       
		%For generating 3 and more item sets-------------------------
   	if (max_length > 2)
   		temp_rules = genMultiCand(file_data,new_candidates,max_length,min_support);	
   		%Perform initial test to see if temp_rules has been added to, and therefore
   		%there are new rules to add and if so concatenate rules into rules variable
   		if temp_rules{1} ~= 0
            rules = cat(2,rules,temp_rules);
         end 
   	end
		%------------------------------------------------------------
		fprintf('Finished Generating Rules:\n');
      
		%Generate rule variants for minimum support------------------
		fprintf('Beginning generation of rule variants..\n');
      %If any goals have been defined
      if ~isempty(RHS_goal) | ~isempty(LHS_goal)
         final_rules = genRuleVariantsWithGoal(rules,candidates,min_confidence,RHS_goal,LHS_goal);
      else   
         final_rules = genRuleVariants(rules,candidates,min_confidence);
      end   
      %------------------------------------------------------------
      fprintf('Mining completed.');	
      
		%Order rules as specified by user removing below min_confidence 
      %rules for each set of rules starting with 1LHS & format for displaying
      empty_flag = 1;
      for no = 1:size(final_rules,2) 
         if ~isempty(final_rules{no})
   			ordered_rules{no} = orderRules(final_rules{no}{1},final_rules{no}{2},final_rules{no}{3},final_rules{no}{4},min_confidence);
            if ~isempty(ordered_rules{no})
             	empty_flag = 0;  
            end
         end 
      end
      
      %If no rules have survived set ordered_rules to empty
      if empty_flag == 1
      	ordered_rules = [];   
      end
	catch
   	lasterr
   	fprintf('WARNING: Error occured while mining rules\n');
      %Set ordered_rules to empty, indicating an error to later functions
      ordered_rules = [];
	end
end

%Finish timing the mining process
time = clock;
time_taken = toc

%If min_sup is perc, convert back to perc from numb
if sup_type == 2
   min_support = round((min_support*100)/no_sets);
   sup_str = num2str(min_support);
   min_support = strcat(sup_str,'%');
end

%Return the final rules data to prodcue mining report
mine_data{1} = ordered_rules;
mine_data{2} = candidates;
mine_data{3} = time_taken;
mine_data{4} = no_sets;

%End----------------------------------------------------------------------

