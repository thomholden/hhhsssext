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

%Function to order rules by Support and Confidence
function resorted_rules2 = orderBySupConf(order_rules)

%Seperate support and confidence from rules for plotting purposes-----------
c=1;
%For each set of a size of LHS
for a=1:size(order_rules,2)
   %For each rule within that size set
	for b=1:size(order_rules{a},2)
      one_array_rules{c} = order_rules{a}{b}{1};
      %Create an index for ordering the array
      presort_index(c,1)=order_rules{a}{b}{2}; %copy each support over
      presort_index(c,2)=order_rules{a}{b}{3}; %copy each confidence over
  		presort_index(c,3)=c; %copy elements current position in array
      c=c+1;   
   end
end

index=sortrows(presort_index,[1,2]);

%sort by index---------------------------------------
a=1;
for b=1:size(index,1)
	c = index(b,3);
   resorted_rules{b} = one_array_rules{c} ;   
end
%----------------------------------------------------

%reverse order for biggest first
a=size(resorted_rules,2);
for b=1:size(resorted_rules,2)
   resorted_rules2{b} = resorted_rules{a};
   a=a-1;
end

%End----------------------------------------------------------------------