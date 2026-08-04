function [simdata] = chmmsim (chmm,N)
% [simdata] = chmmsim (chmm,N)
%
% simulates the output of an two-chain CHMM with gaussian observation model 
% and HMM parameters
%   chmm.chains{:}.Pi = prior probabilities
%   chmm.chains{:}.P  = state transition probabilities
%   N  = number of samples generated
%   chmm.chains{1} = structure for first hmm chain
%   chmm.chains{2} = structure for second hmm chain
%
% The function returns:
%
%  simdata.Xseries sampled observation sequence of first chain
%  simdata.Yseries sampled observation sequence of second chain
%  simdata.Xclass  sampled state sequence of first chain
%  simdata.Yclass  sampled state sequence of second chain
%  simdata.jointclass sampled state sequence (cartesian prod. of the chains)
%  simdata.Pe      estimated transition probabilities
%  simdata.P_cart  cartesian product of the 2 transition probabilities
%  simdata.Pxx     inter-chain transition probabilities: P(X_t | X_{t-1})
%  simdata.Pyy     inter-chain transition probabilities: P(Y_t | T_{t-1})
% 
% e.g.
% N=1024;
% simchmm.chains{1}.K=2;
% simchmm.chains{2}.K=3;
% simchmm.chains{1}.Lags=2;
% simchmm.chains{2}.Lags=2;
% simchmm.chains{1}.Pi=[1/4 2/4 1/3];
% simchmm.chains{2}.Pi=[1/2 1/2];
% simchmm.chains{1}.P(:,:,1)=[0.7 0.15 0.05; 0.1 0.65 0.35; 0.2 0.2 0.6];
% simchmm.chains{1}.P(:,:,2)=[0.8  0.15 .37; 0.1  0.7 .27; 0.1 .15 .36];
% simchmm.chains{2}.P(:,:,1)=[0.97 0.03 0.15;0.03 0.97 0.85];
% simchmm.chains{2}.P(:,:,2)=[0.6  0.1 0.3; 0.4  0.9 0.7];
% simchmm.chains{1}.obsmodel='Gauss'; 
% simchmm.chains{1}.state(1).Mu=[-5;-5]; 
% simchmm.chains{1}.state(2).Mu=[0;0];
% simchmm.chains{1}.state(3).Mu=[5;5];
% simchmm.chains{1}.state(1).Cov=diag([2 2]);
% simchmm.chains{1}.state(2).Cov=diag([1 1]);
% simchmm.chains{1}.state(3).Cov=diag([1.5 1.5]);
% simchmm.chains{2}.obsmodel='Gauss'; 
% simchmm.chains{2}.state(1).Mu=[5;5];   simchmm.chains{2}.state(2).Mu=[0;0];
% simchmm.chains{2}.state(1).Cov=diag([1 1]);
% simchmm.chains{2}.state(2).Cov=diag([2 2]);
% [simdata] = chmmsim (simchmm,N);
  
  if nargin<1,
    help chmmsim
    return;
  end;
     
  if ~isfield(chmm,'chains')
    disp('Need to specify individual Markov Chains');
    return;
  end;
  
  if ~isfield(chmm.chains{1},'Pi') | ~isfield(chmm.chains{2},'Pi')
    disp('Need to specify prior probability');
    return;
  end;

  if ~isfield(chmm.chains{1},'P') | ~isfield(chmm.chains{2},'P')
    disp('Need to specify transition probability');
    return;
  end;

  if ~isfield(chmm.chains{1},'K') | ~isfield(chmm.chains{2},'K')
    disp('Need to specify state space dimension K');
    return;
  end;

  if ~isfield(chmm.chains{1},'Lags') | ~isfield(chmm.chains{2},'Lags')
    disp('Need to specify Lag-vector');
    return;
  end;

Lx=chmm.chains{1}.Lags;	% lag onto X-chain
Ly=chmm.chains{2}.Lags;% lag onto Y-chain
Lmin=min(Lx,Ly);
Lmax=max(Lx,Ly);

