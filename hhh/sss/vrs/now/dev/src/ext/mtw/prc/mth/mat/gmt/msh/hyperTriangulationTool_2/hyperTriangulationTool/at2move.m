%             3
%            / \
%           / | \
%          /  |  \
%         /  /j\  \
%        / /     \ \
%      1 -----------  2
%
% removes a 3-conected vertex
%
%             3
%            / \
%           /   \
%          /     \
%         /       \
%        /         \
%      1 -----------  2
%
%
function [edg,ou,N]=at2move(edg,N,j) 
% g = (1-(N-size(edg,1)/3)/2); %genus (to verify later)
if size(edg,1)>6
        %find neighbours of j
    nn_j = find(edg(:,1)==j | edg(:,2)==j);
    ou1 = 1;
    % execute T1s to reduce degree of j to 3
    while length(nn_j)>3 | ou1 == 0  
        [edg,ou1] = t1move(edg,nn_j(floor(rand*length(nn_j)+1)));
        if ou1==0
            ou=0;
            return
        end
        nn_j=find(edg(:,1)==j | edg(:,2)==j); %neighbours of j
    end
    %choose 1 edge at random among the 3 connected to j
    ed = edg(nn_j(floor(rand*length(nn_j)+1)),:); 
    % first, second and third
    if ed(1) == j
        jj(1)  = ed(2);
        jj(3)  = ed(3);
        jj(2)  = ed(4);
    elseif ed(2) == j
        jj(1)  = ed(1);
        jj(2)  = ed(3);
        jj(3)  = ed(4);
    else
        fprintf('somthing wrong in at2move')
    end
    jj([4,5,6])=jj([1,2,3]); %repeat it twice
    for ii=1:3
        % go through the three edges 1-2,2-3,3-1
        if jj(ii) < jj(ii+1)
            kk = find(edg(:,1)==jj(ii) & edg(:,2)==jj(ii+1));
            edg(kk,4)=jj(ii+2);
        else
            kk = find(edg(:,1)==jj(ii+1) & edg(:,2)==jj(ii));
            edg(kk,3)=jj(ii+2); %<<< 3?
        end        
    end
    % remove edges
    edg = edg(setdiff([1:size(edg,1)],nn_j),:);

    %%%%%%%%%test%%%%%%%%%%%%%%
    if any([edg(:,1);edg(:,2)]==j)
        fprintf('at2move: j-nn_j not removed')
    end
    if any(any(edg==j))
        fprintf('at2move: j lr not removed')
    end    
    %%%%%%%%%%%%%%
    % re-index nodes
    r_a([1:(j-1),(j+1):N])=[1:(N-1)];
    edg = r_a(edg);
    %%%%%%%%%%%%%%
    ou = 1;
    N  = N-1;
else
    ou=0;
end
% if (1-(N-size(edg,1)/3)/2)~=g
%             fprintf('at2move changed genus!\n g=%d\n',1-(N-size(edg,1)/3)/2)
% end

