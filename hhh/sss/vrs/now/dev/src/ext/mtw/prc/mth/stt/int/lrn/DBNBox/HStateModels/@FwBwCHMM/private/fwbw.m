function [Gamma,Xi,scale]=fwbw(hschain,B)
% Forward backward recursions which assume a single chain
% Input
% B     Data likelihood
% Output
% Gamma    Marginal of hidden states
% Gammasum Expectation over time of hidden state marginals
% Xi       Pairwise marginal of states
% scale    normalising constant of hidden states

Pi=hschain.Pi;
P=hschain.P;
K=hschain.K;
T=length(B);			% size(B,1); State Chain length

scale=zeros(T,1);
alpha=zeros(T,K);
beta=zeros(T,K);
Xi=zeros(T-1,K,K);
Gamma=zeros(T,K);


alpha(1,:)=Pi.*B(1,:);
scale(1)=sum(alpha(1,:));
if scale(1)==0,
  error(sprintf('Normalisation constant in forward iteration %d is zero',1));
end

% forward iterations
alpha(1,:)=alpha(1,:)/scale(1);
for i=2:T
  alpha(i,:)=(alpha(i-1,:)*P).*B(i,:);
  scale(i)=sum(alpha(i,:));		% P(X_i | X_1 ... X_{i-1})
  if scale(i)==0,
    error(sprintf('Normalisation constant in forward iteration %d is zero',i));
  end
  alpha(i,:)=alpha(i,:)/scale(i);
end;

beta(T,:)=ones(1,K)/scale(T);
t=alpha(T,:).*beta(T,:);
Gamma(T,:)=t./sum(t);
for i=T-1:-1:1
  % compute beta/ backward variable
  beta(i,:)=(beta(i+1,:).*B(i+1,:))*(P')/scale(i); 
  % compute Xi/ joint marginals
  t=P.*( alpha(i,:)' * (beta(i+1,:).*B(i+1,:)));
  Xi(i,:,:)=t./sum(t(:));
  % compute Gamma/ single marginals
  t=alpha(i,:).*beta(i,:);
  Gamma(i,:)=t./sum(t);
end;

Xi=permute(Xi,[1 3 2]);
