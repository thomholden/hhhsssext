% This program runs the CSVconvert. It takes the current directory, browse
% the files, creates a string, and then have that string be the input of
% the CSVconvert() function.

clear namestring;
namestring = '';
directory = dir;
for (i = 1:length(directory))
    if (strfind(directory(i).name,'.csv') > 0)
        namestring = strcat(namestring,directory(i).name,'|'); 
    end
end
%namestring(length(namestring)) = [];
%namestring
length(strfind(namestring,'|'))
CSVconvert(namestring);