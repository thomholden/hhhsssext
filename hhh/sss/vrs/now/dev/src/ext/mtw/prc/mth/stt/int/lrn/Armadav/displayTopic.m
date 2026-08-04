%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			14/04/03
%Version:		1.2
%-------------------------------------------------------------------------------------

%----------------------------------------------------------------------------

%Function to display help topic
function displayTopic

option_box = findobj(gcbf,'Tag','help_list');
option = get(option_box,'Value');
help_object = findobj(gcbf,'Tag','help_display');

switch option
	case 1,
      help_answer{1} = 'Getting Started';
      help_answer{2} = ' ';
      help_answer{3} = '1. Select a file to mine.';
      help_answer{4} = '2. Select a Delimiting Charcter.';
      help_answer{5} = '3. Select support and confidence.';
      help_answer{6} = '4. If goal builder is required, build rules - specify option to "Mine using built goals".';
      help_answer{7} = '5. Select option for data sampling.';
      help_answer{7} = '6. Click on Begin Mining or press Ctrl + B.';
      set(help_object,'String',help_answer);
   case 2,
      help_answer{1} = 'Selecting A File';
      help_answer{2} = ' ';
      help_answer{3} = 'To select a file input the file name and path into the File Details: box. If a path is not entered, default working path is used.';
      help_answer{4} = 'File must be of numeric data and uses one of the valid delimiting characters.';
      help_answer{5} = 'To traverse directories to select a file, click on the "Browse" button.';
      set(help_object,'String',help_answer);
   case 3,
      help_answer{1} = 'Selecting Appropriate Criteria';
      help_answer{2} = ' ';
      help_answer{3} = 'Guidlines for selecting criteria:';
      help_answer{4} = '1. The lower the support and confidence, the more rules are extratced.';
      help_answer{5} = '2. The higher the support and confidence, the less rules are extracted.';
      set(help_object,'String',help_answer);
   case 4,
      help_answer{1} = 'Using Rule Goal Builder';
      help_answer{2} = ' ';
      help_answer{3} = '1. Select Build Goals button.';
      help_answer{4} = '2. Enter an item in "item to search for" box.';
      help_answer{5} = '3. Select Antecedent or Consequent from drop down menu.';
      help_answer{6} = '4. Select either New Rule or Replace button to insert goal.';
      help_answer{7} = '5. Repeat steps 2 to 4 until goals have ben built.';
      help_answer{8} = '6. Select Save Rules button to save rules or cancel to disregard them.';
      set(help_object,'String',help_answer);
   case 5,
      help_answer{1} = 'Data Sampling';
      help_answer{2} = ' ';
		help_answer{3} = 'Data Sampling is a technique that allows the data set begin mined to be reduced.';
      help_answer{4} = 'To use select the option from the drop down menu.  Next, select the sampling rate required.';
      set(help_object,'String',help_answer);   
   case 6,
      help_answer{1} = 'Using Sampling & Full File';
      help_answer{2} = ' ';
		help_answer{3} = 'This is a technique that allows the analysis of the two techniques to be performed toegther.';
      help_answer{4} = 'The results of the two are then displayed together to allow easy analysis.';
      help_answer{4} = 'To use this strategy select "Mine Full & Sample" from the Data Sampling drop down menu.';
      set(help_object,'String',help_answer);  
   case 7,
      help_answer{1} = 'Results Display Screen';
      help_answer{2} = ' ';
		help_answer{3} = 'The results display scren is split into six parts:';
      help_answer{4} = '1. Rules Section: This box display the rules extracted from mining. They are in format "LHS item(s)-> RHS item(s) Sup=number Conf=number".';
      help_answer{5} = '2. File Items Section: This box displays all the file items that are above the criteria specified.';
      help_answer{6} = '3. Mining Criteria Section: This displays the criteria that were specified';
      help_answer{7} = '4. Mining Report Section: This displays a report on the mining process undertaken, featuring important attributes to assist analysis.';
      help_answer{8} = '5. Mining Strategy Section: This displays a summary of the mining strategy undertaken.';
      help_answer{9} = '6. Graphical Analysis Section: This enable various graphical summaries of the rules to be displayed.';
      set(help_object,'String',help_answer);  
   case 8,
      help_answer{1} = 'Graphical Analysis';
      help_answer{2} = ' ';
      help_answer{3} = 'A useful feature of ARMADA is the ability to summarise the rules graphically. These graphics come in four parts:';
      help_answer{4} = '1. Number of Rules Line Graph: This plots a line graph of the size of LHS of the rule against the number of rules extracted.';
      help_answer{5} = '2. Number of Rules Bar Chart: This plots a bar chart of the size of LHS of the rule against the number of rules extracted.';
      help_answer{6} = '3. Rule Support Line Graph: This plots a line graph of the support of the rules against the number of rules.';
      help_answer{7} = '4. Rule Confidence Line Graph: This plots a line graph of the confidence of the rules against the number of rules.';
      help_answer{8} = ' ';
      help_answer{9} = 'All of the graphs can be plot by clicking on the relevant button or selecting the menu option.';
      set(help_object,'String',help_answer); 
   case 9,
      help_answer{1} = 'Saving Results To File';
      help_answer{2} = ' ';
      help_answer{3} = 'To save a file:';
      help_answer{4} = ' ';
      help_answer{5} = '1. Select File->Save from the menu bar or press Ctrl+s';
      help_answer{6} = '2. Enter a file name in the File Name box.';
      help_answer{7} = '3. Click on the Save button. To replace an existing file, the file can also be selected from the displayed folder.';
      set(help_object,'String',help_answer);  
  	case 10,
      help_answer{1} = 'Opening Results From File';
      help_answer{2} = ' ';
      help_answer{3} = 'To open a file:';
      help_answer{4} = ' ';
      help_answer{5} = '1. Select File->Open from the menu bar or press Ctrl+o';
      help_answer{6} = '2. Enter a file name in the File Name box or select a file from the contents of the folder being displayed.';
      help_answer{7} = '3. Click on the Open button. If the file name is invalid an error message is displayed.';
      set(help_object,'String',help_answer);  
   case 11,
      help_answer{1} = 'What''s New To Version 1.2?';
      help_answer{2} = ' ';
      help_answer{3} = 'The main addition is the new function to';
      help_answer{4} = 'print the rules in the MATLAB Command';
      help_answer{5} = 'Window. This allows printing of the rules';
      help_answer{6} = 'and the ability to ''cut and paste'' the rules';
      help_answer{7} = 'into a text editor, or similar. This can be';
      help_answer{8} = 'performed using a ''full rule dump'' which';
      help_answer{9} = 'simply dumps all the rules to the cmd window.';
      help_answer{10} = 'The second is to display rules in segments';
      help_answer{11} = 'of 50. This can be used to overcome the';
      help_answer{12} = 'inhibitions the Command Window enforces';
      help_answer{13} = 'concerning the amount of text than can be';
      help_answer{14} = 'scrolled to before it is lost.';
      set(help_object,'String',help_answer);
end

%END-------------------------------------------------------------------------
