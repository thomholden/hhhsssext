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

%Function to order rules by support then confidence for displaying purposes
%Also formats rules into suitable string for displaying
function ordered_rules = orderRules(rules_LHS,rules_RHS,support,confidence,min_confidence)

%for each rule in rules_LHS
for x = 1:size(rules_LHS,1) 
   indexed_rules(x,1) = x; %index value
  	indexed_rules(x,2) = support(x); %Support
   indexed_rules(x,3) = confidence(x); %Confidence  
end

%Sort indexed_rules by support then confidence
indexed_rules = sortrows(indexed_rules,[2,3]);

%Initiate variable y which is used to point to next free element in preordered_rules
y = 1;
%for each rule in indexed_rules array 
for x = 1:size(indexed_rules,1)
   %Get index position of rule in original parameters (before sort)
   c = indexed_rules(x,1);
   %Convert numbers to string for dispaying format purposes
   single_LHS = num2str(rules_LHS(c,:));
   single_RHS = num2str(rules_RHS(c,:));
   single_support = num2str(support(c));
   single_conf = num2str(confidence(c));
   %Remove rules below min_confidence
   if (confidence(c) >= min_confidence)	 
      %Format rule for displaying purposes
  		preordered_rules{y}{1} = strcat(single_LHS,' -> ',single_RHS,' Sup= ',single_support,' Conf= ',single_conf);          
      preordered_rules{y}{2} = support(c);
      preordered_rules{y}{3} = confidence(c);
      %Increment index variable to point to next free element
      y = y+1;  
   end     
end

%Reverse order for biggest first------------------------
%Get last element number
y = size(preordered_rules,2);
%For each rule in preordered_rules
for z = 1:size(preordered_rules,2)
   ordered_rules{z}{1} = preordered_rules{y}{1};
   ordered_rules{z}{2} = preordered_rules{y}{2};
   ordered_rules{z}{3} = preordered_rules{y}{3};
   %Decrement y to continue backwards through preordered_rules
   y = y - 1;
end

%End----------------------------------------------------------------------