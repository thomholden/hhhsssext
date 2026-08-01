function Delete_Data(obj)
%Delete_Data
%
%   Delete all of the files in the obj.Data_Dir directory.
%
%   obj.Delete_Data();

% Copyright (c) 04-09-2014,  Shawn W. Walker

File_Del = FELtest('Clear out old data');
File_Del.Delete_Files_In_Dir(obj.Data_Dir);

end