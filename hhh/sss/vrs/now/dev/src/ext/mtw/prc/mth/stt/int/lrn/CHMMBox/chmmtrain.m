function [chmm]=chmmtrain(X,Y,T,chmm)
% function [chmm]=chmmtrain(X,Y,T,chmm)
%
% Train Coupled Hidden Markov Model using Baum Welch/MAP EM algorithm
% using node clustering
%
% INPUTS:
%
% X,Y - observation sequences
% T - length of each sequence (N must evenly divide by T, default T=N)
% chmm.hmmone    definitions of first chain
% chmm.hmmtwo    definitions of second chain
% for each chain
% chmm.hmmone/hmmtwo.K - number of states  for first chain
% chmm.hmmone/hmmtwo.P - state transition matrix, 3 dimensional
% chmm.hmmone/hmmtwo.obsmodel -  'Gauss' ('GaussCom','AR' or 'LIKE' not yet implemented)
%
% chmm.train.cyc - maximum number of cycles of Baum-Welch (default 100)
% chmm.train.tol - termination tol (prop change in likelihood) (default 0.0001)
% chmm.train.init - Already initialised the obsmodel (1 or 0) ? (default=0)
% chmm.train.obsupdate - Update the obsmodel (1 or 0) ?  (default=1)
% chmm.train.pupdate - Update transition matrix (1 or 0) ? (default=1)
%
% OUTPUTS
% chmm.Pi - priors
% chmm.P - state transition matrix, 
% chmm.state(k).$$ - whatever parameters there are in the observation model
% chmm.LPtrain  - training log posterior
%

if isfield(chmm.train,'cyc')
  cyc=chmm.train.cyc;
else
  cyc=50; 
end

if isfield(chmm.train,'tol')
  tol=chmm.train.tol;
else
  tol=0.0001; 
end

% checking parameters and assigning defaults
[chmm,N,K,traininit,updateobs,updatep,P,Pi]=paramchk(chmm,X,Y,T);


LP=[];
lpost=0;

K_cart=K(1)*K(2);
alpha=zeros(T,K_cart);
beta=zeros(T,K_cart);
gamma=zeros(T,K_cart);								    

