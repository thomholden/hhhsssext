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

%Function to display a figure with a graph of no. of rules vs confidence
%of full rules
function displayConfGraph()

%Seperate support and confidence from rules for plotting purposes--------------
conf_button = findobj(gcbf,'Tag','conf_button');
rules = get(conf_button,'UserData');

Line_Window = figure('Name','Data Miner - Rule Confidence Analysis','NumberTitle','Off');
set(gcf,'menubar','none');

c=1;
%For each size of LHS of rule
for a=1:size(rules,2)
   %For each rule in LHS size
	for b=1:size(rules{a},2)
      rules_confidence{c} = rules{a}{b}{3};
      %Create an index for ordering the array
      presort_index(c,1)=rules{a}{b}{2}; %copy each support over
      presort_index(c,2)=rules{a}{b}{3}; %copy each confidence over
  		presort_index(c,3)=c; %copy elements current position in array
      c=c+1;   
   end
end

%order by confidence then support
index=sortrows(presort_index,[2,1]);
%sort by index---------------------------------------
a=1;
for b=1:size(index,1)
	c = index(b,3);
   reversed_confidence(b) = rules_confidence{c};
end
%----------------------------------------------------

%reverse order for biggest first---------------------
a=size(reversed_confidence,2);
for b=1:size(reversed_confidence,2)
   sorted_confidence(b) = reversed_confidence(a);
   a=a-1;
end
%-----------------------------------------------------

%Plot line graph
plot(sorted_confidence);
title('Rule Confidence Analysis');
xlabel('No of Rules (as support decrease)');
ylabel('Confidence of Rules (%)');
uicontrol(Line_Window,'Style','pushbutton','String','Print','Position',[10,50,40,30],'Callback','print'); 
uicontrol(Line_Window,'Style','pushbutton','String','Close','Position',[10,10,40,30],'Callback','close');

%End----------------------------------------------------------------------