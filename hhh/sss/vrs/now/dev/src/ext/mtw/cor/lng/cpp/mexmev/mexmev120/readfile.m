function [str] = readfile(location)
    %[str] = readfile(location)
    %Read the contents of a file as a string
    h = fopen(location,'r');
    str = fread(h,Inf,'char=>char')';
    fclose(h);
end