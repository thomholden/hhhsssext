%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			14/04/03
%Modified:      20/3/2006
%Version:		1.3
%-------------------------------------------------------------------------------------

%-------------------------------------------------------------------------

%Function to evaluate all criteria specified catching any invlaid input that
%may have been entered.  Read data file.
function evaluateCriteria()

try
   %Get all criteria input
   file_object = findobj(gcbf,'Tag','edit_file_name');
	file_to_mine = get(file_object,'String');
	delimiter_object = findobj(gcbf,'Tag','delimiter');
	delimiter_value = get(delimiter_object,'Value');
	support_object = findobj(gcbf,'Tag','support_edit');
	support_input = get(support_object,'String');
	sup_type_object = findobj(gcbf,'Tag','sup_type');
	sup_type = get(sup_type_object,'Value');
	conf_object = findobj(gcbf,'Tag','conf_edit');
	min_confidence = get(conf_object,'String');
	min_confidence = str2num(min_confidence);
	mine_object = findobj(gcbf,'Tag','mine_method');
	mine_method = get(mine_object,'Value');
	sampler_object = findobj(gcbf,'Tag','sampler_switch');
	sampler_switch = get(sampler_object,'Value');

	%Check file has been entered--------------------------------
	if isempty(file_to_mine)
   	msgbox('Please specify a file to mine first','CreateMode','Modal');
   	return;
	else 
   	switch delimiter_value
   		case 1
         	delimiter = ',';
      	case 2 
         	delimiter = ';';
      	case 3
         	delimiter = ':';
      	case 4
         	delimiter = '.';
      	case 5
         	delimiter = ' ';
  		end
	end
	%File criteria should be specified OK once code hits here----

	%Check mining criteria---------------------------------------
	%convert to input string to number
	min_support = str2num(support_input);
	min_support = round(min_support);
	if (isempty(min_support) | (min_support < 1))
   	msgbox('Please enter a valid number for minimum support','CreateMode','modal');
      return;
   %Else if support is % ensure it is between 1 and 100 (inclusive)
	elseif (sup_type == 2) & (min_support < 1 | min_support >100)
   	msgbox('Minimum support as % must be of value 1 - 100','CreateMode','modal');
      return;
	end

	%If mine criteria is by rule builder-------------------------
	if mine_method == 2
   	rule_builder_data = get(mine_object,'UserData');
   	%check to see if rules have been defined
   	if isempty(rule_builder_data)
      	msgbox('There have been no rules defined by rule builder','CreateMode','modal');
      	return;
   	else
      	%Second check is needed in case rules have been deleted in past
      	%Two blank arrays would cause the above isempty check to be false
   		LHS_goal = rule_builder_data{1};
   		RHS_goal = rule_builder_data{2};
      	if isempty(LHS_goal) & isempty(RHS_goal)
        		msgbox('There have been no rules defined by rule builder','CreateMode','modal');
      		return;
      	end
   	end
	end

	%try to read data file
	try 
   	fprintf('Reading data file...\n');
   	[file_data] = dlmread(file_to_mine,delimiter);
	catch
   	%If an error has occured display message and halt mining
   	msg = 'An error occured when attempting to read the data file';
  		msg = strcat(msg,' "',file_to_mine,'".  Please check the file and');
   	msg = strcat(msg,' mining criteria specified.');
   	msgbox(msg,'CreateMode','modal');
   	%If an error has occured reading file stop mining & return to menu
		return;
	end

	%Check to see which sampling method to use
	%If option is specific sample size
	if sampler_switch == 2
   	rate_object = findobj(gcbf,'Tag','sampler_rate');
   	sampler_rate = get(rate_object,'Value');
   	file_data = sampleDataSet(file_data,sampler_rate+1);
	%ElseIf option is sampling and full file (for analysis purposes)
	elseif sampler_switch == 3
   	rate_object = findobj(gcbf,'Tag','sampler_rate');
   	sampler_rate = get(rate_object,'Value');
   	sampler_data = sampleDataSet(file_data,sampler_rate+1);
	end

	if mine_method == 1
   	if sampler_switch == 3
      	%Perform mine using full and sampled data
      	full_data = performMiningAnalysis(file_data,min_confidence,min_support,sup_type);
      	sample_data = performMiningAnalysis(sampler_data,min_confidence,min_support,sup_type);
      
			%If min_sup is perc add % sign on end for displaying
			if sup_type == 2
   			sup_str = num2str(min_support);
   			min_support = strcat(sup_str,'%');
      	end
      
      	method_summary = strcat('Goal Builder: Off|Sampler: On|Sample Rate: ',num2str(sampler_rate+1));
      	displayAnalysisRules(full_data{1},full_data{2},full_data{3},full_data{4},sample_data{1},sample_data{2},sample_data{3},sample_data{4},min_support,min_confidence,file_to_mine,method_summary);
   	else
      	if sampler_switch == 2
      		method_summary = strcat('Goal Builder: Off|Sampler: On|Sample Rate: ',num2str(sampler_rate+1));
   		else
      		method_summary = strcat('Goal Builder: Off|Sampler: Off|Sample Rate: N/A');
      	end
      
      	%Perform normal mining using full file
   		performMining(file_data,min_confidence,min_support,file_to_mine,sup_type,method_summary);
   	end   
   
	elseif mine_method == 2
   	if sampler_switch == 3
      	full_data = performGoalMiningAnalysis(file_data,min_confidence,min_support,file_to_mine,LHS_goal,RHS_goal,sup_type);
			sample_data = performGoalMiningAnalysis(sampler_data,min_confidence,min_support,file_to_mine,LHS_goal,RHS_goal,sup_type);
      
      	%If min_sup is perc add % sign on end for displaying
			if sup_type == 2
   			sup_str = num2str(min_support);
   			min_support = strcat(sup_str,'%');
      	end
      
      	method_summary = strcat('Goal Builder: On|Sampler: On|Sample Rate: ',num2str(sampler_rate+1));
      	displayAnalysisRules(full_data{1},full_data{2},full_data{3},full_data{4},sample_data{1},sample_data{2},sample_data{3},sample_data{4},min_support,min_confidence,file_to_mine,method_summary);
  
		else
   		method_summary = strcat('Goal Builder: On|Sampler: Off|Sample Rate: N/A');
			performGoalMining(file_data,min_confidence,min_support,file_to_mine,LHS_goal,RHS_goal,sup_type,method_summary);
   	end
   end
catch
   lasterr
  	%If an error has occured display message and halt mining
   msg = 'An error occured during mining.';
  	msg = strcat(msg,'  Please check the file and');
   msg = strcat(msg,' mining criteria specified.');
   msgbox(msg,'CreateMode','modal');
   %If an error has occured reading file stop mining & return to menu
	return;
end

%End----------------------------------------------------------------------