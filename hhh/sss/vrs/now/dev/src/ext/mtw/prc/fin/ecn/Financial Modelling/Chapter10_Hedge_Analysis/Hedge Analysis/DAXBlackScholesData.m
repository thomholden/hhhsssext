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



function [data_struct] = DAXBlackScholesData
%------------Excelverbindung öffnen---------------
Excel = actxserver ('Excel.Application');
File = 'C:\Dokumente und Einstellungen\Manuel\Eigene Dateien\Projekte\MarcusEvansKonferenz\Hedging Entwicklungsumgebung\ExcelToMatlab\DAXdata.xls';
Excel.Workbooks.Open(File);
volaData = xlsread1(File,'DAX','D3:AQ833'); 
strikesData = xlsread1(File,'DAX','B1:F1');
maturitiesData= xlsread1(File,'ZeroRate','C1:J1');
datesData = xlsread1(File,'DAX','B3:B833');
spotData = xlsread1(File,'DAX','C3:C833');
rateData = xlsread1(File,'ZeroRate','C3:J833');
%---------- Umformatieren ------------
nData = 831;
% Volacubes
volaCube = zeros(5,8,nData);
for i=1:nData 
    for j=1:8 % maturities
        for k=1:5 % strikes
            volaCube(k,j,i)=volaData(i,(j-1)*5+k)/100;
        end
    end
end
%-----------Output------------
data_struct.stockDates = x2mdate(datesData);
data_struct.interestRates = log(1+ transpose(rateData));
data_struct.volaValues = volaCube;
data_struct.stockPrices = spotData;
data_struct.volaStrikes = strikesData;
data_struct.volaMaturities = maturitiesData;
data_struct.interestMaturities = maturitiesData;
%------------Excelverbindung schließen-----------
Excel.ActiveWorkbook.Save;
Excel.Quit
Excel.delete
clear Excel
end