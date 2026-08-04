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

%Function to request confirmation of save and exit, exit or no action
function exitProgramSaveDual

option = questdlg('Do you wish to save mining results before exiting?', ...
                  'Exit Program', ...
                  'Yes','No','Cancel','Yes');

switch option,
		case 'Yes', 
         saveMiningResultsDual;
         close all;
      case 'No',
         close all;
     	case 'Cancel',
        	break;
end % switch

%End----------------------------------------------------------------------