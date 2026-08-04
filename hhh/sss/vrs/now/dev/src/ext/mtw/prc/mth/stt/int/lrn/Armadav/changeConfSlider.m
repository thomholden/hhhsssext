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

%Function to move slider upon input into confidence edit box
function changeConfSlider

%Get input number
conf_value = get(gcbo,'String');
%Convert string to a number
conf_value = str2num(conf_value);
conf_slider = findobj(gcbf,'Tag','conf_slider');

%If variable is empty then a character was present so display error message
if isempty(conf_value)
   set(gcbo,'String',1);
   set(conf_slider,'Value',0);
   msgbox('Confidence must be a number','Criteria Input Error','warn');
%Else input is a number so check value   
else  
   %If number is greater than 100 display error as number is percentage
	if conf_value > 100
   	set(gcbo,'String',100);
   	set(conf_slider,'Value',1);
   	%Display error message
   	msg = strcat('Confidence can not be greater than 100%');
      msgbox(msg,'Criteria Input Error','warn');
   %If number is less than 1 display error as 1% is lowest value -
   %This will also catch negative numbers
	elseif conf_value < 1
   	set(gcbo,'String',1);
   	set(conf_slider,'Value',0);
   	%Display error message
   	msg = strcat('Confidence can not be less than 1%');
      msgbox(msg,'Criteria Input Error','warn');
   %Else input is valid so set slider position 
	else   
   	conf_value = fix(conf_value);
      set(gcbo,'String',conf_value);
      %Divide input value by 100 to assign appropriate slider value
   	set(conf_slider,'Value',(conf_value/100));
	end
end

%End----------------------------------------------------------------------