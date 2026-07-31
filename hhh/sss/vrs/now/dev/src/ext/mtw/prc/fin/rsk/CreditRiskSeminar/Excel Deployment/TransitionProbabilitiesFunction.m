function transProb = TransitionProbabilitiesFunction()

% Importing the data
rawData = dataset(...
    'File','MigrationHistory.txt',...
    'VarNames',{'ID','Date','Rating'},...
    'ReadVarNames',false,...
    'Delimiter',',');
              
% Convert raw data using ordinal arrays
rawData.Rating = ordinal(rawData.Rating, [],...
    {'AAA','AA','A','BBB','BB','B','CCC','D'});

% Prepare for computing migration matrix

startDate   = '12/31/1986';
endDate     = '12/31/2000';
dates       = cfdates(datenum(startDate) - 1, datenum(endDate), 1)';
migrFtsCell = GetMigrationFtsCell(rawData.ID, rawData.Date,...
    double(rawData.Rating));
                                  
% Compute migration matrix
migrMat = zeros(size(migrFtsCell, 1), length(dates));
for k = 1 : size(migrFtsCell, 1)
    ftsDummy = fillts(migrFtsCell{k}, 'zero', dates, 1);
    [~,idx,~] = intersect(ftsDummy.dates, dates);
    migrMat(k,:) = fts2mat(ftsDummy(idx));
end

% Compute transition probability matrix
transProb = GetTransProb(migrMat, 8);

% The final row is trivial, so we may omit it
transProb = transProb(1:7, :);


