%-------------------------------------------------------------------------------------
%ARMADA - Association Rule Mining And Deduction Analysis
%Desciprtion:	Data Mining Tool for extraction of association rules and analysis
%					of deduction methods.
%Author& 
%Copyright: 	James Malone
%Date:			14/04/03
%Version:		1.2
%-------------------------------------------------------------------------------------

%------------------------------------------------------------------------

%Function to alter 'Enable' status of sampler rate box, depending upon 
%whether or not the sampler_switch has been selected to sample data
function alterRateMenu()

%Get value of sampler_switch which is being altered
sampler_switch = get(gcbo,'Value');
rate_object = findobj(gcbf,'Tag','sampler_rate');

%If switch requires sampling rate box, then activate
if (sampler_switch == 2 | sampler_switch == 3)
   set(rate_object,'Enable','On');
%else make default inactive   
else
   set(rate_object,'Enable','Off');
end

%End Function------------------------------------------------------------