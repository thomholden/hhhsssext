function [chschain]=initbeliefs(chschain,B);
% Initialise the beliefs
%
% B     Data likelihood
%
% Output
%
% Gamma    Marginal of hidden states
% Xi       Pairwise marginal of states

K=chschain.K;

for n=1:length(B.block),
  L = B.block(n).L;
  [Gamma,Xi,S]=initsingchabel(K,chschain.LagOpSpec,L);
  chschain.Gamma.block{n}=Gamma;
  chschain.Xi.block{n}=Xi;
  chschain.S.block{n}=S;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Gamma,Xi,S]=initsingchabel(K,LagOpSpec,B)
% initialises beliefs for each block

[T,C]=size(B);				% topology

Xi=cell(T,C);				% joint marginals
Gamma=cell(0);				% marginals: empty for concat.

for c=1:C,				% initialise
  initarray=zeros(K(c),1);
  Gamma(:,c)=repmat({initarray},T,1);

  sv=[K(c),K(LagOpSpec{c}(2,:))];
  initarray=ones(sv)./prod(sv(:));
  Xi(:,c)=repmat({initarray},T,1);

  initgam=cat(1,B{:,c});		% use likelihood for init
  initgam=rdiv(initgam,rsum(initgam));
  [junk,S(:,c)]=max(initgam,[],2);
end
