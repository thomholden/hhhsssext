%% Set up training set, filter from 1st day to last day of training

% Copyright 2013 The MathWorks, Inc.

TrainingSet = FilterByDate(DataContainer,FirstDay,LastDayOfTrainingSet);
TrainingSetWeekly=FilterByDate(DataContainerWeekly,FirstDay,...
                    LastDayOfTrainingSet);
TrainingSetMonthly=FilterByDate(DataContainerMonthly,FirstDay,...
                    LastDayOfTrainingSet);

%% Set up test set, filter from day after last day of training to last day
TestSet=FilterByDate(DataContainer,...
    datestr(datenum(LastDayOfTrainingSet)+1),LastDay);
TestSetWeekly=FilterByDate(DataContainerWeekly,...
    datestr(datenum(LastDayOfTrainingSet)+1),LastDay);
TestSetMonthly=FilterByDate(DataContainerMonthly,...
    datestr(datenum(LastDayOfTrainingSet)+1),LastDay);