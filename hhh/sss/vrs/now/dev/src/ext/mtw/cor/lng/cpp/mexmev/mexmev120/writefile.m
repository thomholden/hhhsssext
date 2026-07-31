function [] = writefile(location,str)
    %writefile(location,str)
    %Writes a string to a file
    h = fopen(location,'w');
    fwrite(h,str);
    fclose(h);
end