clear all
%   Read a mesh in NASTRAN ASCII format and save it in a *.mat file. 
FileName    = uigetfile('*.nas', 'Select the NASTRAN mesh file to open');
fileID      = fopen(FileName, 'r');

A = fscanf(fileID, '%49c', [49, inf]);
B = A';

%   Extract p, t arrays
P = []; t = [];
for m = 1:size(B, 1)
    Nodes = strfind(B(m, :), 'GRID');
    if ~isempty(Nodes)
        P = [P; str2num(B(m, 24:end))];
    end
    Tri  = strfind(B(m, :), 'CTRIA3');
    if ~isempty(Tri)
        t = [t; str2num(B(m, 24:end))];
    end
end

% Restore outer normals
normals = zeros(size(t)); 
for m = 1:length(t)
    Vertexes        = P(t(m, 1:3)', :)';
    r1              = Vertexes(:, 1);
    r2              = Vertexes(:, 2);
    r3              = Vertexes(:, 3);
    tempv           = cross(r2-r1, r3-r1);  %   clockwise normal
    temps           = sqrt(tempv(1)^2 + tempv(2)^2 + tempv(3)^2);
    normals(m, :)   = tempv/temps; 
end

fclose(fileID);

save(strcat(FileName(1:end-4), '.mat'), 'P', 't', 'normals');
