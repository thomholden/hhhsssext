%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			14/04/03
%Modified:      21/11/06
%Version:		1.3.2
%-------------------------------------------------------------------------------------

%-------------------------------------------------------------------------

%Function to generate one item set, which is a count of all items
function surviving_items = genOneCand(file_data,candidates,no_sets,max_length,min_support)

cand_length = length(candidates);

%Count instances of one set-------------------
%For each entry in candidates, starting at second entry
for k=2:(no_sets)
   %For each item in a file_data entry
   for j=1:(max_length)
      %Initiate found to 0, which is false
      found = 0;
      %For each entry in candidates
      for a=1:(cand_length)
         %If a match of an item is found add one to count of that item
      	if candidates(a,1) == file_data(k,j)
            candidates(a,2) = (candidates(a,2)+1);
            found = 1;
            a=cand_length;
            %Breaks out of inner For loop
         end
      end
      %If item has not been previously recorded add it to candidates
      if found == 0
         %Make sure 0 is not counted as this is a dummy value only
         if file_data(k,j) ~= 0
         	a=a+1;
         	candidates(a,1) = file_data(k,j);
         	candidates(a,2) = 1;
         	cand_length = cand_length+1;
         end
      end
   end  
end 

%Remove all candidates with <= min_support------------------
surviving_items = removeRules(candidates(:,1),min_support,candidates(:,2),1);
%Sort items to assist mining efficiency in later functions
surviving_items = sortrows(surviving_items);

%End----------------------------------------------------------------------