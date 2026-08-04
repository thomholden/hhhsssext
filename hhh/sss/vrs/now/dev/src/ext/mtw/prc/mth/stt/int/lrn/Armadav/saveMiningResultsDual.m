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

%Function to save mining results from sample and full mine to a .dmr 
%(data mining results) file
function saveMiningResultsDual

try
   
   [fileName, pathName] = uiputfile('*.dmr','Save Mining Results File');
   
	if fileName ~= 0
      fileName = cat(2,pathName,fileName);
      
      %set mine_type to a to indicate this is analysis results being saved
      mine_type = 'a';
      
      %get rules
      rules_object = findobj(gcbf,'Tag','support_button');
      rules = get(rules_object,'UserData');
      full_rules = rules{1};
      samp_rules = rules{2};
      
      %get full candidates
		full_item_object = findobj(gcbf,'Tag','full_item_box');
      full_candidates = get(full_item_object,'UserData');
      
      %get sampled candidates
      samp_item_object = findobj(gcbf,'Tag','samp_item_box');
      samp_candidates = get(samp_item_object,'UserData');
      
      %get min_support
		sup_object = findobj(gcbf,'Tag','sup_box');
      min_sup = get(sup_object,'UserData');
      
      %get min_confidence
		con_object = findobj(gcbf,'Tag','con_box');
      min_con = get(con_object,'UserData');
      
      %get time to mine full set
		full_time_object = findobj(gcbf,'Tag','full_time_box');
      full_time_taken = get(full_time_object,'UserData');
      
      %get time to mine sampled set
     	samp_time_object = findobj(gcbf,'Tag','samp_time_box');
      samp_time_taken = get(samp_time_object,'UserData');
      
      %get name of file mined
		file_object = findobj(gcbf,'Tag','file_box');
      file = get(file_object,'UserData');
      
      %get full no of entries
		full_entries_object = findobj(gcbf,'Tag','full_no_entries_box');
   	full_no_entries = get(full_entries_object,'UserData');
      
      %get sampled no of entries
      samp_entries_object = findobj(gcbf,'Tag','samp_no_entries_box');
      samp_no_entries = get(samp_entries_object,'UserData');
      
      %get mining summary
		des_object = findobj(gcbf,'Tag','mine_description');
      method_summary = get(des_object,'UserData');
      
		%save variables to file specified
		save(fileName,'mine_type','full_rules','full_candidates','full_time_taken','full_no_entries','samp_rules','samp_candidates','samp_time_taken','samp_no_entries','min_sup','min_con','file','method_summary');
      msgbox('Mining Results saved'); 
   end
catch
   msgbox('Error when saving file.');
end

%End----------------------------------------------------------------------