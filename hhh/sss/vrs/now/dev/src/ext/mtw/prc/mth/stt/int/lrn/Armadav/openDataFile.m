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

%Function to select a file to perform mine on
function openDataFile()

%Open default open file dialgoue window
[fileName, pathName] = uigetfile; 

%Get handle of object who's UserData will store file data-----------
edit_file_name = findobj(gcbf,'Tag','edit_file_name');

%If a file has been selected
if fileName ~= 0
   %Set file edit box to selected file
   clear dataFile;
   set(edit_file_name,'String',cat(2,pathName,fileName));
end

%End----------------------------------------------------------------------