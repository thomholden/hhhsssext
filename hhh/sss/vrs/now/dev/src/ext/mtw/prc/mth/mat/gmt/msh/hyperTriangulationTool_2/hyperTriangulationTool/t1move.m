% switch an edge 
% 
%        4
%       / \
%      /   \ 
%    1/_____\2
%     \  k  /
%      \   /
%       \ /
%        3
% 
%        4
%       /|\
%      / | \ 
%    1/  |  \2
%     \  |  /
%      \ | /
%       \|/
%        3
%
function [edg,ou] = t1move(edg,k)
ou = 0;
ed = edg(k,:);
if ed(3)==ed(4) % check if 3 and 4 are the same vertex
    return
end
%T1 move
if ed(3)<ed(4)
    if ~any(edg(:,1)==ed(3)&edg(:,2)==ed(4)) % check if 3 and 4 are already conected
        edg(k,:)=[ed(3),ed(4),ed(2),ed(1)];
        ou = 1;
    end
else
    if ~any(edg(:,1)==ed(4)&edg(:,2)==ed(3)) % check if 3 and 4 are already conected
        edg(k,:)=[ed(4),ed(3),ed(1),ed(2)];   
        ou = 1;
    end
end
if ou==1
    if ed(1)<ed(4) 
        edg(edg(:,1)==ed(1)&edg(:,2)==ed(4),3)=ed(3);
    else
        edg(edg(:,1)==ed(4)&edg(:,2)==ed(1),4)=ed(3);
    end
    if ed(1)<ed(3) 
        edg(edg(:,1)==ed(1)&edg(:,2)==ed(3),4)=ed(4);
    else
        edg(edg(:,1)==ed(3)&edg(:,2)==ed(1),3)=ed(4);
    end
    if ed(2)<ed(4) 
        edg(edg(:,1)==ed(2)&edg(:,2)==ed(4),4)=ed(3);
    else
        edg(edg(:,1)==ed(4)&edg(:,2)==ed(2),3)=ed(3);
    end
    if ed(2)<ed(3) 
        edg(edg(:,1)==ed(2)&edg(:,2)==ed(3),3)=ed(4);
    else
        edg(edg(:,1)==ed(3)&edg(:,2)==ed(2),4)=ed(4);
    end    
end

% %%% k = find(((edg(:,1)==tri(1))+(edg(:,2)==tri(2)))==2 & ((edg(:,3)==tri(3))+(edg(:,4)==tri(3)))==1);
% %r0 = find(((edg(:,1)==tri(1)) & (edg(:,2)==tri(2)))|((edg(:,1)==tri(1)) & (edg(:,2)==tri(3)))|((edg(:,1)==tri(2)) & (edg(:,2)==tri(3)))|((edg(:,1)==tri(1)) & (edg(:,2)==tri(3))))
% % list of neighbours of 1,2,3,4 
% r1 = [find(edg(:,1)==ed(1));find(edg(:,2)==ed(1))];
% r2 = [find(edg(:,1)==ed(2));find(edg(:,2)==ed(2))];
% r3 = [find(edg(:,1)==ed(3));find(edg(:,2)==ed(3))];
% r4 = [find(edg(:,1)==ed(4));find(edg(:,2)==ed(4))];
% if any(edg(r3,2)==ed(4)) | any(edg(r4,2)==ed(3)) % check if 3 and 4 are already conected
%     return
% end
% %%%
% % edge 1-2
% k12  = k; 
% % edge 1-3
% if ed(3) > ed(1)
%     k13 = r1(edg(r1,2)==ed(3));
% else
%     k13 = r3(edg(r3,2)==ed(1));
% end
% % edge 2-3
% if ed(3) > ed(2)
%     k23 = r2(edg(r2,2)==ed(3));
% else
%     k23 = r3(edg(r3,2)==ed(2));
% end
% % edge 1-4
% if ed(4) > ed(1)
%     k14 = r1(edg(r1,2)==ed(4));
% else
%     k14 = r4(edg(r4,2)==ed(1));
% end
% % edge 2-4
% if ed(4) > ed(2)
%     k24 = r2(edg(r2,2)==ed(4));
% else
%     k24 = r4(edg(r4,2)==ed(2));
% end
% 
% if length(k12)~=1 | length(k13)~=1 | length(k14)~=1 | length(k23)~=1 | length(k24)~=1
%     ed 
%     k12
%     k13
%     k14
%     k23
%     k24
%     fprintf('somthing wrong\n')
%     return
% end
% 
% % T1 move
% old_edgs(1,:) = edg(k12,:);
% old_edgs(2,:) = edg(k13,:);
% old_edgs(3,:) = edg(k14,:);
% old_edgs(4,:) = edg(k23,:);
% old_edgs(5,:) = edg(k24,:);
% %
% if edg(k12,3)<edg(k12,4)
%     edg(k12,:)=edg(k12,[3,4,2,1]);
% else
%     edg(k12,:)=edg(k12,[4,3,1,2]);
% end
% %
% edg(k13,edg(k13,:)==old_edgs(1,2))=old_edgs(1,4);
% %
% edg(k14,edg(k14,:)==old_edgs(1,2))=old_edgs(1,3);
% %
% edg(k23,edg(k23,:)==old_edgs(1,1))=old_edgs(1,4);
% %
% edg(k24,edg(k24,:)==old_edgs(1,1))=old_edgs(1,3);
% %
% 
% % check
% % [edg(k13,2),edg(k13,3)]
% % [edg(k14,2),edg(k14,3)]
% % [edg(k23,2),edg(k23,3)]
% % [edg(k24,2),edg(k24,3)]
% % (edg(k13,2)==edg(k13,3))||(edg(k14,2)==edg(k14,3))||(edg(k23,2)==edg(k23,3))||(edg(k24,2)==edg(k24,3))
% if (edg(k13,2)==edg(k13,3))||(edg(k14,2)==edg(k14,3))||(edg(k23,2)==edg(k23,3))||(edg(k24,2)==edg(k24,3))
%     edg(k12,:) = old_edgs(1,:);
%     edg(k13,:) = old_edgs(2,:);
%     edg(k14,:) = old_edgs(3,:);
%     edg(k23,:) = old_edgs(4,:);
%     edg(k24,:) = old_edgs(5,:);
% else
%     ou = 1;
% end
% 
