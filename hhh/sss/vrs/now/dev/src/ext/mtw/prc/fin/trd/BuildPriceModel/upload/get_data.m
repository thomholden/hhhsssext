function get_data(coin_name)
%Get raw data from Coinbase in duration 01-Jan-2018 to 08-jan-2021
T1 = datetime(2018,01,1,0,0,0,'Format','uuuu-MM-dd''T''HH:mm:ss''Z');
% T2 = datetime(2021,01,21,0,0,0,'Format','uuuu-MM-dd''T''HH:mm:ss''Z');
T2=datetime('now','Format','uuuu-MM-dd''T''HH:mm:ss''Z');
totalNumDays = days(T2-T1);
complete = arrayfun(@(x) T1+x, 0:totalNumDays, 'UniformOutput', false);
% coin_name ={'ETH','LTC','BCH'};
% coin_name ={'BTC'};
%Output variable from API: {'Time', 'Low', 'High', 'Open', 'Close', 'Volume'};
%Granularity is in seconds, so we are getting 1-minute candle:
% The granularity field must be one of the following values: {60, 300, 900, 3600, 21600, 86400}.
granularity = 86400;%6hrs candle
for i=1:length(coin_name)
    product = coin_name{i};
    %Initialize first line fo concatenating
    Data=table(T1,0,0,0,0,0,'VariableNames',{'Time', 'Low', 'High', 'Open', 'Close', 'Volume'});
    %Loop for getting data
    for ii=1:2:length(complete)-1
        price = getprices(product,complete{1,ii},complete{1,ii+1},granularity);
        Data = [price;Data];
    end
    Data = sortrows(Data,'Time','ascend');
    Data(2,:)=[];%Remove initialized Data
    %Save data to *.xlsx files
    filename = strcat(product,".xlsx");
    writetable(Data,filename);
end
end