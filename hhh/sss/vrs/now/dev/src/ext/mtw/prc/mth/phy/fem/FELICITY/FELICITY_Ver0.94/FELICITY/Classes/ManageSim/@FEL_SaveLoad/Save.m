function Save(obj,Data_Obj,Index)
%Save
%
%   Save the data.
%
%   obj.Save(Data_Obj,Index);
%
%   Data_Obj = struct (or object) containing the stuff you want to save.
%   Index    = index of filename to save it under.

% Copyright (c) 04-09-2014,  Shawn W. Walker

FileName = obj.Make_FileName(Index);
NAMES = fieldnames(Data_Obj);
Data_Struct = [];
for ind = 1:length(NAMES)
    Data_Struct.(NAMES{ind}) = Data_Obj.(NAMES{ind});
end
save(FileName, '-struct', 'Data_Struct');

end