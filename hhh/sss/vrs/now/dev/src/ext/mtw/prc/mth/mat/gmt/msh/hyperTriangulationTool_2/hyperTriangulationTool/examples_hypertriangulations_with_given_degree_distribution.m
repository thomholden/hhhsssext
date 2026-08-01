% generation hyper triangulations withgiven degree distribution
% by using two cases: power law and normal distributions.

clear
tx=tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% power law reference degree distribution
z0=[3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,...
    4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6,6,...
    7,7,7,8,8,8,9,10,10,11,12,13,13,15,17,18,23,26,30,40]';
[zF,edg,N,g,M,en,en1] =  configurational_model_hypertriang(z0,10);
%%%%%%% analyze results %%%%
z = full(sum(compute_adjacency_matrix(edg,N),2));
figure
[a,b]=hist(z0,[0:max([z0;z])]);
plot(b,a,'-+r')
hold on
[a,b]=hist(z,[0:max([z0;z])]);
plot(b,a,'-ob')
set(gca,'xscale','log','yscale','log')
title('comparison between degree distributions Power law case')
legend({'reference net','hypertriangulation'})
drawnow

fprintf('%0.2f per-cent of vertices have degree withn +- 1 from reference\n',sum(abs(z-z0)<=1)/length(z0)*100)
fprintf('final energy = %0.2f ratio with initial %.2f per-cent\n\n',en(1)/N,en(end)/en(1)*100)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% normal distribution
N0  = 200; %number of vertices;
sig = 2; % standard deviation 
mu  = 7;% mean 
z0  = abs(floor(randn(N0,1)*sig+mu));
g = 2; % genus of the surface
[zF,edg,N,g,M,en,en1] =  configurational_model_hypertriang(z0,10,g);
toc(tx)
%%%%%%% analyze results %%%%
z = full(sum(compute_adjacency_matrix(edg,N),2));

figure
[a,b]=hist(z0,[0:max([z0;z])]);
plot(b,a,'-+r')
hold on
[a,b]=hist(z,[0:max([z0;z])]);
plot(b,a,'-ob')
set(gca,'xscale','log','yscale','log')
title('comparison between degree distributions Normal case')
legend({'reference net','hypertriangulation'})
drawnow

fprintf('%0.2f per-cent of vertices have degree withn +- 1 from reference\n',sum(abs(z-z0)<=1)/length(z0)*100)
fprintf('final energy = %0.2f ratio with initial %.2f per-cent\n\n',en(1)/N,en(end)/en(1)*100)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%computes the embedding and the dual network
[faceList,vertexList] = topologicalEmbedding(edg,N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compute coordinates and visualize triangulation
xyz = randn(N,3)*N^(1/3);
xyz = expansion_xyz(edg,N,vertexList,xyz,300, [0.01 0.001 0.005 0.9]);
close 100
uniquetri = compute_triangles_list(edg,N);
figure
p=patchDraw(xyz,uniquetri,[0  1  1],'off',0.7);
set(gca,'visible','off','box','off')
for t=1:360;rotate(p,[mod(t/100,1) 1 mod(t/100,1)],10),pause(0.1);end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compute coordinates and visualize dual network (froth)
V=size(edg,1)*2/3;
for n=1:V
    xyzF(n,:) = sum(xyz(uniquetri(n,:),:),1)/3;
end
figure
p=patchDraw(xyzF,faceList,[1  0.77  0.66],'off');
lighting gouraud
camlight left
set(gca,'visible','off','box','off')
for t=1:360;rotate(p,[mod(t/100,1) 1 mod(t/100,1)],10),pause(0.1);end


