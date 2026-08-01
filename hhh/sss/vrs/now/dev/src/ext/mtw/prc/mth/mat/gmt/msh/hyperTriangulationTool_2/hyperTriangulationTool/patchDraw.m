%draw embedded networks (not only triangulations)
function p=patchDraw(verts,faces,col,ax,al)
if nargin < 5
    al = 0.8;
    if nargin < 4
        ax = 'off';
        if nargin < 3
            col = [0  1  1]; 
        end
    end
end
% verts = xyz positions Nx3 matrix
% faces = i1 i2 i3 i4 ... face indices i.e. uniquetri for triangulation
set(gcf,'Renderer','OpenGL');
p = patch('Faces',faces,'Vertices',verts);
set(p,'FaceColor',col,'FaceAlpha',al);
set(p,'EdgeColor',col*.4,'LineWidth',2,'EdgeAlpha',1);
view(3); 
axis square
box on
axis tight
camproj perspective; 
if strmatch(ax,'on', 'exact')
    set(gca,'XTickLabel',[],'YTickLabel',[],'ZTickLabel',[])
    set(gca,'XTick',[],'YTick',[],'ZTick',[])
end