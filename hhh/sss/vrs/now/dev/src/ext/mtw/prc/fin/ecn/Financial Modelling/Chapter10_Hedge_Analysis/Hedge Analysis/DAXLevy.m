% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [data_struct] = DAXLevy(model,File)
%------------Excelverbindung öffnen---------------
Excel = actxserver ('Excel.Application');
Excel.Workbooks.Open(File);
%-----------Selector------------
if strcmp(model.ID,'Heston') 
    data_struct.heston = xlsread1(File,'Heston','B2:F833');
elseif strcmp(model.ID,'Bates')
    data_struct.bates = xlsread1(File,'Bates','B2:I833'); 
elseif strcmp(model.ID,'NIG')
    data_struct.nig = xlsread1(File,'NIG','B2:D833'); 
elseif strcmp(model.ID,'VarianceGamma')
    data_struct.vg = xlsread1(File,'VG','B2:D833'); 
elseif strcmp(model.ID,'BlackScholes')
    data_struct.dummy = xlsread1(File,'VG','B2:D833'); 
end;
%------------Excelverbindung schließen-----------
Excel.ActiveWorkbook.Save;
Excel.Quit
Excel.delete
clear Excel
end