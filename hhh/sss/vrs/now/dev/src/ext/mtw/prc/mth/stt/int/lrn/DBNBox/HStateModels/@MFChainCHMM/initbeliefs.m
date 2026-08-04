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
  [Gamma,Xi,pXi]=initsingchabel(K,chschain.LagOpSpec,L);
  chschain.Gamma.block{n}=Gamma;
  chschain.Xi.block{n}=Xi;
  chschain.pXi.block{n}=pXi;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Gamma,Xi,pXi]=initsingchabel(K,LagOpSpec,B)
% initialises beliefs for each block

[T,C]=size(B);				% topology

Xi=cell(T,C);				% joint marginals
pXi=cell(T,C);				% joint pairwise marginals
Gamma=cell(0);				% marginals: empty for concat.

for c=1:C,				% initialise
  initgam=cat(1,B{:,c});		% use likelihood for init
  initgam=rdiv(initgam,rsum(initgam));
  Gamma=cat(2,Gamma,num2cell(initgam',1)');
  sv=[K(c),K(LagOpSpec{c}(2,:))];
  initarray=ones(sv)./prod(sv(:));
  Xi(:,c)=repmat({initarray},T,1);
  initarray=ones([K(c),K(c)]);
  initarray=initarray./sum(initarray(:));
  pXi(:,c)=repmat({initarray},T,1);
end
