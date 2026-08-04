%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			14/04/03
%Modified:      21/11/06
%Version:		1.3
%-------------------------------------------------------------------------------------

%-------------------------------------------------------------------------

%Function to generate 3 and more item sets
function rules = genMultiCand(file_data,new_candidates,max_length,min_support)

%Initiate variables
temp_cand=[1];
i = 2;
rules{1} = 0;

%While there are still candidates to generate rules from and max length 
%of rules has not been reached
while (~isempty(temp_cand) & i ~= max_length)
   %For each size of rule to maximum length of data set
   for i=3:max_length
		cand_length = size(new_candidates,1);
      next_elem = 1;
      temp_cand = [];
      %For each item in new_candidates up to second last entry
      for j=1:(cand_length - 1)
         %For each item in new_candidates after new_candidates(j)
         for k=(j+1):cand_length
            %Initiate macth to 0 which is no match found
            match = 0;
            %For each item in an entry up to second last one
            for l=1:(i-1)
               %For each item in an entry up to second last one
               for m=1:(i-1)
                  %If items match then increment match variable
                  if new_candidates(j,l) == new_candidates(k,m)
               		match = match+1;
                     %If matches are enough to form a new rule
                     if match == (i-2)
								possible_candidates = union(new_candidates(j,:),new_candidates(k,:));
                        %Ensure possible_candidate is of correct size, i.e. that there aren't 
                        %too many matches in unified rule which would reduce size
                        if size(possible_candidates,2) == i
                         	temp_cand(next_elem,:) = union(new_candidates(j,:),new_candidates(k,:));  
                        	%Order line using sort----------------------
               				temp_cand(next_elem,:)=sort(temp_cand(next_elem,:));
                           next_elem = next_elem + 1;
                        end
               			return
                        l=(i-1); %breaks out of next for loop as well
                    end 
            	   end
         		end
            end
         end
      end

      %remove duplicate rules
      if ~isempty(temp_cand) %If possible new candidates set is not empty
         temp_cand = unique(temp_cand,'rows'); %Remove any duplicates
         new_candidates = temp_cand;
         
         %Now count instances of new candidates-------------
         clear count;
         new_instance = 0;
         for z = 1:size(new_candidates,1)
   			count(z) = countInstance(new_candidates(z,:),file_data);
            if count(z) >= min_support
               new_instance = 1;
            end
         end
         %-------------------------------------------------
         
         %Following the count, check to see if there any new rules over
         %minimum spec, otherwise halt the mining
         if new_instance == 0
            return
         else
         %Else, remove all rules with < min_coverage-------------
			rules{(i-2)} = removeRules(new_candidates,min_support,count,i);
         %Remove counts from end of array for next comparisons
         clear new_candidates;
         new_candidates = rules{i-2}(:,1:i);
         end
         %-------------------------------------------------
         
      else
         %no more candidates - break out of for loop
   		return
      end 
      fprintf('Generated next set %g out of %g\n',i,max_length);
	end
end

%End----------------------------------------------------------------------
