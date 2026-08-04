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

%function to calculate coverage of each rule and then
%discard if under minimum specified for consideration
function rule_confidence = calculateConfidence(rules,candidates,variants)

%confidence is calculated by:
%support of current rule/support of LHS part of current rule
%variants{1} is LHS
%variants{2} is RHS
%variants{3} is support of current rule
LHS_size = size(variants{1},2);

%If LHS has one part counts taken from candidates array
if LHS_size == 1   
	%for each rule
	for a = 1:(size(variants{1},1))
   	%for each candidate already counted
   	for b = 1:(size(candidates,1))
      	if candidates(b,1) == variants{1}(a)
         	rule_confidence(a) = (variants{3}(a)/candidates(b,2))*100;
         	%If match is found break out of for loop to start at beginning of
         	%candidates again for next search through
         	break;
      	end
   	end
   end
%Else take counts from array that is appropriate for comparison
else
   %for each rule
	for a = 1:(size(variants{1},1))
      %for each candidate already counted
      for b = 1:(size(rules{LHS_size-1},1))
			check = ismember(variants{1}(a,:),rules{LHS_size-1}(b,1:LHS_size),'rows');
         if check == 1
         	rule_confidence(a) = (variants{3}(a)/rules{LHS_size-1}(b,LHS_size+1))*100;
         	%If match is found break out of for loop to start at beginning of
         	%candidates again for next search through
         	break;
      	end      
      end
   end
end   

%End----------------------------------------------------------------------