% priors
Pix=chmm.chains{1}.Pi;
Piy=chmm.chains{2}.Pi;

% transition Probs:
Pxy=chmm.chains{1}.P;
Pyx=chmm.chains{2}.P;

% integrate out neighbouring chain to get Px=P(Sx_t | Sx_t-1)
Pxx=squeeze(sum(mdprod(chmm.chains{1}.P,chmm.chains{2}.Pi,3),3));
% integrate out neighbouring chain to get Py=P(Sy_t | Sy_t-1)
Pyy=squeeze(sum(mdprod(chmm.chains{2}.P,chmm.chains{1}.Pi,2),2));

Xix=zeros([N size(Pxy)]);
Xiy=zeros([N size(Pyx)]);
% now sampling states
N=N+Lmax;				% overshoot of initial cut-off
for t=1:N,
  if t==1,
    % sampling from prior
    C(t,1)=find(multinom(Pix,1,1)); 
    C(t,2)=find(multinom(Piy,1,1)); 
  elseif t<=Lmax,
    % sampling  from inter-chain Tx Prob.
    C(t,1)=find(multinom(Pxx(:,C(t-1,1)),1,1)); 
    C(t,2)=find(multinom(Pyy(:,C(t-1,2)),1,1)); 
  elseif Ly==0
    C(t,1)=find(multinom(Pxy(:,C(t-1,1),C(t-Lx,2)),1,1)); 
    C(t,2)=find(multinom(Pyy(:,C(t-1,2)),1,1)); 
  elseif Lx==0
    C(t,1)=find(multinom(Pxx(:,C(t-1,1)),1,1)); 
    C(t,2)=find(multinom(Pyx(:,C(t-Ly,1),C(t-1,2)),1,1)); 
  else
    C(t,1)=find(multinom(Pxy(:,C(t-1,1),C(t-Lx,2)),1,1)); 
    C(t,2)=find(multinom(Pyx(:,C(t-Ly,1),C(t-1,2)),1,1)); 
    Xix(t-Lmax,C(t,1),C(t-1,1),C(t-Lx,2))=1;
    Xiy(t-Lmax,C(t,2),C(t-Ly,1),C(t-1,2))=1;
  end
  % sample from each observation model
  hmm=chmm.chains{1};
  x(t,:)=sampgauss(hmm.state(C(t,1)).Mu,hmm.state(C(t,1)).Cov,1)';
  hmm=chmm.chains{2};
  y(t,:)=sampgauss(hmm.state(C(t,2)).Mu,hmm.state(C(t,2)).Cov,1)';
end;

% ignore initial values
x=x(Lmax+1:N,:);			
y=y(Lmax+1:N,:);
C=C(Lmax+1:N,:);

simdata.Xseries=x;
simdata.Yseries=y;
simdata.Xclass=C(:,1);
simdata.Yclass=C(:,2);
simdata.jointclass = (C(:,1)-1)+(C(:,2)-1)*chmm.chains{2}.K +1;
simdata.P_cart=joinpdf(chmm.chains{1}.P,chmm.chains{2}.P,[2 3]);
simdata.Pxx=Pxx;
simdata.Pyy=Pyy;
simdata.Xix=Xix;
simdata.Xiy=Xiy;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y,p_avg,p_std]=multinom(p,m,n)
%Performs random sampling from a binomial distribution
%
% [y]=multinom(p,m,n)
% where p=1-by-k vector of probabilities of occurrence 
%       n=sample size
% and   m= number of trials
%       y=samples-matrix of size k-by-m
%
% for picking out one of k mixture components, set n=1;
%
k=length(p);
x=rand(n,m);

if (sum(p)~=1) , 
  p(k+1)=1-sum(p); 
  k=k+1; 
end;
p=cumsum(p);

y(1,:)=sum(x<=p(1));
for i=2:k,
  y(i,:)=sum(x>p(i-1) & x<=p(i));
end;

