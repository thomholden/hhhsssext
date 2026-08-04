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

%Function to alter confidence box according to value of confidence slider
function alterConfBox()

%Get value of confidence slider
conf_value = get(gcbo,'Value');

%If value is 0 make it 1 since 1% is lowest value for confidence box
if (conf_value == 0)
   conf_value = 0.01;
end

%Set confidence box with value*100 to give percentage
conf_edit = findobj(gcbf,'Tag','conf_edit');
conf_value = fix(conf_value*100);
set(conf_edit,'String',conf_value);

%End Function------------------------------------------------------------