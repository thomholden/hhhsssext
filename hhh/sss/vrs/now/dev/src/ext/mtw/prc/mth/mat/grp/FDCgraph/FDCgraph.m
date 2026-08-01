%------------------------------------------------------------------------
% Plot of a Graph representing a TROPHIC WEB.
% Author: Francisco de Castro. fdcastro@tld.net
% Uses function DRAWARROW from Kang Zhao, modified to accept colors.
% Requires functions: circle, nodes_circle, nodes_ntrof3
% In reciprocal relationships only one relationship is represented.
% Needs: Adjacency square matrix (a)
%			Type of graph: 'circle' or 'trofic'
%			Size of arrowhead (asize), Color of arrows (acol)
%			Size of nodes (csize), Color of nodes (ccol)
%			Background color (bckgcol)
%------------------------------------------------------------------------
function []= fdcgraph(a,ntype,asize,acol,csize,ccol,bckgcol)

%Tipo de dist. de nodos
switch ntype
	case 'circle', [xy]= nodes_circle(a); %Nodes in a circle
   case 'trofic', [xy]= nodes_ntrof3(a); %Nodes in 3 trophic levels
end

nsp= size(a,1);

figure ('Name','FDCgraph','NumberTitle','off','Menubar','none','Color',bckgcol)
hold on;

% Dibujo de los puntos
for i= 1:nsp 
   circle (xy(i,1),xy(i,2),csize,ccol)
   text(xy(i,1)-0.15,xy(i,2),num2str(i),'Color','w','FontWeight','bold')
end

%Eliminar reciproc. Solo se pinta predación
for i= 1:nsp 
   a(i,i:nsp)= 0;
end

%Dibujo de flechas
for i= 1:nsp
for j= 1:nsp
  	if a(i,j) ~= 0 
		x1= xy(j,1); y1= xy(j,2); x2= xy(i,1); y2= xy(i,2);
     	drawarrow(x1,x2,y1,y2,asize,acol);
	end
end
end

axis image; 
hold off;
axis off;

return
