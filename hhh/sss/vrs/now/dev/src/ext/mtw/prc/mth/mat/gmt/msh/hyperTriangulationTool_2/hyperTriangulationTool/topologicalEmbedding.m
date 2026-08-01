% compute the topological embedding
% i.e. make the ordered list for each face of the dual froth
% NOT WORKING !$/08/12!!!!!!!!!!
function [faceList,vertexList] = topologicalEmbedding(edg,N)
A=compute_adjacency_matrix(edg,N);
n_n=sum(A~=0,1);
[Bij,uniquetri]=compute_reciprocal_adijacency(edg,N);
faceList = nan(N,max(n_n));
for n=1:N
    [f,~]=find(uniquetri==n);
    of=f(1); % first element in the ordered faceList
    [~,i]=ismember(find(Bij(f(1),:)),f);
    i=i(i>0);
    of(2) = f(i(1)); % second element in the ordered faceList (this gives the direction)
    r=2;
    while length(of)<length(f)
        [~,i]=ismember(find(Bij(of(r),:)),f);
        i=i(i>0);
        of(r+1)=f(i(f(i)~=of(r-1))); % next element in the ordered faceList
        r = r+1;
    end
    faceList(n,1:length(of))=of;
end
% << up to here works fine 14/08/12
% orient the elements in the faceList i.e. topologically embed the network
A=compute_adjacency_matrix(edg,N);
orientedlist = zeros(N,1);
orientedlist(1)=1; %consider the first as correctly oriented all others not
nn0 = 1;
while any(orientedlist==0)
    [~,nn] = find(A(orientedlist==1,:)); 
    nn = unique(nn); %neighbours of oriented vertices
    nn = nn(orientedlist(nn)==0); %non-oriented neighbours
    for z=1:length(nn0) %go through the last shell
        for s=1:length(nn) %go through the new shell
            if orientedlist(nn(s))==0
                %look for unoriented neighours that share 2 consecutive vertices  
                l1 =faceList(nn(s),~isnan(faceList(nn(s),:)));%unoriented face
                l2 =faceList(nn0(z),~isnan(faceList(nn0(z),:)));%oriented face
                a = ismember(l1,l2); %do they share indices?
                if ~isempty(a)
                    i = find(a);
                    j = find(diff(i)==1,1); %consecutive memebers
                    l1o=l1;
                    if isempty(j)
                        if ~isempty(find(any(i==length(l1)) & any(i==1), 1)) %manage circularity
                            j =length(i);                       
                            l1 = [l1,l1(1)];
                            i(end+1)=length(l1);
                        end
                    end
                    if ~isempty(j) 
                        k12=l1(i([j,j+1])); %two consecutive neighbours of the oriented
                        a = ismember(l2,l1o);
                        i = find(a);
                        j = find(diff(i)==1,1); %detect consecutive
                        if isempty(j)
                            if ~isempty(find(any(i==length(l2)) & any(i==1), 1)) %manage circularity
                                j =length(i);                       
                                l2 = [l2,l2(1)];
                                i(end+1)=length(l2);
                            end
                        end
                        for m=1:2
                            k21=l2(i([j,j+1])); %two consecutive neighbours of the non-oriented
                            %[nn0(z) nn(s)]
                            if k21(1)==k12(1) && k21(2)==k12(2) %if same order
                                k = find(~isnan(faceList(nn(s),:)));
                                faceList(nn(s),k)=faceList(nn(s),k(end:-1:1)); %reverse faceList
                                orientedlist(nn(s))=1;
                                %fprintf('reverse %d\n',nn(s))
                                %[k21; k12]
                                break
                           elseif k21(1)==k12(2) && k21(2)==k12(1) %if opposite order
                                orientedlist(nn(s))=1;
                                %fprintf('keep %d\n',nn(s))
                                %[k21; k12]
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    nn0 = nn;
    %sum(orientedlist==1)
end
vertexList = nan(N,max(n_n));
for n=1:size(faceList,1)
    f=faceList(n,~isnan(faceList(n,:)));
    v0 =  uniquetri(f(1),:);
    v0 = v0(find(v0~=n));
    v1 = v0;
    vv=[];
    for m=2:length(f)
        v2 = uniquetri(f(m),:);
        v2 = v2(find(v2~=n));
        vv=[vv,intersect(v1,v2)];
        v1=v2;
    end
    vertexList(n,1:(length(vv)+1))=[vv,intersect(v0,v1)];
end
        
        