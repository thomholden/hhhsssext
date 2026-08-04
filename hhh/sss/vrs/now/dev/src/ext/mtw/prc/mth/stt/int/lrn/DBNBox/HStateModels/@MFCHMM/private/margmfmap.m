function [S]=margmfmap(chschain,Gamma,B)
% The actual sampling of the chains using indiscrimant mean field assumption
%
% B     Data likelihood
% Gamma    Marginal of hidden states from previous iterations
%
% Output
%
% S        State squence
%


C=chschain.NChains;
LagOp=chschain.LagOp;
K=chschain.K;
TxP=chschain.P;
Pi=chschain.Pi;

T=length(B);				% size(B,1); State Chain length
Topo=[T,C];				% topology

S=zeros(Topo);                          % Value of state 


t=SpaceTime(T,C,'Tcyclic');		% generic circular index
for ns=1:chschain.NSweep,		% number of sweeps
  t=reset(t);				% reset to beginning;
  while ~ending(t),			% loop until 1 sweep over T&C completed
    P=log(TxP{t.ch});
    L=log(reshape(B{t.tc},K(t.ch),1));	% likelihood;
    parents=LagOp*t;			% get parents
    pndxvec=[];				% indeces over which to integrate
    for p=1:length(parents),
      pndx=parents{p};			% parent time/chain index
      pndxvec=cat(2,pndxvec,p+1);
      P=mdvecprod(P,Gamma{pndx.tc},pndxvec(end),0); % multiply/no integration
    end
    Ppast=mdsum(P,pndxvec);			% now integrate out and keep separate
    Pfut=L;				                        % P(obs|S)
    children=inv(LagOp)*t;
    for c=1:length(children),
      cndx=children{c};
      cP=log(TxP{cndx.ch});			% transition prob to child
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
    P=epx(Ppast.*Pfut);          % combine future with past
    P=P./sum(P);			% renormalise
    Gamma{t.tc}=P;			% mean field marginal
    [Pm,S(t.tc)]=max(P);
    t=next(t);				% who's next?
  end;					% while ~ending(t)
end;					% sweep

