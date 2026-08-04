function [Gamma,Xi]=mfprop(chschain,Gamma,Xi,B)
% The actual sampling of the chains using indiscrimant mean field assumption
%
% B     Data likelihood
% Gamma    Marginal of hidden states from previous iterations
% Xi       Pairwise marginal of states from previous iterations
%
% Output
%
% Gamma    Marginal of hidden states
% Xi       Pairwise marginal of states

C=chschain.NChains;
LagOp=chschain.LagOp;
K=chschain.K;
TxP=chschain.P;
Pi=chschain.Pi;

T=length(B);				% size(B,1); State Chain length
Topo=[T,C];				% topology


%%%%% Now the propagation
% Description: t is a cyclic index, i.e. it implements cyclic boundary
% conditions , so that a neg. time index t are mapped to postitive T-t 
% LagOp is used to calculate indeces of markov blanket (MB)
% the values of the MB state space variables are used to construct an
% evaluation string to pick the right array elements.
% The  probabability conditional on the MB is calcuated by 
% marginalisation of the MB


% Note, the MF assumes  transition probabilites which don't change
% dimensionality, so TxP below is only selected for each chain. Allowing for
% separate initial state probabilites needs SpaceTime indeces to be linear 
% and more changes to core
t=SpaceTime(T,C,'Tcyclic');		% generic circular index
for ns=1:chschain.NSweep,		% number of sweeps
  t=reset(t);				% reset to beginning;
  while ~ending(t),			% loop until 1 sweep over T&C completed
    P=TxP{t.ch};
    L=reshape(B{t.tc},K(t.ch),1);	% likelihood;
    parents=LagOp*t;			% get parents
    pndxvec=[];				% indeces over which to integrate
    for p=1:length(parents),
      pndx=parents{p};			% parent time/chain index
      pndxvec=cat(2,pndxvec,p+1);
      P=mdvecprod(P,Gamma{pndx.tc},pndxvec(end),0); % multiply/no integration
    end
    Ppast=mdsum(P,pndxvec);		% now integrate out and keep as separate
    Pfut=L;				% P(obs|S)
    children=inv(LagOp)*t;
    for c=1:length(children),
      cndx=children{c};
      cP=TxP{cndx.ch};			% transition prob to child
      childparents=LagOp*cndx;		% childrens' parents
      cpndxvec=[1];			% indeces over which to integrat
      cP=mdvecprod(cP,Gamma{cndx.tc},cpndxvec(end),0);
      for cp=1:length(childparents),
	cpndx=childparents{cp};		% childrens' parents  time/chain index
	if ~(cpndx==t),			% parent is current state
	  cpndxvec=cat(2,cpndxvec,cp+1);
	  cP=mdvecprod(cP,Gamma{cpndx.tc},cpndxvec(end),0);
	end
      end
      cP=mdsum(cP,cpndxvec);		% now integrate out
      Pfut=Pfut.*reshape(cP,K(t.ch),1);
    end
    P=Ppast.*Pfut;         % combine past with future
    P=P./sum(P);			% renormalise
    Gamma{t.tc}=P;			% mean field marginal
    xi=P;				% now joint
    for p=1:length(parents),
      pndx=parents{p};			% parent time/chain index
      xi=kron(Gamma{pndx.tc},xi);	% outer product
    end
    xi=xi./sum(xi(:));			% normalise
    Xi{t.tc}=reshape(xi,size(Xi{t.tc}));% save
    t=next(t);				% who's next?
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P]=mdvecprod(P,Pi,Dim,mflag);
% [P]=mdvecprod(P,Pi,Dim,mflag);
%
% multiply a MD array by a vector along dimension Dim  
% with optional marginalisation over dimension Dim


sv=size(P);
p=reshape(1:prod(size(P)),size(P));

pv1=setdiff(1:ndims(P),Dim);
pv2=Dim;
pv=[pv1 pv2];
pp=permute(p,pv);
ppp=reshape(pp,prod(sv(pv1)),prod(sv(pv2)));
P(ppp)=P(ppp).*repmat(Pi(:)',size(ppp,1),1);

%and if marginal
if nargin<4 | mflag,
  P=squeeze(sum(P,Dim));
end

