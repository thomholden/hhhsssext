%% Commodities Trading with MATLAB - Importing and cleaning data
% Importing data from a variety of sources and aligning / cleaning up the
% data consumes a significant portion of an analyst workflow. It can be
% challenging to align and synchronize data from multiple sources, and to
% transform the data into multiple useful formats, e.g. rolling up daily
% data into weekly and monthly data.
%
% This script demonstrates one possible way to automate this workflow;
% commodity data is stored across multiple data sources: as a group of CSV
% files in the _.\Datasets_ folder, as an SQLite database (_ohlcdata.db_) in
% the current folder, as well as index data from _Yahoo! Finance_ . The script
% figures out what data to retrieve using the CommodityMetadata spreadsheet
% in the current folder (_CommodityMetadata.xlsx_), and then connects to 
% the appropriate data source to retrieve the data. 
% Once the data has been retrieved, the next step in the workflow is to
% align the data for each of the commodities to the same starting and
% ending dates, after which we can compute data sets on a weekly and
% monthly basis.
%
% Finally, once the data has been retrieved, aligned and transformed, we
% save it into a MAT file for easy access later.

% Copyright 2013 The MathWorks, Inc.

%% 1. Read commodity metadata and initialize other boring housekeeping
% In this section, commodity metadata is imported into the workspace, and
% literals are setup for use later. We also setup the connection parameters
% for the local SQLite database that we connect to.
clc;clear
ImportCommodityMetadata;
SetupLiterals;
SetupDBParameters;

%% 2. Get all data into workspace
% In this section, we iterate through the commodity metadata information in
% order to figure out which data source to access to retrieve that
% particular data. We set up separate struct arrays for commodities data and
% equities data, and add the retrieved data to the corresponding struct as
% a dataset, along with its metadata information.
%
% *NOTE: The commodity data included in this demo is fake data, and has
% been generated solely for the purposes of this webinar*.
fprintf('Getting data into workspace.\n');

DataContainer = struct;
EquitiesContainer = struct;

for i = 1:length(CommodityMetadata)
    symbol = CommodityMetadata.Symbol{i};
    source = CommodityMetadata.Source{i};
    
    switch source
        case 'CSV' % Import data from CSV files
            DataContainer.(symbol).Metadata = CommodityMetadata(i,:);
            ReadAllContractsFromCSV;
        case 'Database' % Import data from SQLite database
            DataContainer.(symbol).Metadata = CommodityMetadata(i,:);
            ReadAllContractsFromDB;
        case 'Yahoo' % Import data from Yahoo! Finance
            EquitiesContainer.(symbol) = currDataset;
            ReadDataFromYahoo;            
    end
end

%% 4. Align the data to the same starting and ending dates
% The retrieved data can have different starting and ending dates; in this
% section, we call a custom filtering function that aligns every dataset to
% the same start and end dates.
fprintf('Aligning data to same starting and ending dates.\n');
DataContainer = FilterByDate(DataContainer,FirstDay,LastDay);

%% 5. Create monthly and weekly data containers
% For parts of our analysis, we will need to "roll up" daily OHLC data into
% weekly and monthly formats. In this section, we call a custom filtering
% function that performs this task easily.
fprintf('Computing monthly and weekly OHLC data containers.\n');
DataContainerWeekly=RollupDailyData(DataContainer,'w');
DataContainerMonthly=RollupDailyData(DataContainer,'m');

%% 6. Divide into training and testing datasets
% Finally, in order to protect ourselves against the worst excesses of data
% mining, we will split our data into separate training and test sets. Our
% test set will only be used at the very end of our analysis workflow.
fprintf('Creating training and test data containers.\n');
LastDayOfTrainingSet='12/31/2005';
SetupTrainingAndTestSets;

%% 7. Perform book-keeping and save clean data into MAT file
% Once we are done with importing and cleaning up our data, we save
% everything into a MAT file (_StageA.mat_) for access by other scripts.
ClearBunchOfVariables;
save('StageA')
