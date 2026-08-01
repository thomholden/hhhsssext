% use Hooke attarction, Coulomb repulsion, and pressure to find the
% coordinates for the vertices of the triangulation
function xyz = expansion_xyz(edg,N,vertexList,xyz,maxLoop,parameters)

if nargin < 6
    kh  =0.01;
    qr  = 1;
    pres=0.1;
    damping = 0.5;
    if nargin < 5
        maxLoop = 1000;
        if nargin < 4
            xyz = rand(N,3);%start from random positions
        end
    end
elseif nargin >= 6
    kh  =parameters(1);
    qr  =parameters(2);
    pres=parameters(3);
    damping =parameters(4);  
end

v = zeros(N,3);
uniquetri = compute_triangles_list(edg,N);
A=compute_adjacency_matrix(edg,N);
[i,j]  = find(A);
[~, p] = sort(max(i,j));
i = i(p);
j = j(p);
tic
t=0;
nor = zeros(N,3);
while (t<maxLoop)
    t=t+1;
    for h=1:N
        pos = xyz(h,:);
        r = [pos(1)-xyz(:,1),pos(2)-xyz(:,2),pos(3)-xyz(:,3)];
        %%%%%% compute force %%%%%%
        f=[0 0 0];
        %pressure
        %% compute normals to vertex
        k = find(~isnan(vertexList(h,:)));
        c = xyz(h,:);
        rx = [xyz(vertexList(h,k),1)-c(1),xyz(vertexList(h,k),2)-c(2),xyz(vertexList(h,k),3)-c(3)];
        nx=sum(cross(rx(1:(end-1),:),rx(2:end,:)),1);
        nx = nx/sum(nx.^2)^.5;
        nor(h,:)=nx;
        f = pres*nor(h,:);
        %coulomb repulsion
        d2 = r(:,1).^2+r(:,2).^2+r(:,3).^2;
        fr = [r(:,1)./d2 r(:,2)./d2 r(:,3)./d2]; 
        fr(isnan(fr))=0;
        f = qr*sum(fr)+f;
        %Hooke attraction
        %k = find(A(h,:));
        f = f - kh*sum(r(A(h,:)~=0,:),1);
        %pause(0.5)
        %%%%%% new veocity %%%%%%
        v(h,:) = v(h,:)*damping + f;
        %%%%%% new position %%%%%%
        xyz(h,:) = pos + v(h,:);
    end
    %end 
    %visualize relaxation
    figure(100)
    clf
    patchDraw(xyz,uniquetri);
%     hold on
%     for h=1:N
%         nor = nor*1;
%         line([nor(h,1)+xyz(h,1) xyz(h,1)],[nor(h,2)+xyz(h,2) xyz(h,2)],[nor(h,3)+xyz(h,3) xyz(h,3)],'Color','r');
%     end
%     hold off
end


