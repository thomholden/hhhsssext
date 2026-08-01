% insert a new vertex inside the existing triangle:  [edg(k,1:2),edg(k,lr)]
%
%             3
%            / \
%           /   \
%          /     \
%         /       \
%        /         \
%      1 -----------  2
%
%             3
%            /|\
%           / | \
%          /  |  \
%         /  / \  \
%        / /     \ \
%      1 -----------  2
%
% lr is 3 (right) or 4 (left)
%
function [edg,N]=t2move(edg,N,k,lr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tri = [edg(k,1:2),edg(k,lr)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% k = find(((edg(:,1)==tri(1))+(edg(:,2)==tri(2)))==2 & ((edg(:,3)==tri(3))+(edg(:,4)==tri(3)))==1);
%r0 = find(((edg(:,1)==tri(1)) & (edg(:,2)==tri(2)))|((edg(:,1)==tri(1)) & (edg(:,2)==tri(3)))|((edg(:,1)==tri(2)) & (edg(:,2)==tri(3)))|((edg(:,1)==tri(1)) & (edg(:,2)==tri(3))))
% r1 = find(edg(:,1)==tri(1));
% k  = r1(edg(r1,2)==tri(2));
% if isempty(k)
%     warning('error in T2: cannot find triangle')
%     return
% end
% length(k)  % must be 1
%%%%
% k=find(all(((edg(:,1:2)==tri(1)) + (edg(:,1:2)==tri(2)) + (edg(:,1:2)==tri(3)))'));
% length(k)  % must be 3
% k = k(1);
%%%%
%[x,ou]=setxor(edg(k,:),tri); %find the elemet not in the triangle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if lr == 3
    in = edg(k,3);
    edg(k,3)=N+1;
    edg(end+1,1:4)=[edg(k,2) N+1 edg(k,1) in];
    edg(end+1,1:4)=[edg(k,1) N+1 in edg(k,2)];
    edg(end+1,1:4)=[in N+1 edg(k,2) edg(k,1)];
    if edg(k,1) < in
        edg((edg(:,1)==edg(k,1))&(edg(:,2)==in),4)=N+1;
    else
        edg((edg(:,1)==in)&(edg(:,2)==edg(k,1)),3)=N+1;        
    end
    if edg(k,2) < in
        edg((edg(:,1)==edg(k,2))&(edg(:,2)==in),3)=N+1;
    else
        edg((edg(:,1)==in)&(edg(:,2)==edg(k,2)),4)=N+1;        
    end
else
    in = edg(k,4);
    edg(k,4)=N+1;
    edg(end+1,1:4)=[edg(k,2) N+1 in edg(k,1)];
    edg(end+1,1:4)=[edg(k,1) N+1 edg(k,2) in];
    edg(end+1,1:4)=[in N+1 edg(k,1) edg(k,2)];
    %%%%
    if edg(k,1) < in
        edg((edg(:,1)==edg(k,1))&(edg(:,2)==in),3)=N+1;
    else
        edg((edg(:,1)==in)&(edg(:,2)==edg(k,1)),4)=N+1;        
    end
    if edg(k,2) < in
        edg((edg(:,1)==edg(k,2))&(edg(:,2)==in),4)=N+1;
    else
        edg((edg(:,1)==in)&(edg(:,2)==edg(k,2)),3)=N+1;        
    end    
end
%%%%
N = N+1;
%%%%



