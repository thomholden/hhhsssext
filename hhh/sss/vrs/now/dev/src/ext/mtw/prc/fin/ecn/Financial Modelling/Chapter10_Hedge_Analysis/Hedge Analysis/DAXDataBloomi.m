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



function [data_struct] = DAXDataBloomi(model,File)
%------------Excelverbindung öffnen---------------
Excel = actxserver ('Excel.Application');
Excel.Workbooks.Open(File);
maturitiesData= xlsread1(File,'DAX','O1:U1');
datesData = xlsread1(File,'DAX','B4:B1438');
spotData = xlsread1(File,'DAX','C4:C1438');
rateData = xlsread1(File,'DAX','BA4:BG1438')/100;
nData = length(spotData);
%-----------Output------------
data_struct.stockDates = x2mdate(datesData);
data_struct.interestRates = log(1+ transpose(rateData));
data_struct.stockPrices = spotData;
data_struct.interestMaturities = maturitiesData;
data_struct.nData = nData;
%------------Vol Cube----------
if strcmp(model.ID,'Heston')
    volaData = xlsread1(File,'DAX','D4:AZ1438'); 
    strikesData = xlsread1(File,'DAX','F1:L1');
% Volacubes
lenT = length(maturitiesData);
lenS = length(strikesData);
volaCube = zeros(lenS,lenT,nData);
for i=1:nData 
    for j=1:lenT % maturities
        for k=1:lenS % strikes
            volaCube(k,j,i)=volaData(i,(j-1)*lenS+k)/100;
        end
    end
end
    data_struct.volaValues = volaCube;
    data_struct.volaStrikes = strikesData;
    data_struct.volaMaturities = maturitiesData;
end
%------------Excelverbindung schließen-----------
Excel.ActiveWorkbook.Save;
Excel.Quit
Excel.delete
clear Excel
end
