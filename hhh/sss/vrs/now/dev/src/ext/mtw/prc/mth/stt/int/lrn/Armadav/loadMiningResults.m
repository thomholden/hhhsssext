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

%Function to load a mining results file
function loadMiningResults

%Try block to catch any errors that may occur when opening file
try
   %Open default open file dialogue, filter to display files with dmr extension
   [fileName, pathName] = uigetfile('*.dmr','Open Mining Results File'); 
   %If a file has been selected
   if fileName ~= 0
      %cast file to load as a matlab data file
      fileName = cat(2,'load ',pathName,fileName,' ','-mat');
      eval(fileName);
      %If file type is a normal mine call displayRules
      if mine_type == 'n'
   		close all;
      	displayRules(rules,candidates,min_sup,min_con,time_taken,file,no_entries,method_summary);
      %Else if file type is an analysis mine then call displayAnalysisRules   
      elseif mine_type == 'a'
         close all;
         displayAnalysisRules(full_rules,full_candidates,full_time_taken,full_no_entries,samp_rules,samp_candidates,samp_time_taken,samp_no_entries,min_sup,min_con,file,method_summary);
      %Otherwise an error has occured, display error message   
      else msgbox('File is of incorrect format for displaying.');   
      end
      msgbox('Mining results loaded');
   end
%Catch and handle any errors that may occur when opening data file
catch
   msgbox('Error when opening file.  Check that file is of correct format');
end

%End----------------------------------------------------------------------