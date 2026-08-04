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

%Function to generate rule variants for given set of rules.
%Returns new_rules as rule variants
function new_rules = genRuleVariants(rules,candidates,min_confidence)

%Ensure that preconditions have been properly met, i.e. that neither
%rules nor candidates is empty
if (~isempty(rules) & ~isempty(candidates))
	%For each set of rules for a given LHS size
	for a = 1:size(rules,2)
   	fprintf('Generating rule variants %g of %g\n',a,size(rules,2));
   	%Generate all variants initially
   	new_rules{a} = gen1RHS(rules{a});
   	%Now check for minimum coverage of 1RHS variants
   	new_rules{a}{4} = calculateConfidence(rules,candidates,new_rules{a});
   end
%If this part is reached then an error has occured so return empty   
else
  	new_rules = []; 
end
%End----------------------------------------------------------------------