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

%Function to count instances of a particular rule that occur in a given 
%data set.  Returns count as number of instances.
function count = countInstance(check_line,data_set)

%Initiate count to 0 before any checks occur
count = 0;

%for each row in data_set
for i=1:size(data_set,1)
   %compare check_line with each line of data_set
   check_member = ismember(check_line,data_set(i,:));
   %Initiate match before any checks occur on check_member
   match = 1;
   %for each element in check_member
   for j=1:length(check_member)
      %If one of the members is not present match is false, i.e., = 0
      if check_member(j) == 0
         match = 0;
      end
   end
   %If all members in check_line are in the current data_set line then match = 1
   if match == 1
      %Add one to count of instance
      count = count + 1;
   end  
end

%End----------------------------------------------------------------------