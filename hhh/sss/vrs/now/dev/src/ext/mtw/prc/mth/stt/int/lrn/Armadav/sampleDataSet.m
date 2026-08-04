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

%Function to sample data set at specified rate
function new_file_data = sampleDataSet(file_data,sampler_rate)

%Initiate counter to guarantee at least first element is copied over 
i = sampler_rate;
k = 1;

%For each entry in file_data
for j=1:size(file_data,1)
   %If this iteration is one to select sample of data on
   if i == sampler_rate
      %Copy over entry
      new_file_data(k,:) = file_data(j,:);     
      k = k + 1;   
      i = 1;
   else
      i = i + 1;
   end   
end

%End----------------------------------------------------------------------