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

%Function to save mining results from full mine to a .dmr 
%(data mining results) file
function saveMiningResults

try
   [fileName, pathName] = uiputfile('*.dmr','Save Mining Results File');
  	%If file has been selected or entered
	if fileName ~= 0
      fileName = cat(2,pathName,fileName);
      
      %set mine_type to n to indicate normal mine mode
      mine_type = 'n';
      
      %get rules
      rules_object = findobj(gcbf,'Tag','support_button');
      rules = get(rules_object,'UserData');
      
      %get items in file as candidates
		item_object = findobj(gcbf,'Tag','item_box');
      candidates = get(item_object,'UserData');
      
      %get min_support
      sup_object = findobj(gcbf,'Tag','sup_box');
      min_sup = get(sup_object,'UserData');
      
      %get min_confidence
		con_object = findobj(gcbf,'Tag','con_box');
      min_con = get(con_object,'UserData');
      
      %get time to mine
		time_object = findobj(gcbf,'Tag','time_box');
      time_taken = get(time_object,'UserData');
      
      %get name of file mined
		file_object = findobj(gcbf,'Tag','file_box');
      file = get(file_object,'UserData');
      
      %get no of entries
		entries_object = findobj(gcbf,'Tag','no_entries_box');
      no_entries = get(entries_object,'UserData');
      
      %get mining summary
      des_object = findobj(gcbf,'Tag','mine_description');
      method_summary = get(des_object,'UserData');
      
		%save variables to file specified
		save(fileName,'mine_type','rules','candidates','min_sup','min_con','time_taken','file','no_entries','method_summary');
		msgbox('Mining Results saved'); 
   end
catch
   msgbox('Error when saving file.');
end

%End----------------------------------------------------------------------