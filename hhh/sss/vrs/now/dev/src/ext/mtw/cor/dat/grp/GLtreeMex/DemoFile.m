%%Gltree bidimensional demo project;

%Select the number of reference and query point, the points set and run the
%project

%point sets to select with mode

%   -1 uniform distrubution
%   -2 boundary spread dataset
%   -3  corners dataset
%   -4  points gathered on centre
clc
clear all
close all

%% INPUT
N=1000;%Number of reference points
Nq=1000;%Number of query points
mode=4;%point disposition mode




%% random generation
switch mode
    case 1  %uniform dataset

          px=rand(N,1);
          py=rand(N,1);
     case 2  %boundary spread dataset
        px=zeros(N,1);
        py=zeros(N,1);
        i=1;
        while i<=N
            px(i)=rand(1,1);
             py(i)=rand(1,1);
            if (px(i)<.1 || px(i)>.9 || py(i)<.1 || py(i)>.9)
                i=i+1;
            end
        end
           
          
    case 3  %corners dataset
        px=zeros(N,1);
        py=zeros(N,1);
        i=1;
        while i<=N
            px(i)=rand(1,1);
            if (px(i)<.1 || px(i)>.9)
                i=i+1;
            end
        end
        i=1;
        while i<=N
            py(i)=rand(1,1);
            if (py(i)<.1 || py(i)>.9)
                i=i+1;
            end
        end
            
    case 4 %points gathered on centre
        
        px=zeros(N,1);
        py=zeros(N,1);
        i=1;
        while i<=N
            px(i)=rand(1,1);
             py(i)=rand(1,1);
            if (px(i)<.6 && px(i)>.4 && py(i)<.6 && py(i)>.4)
                i=i+1;
            end
        end
    otherwise
        error('unvalid point disposition mode')
end
qpx=rand(Nq,1);
qpy=rand(Nq,1);

%% plot points
figure(1)
hold on
axis equal
plot(px,py,'b.');
plot(qpx,qpy,'r.');
 legend('Reference points','Query points');
 title('Points disposition');



%% Perform Search
fprintf('\n\n Start Search!\n\n')
%% GLtree
tic
resultsGL=GLtreeMex(px,py,qpx,qpy);
GLtime=toc;
fprintf('GLtree took: %g s\n', GLtime);
resultsGL=int32(resultsGL);%save memory

%% Kdtree
tic
[foo, foo, TreeRoot] = kdtree( [px,py], []);
[ resultsKd, foo, TreeRoot ] = kdtreeidx([], [qpx,qpy], ...
						  TreeRoot);
Kdtime=toc;
fprintf('Kdtree took: %g s\n', Kdtime);
clear foo TreeRoot
resultsKd=int32(resultsKd);%save memory

%% ANN(kd-tree)
tic
resultsANNkd = annquery([px,py]',[qpx,qpy]', 1);
ANNtimekd=toc;
fprintf('ANN took: %g s\n', ANNtimekd);
resultsANNkd=int32(resultsANNkd);%save memory
%% ANN(bd-tree)
tic
resultsANNbd = annquery([px,py]',[qpx,qpy]', 1,'use_bdtree', true);
ANNtimebd=toc;
fprintf('ANN bd-tree took: %g s\n', ANNtimebd);
resultsANNbd=int32(resultsANNbd);%save memory
% 


%% check results
errorsGL=0;
errorsKd=0;
errorsANNkd=0;


for i=1:Nq
    if not(resultsGL(i)==resultsKd(i) && resultsKd(i)==resultsANNkd(i) ...
            && resultsGL(i)==resultsANNkd(i) )%we miss when they are all wrong but this is  unprobably
        warning('error found!');
        i1=resultsGL(i);
        i2=resultsKd(i);
        i3=resultsANN(i);
        dist1=(px(i1)-qpx(i))^2+(py(i1)-qpy(i))^2;
        dist2=(px(i1)-qpx(i))^2+(py(i1)-qpy(i))^2;
        dist3=(px(i1)-qpx(i))^2+(py(i1)-qpy(i))^2;
        mindist=min((px-qpx(i)).^2+(py-qpy(i)).^2);%brute search
        if not(dist1==mindist)
            errorsGL=errorsGL+1;
        end
        if not(dist2==mindist)
            errorsKd=errorsKd+1;
        end
        if not(dist3==mindist)
            errorsANN=errorsANN+1;
        end
    end
end
fprintf('\n\nErrors Check:\n');
fprintf('GLtree made %4.0f errors\n',errorsGL);
fprintf('Kdtree made %4.0f errors\n',errorsKd);
fprintf('ANN made %4.0f errors\n',errorsANNkd);



%% Time results
[foo,winner]=min([GLtime,Kdtime,ANNtimekd,ANNtimebd]);
fprintf('\n\nRelative Time Comparison:\n');
switch winner
    case 1
        fprintf('Gltree is:\n %4.4f times faster than Kdtree \n %4.4f faster than ANNkd\n %4.4f faster than ANNbd\n',Kdtime/GLtime,ANNtimekd/GLtime,ANNtimebd/GLtime);
    case 2
        fprintf('Kdtree is:\n %4.4f times faster than GLtree \n %4.4f faster than ANNkd\n %4.4f faster than ANNbd\n',GLtime/Kdtime,ANNtimekd/Kdtime,ANNtimebd/Kdtime);
    case 3
        fprintf('ANNkd is:\n %4.4f times faster than Kdtree \n %4.4f faster than GLtree\n %4.4f faster than ANNbd\n',Kdtime/ANNtimekd,GLtime/ANNtimekd,ANNtimebd/ANNtimekd);
    case 4
        fprintf('ANNbd is:\n %4.4f times faster than Kdtree \n %4.4f faster than GLtree\n and %4.4f faster than ANNkd\n ',Kdtime/ANNtimebd,GLtime/ANNtimebd,GLtime/ANNtimebd);

end







        