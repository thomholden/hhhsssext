function [simdata,hmm] = hmmsim (hmm,N,segsize,Nt)
% [simdata,simhmm] = hmmsim (hmm,N,segsize,Nt)
%
% Sample N samples from an HMM with various observation models 
% and HMM parameters. For each sample drawn from the hidden states
% sample segsize samples from the observation models. 
% <hmm> is either a string with values
%  'defGauss'      sample from default Gaussian observation HMM
%  'defuvAR'       sample from default univariate AR observation HMM
%  'defuvAR'       sample from 2nd default univariate AR observation HMM
%                  with very close spectra
%  'defbvAR'       sample from default bivariate AR observation HMM
%  'defMn'         sample from default discrete observation HMM
%  'LIKE'          sample from 'LIKE' observation HMM
%
% or a structure  with parameters
%   hmm.Pi         prior probability
%   hmm.P          state transition probability
%   hmm.K          state space dimension
%   hmm.obsmodel   name of observation model ('Gauss','Multinomial','LIKE','AR');
%   hmm.state      for each state the observation specific parameters
%   for Gauss Obs. Model
%     Mu            state mean
%     Cov           state covariance
%   for Multinomial Observation model
%     P             observation prob. vector
%   for AR observation model (uses arfit)
%     w             intercepts;
%     A             ar coefficients
%     C             driving noies  covariance matrix
%     
% The function returns:
%
%   data.Xseries sampled observation sequence
%   data.Xclass  sampled state sequence
% 
%   data.sorted  same as above but with sorted state sequence with
%   at least Nt transitions.
%   
%  simplest to call is by using default settings:
%  e.g.
%  model='defGauss';
%  [simdata] = hmmsim (model,1024); 
%  
%  or 
%  N=4096;
%  hmm.Pi=[1/2 1/2];
%  hmm.P=[3/4 1/4; 1/2 1/2];
%  hmm.K=2;
%  hmm.obsmodel='Gauss';
%  hmm.state(1).Mu=-5;hmm.state(2).Mu=0;
%  hmm.state(1).Cov=2;hmm.state(2).Cov=1;
%  [simdata] = hmmsim (hmm,N);
% 
% 
  
  if nargin<4
    Nt=3;
  end
  
  if nargin<3
    segsize=1;
  end
  
  if nargin<2,
    N=1024;
  end
  
  if nargin<1
    hmm='defGauss';
  end
  
  if isstr(hmm)
    model=hmm;
    hmm=struct('Pi',[1/2 1/2],'P',[8/9 1/9; 1/8 7/8],'K',2);
    switch model
     case 'defGauss'
      hmm.obsmodel='Gauss';
      hmm.state(1).Mu=-5;hmm.state(2).Mu=0;
      hmm.state(1).Cov=2;hmm.state(2).Cov=1;
     case 'defGamma'
      hmm.obsmodel='Gamma';
      hmm.state(1).alpha=15;hmm.state(2).alpha=10;
      hmm.state(1).beta=2; hmm.state(2).beta=1;
     case 'defuvAR'
      hmm.obsmodel='AR';
      hmm.state(1).w=0;
      hmm.state(1).A=[.4 .35];
      hmm.state(1).C=[1];
      hmm.state(1).p=length(hmm.state(1).A);
      hmm.state(2).w=0;
      hmm.state(2).A=[1.2 -.7]; 
      hmm.state(2).C=[1];
      hmm.state(2).p=length(hmm.state(2).A);
      
      case 'defuvAR2'
      hmm.obsmodel='AR';
      hmm.state(1).w=0;
      hmm.state(1).A=[.5 -.71 -.22];
      hmm.state(1).C=[1];
      hmm.state(1).p=length(hmm.state(1).A);
      hmm.state(2).w=0;
      hmm.state(2).A=[.6 -.538 -.15]; 
      hmm.state(2).C=[1];
      hmm.state(2).p=length(hmm.state(2).A);
     
     case 'defbvAR'
      % Coeffs at lag 1 of first AR mixture component 
      Al1(:,:,1) = [ 0.4   1.2;   0.3   0.7 ];
      % Coeffs at lag 2
      Al2(:,:,1) = [ 0.35 -0.3;  -0.4  -0.5 ];
      % Coeffs at lag 1 of second AR mixture component 
      Al1(:,:,2) = [ 0.4   0;   0   0.7 ];
      % Coeffs at lag 2
      Al2(:,:,2) = [ 0.35 0;  0  -0.5 ];
      
      hmm.obsmodel='AR';
      hmm.state(1).w=[0;0];
      hmm.state(1).A=squeeze([ Al1(:,:,1) Al2(:,:,1) ]);
      hmm.state(1).C=[ 1.00  0.50;   0.50  1.50 ];
      hmm.state(1).p=2;
      hmm.state(2).w=[0;0];
      hmm.state(2).A=squeeze([ Al1(:,:,2) Al2(:,:,2) ]);
      hmm.state(2).C=[ 1.00  0.50;   0.50  1.50 ];
      hmm.state(2).p=2;
      
     case 'defMn'
      hmm.obsmodel='Multinomial';
      hmm.state(1).P=[0.39    0.46    0.15];
      hmm.state(2).P=[0.05    0.25    0.70];
     case 'defLike'
      hmm.obsmodel='LIKE';
     otherwise
      error('Unrecognized Model');
    end
  end

  if ~isfield(hmm,'K')
    error('Need to specify state space dimension K ');
  else,
    K=hmm.K;
  end;
 
  if ~isfield(hmm,'Pi');
    error('Need to specify prior probability');
  else
    Pi=hmm.Pi;
  end;

  if ~isfield(hmm,'P');
    error('Need to specify transition probability');
  else
    P=hmm.P;
  end;
  
  
  if (length(Pi)~=size(P,1)) & (length(Pi)~=size(P,2))
    error('Prior vector and transition matrix non-conformant');
  end;

   
  if ~isfield(hmm,'obsmodel'),
    error('Need to specify observation model');
  end;
  
