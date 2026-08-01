function [vnew,fnew,control] = remesh( vold, fold, cutoff )

fk1 = fold(:,1);
fk2 = fold(:,2);
fk3 = fold(:,3);

numverts = size(vold,1);
numfaces = size(fold,1);

D1=sqrt(sum((vold(fk1,:)-vold(fk2,:)).^2,2));
D2=sqrt(sum((vold(fk1,:)-vold(fk3,:)).^2,2));
D3=(1:size(D2,1))';

D1=horzcat(D1,D3);
D2=horzcat(D2,D3);

D1=D1(D1(:,1)>cutoff,:);
D2=D2(D2(:,1)>cutoff,:);

Indices=unique(vertcat(D1(:,2),D2(:,2)));
control=size(Indices,1);

    m1x = (vold( fk1(Indices,1),1) + vold( fk2(Indices,1),1) )/2;
    m1y = (vold( fk1(Indices,1),2) + vold( fk2(Indices,1),2) )/2;
    m1z = (vold( fk1(Indices,1),3) + vold( fk2(Indices,1),3) )/2;
    
    m2x = (vold( fk2(Indices,1),1) + vold( fk3(Indices,1),1) )/2;
    m2y = (vold( fk2(Indices,1),2) + vold( fk3(Indices,1),2) )/2;
    m2z = (vold( fk2(Indices,1),3) + vold( fk3(Indices,1),3) )/2;
    
    m3x = (vold( fk3(Indices,1),1) + vold( fk1(Indices,1),1) )/2;
    m3y = (vold( fk3(Indices,1),2) + vold( fk1(Indices,1),2) )/2;
    m3z = (vold( fk3(Indices,1),3) + vold( fk1(Indices,1),3) )/2;


vnewtemp = [ [m1x m1y m1z]; [m2x m2y m2z]; [m3x m3y m3z] ];
[vnewtemp_ ii jj] = unique(vnewtemp, 'rows' );

m1 = jj(1:control)+numverts;
m2 = jj(control+1:2*control)+numverts;
m3 = jj(2*control+1:3*control)+numverts;

tri1 = [fk1(Indices) m1 m3];
tri2 = [fk2(Indices) m2 m1];
tri3 = [ m1 m2 m3];
tri4 = [m2 fk3(Indices) m3];
fk1(Indices)=[];
fk2(Indices)=[];
fk3(Indices)=[];

tri5=[fk1 fk2 fk3];
clear m1 m2 m3 fk1 fk2 fk3
 
vnew = [vold; vnewtemp_]; % the new vertices
fnew = [tri5; tri1; tri2; tri3; tri4]; % the new faces
 






