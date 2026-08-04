function [w,gamma,trainCorr, testCorr, cpu_time, nu]=nsvm(A,d,k,nu,output,wp1,arm)
% version 1.5
% last revision: 07/07/03
%=====================================================================
% Usage: [w, gamma, train, test, time, nu]=nsvm(A,d,k,nu,output,wp1,arm);
%
% Input parameters: 
%    A: Data points
%    d: 1's or -1's
%    k: way to divide the data set into test and training set
%       if k = 0: simply run the algorithm without any correctness
%         calculation, this is the default
%       if k = 1: run the algorithm and calculate correctness on
%         the whole data set
%       if k = any value less than the # of rows in the data set:
%         divide up the data set into test and training
%         using k-fold method
%       if k = # of rows in the data set: use the 'leave one out' method
%
%       nu:             weighted parameter
%                       -1 - easy estimation
%                       0  - hard estimation
%                       any other value - used as nu by the algorithm
%                       default - 0
%       pw1: percentage of weight for class 1 , pw must be 0<=pw1<=1  
%       the precentage for class -1 is 1-pw1 (1 is more important,
%       0 is less important					      
% 
%
%    output: 0 - no output, 1 - produce output, default is 0
%    arm:   1 - use armijo, 0 - otherwise, default is 0
%
%  Output parameters:
%     w:   the normal vector of the classifier
%     gamma: the threshold
%     trainCorr:      training set correctness
%     testCorr:       test set correctness
%     cpu_time:       time elapsed
%     nu:             the value used for nu
%===========================================================



if nargin<7
arm=0;
end


if nargin<6
wp1=.5;
end



if nargin<5
output=0;
end

if ((nargin<4)|(nu==0))
     nu = EstNuLong(A,d);  % default is hard estimation
elseif nu==-1  % easy estimation
nu = EstNuShort(A,d);
end

if nargin<3
k=0;
end

r=randperm(size(d,1));d=d(r,:);A=A(r,:);    % random permutation
trainCorr=0;
testCorr=0;

if k==0
tic;
  [w, gamma,iter] = core(A,d,nu,arm,wp1);
  cpu_time=toc;
  if output==1
  fprintf(1,'\nNumber of Iterations: %d',iter);
  fprintf(1,'\nElapsed time: %10.2f\n\n',cpu_time);
  end
  return
end

%if k==1 only training set correctness is calculated
if k==1
tic;
[w, gamma,iter] = core(A,d,nu,arm,wp1);
trainCorr = correctness(A,d,w,gamma);
cpu_time = toc;
  if output == 1
fprintf(1,'\nTraining set correctness: %3.2f%%',trainCorr);
fprintf(1,'\nNumber of Iterations: %d',iter);
fprintf(1,'\nElapsed time: %10.2f\n\n',cpu_time);
  end
  return
end

[sm sn]=size(A);
accuIter = 0;
lastToc=0;    % used for calculating time
indx = [0:k];
indx = floor(sm*indx/k);    %last row numbers for all 'segments'
% split trainining set from test set
tic;
for i = 1:k
Ctest = []; dtest = [];Ctrain = []; dtrain = [];

Ctest = A((indx(i)+1:indx(i+1)),:);
dtest = d(indx(i)+1:indx(i+1));

Ctrain = A(1:indx(i),:);
Ctrain = [Ctrain;A(indx(i+1)+1:sm,:)];
dtrain = [d(1:indx(i));d(indx(i+1)+1:sm,:)];

   [w, gamma,iter] = core(Ctrain,dtrain,nu,arm,wp1);

tmpTrainCorr = correctness(Ctrain,dtrain,w,gamma);
tmpTestCorr = correctness(Ctest,dtest,w,gamma);

 if output==1
fprintf(1,'________________________________________________\n');
fprintf(1,'Fold %d\n',i);
fprintf(1,'Training set correctness: %3.2f%%\n',tmpTrainCorr);
fprintf(1,'Testing set correctness: %3.2f%%\n',tmpTestCorr);
fprintf(1,'Number of iterations: %d\n',iter);
fprintf(1,'Elapsed time: %10.2f\n',toc-lastToc);
lastToc=toc;
end

trainCorr = trainCorr + tmpTrainCorr;
testCorr = testCorr + tmpTestCorr;
accuIter = accuIter + iter; % accumulative iterations

end % end of for (looping through test sets)

     trainCorr = trainCorr/k;
     testCorr = testCorr/k;
     cpu_time=toc/k;

if output == 1
     fprintf(1,'==============================================');
fprintf(1,'\nTraining set correctness: %3.2f%%',trainCorr);
fprintf(1,'\nTesting set correctness: %3.2f%%',testCorr);
fprintf(1,'\nAverage number of iterations: %d',accuIter/k);
fprintf(1,'\nAverage cpu_time: %10.2f\n',cpu_time);
end

return;  % nsvm function return

%%%%%%%%%%% core calculation function %%%%%%%%%%%%%%%%%%%%%
function [w, gamma, iter] = core(A,d,nu,arm,wp1);

[m,n]=size(A);

if m>=n
    [w,gamma,iter]=nsvm_with_smw(A,d,nu,arm,wp1);
else
    [w,gamma,iter]=nsvm_without_smw(A,d,nu,arm,wp1);
end

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        NSVM for m>=n                                           %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w,gamma,iter]=nsvm_with_smw(A,d,nu,arm,wp1);
% with armijo and with SMW
maxIter=100;
[m,n]=size(A);
iter=0;
u=zeros(m,1);e=ones(m,1);

H=[spdiags(d,0,m,m)*A -d]; 

