function [Bij,uniquetri]=compute_reciprocal_adijacency(edg,N)
uniquetri = compute_triangles_list(edg,N);
V=size(edg,1)*2/3;  % [V,size(uniquetri,1)]
Bij = sparse(V,V);
for v=1:V %go through the list of triangles
    t=find((sum((edg(:,[1 2])==uniquetri(v,1))+(edg(:,[1 2])==uniquetri(v,2))+(edg(:,[1 2])==uniquetri(v,3)),2)==2)&(sum((edg==uniquetri(v,1))+(edg==uniquetri(v,2))+(edg==uniquetri(v,3)),2)==3));
    if length(t)~=3,fprintf('Somthing wrong, triangele has %d neighbours!\n',length(t)),uniquetri(v,:),edg(t,:),return,end
    for n=1:3 %3 neighbours of t
        k=setdiff(edg(t(n),:),uniquetri(v,:));
        t1 = sort(edg(t(n),[1:2 find(edg(t(n),:)==k)]));
        Bij(v,find((uniquetri(:,1)==t1(1))&(uniquetri(:,2)==t1(2))&(uniquetri(:,3)==t1(3))))=1;
    end
end
