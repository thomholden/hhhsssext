function paths = getNonMatlabPaths()
%  This function returns a list of paths in the Matlab path variable, that
%  do not refer to Matlab directories.
remain = path;
paths = {};
while ~isempty(remain)
    [token, remain] = strtok(remain, ';');
    if isempty(strfind(token, '\MATLAB\'))
        paths = [paths token];
    end
end