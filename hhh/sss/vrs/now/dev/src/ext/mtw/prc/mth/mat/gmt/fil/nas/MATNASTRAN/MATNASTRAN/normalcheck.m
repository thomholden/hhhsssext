clear all
%   Check if the outer normal vectors follow the right-hand rule
%   If they do not, rearrange vertices accordingly
FileName = uigetfile('*.mat','Select the MATLAB mesh file to open');
S = load(FileName, '-mat');
P = S.P; t = S.t; normals = S.normals;

ind = 0;
for m = 1:length(t)
    Vertexes        = P(t(m, 1:3)', :)';
    r1              = Vertexes(:, 1);
    r2              = Vertexes(:, 2);
    r3              = Vertexes(:, 3);
    tempv           = cross(r2-r1, r3-r1);  %   definition (*)
    temps           = sqrt(tempv(1)^2 + tempv(2)^2 + tempv(3)^2);
    normalscheck     = tempv'/temps;
    if sum(normalscheck.*normals(m, :))<0;   %   rearrange vertices to have exactly the outer normal
        t(m, 2:3) = t(m, 3:-1:2);            %   by definition (*)
        ind = ind + 1;
    end
end
save(FileName, 'P', 't', 'normals');
ind
