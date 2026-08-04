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
%of sampled rules and of full rules
function displayAnalysisConfGraph()

%Seperate support and confidence from rules for plotting purposes--------------
conf_button = findobj(gcbf,'Tag','conf_button');
rules = get(conf_button,'UserData');

%Loop twice, once for full and once for sampled rules
for d=1:2
	c=1;
	for a=1:size(rules{d},2)
		for b=1:size(rules{d}{a},2)
      	rules_confidence{c} = rules{d}{a}{b}{3};
      	%Create an index for ordering the array
      	presort_index(c,1)=rules{d}{a}{b}{2}; %copy each support over
      	presort_index(c,2)=rules{d}{a}{b}{3}; %copy each confidence over
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
   	sorted_confidence{d}(b) = reversed_confidence(a);
   	a=a-1;
	end
   %-----------------------------------------------------
end
%--------------------------------------------------------

Line_Window = figure('Name','Data Miner - Rule Confidence Analysis','NumberTitle','Off');
set(gcf,'menubar','none');

%Plot graph, sorted_confidence{1} is full, sorted_confidence{2} is sample
plot(1:size(sorted_confidence{1},2),sorted_confidence{1},'r',1:size(sorted_confidence{2},2),sorted_confidence{2},'b');
title('Rule Confidence Analysis');
xlabel('No of Rules (as support decrease)');
ylabel('Confidence of Rules (%)');
legend('Full','Sample',0);
uicontrol(Line_Window,'Style','pushbutton','String','Print','Position',[10,50,40,30],'Callback','print'); 
uicontrol(Line_Window,'Style','pushbutton','String','Close','Position',[10,10,40,30],'Callback','close');

%End----------------------------------------------------------------------