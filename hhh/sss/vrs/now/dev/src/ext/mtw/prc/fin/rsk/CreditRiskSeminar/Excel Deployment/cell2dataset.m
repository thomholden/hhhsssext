function dsobj = cell2dataset(cellobj, varargin)
% CELL2DATASET converts a Cell array into a Dataset array. In this process
% it can automatically perform conversions so that the underlying dataset
% variables are not cell arrays.
%
% USAGE:
% dsobj = cell2dataset(cellobj, 'VarNames', headers)
%       This syntax allows you to specify the column names via the cell
%       array "headers".
%
% dsobj = cell2dataset(..., 'ReadVarNames', true, ...)
%       This syntax allows you to automatically assign column names via
%       row 1 of the cell array.
%
% dsobj = cell2dataset(cellobj, 'ObsNames', rownames)
%       This syntax allows you to specify the row names via the cell
%       array "rownames".
%
% dsobj = cell2dataset(..., 'ReadObsNames', true, ...)
%       This syntax allows you to automatically assign row names via
%       column 1 of the cell array.
%
% dsobj = cell2dataset(..., 'DataTypes', {type1, type2, ...}, ...);
%       This syntax allows you to specify data types for the different
%       columns of the cell array to force a conversion. The possible data
%       types include 'double', 'date', 'nominal', 'string'. If any data
%       types are omitted, an automatic conversion is attempted.

% What follows is a fancy way of doing input argument validation.  Not at
% all required, but it does take advantage of MATLAB's built-in object
% system.
p = inputParser;
p.addRequired('cellobj', @iscell);
p.addParamValue('VarNames',[], @iscellstr);
p.addParamValue('ReadVarNames', false, @islogical);
p.addParamValue('ObsNames',[], @iscellstr);
p.addParamValue('ReadObsNames', false, @islogical);
p.addParamValue('DataTypes', [], @iscellstr);

p.FunctionName = 'CELL2DATASET';

p.parse(cellobj, varargin{:})

%TODO: More rigorous error checking.

if p.Results.ReadVarNames
    headers = cellobj(1,:);
    cellobj = cellobj(2:end,:);
else
    headers = p.VarNames;
end

RON = false; % Flag for dataset constructor.
if p.Results.ReadObsNames
    rownames = cellobj(:,1);
    cellobj = cellobj(:,2:end);
    if p.Results.ReadVarNames
        headers = headers(1, 2:end);
    end
    RON = true;
elseif ~isempty(p.Results.ObsNames)
    rownames = p.Results.ObsNames;
    RON = true;
end

dsobj = dataset([{cellobj}, headers]);
if RON
    dsobj = set(dsobj, 'ObsNames', rownames);
end

% In case any variable names were changed to make them valid:
headers = get(dsobj, 'VarNames');

if ~isempty(p.Results.DataTypes)
    types = p.Results.DataTypes;
    for i = 1 : length(types)
        switch types{i}
            case 'double'
                dsobj.(headers{i}) = cell2mat(dsobj.(headers{i}));
            case 'date'
                dsobj.(headers{i}) = x2mdate(cell2mat(dsobj.(headers{i})));
            case 'nominal'
                dsobj.(headers{i}) = nominal(dsobj.(headers{i}));
            case 'string'
                % Do nothing
        end
    end
else % Attempt automatic conversion
    for i = 1 : size(dsobj, 2)
        if isnumeric(dsobj{1, i})
            dsobj.(headers{i}) = cell2mat(dsobj.(headers{i}));
        end
    end
end