p_avg=mean(y'./n);
p_std=std(y'./n);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x]=sampgauss(m,C,N)
%
%  x=SAMPGAUSS(m,C,N)
%
%  samples N-times from an multi-dimensional gaussian distribution 
%  with covariance matrix C and mean m. Dimensionality is implied
%  in the mean vector
%
%  e.g: C=[1 .7;0.7 1];
%       m=[0;0];
%       x=sampgauss(m,C,300);
%(see e.g. B.D. Ripley, Stochastic Simulation, Wiley, 1987, pp. 98--99)
%
m=m(:);

r=size(C,1);
if size(C,2)~= r
  error('Wrong specification calling normal')
end
% find cholesky decomposition of A
[L,p]=chol(C);
% generate r  independent N(0,1) random numbers
z=randn(r,N);
x=m(:,ones(N,1))+L*z;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Z=mdprod(X,Y,conddim)
% function Z=mdprod(X,Y,conddim)
%
% multiplication of multidimensional arrays along dimensions <conddim>
%
% e.g. P(A|B,C) is of size 3x2x4
%,     Pi(C)     is of size 1x4
% to obtain P(A,C|B)
% mdprod(P,Pi,3) as C varies along dimension 3
%
% example:
% X=round(10*rand(2,2,2));
% dim=3;
% Y=mdsum(X,dim);
% Z=mdprod(X,Y,dim);
% results in every other element X in dimensions 1 and 2
% is multiplied by every value of Y


svx=size(X);				% need old demensions of X
svy=size(Y);				% and Y

freedim=setdiff(1:length(svx),conddim);	% get free dimensions
conddim=conddim(:)'; freedim=freedim(:)';


if prod(svx(conddim))~=prod(svy),
  error(['Dimensionality of Y and number of conditioning dimensions must' ...
	 ' be identical']);
end;

if length(svy)==2 & any(svy==1),	% matlab is incabable 
  if ~all(svx(conddim)==setdiff(svy,1))
    error('Array sizes along conditioning dimensions must be identical')
  end;
else
  if ~all(svx(conddim)==svy)
    error('Array sizes along conditioning dimensions must be identical')
  end;
end;

% uncomment for mddiv
%if any(Y(:)==0),
%   error('Y contains zeros');
%end;
  
X=permute(X,[freedim,conddim]);		% move freedims to front
svx2=size(X);				% what's the new size

X=reshape(X,prod(svx(freedim)),prod(svx(conddim))); % vectorise the 2 dim sets
Y=reshape(Y,prod(svx(conddim)),1);

Z=zeros(size(X));
 for d=1:prod(svx(conddim)),
   Z(:,d)=X(:,d).*Y(d);	
 end;
Z=reshape(Z,svx2);			% unvectorise
Z=ipermute(Z,[freedim,conddim]);	% restore to old shape of X


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Z] = joinpdf(A,B,conddim);
% [Z] = joinpdf(A,B,conddim);
%
% creates a joint conditional pdf with conditioning
% dimensions specified in <conddim>
% the output array contains the cathesian product along
% the other dimensions
%
% Note that the new N-D array Z has condim as its trailing
% dimenions

svA=size(A);
svB=size(B);
if ~isequal(svA(conddim),svB(conddim))
   error('Conditioning dimensions must be identical in size')
end;
freedimA=setdiff(1:length(svA),conddim);
freedimB=setdiff(1:length(svB),conddim);

A=permute(A,[freedimA,conddim]);
B=permute(B,[freedimB,conddim]);


Ar=reshape(A,prod(svA(freedimA)),prod(svA(conddim)));
Br=reshape(B,prod(svB(freedimB)),prod(svB(conddim)));

for i=1:size(Ar,2),
  %   Z(:,:,i)=Ar(:,i)*Br(:,i)';
  Z(:,i)=kron(Br(:,i),Ar(:,i));
end;

Z=reshape(Z,[svA(freedimA),svB(freedimB),svA(conddim)]);
%svZ=size(Z);
%freedimZ=setdiff(1:length(svZ),conddim);
%Z=ipermute(Z,[freedimZ conddim]);

%svZ=size(Z);
%Z=reshape(Z,[svZ(1),svZ(2),svA(conddim)]);
