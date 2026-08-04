function [w,gamma, trainCorr, testCorr, cpu_time, nu, mu]=n_psvm(A,d,rr,k,nu,mu,output,bal);
% version 1.1
% last revision: 01/24/03
%==========================================================================================
% Usage:    [w,gamma,trainCorr, testCorr,cpu_time,nu, mu]=n_psvm(A,d,rr,k,nu,mu,output,bal)
%
% A and d are both required, everything else has a default
% An example: [w gamma train test time nu] = n_psvm(A,d,0.5,10);
%
% Input:
% A is a matrix containing m data in n dimensions each.
% d is a m dimensional vector of 1's or -1's containing
% the corresponding labels for each example in A.
% rr: reduce rate, default is 100% -> not reduced
% k is k-fold for correctness purpose
% nu - the weighting factor.
%                       -1 - easy estimation
%                       0  - hard estimation
%                       any other value - used as nu by the algorithm
%                       default - 0
%    mu:    mu in calculating kernel, 0 means take the default estimation
% output - indicates whether you want output
%
% If the input parameter bal is 1
% the algorithm weighs the classes depending on the
% number of points in each class and balance them. 
% It is useful when  the number of point in each class
% is very unbalanced.
%
% Output:
% w,gamma are the values defining the separating
% Hyperplane w'x-gamma=0 such that:
%
% w'x-gamma>0 => x belongs to A+
% w'x-gamma<0  => x belongs to A-
% w'x-gamma=0 => x can belongs to both classes
% nu - the estimated or specified value of nu
%
% For details refer to the paper:
% "Proximal Support Vector Machine Classifiers"
% available at: www.cs.wisc.edu/~gfung
% For questions or suggestions, please email:
% Glenn Fung, gfung@cs.wisc.edu
% Sept 2001.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n]=size(A);
r=randperm(size(d,1));d=d(r,:);A=A(r,:);    % random permutation

%move one point in A a little if perfectly balanced
AA=A;dd=d;
ma=A(find(d==1),:); mb=A(find(d==-1),:);
[s1 s2]=size(ma);
     c1=sum(ma)/s1;
[s1 s2]=size(mb);
     c2=sum(mb)/s1;
if (c1==c2)
     nu=1;
     A(3,:)=A(3,:)+0.01*norm(A(3,:)-c1,inf)*ones(1,n);
end

% default values for input parameters
if nargin<8
   bal=0;
end 

if nargin<7
   output=0;
end

if nargin<6
mu=EstMu(A,d);
end

if ((nargin<5)|(nu==0))
nu = EstNuLong(A,d,m);  % default is hard estimation
elseif nu==-1  % easy estimation
nu = EstNuShort(A,d);
end

if (nargin<4)
     k=0;
end

if (nargin<3)
rr=1;
end

[H,v]=HV(A,d,bal);  % calculate H and v

trainCorr = 0;
testCorr = 0;

if (nu==0)
  nu = EstNuLong(H,d,m);
elseif nu==-1  % easy estimation
  nu = EstNuShort(H,d);
end

% if k=0 no correctness is calculated, just run the algorithm
if k==0
  A = calcKer(A,rr,mu,output);
  [H,v]=HV(A,d,bal);  
  tic;
  [w, gamma] = core(H,v,nu);
  cpu_time = toc;
  fprintf(1,'\nElapsed time: %10.2f\n\n',cpu_time);
  return
end

%if k==1 only training set correctness is calculated
if k==1
[kA,Abar] = calcKer(A,rr,mu,output);
tic;
[H,v]=HV(kA,d,bal);
  [w, gamma] = core(H,v,nu);
  trainCorr = correctness(A,Abar,d,w,gamma,mu);
  cpu_time = toc;
  if output == 1
  fprintf(1,'\nTraining set correctness: %3.2f%% \n',trainCorr);
  fprintf(1,'\nElapse time: %10.2f\n',toc);
  end
  return
end

%% if k= folds

  accuIter = 0;
cpu_time = 0;
indx = [0:k];
indx = floor(m*indx/k);    %last row numbers for all 'segments'
% split trainining set from test set
for i = 1:k
Ctest = []; dtest = [];Ctrain = []; dtrain = [];

Ctest = A((indx(i)+1:indx(i+1)),:);
dtest = d(indx(i)+1:indx(i+1));

Ctrain = A(1:indx(i),:);
Ctrain = [Ctrain;A(indx(i+1)+1:m,:)];
dtrain = [d(1:indx(i));d(indx(i+1)+1:m,:)];

[kCtrain,Abar] = calcKer(Ctrain,rr,mu,output);
tic;
[H, v] = HV(kCtrain,dtrain,bal);
[w, gamma] = core(H,v,nu);
thisToc = toc;

