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

%Function to either close display and save, close display or cancel
function closeAnalysisDisplay

option = questdlg('Do you wish to save mining results first?', ...
                  'Save Mining Results', ...
                  'Yes','No','Cancel','Yes');

switch option,
   	%Option selected is 'Yes' so save and close display
		case 'Yes', 
         saveMiningResultsDual;
         close all;
         ARMADA;
      %Option selected is 'No' so close display
      case 'No',
         close all;
         ARMADA;
      %Option selected is 'Cancel'
     	case 'Cancel',
        	return;
end

%End----------------------------------------------------------------------