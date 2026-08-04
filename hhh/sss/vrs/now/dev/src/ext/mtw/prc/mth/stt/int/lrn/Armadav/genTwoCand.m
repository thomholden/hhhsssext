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

%Function to generate 2 item sets
function new_rules = genTwoCand(file_data,candidates,cand_length,min_support)

%Firstly generate all 2 item candidate sets-------
l = 1;

%For each entry in candidates - 1
for j=1:(cand_length-1)
   %For each entry in candidates, starting from next one after previous for loop
   for k=(j+1):cand_length
      new_candidates(l,1) = candidates(j,1);
      new_candidates(l,2) = candidates(k,1);
      new_candidates(l,:) = sort(new_candidates(l,:));
      l=l+1;
   end
end
%-------------------------------------------------

%Count instances of new_candidates----------------
for j=1:size(new_candidates,1)
   count(j) = countInstance(new_candidates(j,:),file_data);
end
%------------------------------------------------

%Remove all rules with < min_coverage------------
new_rules = removeRules(new_candidates,min_support,count,2);
%-------------------------------------------

fprintf('Counted LHS:2 rules\n');

%End----------------------------------------------------------------------