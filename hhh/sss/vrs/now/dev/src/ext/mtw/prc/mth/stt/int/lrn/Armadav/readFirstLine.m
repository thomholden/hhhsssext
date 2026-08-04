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

%Function to read in first line of data to enable count to begin
function candidates = readFirstLine(file_data,max_length)

%Get first elements to begin comparisons - read in first line
next_elem = 1;
for j=1:(max_length)
   %Ignore if element is 0 as this is a place holder only
   if file_data(1,j) ~= 0
      candidates(next_elem,1)=file_data(1,j);
      candidates(next_elem,2)=1;
      next_elem = next_elem + 1;
   end
end

%End----------------------------------------------------------------------