function [ RESULTS ] = MNIGscheme2
%This function estimates the parameters of the Multivariate NIG
%distribution using a MCMC method. {Ez=1}

%y portfolio return (n x m) matrix. 
%mu,b (1 x m) parameter vectors.
%g,d (1 x 1) scalars.
%D (m x m) parameter matrix.
%a is a function of g, b, D a scalar
clear;clc
%load portfolio price matrix S (n-days x m-stocks)
load Greekdata
%Transform to the portfolio return matrix R
% y=price2ret(S);
y=R2_data;
%Return matrix dimensions
[n,m]=size(y);

%Number of iterations for the Gibbs sampler
p=input('How many iteration do you want?');

%Space allocation
mu=zeros(p,m);
b=zeros(p,m);
g=zeros(p,1);
a=zeros(p,1);

%Set the Parameter Seeds
mu(1,:)=[0.00165026459315843       0.00104480484616614       0.00077871638825081      -0.00169433678018341];
b(1,:)=[-1.84523879620938          2.40676715711334        -0.399903270946482          4.66807795196428];
g(1)=3.34508909839828;
D(:,:,1)=[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];

a(1,:)=sqrt(g(1).^2+b(1,:)*D(:,:,1)*b(1,:)');

for i=1:p
i
  %1 Sampling from the posterior of the latent Z
  
    for j=1:length(y)
   fi=1+(g(i)^-2).*(y(j,:)-mu(i,:))*(D(:,:,i)^-1)*(y(j,:)-mu(i,:))'; 
   z(i,j)=randraw('gig',[-(m+1)/2, ( g(i)*sqrt(fi) )^2 ,a(i)^2], 1); 
    end
    
%2 Gamma part for the g posterior
%Set the hyperparameters
w=0;
ksi=0.001;

%Parameters
ga(1)=n/2+w ;
ga(2)=ksi-n+1/2*sum(z(i,:)+1./z(i,:)) ;   
%One random draw
gsq=gamrnd(ga(1),1/ga(2));
g(i+1)=sqrt(gsq);

%Update parameter scalar parameter a.
  a(i+1,:)=sqrt(g(i+1).^2+b(i,:)*D(:,:,i)*b(i,:)');

%3 Random draw from the multivariate normals for the parameters (b,mu) using
%the non-informative priors.

 %Parameters for the Multivariate Normals for b
SIGMA1=(sum(z(i,:))^(-1))*(D(:,:,i)^-1);
MU1=SIGMA1*sum(y-ones(n,1)*mu(i,:))';      
b(i+1,:)= mvnrnd(MU1,SIGMA1);
 
%Parameters for the Multivariate Normals for mu
SIGMA2=((sum(1./z(i,:)))^(-1))*(D(:,:,i));
Z=z(i,:)'*ones(1,m);
MU2=(SIGMA2*((D(:,:,i)^-1)*sum(y.*(1./Z))'-n*b(i+1,:)'))';
mu(i+1,:)= mvnrnd(MU2,SIGMA2);

%4 Random draw from the posterior of D. 

P1=(y-ones(n,1)*mu(i+1,:));
So=zeros(m);
for k=1:length(P1)
temp=P1(k,:)'*P1(k,:)/z(k);
So=So+temp;
end

%The m x m scale hyperparameter for the Inverse Wishart distribution we used as a
%prior. We used [5 0;0 5]
Lo=diag(ones(m,1));
no=1;

beta=sum(z(i,:))/2;
alpha=(Lo+So)/2;
zeta=b(i+1,:)';
qq=(no+n)/2;  %the target degrees of freedom of the MGIG
s=m; %dimensions of the problem
pp=qq+(1-s)/2;

lam=-pp;
chi=2*beta;
psi=2*(zeta'*alpha*zeta);
%The sampling algorithm
c=psi;

X=randraw('gig',[lam,chi,psi],1); 
Y=wishrnd((alpha)^(-1),qq);    
D(:,:,i+1)=(zeta*X*zeta'+Y)^(-1);  %U follows a Matrix GIG distribution with the desired parameters.

RESULTS(i,:)=[mu(i,:) b(i,:) g(i,:) a(i,:) D(1,:,i) D(2,:,i) D(3,:,i) D(4,:,i)];
[D(1,:,i) D(2,:,i) D(3,:,i) D(4,:,i)]

if mod(i,100)==0
    
subplot(2,2,1)
plot(log(z(:,50)));
subplot(2,2,2)
plot(log(z(:,100)));
subplot(2,2,3)
plot(log(z(:,200)));
subplot(2,2,4)
plot(log(z(:,600)))
pause(0.15)
end
    pause(0.002)
save z z
save Results RESULTS
end
