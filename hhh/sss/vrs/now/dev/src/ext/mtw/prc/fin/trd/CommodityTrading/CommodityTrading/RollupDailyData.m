function [ newData ] = RollupDailyData( oldData, newFreq )
%ROLLUPDAILYDATA Rolls up daily OHLC data to a weekly, monthly or yearly
%format.
%   oldData         Dataset array or container that is to be rolled up.
%   newFrequency    New frequency of dataset array; can be 'w', 'm', 'y'.
%
% Note that the function assumes the old data is of a daily frequency, and
% that the old data has 'Open', 'High', 'Low', 'Close', 'Volume' and 'OI'
% columns.
% If a container is passed, all datasets in the container will get rolled
% up, and a new container with the rolled-up datasets will be returned.
%
% Copyright 2013 The MathWorks, Inc.
if isa(oldData,'struct')
    newData = struct;
    
    symbols = fields(oldData);
    
    for i = 1:length(symbols)
        currSym = oldData.(symbols{i});
        if isa(currSym,'dataset')
            newData.(symbols{i}) = RollupDailyData(currSym, newFreq);
        elseif isa(currSym,'struct')
            for j = 1:length(currSym.Month)
                if ~isempty(currSym.Month{j})
                    rolledData = RollupDailyData(currSym.Month{j}, newFreq);
                    currSym.Month{j}=rolledData;
                end
            end            
            newData.(symbols{i})=currSym;
        end
    end
    
elseif isa(oldData,'dataset') & ~isempty(oldData)
    ColumnNames = {'Date', 'Open', 'High', 'Low', 'Close', 'Vol', 'OI'};

    %% Extract vectors from old dataset
    AllDate=oldData.Date;
    AllOpen=oldData.Open;
    AllHigh=oldData.High;
    AllLow=oldData.Low;
    AllClose=oldData.Close;
    AllVol=oldData.Vol;
    AllOI=oldData.OI;

    %% Set up switching conditions
    switch upper(newFreq)
        case {'W','WEEKLY'}
            condFcn=@weeknum;
        case {'M','MONTHLY'}
            condFcn=@month;
        case {'Y','YEARLY'}
            condFcn=@year;
        otherwise
            condFcn=@false;
    end

    %% Set up new dataset vectors
    newData=dataset;   
    maxIterations=length(AllDate);
    newDate=zeros(1,1);
    newOpen=zeros(1,1);
    newHigh=zeros(1,1);
    newLow=zeros(1,1);
    newClose=zeros(1,1);
    newVol=zeros(1,1);
    newOI=zeros(1,1);

    %% Initialize the state machine
    startDate=AllDate(1);
    open=AllOpen(1);
    high=AllHigh(1);
    low=AllLow(1);
    endClose=AllClose(1);
    volume=AllVol(1);
    OI=AllOI(1);

    %% Execute the state machine
    for i=2:maxIterations
        % Set up switching conditions    
        condition=condFcn(AllDate(i))==condFcn(AllDate(i-1));

        if(i==maxIterations) % End of dataset
            endClose=AllClose(i);
            newData=mat2dataset([newDate, newOpen, newHigh, newLow, ...
                newClose, newVol, newOI],'VarNames',ColumnNames);

        elseif(condition) % Still in the same period
            high=max(high,AllHigh(i));
            low=min(low,AllLow(i));
            volume=volume+AllVol(i);
            OI=OI+AllOI(i);

        else % New period!

            % Save data for old period
            endClose=AllClose(i-1);

            newDate=[newDate; startDate];
            newOpen=[newOpen; open];
            newHigh=[newHigh; high];
            newLow= [newLow; low];
            newClose=[newClose; endClose];
            newVol=[newVol; volume];
            newOI=[newOI; OI];

            % Reset dates, etc..
            startDate=AllDate(i);
            open=AllOpen(i);
            high=AllHigh(i);
            low=AllLow(i);
            volume=AllVol(i);
            OI=AllOI(i);

        end
    end

    % Remove leading zeros
    if(newData.Date(1)==0)
        newData=newData(2:end,:);
    end

end

    
end


