function [fName] = openFile

global fName st hFname hStat bGoOnOptimizing 

[fname,pname] = uigetfile('*.txt','Choose the file to read')
if (isa(fname,'char') == 0)
    return;
end

fName = strcat(pname,fname);
st = readMetastockFile (fName);

set (hFname, 'String', fName);
