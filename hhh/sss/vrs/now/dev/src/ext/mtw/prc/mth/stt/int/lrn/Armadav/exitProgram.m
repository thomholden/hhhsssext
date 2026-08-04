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

%Function to request confirmation of exiting
function exitProgram

option = questdlg('Are you sure you wish to exit?', ...
                  'Exit Program', ...
                  'Yes','No','No');

switch option,
		case 'Yes', 
         close all;
      case 'No',
        	break;
end % switch

%End----------------------------------------------------------------------