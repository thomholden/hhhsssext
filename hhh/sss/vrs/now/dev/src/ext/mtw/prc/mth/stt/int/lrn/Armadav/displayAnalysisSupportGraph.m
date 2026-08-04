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

%Function to display a figure with a graph of no. of rules vs support
%of sampled rules and of full rules
function displayAnalysisSupportGraph()

%Seperate support and confidence from rules for plotting purposes--------------
support_button = findobj(gcbf,'Tag','support_button');
rules = get(support_button,'UserData');
full_object = findobj(gcbf,'Tag','full_no_entries_box');
full_total_str = get(full_object,'String');
total_entries(1) = str2num(full_total_str);
samp_object = findobj(gcbf,'Tag','samp_no_entries_box');
samp_total_str = get(samp_object,'String');
total_entries(2) = str2num(samp_total_str);

%Loop twice, once for full and once for sampled rules
for d=1:2
	c=1;
	for a=1:size(rules{d},2)
      for b=1:size(rules{d}{a},2)
         %Convert support from number to percentage of file entries mined
      	rules_support{c} = ((rules{d}{a}{b}{2})/total_entries(d))*100;
      	%Create an index for ordering the array
      	presort_index(c,1)=((rules{d}{a}{b}{2})/total_entries(d))*100; %copy each support over
      	presort_index(c,2)=rules{d}{a}{b}{3}; %copy each confidence over
  			presort_index(c,3)=c; %copy elements current position in array
      	c=c+1;   
   	end
	end
   
   %order by support then confidence
	index=sortrows(presort_index,[1,2]);
	%sort by index---------------------------------------
	a=1;
	for b=1:size(index,1)
		c = index(b,3);
   	reversed_support(b) = rules_support{c} ;
	end
	%----------------------------------------------------

	%reverse order for biggest first---------------------
	a=size(reversed_support,2);
	for b=1:size(reversed_support,2)
      sorted_support{d}(b) = reversed_support(a);
   	a=a-1;
	end
	%-----------------------------------------------------
end
%--------------------------------------------------------

Line_Window = figure('Name','Data Miner - Rule Support Analysis','NumberTitle','Off');
set(gcf,'menubar','none');

%Plot graph, sorted_support{1} is full, sorted_support{2} is sample
plot(1:size(sorted_support{1},2),sorted_support{1},'r',1:size(sorted_support{2},2),sorted_support{2},'b');
title('Rule Support Analysis');
xlabel('No of Rules');
ylabel('Support of Rules (as % of file)');
legend('Full','Sample',0);
uicontrol(Line_Window,'Style','pushbutton','String','Print','Position',[10,50,40,30],'Callback','print'); 
uicontrol(Line_Window,'Style','pushbutton','String','Close','Position',[10,10,40,30],'Callback','close'); 

%End----------------------------------------------------------------------