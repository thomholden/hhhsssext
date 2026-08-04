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

%Function to save rules entered in rule builder window
function saveRuleBuilder()

%Save rules in mine_method popupmenu's UserData
%built_rules{1} is LHS, built_rules{2} is RHS

antec_list = findobj(gcbf,'Tag','antec_list');
conse_list = findobj(gcbf,'Tag','conse_list');
builder_box = findobj('Tag','mine_method');
built_rules{1} = get(antec_list,'UserData');
built_rules{2} = get(conse_list,'UserData');
set(builder_box,'UserData',built_rules);
close;

%End----------------------------------------------------------------------