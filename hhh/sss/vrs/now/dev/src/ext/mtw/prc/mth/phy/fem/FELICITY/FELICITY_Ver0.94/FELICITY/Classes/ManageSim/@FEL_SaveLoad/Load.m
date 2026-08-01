function Data_Struct = Load(obj,Index)
%Load
%
%   Load the data.
%
%   Data_Struct = obj.Load(Index);
%
%   Data_Struct = struct containing the stuff you want to load.
%
%   Index = index of filename to load.

% Copyright (c) 04-09-2014,  Shawn W. Walker

FileName = obj.Make_FileName(Index);
Data_Struct = load(FileName);

end