function [Delta,Psi,Q_star,Likv,Lik_best]=mfchainvit(chschain,Gamma,pXi,B)
% The actual sampling of the chains using indiscrimant mean field assumption
%
% B     Data likelihood
% Gamma    Marginal of hidden states
% pXi      pair-wise marginal of states
%
% Output
%

C=chschain.NChains;
K=chschain.K;
Pi=chschain.Pi;

Delta=cell(C,1);
Psi=cell(C,1);
Q_star=[];
Likv=zeros(C,1);
Lik_best=zeros(C,1);

[P,B]=marginalchain(chschain,Gamma,pXi,B);              % find marginal chains

for c=1:C,
  L=cat(1,B{:,c});
  [delta,psi,q_star,likv,lik_best]=viterbi(P(:,c),Pi{c},K(c),L);
  Delta{c}=delta;
  Psi{c}=psi;
  Q_star=cat(2,Q_star,q_star);
  Likv(c)=likv;
  Lik_best(c)=lik_best;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P,L]=marginalchain(chschain,Gamma,pXi,B);
LagOp=chschain.LagOp;
K=chschain.K;
TxP=chschain.P;
C=chschain.NChains;

T=length(B);				% size(B,1); State Chain length
Topo=[T,C];				% topology
P=cell(Topo);                           % transition P at each time step
L=cell(Topo);                           % likelihoods


% generic curcluar index which increments chains first
t=SpaceTime(T,C,'Ccyclic');	
% number of sweeps
% reset to beginning;
t=reset(t);				
% loop until 1 complete sweep over T&C
while ~ending(t),		
    
  % integrate out neighbouring chains first
  [curP,curL]=marginchain(LagOp,TxP,K,Gamma,pXi,t);
  % combine with last piece of evidence
  curL=curL.*reshape(B{t.tc},K(t.ch),1);	% give total likelihood;

  P{t.tc}=curP';                        % viterbi uses transpose
  L{t.tc}=curL';
  
  t=next(t);				% who's next?
end					% while ~ending(t)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function [delta,psi,q_star,likv,lik_best]=viterbi(P,Pi,K,B);
% Find optimal Viterbi state sequence
  

T=length(B);			% size(B,1); State Chain length

tiny=exp(-700);


% Initialise Viterbi bits
delta=zeros(T,K);
psi=zeros(T,K);
scale=zeros(T,1);
dscale=zeros(T,1);			% Scaling for delta
q_star=zeros(T,1);

alpha(1,:)=Pi.*B(1,:);
scale(1)=sum(alpha(1,:)); 
alpha(1,:)=alpha(1,:)/(scale(1)+tiny);
% For viterbi decoding
delta(1,:) = alpha(1,:);    % Eq. 32(a) Rabiner (1989)
% $$$  Eq. 32(b) Psi already zero
for i=2:T
  alpha(i,:)=(alpha(i-1,:)*P{i}).*B(i,:);
  scale(i)=sum(alpha(i,:));
  alpha(i,:)=alpha(i,:)/(scale(i)+tiny);
  
  for k=1:K,
    v=delta(i-1,:).*P{i}(:,k)';
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

