function [delta,psi,q_star,likv,lik_best]=viterbi(hschain,B);
% Find optimal Viterbi state sequence

Pi=hschain.Pi;
P=hschain.P;
K=hschain.K;

T=length(B);			% size(B,1); State Chain length

tiny=exp(-700);

% Initialise Viterbi bits
delta=zeros(T,K);
psi=zeros(T,K);
scale=zeros(T,1);
dscale=zeros(T,1);			% Scaling for delta

alpha(1,:)=Pi.*B(1,:);
scale(1)=sum(alpha(1,:)); 
alpha(1,:)=alpha(1,:)/(scale(1)+tiny);
% For viterbi decoding
delta(1,:) = alpha(1,:);    % Eq. 32(a) Rabiner (1989)
% $$$  Eq. 32(b) Psi already zero
for i=2:T
  alpha(i,:)=(alpha(i-1,:)*P).*B(i,:);
  scale(i)=sum(alpha(i,:));
  alpha(i,:)=alpha(i,:)/(scale(i)+tiny);
  
  for k=1:K,
    v=delta(i-1,:).*P(:,k)';
    mv=max(v);
    delta(i,k)=mv*B(i,k);  % Eq 33a Rabiner (1989)
    if length(find(v==mv)) > 1
      % no unique maximum - so pick one at random
      tmp1=find(v==mv);
      tmp2=rand(length(tmp1),1);
      [tmp3,tmp4]=max(tmp2);
      psi(i,k)=tmp4;
    else      
      psi(i,k)=find(v==mv);  % ARGMAX; Eq 33b Rabiner (1989)
    end
  end;
  
  % SCALING FOR DELTA ????
  dscale(i)=sum(delta(i,:));
  delta(i,:)=delta(i,:)/(dscale(i)+tiny);
  
end;

likv=sum(log(scale+(scale==0)*tiny));
lik_best=sum(log(dscale+(dscale==0)*tiny));

% Backtracking for Viterbi decoding
q_star(T)=find(delta(T,:)==max(delta(T,:)));% Eq 34b Rabiner;
for i=T-1:-1:1,
  q_star(i) = psi(i+1,q_star(i+1));
end
