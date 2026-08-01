function [registered,targetV,targetF]=nonrigidICP2(targetV,sourceV,targetF,sourceF,iterations)

% INPUT
% -target: vertices of target mesh; n*3 array of xyz coordinates
% -source: vertices of source mesh; n*3 array of xyz coordinates
% -Ft: faces of target mesh; n*3 array
% -Fs: faces of source mesh; n*3 array
% -iterations: number of iterations; usually between 20 en 100
% source and target should be close to equal size in vertices


% OUTPUT
% -registered: registered source vertices on target mesh. Faces are not affected and remain the same is before the registration (Fs). 

%EXAMPLE

% load EXAMPLE
% [registered]=nonrigidICP2(targetV,sourceV,targetF,sourceF,25)

tic
clf
%initial allignment and scaling
muT=mean(targetV);
targetV=targetV-repmat(muT,size(targetV,1),1);
[error1,sourceV,transform]=rigidICP(targetV,sourceV,0);

%plot of the meshes
h=trisurf(sourceF,sourceV(:,1),sourceV(:,2),sourceV(:,3),0.3,'Edgecolor','none');
hold
light
lighting phong;
set(gca, 'visible', 'off')
set(gcf,'Color',[1 1 0.88])
view(90,90)
set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
tttt=trisurf(targetF,targetV(:,1),targetV(:,2),targetV(:,3),'Facecolor','m','Edgecolor','none');
alpha(0.6)

[p]=size(sourceV,1);

% General deformation
kernel1=2:-(1/iterations):1;
kernel2=1.4:(0.6/iterations):2;
for i =1:iterations
    nrseedingpoints=round(10^(kernel2(1,i)));
   
%        define mutual closest points
    [IDXS,dS] = knnsearch(targetV,sourceV);
    [IDXT,dT] = knnsearch(sourceV,targetV);

    idx=unique(round((p-1)*rand(nrseedingpoints,1))+1);
    temp=sourceV(idx,:);
    [q]=size(idx,1);
    D = pdist2(sourceV,temp);
    
    gamma=1/(2*(mean(mean(D)))^kernel1(1,i));
    Datasetsource=vertcat(sourceV,sourceV(IDXT,:));

    Datasettarget=vertcat(targetV(IDXS,:),targetV);
    Datasetsource2=vertcat(D,D(IDXT,:));
    vectors=Datasettarget-Datasetsource;
    [r]=size(vectors,1);

    % define radial basis width for deformation points
   
    tempy1=exp(-gamma*(Datasetsource2.^2));

    tempy2=zeros(3*r,3*q);
    tempy2(1:r,1:q)=tempy1;
    tempy2(r+1:2*r,q+1:2*q)=tempy1;
    tempy2(2*r+1:3*r,2*q+1:3*q)=tempy1;

    %solve optimal deformation directions
    ppi=pinv(tempy2);
    modes=ppi*reshape(vectors,3*r,1);

    test=tempy2*modes;
    test=reshape(test,size(test,1)/3,3);
    %deforme source mesh
    sourceV=sourceV+test(1:size(sourceV,1),1:3);
    
     [error,sourceV,transform]=rigidICP(targetV,sourceV,1);
     delete(h)
     h=trisurf(sourceF,sourceV(:,1),sourceV(:,2),sourceV(:,3),'FaceColor','y','Edgecolor','none');
     alpha(0.6)
    pause (0.1)
    
end

% local deformation
p=size(sourceV,1);
arraymap = repmat(cell(1),p,1);
kk=12+iterations;
control=1;
[cutoff] = definecutoff( sourceV, sourceF );

while control>0
[targetV,targetF,control] = remesh( targetV, targetF,cutoff);
end
delete(tttt)
tttt=trisurf(targetF,targetV(:,1),targetV(:,2),targetV(:,3),'Facecolor','m','Edgecolor','none');



%define local mesh relation
for ddd=1:iterations
   k=kk-ddd;
tic
[IDXsource,Dsource]=knnsearch(sourceV,sourceV,'K',k);
[IDXtarget,Dtarget]=knnsearch(targetV,sourceV);
sumD=sum(Dsource,2);
sumD2=repmat(sumD,1,k);
sumD3=sumD2-Dsource;
sumD2=sumD2*(k-1);
weights=sumD3./sumD2;

for i=1:size(sourceV,1)
    sourceset=sourceV(IDXsource(i,:)',:);
    targetset=targetV(IDXtarget(IDXsource(i,:)',:),:);
    [d,z,arraymap{i,1}]=procrustes(targetset,sourceset,'scaling',0,'reflection',0);
       
end
for i=1:size(sourceV,1)
    for ggg=1:k
   sourceVtemp(ggg,:)=weights(i,ggg)*(arraymap{IDXsource(i,ggg),1}.b*sourceV(i,:)*arraymap{IDXsource(i,ggg),1}.T+arraymap{IDXsource(i,ggg),1}.c(1,:));
    end
    sourceV(i,:)=sum(sourceVtemp);
end
toc
     [error2,sourceV,transform]=rigidICP(targetV,sourceV,1);
     delete(h)
     h=trisurf(sourceF,sourceV(:,1),sourceV(:,2),sourceV(:,3),'FaceColor','y','Edgecolor','none');   
    pause (0.1)

end

registered=sourceV;