% merging transition probabilities, initial state probabilities,transition
% probability and initial state probability priors
P_cart=reshape(joinpdf(P.hmmone,P.hmmtwo,[2 3]),K_cart,K_cart) % checked
Pi_cart=reshape(Pi.hmmone'*Pi.hmmtwo,1,K_cart);
chmm.priors.Dir2d_alpha=...
    reshape(joinpdf(chmm.hmmone.priors.Dir3d_alpha,...
		    chmm.hmmtwo.priors.Dir3d_alpha,[2 3]),K_cart,K_cart) ;
chmm.priors.Dir_alpha=...
    reshape(chmm.hmmone.priors.Dir_alpha'*chmm.hmmtwo.priors.Dir_alpha,...
	    1,K_cart);

% The transition probabilities have the following form
%
% P_cart=P(S_t|S_t')=P(next state | current state) = 
%{Sa,Sb}_t|{Sa,Sb}_t';{Sa,Sb}_t|{~Sa,Sb}_t';{Sa,Sb}_t|{Sa,~Sb}_t';{Sa,Sb}_t|{~Sa,~Sb}_t'
%{~Sa,Sb}_t|   ,,    ;{~Sa,Sb}_t|    ,,    ;{~Sa,Sb}_t|   ,,     ;{~Sa,Sb}_t|    ,,      
%{Sa,~Sb}_t|   ,,    ;{Sa,~Sb}_t|    ,,    ;{Sa,~Sb}_t|   ,,     ;{Sa,~Sb}_t|    ,,      
%{~Sa,~Sb}_t|  ,,    ;{~Sa,~Sb}_t|   ,,    ;{~Sa,~Sb}_t|  ,,     ;{~Sa,~Sb}_t|   ,,      
%




for cycle=1:cyc
   
  %%%% FORWARD-BACKWARD 
  
  Gamma.joint=[];								   
  Gamma.hmmone=[];
  Gamma.hmmtwo=[];
  Gammasum.joint=zeros(1,K_cart);
  Gammasum.hmmone=zeros(1,K(1));
  Gammasum.hmmtwo=zeros(1,K(2));
  Scale=zeros(T,1);
  Xi=zeros(T-1,K_cart,K_cart);

  for n=1:N
    
    Bone = obslike(X,T,n,chmm.hmmone);
    Btwo = obslike(Y,T,n,chmm.hmmtwo);	

    % Augmenting
    for i=1:T,
       Btemp=Bone(i,:)'*ones(1,K(2)); 
       Bcompone(i,:)=reshape(Btemp,1,K_cart); % P(Sa,~Sa,Sa,~Sa);
       Btemp=ones(1,K(1))'*Btwo(i,:); 
       Bcomptwo(i,:)=reshape(Btemp,1,K_cart); % P(Sb,Sb,~Sb,~Sb);
       % Bcompone.* Bcomptwo  <=>  P({Sa,Sb},{~Sa,Sb},{Sa,~Sb},{~Sa,Sb})
    end;
    % alpha <=>  P(O,{Sa,Sb},{~Sa,Sb},{Sa,~Sb},{~Sa,Sb})
    scale=zeros(T,1);								    
    alpha(1,:)=Pi_cart.*[Bcompone(1,:).* Bcomptwo(1,:)];
    scale(1,:)=sum(alpha(1,:));
    alpha(1,:)=alpha(1,:)/scale(1);

    for i=2:T
      % alpha(i,:)=(alpha(i-1,:)*P_cart).*[Bcompone(i,:).*Bcomptwo(i,:)];
      alpha(i,:)=([P_cart*alpha(i-1,:)']').*[Bcompone(i,:).*Bcomptwo(i,:)];
      scale(i)=sum(alpha(i,:));
      alpha(i,:)=alpha(i,:)/scale(i);
    end;

    beta(T,:)=ones(1,K_cart)/scale(T);						   
    for i=T-1:-1:1
        beta(i,:)=(beta(i+1,:).*...
 		  [Bcompone(i+1,:).*Bcomptwo(i+1,:)])*(P_cart)/scale(i); 
	%
        % beta(i,:)=(beta(i+1,:).*[Bcompone(i+1,:).*Bcomptwo(i+1,:)])*(Pcart')/scale(i);
    end;
    
    gamma.joint=(alpha.*beta); 
    gamma.joint=mddiv(gamma.joint,sum(gamma.joint,2),2); % sum over states
    gammasum.joint=sum(gamma.joint,1);	% sum over time for each state
    
    gamma.hmmone=squeeze(sum(reshape(gamma.joint,T,K(1),K(2)),3));
    gammasum.hmmone=sum(gamma.hmmone,1);
    gamma.hmmtwo=squeeze(sum(reshape(gamma.joint,T,K(1),K(2)),2));
    gammasum.hmmtwo=sum(gamma.hmmtwo,1);
    
    xi=zeros(T-1,K_cart,K_cart);
    for i=1:T-1  
      % t=P_cart.*( alpha(i,:)' * (beta(i+1,:).*[Bcompone(i+1,:).*Bcomptwo(i+1,:)]));
      t=P_cart.*((beta(i+1,:).*[Bcompone(i+1,:).*Bcomptwo(i+1,:)])'*alpha(i,:));
      xi(i,:,:)=t./sum(t(:));
    end;
    
    Scale=Scale+log(scale);
    Gamma.joint=[Gamma.joint; gamma.joint];
    Gammasum.joint=Gammasum.joint+gammasum.joint;
    Gamma.hmmone=[Gamma.hmmone; gamma.hmmone];
    Gammasum.hmmone=Gammasum.hmmone+gammasum.hmmone;
    Gamma.hmmtwo=[Gamma.hmmtwo; gamma.hmmtwo];
    Gammasum.hmmtwo=Gammasum.hmmtwo+gammasum.hmmtwo;

    Xi=Xi+xi;
  end;

  %  evaluate likelihood and priors 
  oldlpost=lpost;
  lik=sum(Scale);
  lprior=evalmodelprior(chmm.hmmone);	% compute parameter pops under priors
  lprior=[lprior evalmodelprior(chmm.hmmtwo)]; % for both chains

  
  % Transition Props and props of first state node
  lprior=[lprior dirichlet(Pi_cart,chmm.priors.Dir_alpha,1)];
  for l=1:K,
    lprior=[lprior dirichlet(P_cart(:,l),chmm.priors.Dir2d_alpha(:,l),1)];
  end;
  lpost=(lik+sum(lprior));		% log posterior
  LP=[LP; lik lprior];

%%%% M STEP 
  
  % transition matrix 
  sxi=squeeze(sum(Xi,1));                  % sum over time
  if updatep
    sxi=sxi+(chmm.priors.Dir2d_alpha-1);
    P_cart=mddiv(sxi,sum(sxi,1),1);        % normalise over future state
  end

  % priors
  Pi_cart=zeros(1,K_cart);
  for i=1:N
    Pi_cart=Pi_cart+Gamma.joint((i-1)*T+1,:);
  end
  Pi_cart=Pi_cart+chmm.priors.Dir_alpha-1;
  Pi_cart=Pi_cart./sum(Pi_cart);
  
  Pi.hmmone=sum(reshape(Pi_cart,K(1),K(2)),2)';
  Pi.hmmtwo=sum(reshape(Pi_cart,K(1),K(2)),1);


  % Observation model
  if sum(updateobs.hmmone) > 0
    chmm.hmmone=obsupdate(X,T,Gamma.hmmone,Gammasum.hmmone,chmm.hmmone,updateobs.hmmone);
  end
  if sum(updateobs.hmmtwo) > 0
    chmm.hmmtwo=obsupdate(Y,T,Gamma.hmmtwo,Gammasum.hmmtwo,chmm.hmmtwo,updateobs.hmmtwo);
  end
  
  fprintf('cycle %i log posterior = %f ',cycle,lpost);  
  if (cycle<=2)
    lpostbase=lpost;
  elseif (lpost<oldlpost) 
    fprintf('violation');
  elseif ((lpost-lpostbase)<(1 + tol)*(oldlpost-lpostbase)|~finite(lpost)) 
    fprintf('\n');
    break;
  end;
  fprintf('\n');
end


chmm.hmmone.P=squeeze(sum(reshape(P_cart,K(1),K(2),K(1),K(2)),2));
chmm.hmmtwo.P=squeeze(sum(reshape(P_cart,K(1),K(2),K(1),K(2)),1));
chmm.hmmone.Pi=Pi.hmmone;
chmm.hmmtwo.Pi=Pi.hmmtwo;
chmm.P=P_cart;
chmm.Pi=Pi_cart;
chmm.K=K_cart;

chmm.LPtrain=lpost;

chmm.data.Xtrain=X;
chmm.data.Ytrain=Y;
chmm.data.T=T;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [chmm,N,K,traininit,updateobs,updatep,P,Pi]=paramchk(chmm,X,Y,T)

%
% Copy in and check existence of parameters for chmm data structure
%
% Input chmm, data series X and Y 
%
% Output params: 
%        params(1) = p	; time-series Dimension
%        N	; time-series length
%	 K		; dimension of state-space
%	 traininit	; initialisation flag
%	 P		; transition probabilities


% The first hmm chain
[chmm.hmmone,params.hmmone]=scparamchk(chmm.hmmone,X);
% Now the second hmm chain
[chmm.hmmtwo,params.hmmtwo]=scparamchk(chmm.hmmtwo,Y);


% consistency check for the 2 chains
if params.hmmone.N~=params.hmmtwo.N
	error('Time series must be of equal length');
else
   N=params.hmmone.N;
end

% hidden states
K=[params.hmmone.K; params.hmmtwo.K];

% training initialisation
traininit.hmmone=params.hmmone.init;
traininit.hmmtwo=params.hmmtwo.init;

% transition matrices
if params.hmmone.P==-1, 
 P.hmmone=rand(K(1),K(1),K(2));
 P.hmmone=mddiv(P.hmmone,sum(P.hmmone,1),1);
else 
 P.hmmone=chmm.hmmone.P;
end;
if params.hmmtwo.P==-1, 
 P.hmmtwo=rand(K(2),K(1),K(2));
 P.hmmtwo=mddiv(P.hmmtwo,sum(P.hmmtwo,1),1);
else 
 P.hmmtwo=chmm.hmmtwo.P;
end;

% update observation models
updateobs.hmmone=params.hmmone.updateobs;
updateobs.hmmtwo=params.hmmtwo.updateobs;

% update state transition prop.
if (params.hmmone.updatep ~= params.hmmtwo.updatep),
  error('Transition Probabilities must be updated jointly');
end;
updatep=params.hmmone.updatep;


% prior
Pi.hmmone=params.hmmone.Pi;
Pi.hmmtwo=params.hmmtwo.Pi;


if (rem(N,T)~=0)
  error('Data matrix length must be multiple of sequence length T');
  return;
end;
N=N/T;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hmm,params]=scparamchk(hmm,X)

% function [hmm,params]=scparamchk(hmm,X)
%
% Copy in and check existence of parameters for single chain hmm data structure
%
% Input hmm
%
% Output params: 
%        params.p	; time-series Dimension
%        params.N	; time-series length
%	 params.K	; dimension of state-space
%	 params.traininit	; initialisation flag
%	 params.obsupdate	; update observation model
%	 params.pupdatep	; update state transition matrix
%	 params.P	; transition probabilities
%        params.Pi	; initial state probabilities

if ~isfield(hmm,'obsmodel')
  disp('Error in hmm_train: obsmodel not specified');
  return
end

params.p=length(X(1,:));
params.N=length(X(:,1));

if isfield(hmm,'K')
  params.K=hmm.K;
else
  disp('Error in hmmtrain: K not specified');
  return
end

if ~isfield(hmm,'train')
  disp('Error in hmmtrain: hmm.train not specified');
  return
end

if ~isfield(hmm.train,'init')
  params.init=0;
else
  params.init=hmm.train.init;
end

if ~isfield(hmm.train,'obsupdate')
  params.updateobs=ones(1,hmm.K);  % update observation models for all states
else
  params.updateobs=hmm.train.obsupdate;
end

if ~isfield(hmm.train,'pupdate')
  params.updatep=1;
else
  params.updatep=hmm.train.pupdate;
end



if ~isfield(hmm,'P')
%  P=rand(hmm.K,hmm.K,hmm.K);
%  params(7)=mddiv(P,mdsum(P,dim),dim);
   params.P=-1;			% must be done outside
else				% need info from other chain
  params.P=1;
end

if ~isfield(hmm,'Pi')
   params.Pi=rand(1,hmm.K);
   params.Pi=params.Pi./sum(params.Pi);
else
   params.Pi=hmm.Pi;
end;

if ~params.init,
  hmm=obsinit(X,hmm);
end;