tmpTrainCorr = correctness(Ctrain,Abar,dtrain,w,gamma,mu);
tmpTestCorr = correctness(Ctest,Abar,dtest,w,gamma,mu);

 if output==1
 fprintf(1,'________________________________________________\n');
 fprintf(1,'Fold %d\n',i);
 fprintf(1,'Training set correctness: %3.2f%%\n',tmpTrainCorr);
 fprintf(1,'Testing set correctness: %3.2f%%\n',tmpTestCorr);    
 fprintf(1,'Elapse time: %10.2f\n',thisToc);
 end

 trainCorr = trainCorr + tmpTrainCorr;
testCorr = testCorr + tmpTestCorr;
cpu_time = cpu_time + thisToc;

 end % end of for (looping through test sets)

 trainCorr = trainCorr/k;
 testCorr = testCorr/k;
 cpu_time = cpu_time/k;

if output == 1
  fprintf(1,'___________________________________________________\n');
  fprintf(1,'\nAverage training set correctness: %3.2f%% \n',trainCorr);
  fprintf(1,'\nAverage testing set correctness: %3.2f%% \n',testCorr);
  fprintf(1,'\nAverage CPU time is: %3.2f \n',cpu_time);
end

return

%%%%%%%%%%%%%%%% core function to calcuate w and gamma %%%%%%%%
function [w, gamma]=core(H,v,nu)

     n=size(H,2);
v=(speye(n)/nu+H'*H)\v;
w=v(1:n-1);gamma=v(n);

return

%%%%%%%%%%%%%%%% correctness calculation %%%%%%%%%%%%%%%%

function corr = correctness(Atest,Abar,dd,w,gamma,mu)

k = Rec_Kernel(Atest,Abar,mu);
p = sign(k*w - gamma);
corr=length(find(p==dd))/size(Atest,1)*100;
return

%%%%%%%%%%%%%       EstNuLong     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use to estimate nu
function lamda=EstNuLong(H,d,m)

if m<201
H2=H;d2=d;
else
r=rand(m,1);
 [s1,s2]=sort(r);
 H2=H(s2(1:200),:);
 d2=d(s2(1:200));
end

lamda=1;
[vu,u]=eig(H2*H2');u=diag(u);p=length(u);
yt=d2'*vu;  
lamdaO=lamda+1;

cnt=0;
while (abs(lamdaO-lamda)>10e-4)&(cnt<100)
   cnt=cnt+1;
   nu1=0;pr=0;ee=0;waw=0;
   lamdaO=lamda;   
   for i=1:p
     nu1= nu1 + lamda/(u(i)+lamda);
     pr= pr + u(i)/(u(i)+lamda)^2;
     ee= ee + u(i)*yt(i)^2/(u(i)+lamda)^3;
     waw= waw + lamda^2*yt(i)^2/(u(i)+lamda)^2;
   end
   lamda=nu1*ee/(pr*waw);
end

value=lamda;
if cnt==100
    value=1;
end
return
%%%%%%%%%%%%%%%%%EstNuShort%%%%%%%%%%%%%%%%%%%%%%%

% easy way to estimate nu if not specified by the user
function value = EstNuShort(C,d)

value = 1/(sum(sum(C.^2))/size(C,2));
return

%%% function to calculate H and v %%%%%%%%%%%%%
function [H,v]=HV(A,d,bal);

[m,n]=size(A);e=ones(m,1);

if (bal==0)
     H=[A -e];
     v=(d'*H)';
else
     H=[A -e];
     mm=e;
     m1=find(d==-1);
     mm(m1)=(1/length(m1));
     m2=find(d==1);
     mm(m2)=(1/length(m2));
     mm=sqrt(mm);
     N=spdiags(mm,0,m,m);
     H=N*H;
    %keyboard
    v=(d'*N*H)';
end

 %%%%%%%%%%%%%%calcKer%%%%%%%%%%%%%%%%%%%%%%%
function [A,Abar] = calcKer(A,rr,mu,output)

  [sm sn]=size(A);
  % calculate kernel
  if output==1
  fprintf(1,'\nCalculating kernel . . .\n');
  end
  rrows = floor(rr*sm);  % reduced number of rows
  indx = rand(sm,1);
  [s1 s2]=sort(indx);
  Abar = A(s2(1:rrows),:)';
  A = Rec_Kernel(A,Abar,mu);
  return;

%%%%%%%%%%%%%%%%%%%%%%%EstMu%%%%%%%%%%%%%
function mu = EstMu(A,d)

Aplus = A(find(d==1),:); Aminus=A(find(d==-1),:);

AplusRow = size(Aplus,1);
AminusRow = size(Aminus,1);
x=(sum(Aplus,1)/AplusRow + sum(Aminus,1)/AminusRow);
mu = 1/(1 + x*x');
return;







