%% Read historical data from Yahoo! Finance
%
% Copyright 2013 The MathWorks, Inc.
conn = yahoo;
Data=fetch(conn, symbol, {'Open', 'High', 'Low', ...
    'Adj Close', 'Volume'}, FirstDay, LastDay);
close(conn);
clear conn;

Data = flipud(Data); % Rearrange to oldest first
Data = [Data zeros(size(Data,1),1)]; % Set Open Int to zero
currDataset = mat2dataset(Data,'VarNames',ColumnNames);

clear Data;

disp(['Yahoo: ' symbol]);            