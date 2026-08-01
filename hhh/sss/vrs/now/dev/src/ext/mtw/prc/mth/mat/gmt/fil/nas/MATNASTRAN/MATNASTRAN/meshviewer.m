clear all
%   Plot a triangular mesh: edges, curvature, outer normals
FileName = uigetfile('*.mat','Select the NASTRAN mesh file to open');
S = load(FileName, '-mat');
P = S.P; t = S.t; normals = S. normals;

a = figure; 
patch('Faces', t, 'Vertices', P, 'FaceColor', [1 0.75 0.65], 'EdgeColor', 'k', 'FaceAlpha', 1.0);
axis 'equal';    axis 'tight', set(gca, 'YDir','normal');
xlabel('x, m'); ylabel('y, m'); view(-9, 19); grid on;

b = figure;
X = reshape(P(t(:, 1:3)', 1)', [3, size(t, 1)]);
Y = reshape(P(t(:, 1:3)', 2)', [3, size(t, 1)]);
Z = reshape(P(t(:, 1:3)', 3)', [3, size(t, 1)]);
patch(X, Y, Z, [1 0.75 0.65], 'EdgeColor', 'none', 'FaceAlpha', 1.0);
axis 'equal';    axis 'tight', set(gca, 'YDir','normal');
xlabel('x, m'); ylabel('y, m'); view(-9, 19); grid on;
light('Position',[1 3 2]); light('Position',[-3 -1 3]); material shiny; 

c = figure
patch(X, Y, Z, [1 0.75 0.65], 'EdgeColor', 'none', 'FaceAlpha', 1.0);
    hold on;
    Center = (P(t(:, 1),:)+P(t(:, 2),:)+P(t(:, 3),:))/3;
    quiver3(Center(:,1),Center(:,2),Center(:,3), ...
         normals(:,1),normals(:,2),normals(:,3), 0.7, 'color','r');
axis 'equal';    axis 'tight', set(gca, 'YDir','normal');
xlabel('x, m'); ylabel('y, m'); view(-9, 19); grid on;
light('Position',[1 3 2]); light('Position',[-3 -1 3]); material shiny; 

str.Nodes       = size(P, 1);
str.Triangles   = size(t, 1);
str.SizeX       = max(P(:, 1)) - min(P(:, 1));  
str.SizeY       = max(P(:, 2)) - min(P(:, 2));
str.SizeZ       = max(P(:, 3)) - min(P(:, 3));
str