% When balance is on this only approximates the norm
alpha=1.1*((1/nu)+(norm(H',2)^2));

if wp1==0.5
   v=u/nu+H*(H'*u)-e;
else
   vt=ones(m,1);
   vt(find(d==1))=(1-wp1)*ones(length(find(d==1)),1);
   vt(find(d==-1))=wp1*ones(length(find(d==-1)),1);
   v=vt.*u/nu+H*(H'*u)-e;
end  
hu=-max((v-alpha*u),0)+v;




while norm(hu)>10^(-3) & (iter < maxIter)  
    iter=iter+1;
    E=sign(max(v-alpha*u,0));
    if wp1==.5
       temp=(1./((alpha-(1/nu))*E+(1/nu)));    
    else
       temp=(1./((alpha*E)-E.*vt*(1/nu)+vt.*(1/nu)));
   end
    G=spdiags(temp.*(1-E),0,m,m);
    FHU=temp.*hu;
    LD=H'*FHU;
    GH=G*H;
    SM=speye(n+1)+H'*GH;
    R=chol(SM);
    sol=R'\LD;
    sol=R\sol;
    delta=FHU-GH*sol;
    
    if arm==1 %armijo step without the balance yet
        lambda=1;
        v1=v+e;
        v2=v;
        su=0.5*(u'*v1)-sum(u)+(1/(2*alpha))*(norm(max(-alpha*u+v2,0))^2-norm(v2)^2);        
        unew=u-lambda*delta;
        v1=u/nu+H*(H'*unew);
        v2=v1-e;
        sunew=0.5*(unew'*v1)-sum(unew)+(1/(2*alpha))*(norm(max(-alpha*unew+v2,0))^2-norm(v2)^2);
        while su-sunew < -(0.25)*lambda*hu
        
            lambda=0.1*lambda;           
            unew=u-lambda*delta;
            v1=u/nu+H*(H'*unew);
            v2=v1-e;
            sunew=0.5*(unew'*v1)-sum(unew)+(1/(2*alpha))*(norm(max(-alpha*unew+v2,0))^2-norm(v2)^2);
        end
        
    else
        unew=u-delta;
    end    
    
    u=unew;
    
    if wp1==.5
       v=u/nu+H*(H'*u)-e;
   else
       v=vt.*u/nu+H*(H'*u)-e;
   end
    hu=-max((v-alpha*u),0)+v;
    
      
    
end

w=A'*(d.*u);gamma=-sum(d.*u);
    
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        NSVM for m<n                                           %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [w,gamma,iter]=nsvm_without_smw(A,d,nu,arm,wp1);
maxIter=100;
[m,n]=size(A);
iter=0;
u=zeros(m,1);e=ones(m,1);
HH=diag(d)*(A*A'+1)*diag(d);
if wp1==.5
   Q=speye(m)/nu+HH;
else
   vt=ones(m,1);
   vt(find(d==1))=(1-w1)*ones(length(find(d==1)));
   vt(find(d==-1))=w1*ones(length(find(d==-1)));
   Q=spdiags(vt,0,m,m)/nu+HH;
end
alpha=1.1*((1/nu)+norm(HH));
v=Q*u-e;
hu=-max((v-alpha*u),0)+v;

while norm(hu)>10^(-3) & (iter < maxIter)
    iter=iter+1;
    dhu=sign(max(((Q-alpha*eye(m))*u-e),0));% the 1/2 thing
    dhu=sparse((diag(1-dhu))*Q+diag(alpha*dhu));
    delta=dhu\hu;
    
    if arm==1 %armijo step
        lambda=1;
        v=Q*u;
        ve=v-e;
        su=0.5*(u'*v)-sum(u)+(1/(2*alpha))*(norm(max(-alpha*u+ve,0))^2-norm(ve)^2)           
        unew=u-lambda*delta;
        v=Q*unew;
        ve=v-e;
        sunew=0.5*(unew'*v)-sum(unew)+(1/(2*alpha))*(norm(max(-alpha*unew+ve,0))^2-norm(ve)^2);
        at=0;
        while (su-sunew < -(0.25)*lambda*hu) & (at<5)
            at=at+1;
            disp('armijo');
            lambda=0.5*lambda;           
            unew=u-lambda*delta;
            v=Q*unew;
            ve=v-e;
            sunew=0.5*(unew'*v)-sum(unew)+(1/(2*alpha))*(norm(max(-alpha*unew+ve,0))^2-norm(ve)^2);
        end
        if at==5
            unew=u-delta;
        end    
    else
        unew=u-delta;
    end    
    
  
    u=unew;
    v=Q*unew-e;
    hu=-max((v-alpha*u),0)+v;
     
          
end

w=A'*(d.*u);gamma=-sum(d.*u);

return
    
%%%%%%%%%%%%%%%% correctness calculation %%%%%%%%%%%%%%%%

function corr = correctness(AA,dd,w,gamma)

p=sign(AA*w-gamma);
corr=length(find(p==dd))/size(AA,1)*100;
return

%%%%%%%%%%%%%%EstNuLong%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hard way to estimate nu if not specified by the user
function value = EstNuLong(C,d)

[m,n]=size(C);e=ones(m,1);
H=[C -e];
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
while (abs(lamdaO-lamda)>10e-4)& (cnt<100)
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

value =lamda;
if cnt==100
    value=1;
end    

return

%%%%%%%%%%%%%%%%%EstNuShort%%%%%%%%%%%%%%%%%%%%%%%

% easy way to estimate nu if not specified by the user
function value = EstNuShort(C,d)

value = 1/(sum(sum(C.^2))/size(C,2));
return
    
    


    
    