switch hmm.obsmodel
 case {'GaussComm', 'Gauss'},
  if ~isfield(hmm.state,'Mu'),
    error('Missing mean vector for Gaussian observation model');
  elseif ~isfield(hmm.state,'Cov'),
    error('Missing covariance matrix for Gaussian observation model');
  end
 case {'Gamma'},
  if ~isfield(hmm.state,'alpha'),
    error('Missing shape parameter for Gamma observation model');
  elseif ~isfield(hmm.state,'beta'),
    error('Missing scale parameter for Gamma observation model');
  end
 case {'Multinomial'}
  if ~isfield(hmm.state,'P'),
    error('Missing probability vector for Multinomial observation model');
  end
 case {'AR'},
  if ~exist('arfit','file')
    error('Require arfit package in search path');
  elseif ~isfield(hmm.state,'w'),
    error('Missing intercept vector for AR observation model');
  elseif ~isfield(hmm.state,'C'),
    error('Missing covariance matrix for AR observation model');
  elseif ~isfield(hmm.state,'A'),
    error('Missing AR coefficients for observation model');
  end
 case {'LIKE'},
 otherwise
  error('Unknown observation model');
end;

for k=1:K,
  % sample from each observation model
  switch hmm.obsmodel
   case {'GaussComm', 'Gauss'},
    y(:,:,k)=sampgauss(hmm.state(k).Mu,hmm.state(k).Cov,N*segsize)';
   case {'Gamma'},
    y(:,:,k)=sampgamma(hmm.state(k).alpha,hmm.state(k).beta,N*segsize);
   case {'AR'},
    y(:,:,k)=arsim(hmm.state(k).w,hmm.state(k).A,hmm.state(k).C,...
		   hmm.state(k).p);
    e(:,:,k)=sampgauss(zeros(ndims(hmm.state(k).C),1),...
		       hmm.state(k).C,N*segsize)';
   case {'Multinomial'}
    y(:,:,k)=multinomrnd(hmm.state(k).P,N*segsize);
   case {'LIKE'},
  end; 
end;


% now sampling states
for i=1:segsize:N*segsize,
  if i==1,
    c(i:i+segsize-1)=repmat(find(multinomrnd(Pi,1,1)),1,segsize);	% sampling prior
  else
    c(i:i+segsize-1)=repmat(find(multinomrnd(P(c(i-1),:),1,1)),1,segsize);
  end;
  for l=i:i+segsize-1,
  % sample from each observation model
  switch hmm.obsmodel
   case {'GaussComm', 'Gauss'}
    x(l,:)=y(l,:,c(l));
   case {'Gamma'}
    x(l,:)=squeeze(y(:,l,c(l)));
   case {'AR'},
    z=[];
    for j=1:hmm.state(c(l)).p
      if (l-j)<1
	z=cat(2,z,y(hmm.state(c(l)).p-j+l,:,c(l)));
      else
	z=cat(2,z,x(l-j,:));
      end
    end
    x(l,:)=z*hmm.state(c(l)).A'+e(l,:,c(l));
   case {'Multinomial'}
    x(l,:)=find(squeeze(y(:,l,c(l))));
   case {'LIKE'},
    x(l,:)=c(l);
  end; 
  end
end


N=length(c);
simdata.Xseries=x;
simdata.Xclass=c(:);

% sorting to obtain a presentable viterbi path
simdata.sorted.Xseries=[];
simdata.sorted.Xclass=[];
[junk,segndx]=sort(rand(1,N-1));
segndx=sort(segndx(1:Nt-1));
segndx=[0 segndx N];
for s=1:Nt,
  [sc,ndx]=sort(c(segndx(s)+1:segndx(s+1)));
  sx=x(ndx+segndx(s),:);
  simdata.sorted.Xseries=[simdata.sorted.Xseries;sx];
  simdata.sorted.Xclass=[simdata.sorted.Xclass;sc(:)];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y,p_avg,p_std]=multinomrnd(p,m,n)
%Performs random sampling from a binomial distribution
%
% [y]=multinomrnd(p,m,n)
% where p=1-by-k vector of probabilities of occurrence 
%       n=sample size
% and   m= number of trials
%       y=samples-matrix of size k-by-m
%
% for picking out one of k mixture components, set n=1;
%
if nargin<3,
  n=1;
end;

k=length(p);
x=rand(n,m);

if (sum(p)-1>100*eps) , 
  p(k+1)=1-sum(p); 
  k=k+1; 
end;
p=cumsum(p);


y(1,:)=sum(x<=p(1),1);
for i=2:k,
  y(i,:)=sum(x>p(i-1) & x<=p(i),1);
end;

p_avg=mean(y'./n);
p_std=std(y'./n);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x]=sampgamma(A,B,N)
%
%  x=SAMPGAMMA(a,b,N)
%
%  samples N-times from an uni-dimensional gamma distribution 
%  with scale parameter b and shape paramter a. 
%
%  e.g: a=15;
%       b=2;
%       x=sampgamma(a,b,300);
%

x = gamrnd(A,1./B,N,1)';

