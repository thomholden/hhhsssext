function [simdata] = chmmsim (chmm,N)
% [simdata] = chmmsim (chmm,N)
%
% simulates the output of an HMM with gaussian observation model 
% and HMM parameters
%   chmm.Pi = prior probability
%   chmm.P  = state transition probability
%   N  = number of samples generated
%   chmm.hmmone	= structure for first hmm chain
%   chmm.hmmtwo = structure for second hmm chain
%
% The function returns:
%
%   data.Xseries sampled observation sequence of first chain
%   data.Yseries sampled observation sequence of second chain
%   data.Xclass  sampled state sequence of first chain
%   data.Yclass  sampled state sequence of second chain
%   data.jointclass sampled state sequence (cartesian prod. of the chains)
%   data.Pe      estimated transition probabilities
% 
%   data.sorted  same as above but with sorted cart. state sequence
%   
% e.g.
% N=1024;
% chmm.Pi=[1/4 1/8 1/4 3/8];
% chmm.P=[1/4 1/4 1/4 1/4; 0 1/3 1/3 1/3;.13 .37 .1 .40; .38 .38 .04 .20]';
% chmm.P=[.94 .02 .02 .02;.02 .94 .02 .02;.02 .02 .94 .02;.02 .02 .02 .94]';
% chmm.K=[2 2];
% chmm.hmmone.obsmodel='Gauss'; chmm.hmmtwo=chmm.hmmone;
% chmm.hmmone.state(1).Mu=[-5;-5];chmm.hmmone.state(2).Mu=[0;0];
% chmm.hmmtwo.state(1).Mu=[5;5];chmm.hmmtwo.state(2).Mu=[0;0];
% chmm.hmmone.state(1).Cov=diag([2 2]);chmm.hmmone.state(2).Cov=diag([1 1]);
% chmm.hmmtwo.state(1).Cov=diag([1 1]);chmm.hmmtwo.state(2).Cov=diag([2 2]);
% chmm.TPx=sum(reshape(chmm.P,2,2,2,2),2);
% chmm.TPy=sum(reshape(chmm.P,2,2,2,2),1);
% chmm.TPx=reshape(chmm.TPx,2,4);
% chmm.TPy=reshape(chmm.TPy,2,4);
% [simdata] = chmmsim (chmm,N)
  
  if nargin<1,
    help chmmsim
    return;
  end;
  
  if ~isfield(chmm,'Pi');
    disp('Need to specify prior probability');
    return;
  else
    Pi=chmm.Pi;
  end;

  if ~isfield(chmm,'P');
    disp('Need to specify transition probability');
    return;
  else
    P=chmm.P;
  end;
  
  
  if (length(Pi)~=size(P,1)) & (length(Pi)~=size(P,2))
    disp('Prior vector and transition matrix non-conformant');
    return;
  end;

  if ~isfield(chmm,'K')
    disp('Need to specify state space dimension K ');
    return;
  else,
    K=chmm.K;
    Kcart=prod(K);
  end;
   
  if ~isfield(chmm,'hmmone') | ~isfield(chmm,'hmmtwo'),
    disp('Need to specify individual Markov Chains');
    return;
  end;
 
  if ~isfield(chmm.hmmone,'obsmodel') | ~isfield(chmm.hmmtwo,'obsmodel')
    disp('Need to specify observation model');
    return;
  end;
  

switch chmm.hmmone.obsmodel
 case {'GaussComm', 'Gauss'},
  if ~isfield(chmm.hmmone.state,'Mu'),
    disp('Missing mean vector for Gaussian observation model');
    return;
  elseif ~isfield(chmm.hmmone.state,'Cov'),
      disp('Missing covariance matrix for Gaussian observation model');
      return;
  end
 case {'AR'},
  disp('Sorry. Not supporting AR at the moment');
  return;
 case {'LIKE'},
 otherwise
  disp('Unknown observation model');
  return
end;

switch chmm.hmmtwo.obsmodel
 case {'GaussComm', 'Gauss'},
  if ~isfield(chmm.hmmtwo.state,'Mu'),
    disp('Missing mean vector for Gaussian observation model');
    return;
  elseif ~isfield(chmm.hmmtwo.state,'Cov'),
      disp('Missing covariance matrix for Gaussian observation model');
      return;
  end
 case {'AR'},
  disp('Sorry. Not supporting AR at the moment');
  return;
 case {'LIKE'},
 otherwise
  disp('Unknown observation model');
  return
end;
  
% now sampling states
for i=1:N,
  if i==1,
    c(i)=find(multinom(Pi,1,1));		% sampling prior
    C=[];
  else
    c(i)=find(multinom(P(:,c(i-1)),1,1));
  end;
  C=[C;rem(c(i),K(1))+1 ceil(c(i)/K(1)) ];
  % sample from each observation model
    hmm=chmm.hmmone;
    switch hmm.obsmodel
      case {'GaussComm', 'Gauss'},
        x(i,:)=sampgauss(hmm.state(C(i,1)).Mu,hmm.state(C(i,1)).Cov,1)';
      case {'AR'},
        disp('Sorry. Not supporting AR at the moment');
        return;
      case {'LIKE'},
        x(i,:)=C(i,1);
    end; 
    hmm=chmm.hmmtwo;
    switch hmm.obsmodel
      case {'GaussComm', 'Gauss'},
        y(i,:)=sampgauss(hmm.state(C(i,2)).Mu,hmm.state(C(i,2)).Cov,1)';
      case {'AR'},
        disp('Sorry. Not supporting AR at the moment');
        return;
      case {'LIKE'},
        y(i,:)=C(i,2);
  end;
end;

simdata.Xseries=x;
simdata.Yseries=y;
simdata.Xclass=C(:,1);
simdata.Yclass=C(:,2);
simdata.jointclass = c;

Nj=length(simdata.jointclass);
for i=1:max(c),
  for j=1:max(c), 
    simdata.Pe(j,i)=sum(simdata.jointclass(1:Nj-1)==i & ...
			simdata.jointclass(2:Nj)==j);
  end; 
  simdata.Pe(:,i)=simdata.Pe(:,i)./sum(simdata.Pe(:,i));
end;



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

