function [txmodel]=update(txmodel,Xi,Gamma,T,varargin)
% [txmodel]=update(txmodel,Xi,Gamma,T)
% updates hidden state parameters of an TXMODEL
% 
% INPUT:
%
% Xi     probability of past and future state cond. on data
% Gamma  probability of current state cond. on data
% K      state space dimension
% T      lengths of individual blocks
% txmodel    single txmodel data structure
%
% OUTPUT
% txmodel    single txmodel data structure with updated state model probs.


implement=1;

switch implement
 case 1
  [txmodel]=update1(txmodel,Xi,Gamma,T);
 case 2
  [txmodel]=update2(txmodel,Xi,Gamma,T);
end
  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [txmodel]=update1(txmodel,Xi,Gamma,T)
% [txmodel]=update(txmodel,Xi,Gamma,T)
% updates hidden state parameters of an TXMODEL by computing the incomplete conditionals
% directly
%
% INPUT:
%
% Xi     probability of past and future state cond. on data
% Gamma  probability of current state cond. on data
% K      state space dimension
% T      lengths of individual blocks
% txmodel    single txmodel data structure
%
% OUTPUT
% txmodel    single txmodel data structure with updated state model probs.

K=[txmodel.K(1) prod(txmodel.K(2:end))];% MD -> 2-D for loop

% transition matrix 
sxi=squeeze(sum(Xi,1));   		% counts over time
sxi=reshape(sxi,K);			% make 2-dimensional

pr=txmodel.prior;			% tmp var for reshape
pr.Dir_alpha=reshape(pr.Dir_alpha,K);

Dir_alpha=sxi+pr.Dir_alpha;
for p=1:K(2),
  PsiSum=digamma(sum(Dir_alpha(:,p)));
  for n=1:K(1),
    P(n,p)=digamma(Dir_alpha(n,p))-PsiSum;
  end;
end;
P=exp(P);
txmodel.Dir_alpha=reshape(Dir_alpha,txmodel.K); % ret. 2 normal
P=cdiv(P,csum(P));
txmodel.P=reshape(P,txmodel.K);


T=cumsum([0 T(1:end-1)])+1;			% indeces of block onset

% intial state
txmodel.Dir1d_alpha=txmodel.prior.Dir1d_alpha;
txmodel.Dir1d_alpha=txmodel.Dir1d_alpha+sum(Gamma(T(:),:),1);

PsiSum=digamma(sum(txmodel.Dir1d_alpha,2));
for i=1:K(1),
  Pi(i)=exp(digamma(txmodel.Dir1d_alpha(i))-PsiSum);
end
txmodel.Pi=Pi./sum(Pi);
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [txmodel]=update2(txmodel,Xi,Gamma,T);
% [txmodel]=update(txmodel,Xi,Gamma,T)
% updates hidden state parameters of an TXMODEL by computing the incomplete joint
% and from that the approximate conditional
%
% INPUT:
%
% Xi     probability of past and future state cond. on data
% Gamma  probability of current state cond. on data
% K      state space dimension
% T      lengths of individual blocks
% txmodel    single txmodel data structure
%
% OUTPUT
% txmodel    single txmodel data structure with updated state model probs.


% transition matrix 
sxi=squeeze(sum(Xi,1));   		% counts over time
txmodel.Dir_alpha=sxi+txmodel.prior.Dir_alpha;% posterior alpha

K=[txmodel.K(1) prod(txmodel.K(2:end))];% MD -> 2-D for loop

% computing joint probablity from posterior params
vDir=txmodel.Dir_alpha(:);		% rehape to vector
lD=length(vDir);			% number of elements
P=zeros(lD,1);				% joint prob
PsiSum=digamma(sum(vDir)); 		% normalising const
for k=1:lD,
    P(k)=digamma(vDir(k))-PsiSum;
end;
P=exp(P);
P=P./sum(P(:)); 
P=reshape(P,[txmodel.K(1) prod(txmodel.K(2:end))]);% -> 2-D for loop
P=cdiv(P,csum(P));
txmodel.P=reshape(P,txmodel.K);		% reshape to normal


T=cumsum([0 T(1:end-1)])+1;			% indeces of block onset

% intial state
txmodel.Dir1d_alpha=txmodel.prior.Dir1d_alpha+sum(Gamma(T(:),:),1);

PsiSum=digamma(sum(txmodel.Dir1d_alpha,2));
for i=1:K(1),
  Pi(i)=exp(digamma(txmodel.Dir1d_alpha(i))-PsiSum);
end
txmodel.Pi=Pi./sum(Pi);
  
