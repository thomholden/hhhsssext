clear all
%   Read a MATLAB mesh and save it in ASCII NASTRAN format - a *.nas file. 
FileName = uigetfile('*.mat','Select the MATLAB mesh file to open');
S = load(FileName, '-mat');
P = S.P; t = S.t; normals = S. normals;

fileID = fopen(strcat(FileName(1:end-4), '.nas'), 'w');

for m = 1:size(P, 1)
    fprintf(fileID, '%-8s%-8s%-8s%8s%8s%8s\n', 'GRID', num2str(m, 5), '', ...
    num2str(P(m, 1), '%6.4f'), num2str(P(m, 2), '%6.4f'), num2str(P(m, 3), '%6.4f'));
end
for m = 1:size(t, 1)
     fprintf(fileID, '%-8s%-8s%-8s%8s%8s%8s\n', 'CTRIA3', num2str(m, 5), '1', ...
     num2str(t(m, 1), '%6d'), num2str(t(m, 2), '%6d'), num2str(t(m, 3), '%6d'));   
end

fclose(fileID);
