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

%Function to remove any rules below minimum support. Returns new_rules 
%which are pos_candidates that are above or equal ro min_support
function new_rules = removeRules(pos_candidates,min_support,count,rule_size)

%Initiate variables
new_rules = [];
next_elem = 1;

%For each entry in pos_candidates
for j=1:size(pos_candidates,1)
   %If pos_candidates entry is above min_support
   if count(j) >= min_support
      %Append support of rule to end of pos_candidates
      pos_candidates(j,(rule_size+1)) = count(j);
      %Copy over complete rule to new_rules for returning
      new_rules(next_elem,:) = pos_candidates(j,:);
      %Increment next free element pointer
      next_elem=next_elem+1;
   end
end   

%If no rules survive min_support threshold
if isempty(new_rules)
   new_rules = 0;
end

%End----------------------------------------------------------------------