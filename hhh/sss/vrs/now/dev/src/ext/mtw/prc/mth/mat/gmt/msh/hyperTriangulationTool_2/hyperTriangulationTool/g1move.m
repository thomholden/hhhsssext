% increases the genus by 1 with a G1 moves which insets 7 verrtices and 21
% edges
% lr is 3 (right) or 4 (left)
function [edg,N]=g1(edg,N,e,lr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% select the triangle [edg(k,1:2),edg(k,lr)];
k(1:7)=[(N+1):(N+7)]; %indeces of the seven new vertices
if lr == 3 %[B A C]
    B = edg(e,1);
    A = edg(e,2);
    C = edg(e,3);
    edg(e,3) = k(4); %[B A C ~]->[B A k4 ~]
else
    A = edg(e,1);
    B = edg(e,2);
    C = edg(e,4);
    edg(e,4) = k(4); %[A B ~ C]->[A B ~ k4]
end %[A B C]
if A<C
    edg(edg(:,1)==A & edg(:,2)==C,3)=k(1); %[A C B ~]->[A C k1 ~]
else
    edg(edg(:,1)==C & edg(:,2)==A,4)=k(1); %[C A ~ B]->[C A ~ k1]
end
if B<C
    edg(edg(:,1)==B & edg(:,2)==C,4)=k(6); %[B C ~ A]->[B C ~ k6]
else
    edg(edg(:,1)==C & edg(:,2)==B,3)=k(6); %[C B A ~]->[C B k6 ~]
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create new edges
edg(end+1,:)=[A k(4) B k(3)];
edg(end+1,:)=[B k(4) k(2) A];
%% triangle 2-3-4
edg(end+1,:)=[k(2) k(4) k(6) B];
edg(end+1,:)=[k(3) k(4) A k(7)];
edg(end+1,:)=[k(2) k(3) k(1) k(5)];
%%
edg(end+1,:)=[A k(3) k(4) k(1)];
edg(end+1,:)=[A k(1) k(3) C];
edg(end+1,:)=[C k(1) A k(7)];
edg(end+1,:)=[C k(7) k(1) k(6)];
edg(end+1,:)=[k(1) k(7) k(5) C];
edg(end+1,:)=[k(1) k(5) B k(7)];
%% triangle 5-6-7
edg(end+1,:)=[k(5) k(7) k(3) k(1)];
edg(end+1,:)=[k(5) k(6) B k(2)];
edg(end+1,:)=[k(6) k(7) C k(4)];
%%
edg(end+1,:)=[C k(6) k(7) B];
edg(end+1,:)=[B k(2) k(1) k(4)];
edg(end+1,:)=[B k(1) k(5) k(2)];
edg(end+1,:)=[B k(5) k(6) k(1)];
edg(end+1,:)=[B k(6) C k(5)];
edg(end+1,:)=[k(1) k(2) k(3) B];
edg(end+1,:)=[k(1) k(3) A k(2)];
%% tube
edg(end+1,:)=[k(2) k(5) k(3) k(6)];
edg(end+1,:)=[k(2) k(6) k(5) k(4)];
edg(end+1,:)=[k(4) k(6) k(2) k(7)];
edg(end+1,:)=[k(4) k(7) k(6) k(3)];
edg(end+1,:)=[k(3) k(7) k(4) k(5)];
edg(end+1,:)=[k(3) k(5) k(7) k(2)];
%%%%
%if sum(edg(:,4)==0)>0,edg,fprintf('somthing wrong!\n'),return,end
N = N+7;
%%%%



