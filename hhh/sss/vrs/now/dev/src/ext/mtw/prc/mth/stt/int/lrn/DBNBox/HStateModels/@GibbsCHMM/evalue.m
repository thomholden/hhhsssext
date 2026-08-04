function [Entr] = evalue (chschain,T);
% [Entr] = evalue (chschain,T);
%
% Computes the Free Energy of the state chain part of (C)HMM
% 
% INPUT
% chschain   Chschains object with values of Gamma and Xi
% T      lengths of individual blocks
%
% OUTPUT
%  Entr       entropy of hidden states
%

[Gamma,Xi]=getbeliefs(chschain);    % get messages first

T=cumsum([0 T(1:end-1)])+1;			% indeces of block onset
Entr=zeros(1,chschain.NChains);
for c=1:chschain.NChains,
  Entr(c)=evalsinglechain(Gamma{c},Xi{c},T);
end
Entr=sum(Entr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Entr]=evalsinglechain(Gamma,Xi,T);
% compute entropy of one of the coupled chains
% one chain
% Gamma    Hidden state marginal distributions
% Xi       Hidden state joint marginal distributions
% T        index of onset of individual blocks


K=size(Gamma,2);


% Entropy of initial state
T0=length(T);			% number of blocks 
T0Gamma=Gamma(T(:),:);
T0Gamma=T0Gamma(find(T0Gamma~=0));
Entr=sum(sum(T0Gamma.*log(T0Gamma)));	% Entropy of intial states

% Entropy of transitions: easiest done by reshaping
xisv=size(Xi); 
Xi=reshape(Xi,[xisv(1),xisv(2),prod(xisv(3:end))]);
xisv=size(Xi);                    % new size vector

cXi=zeros(size(Xi));			% will be P(S_t|parents(S_t))
for k=1:K,
  sXi=squeeze(sum(Xi(:,k,:),3));        % normalising constant for conditional
  ndx=find(sXi~=0);			% avoid division by zero
  if ~isempty(ndx),
     cXi(ndx,k,:)=Xi(ndx,k,:)./repmat(sXi(ndx),[1,1,xisv(end)]);
  end;
end;

ndx=find(cXi(:)~=0);
if ~isempty(ndx)
  Entr=Entr+sum(Xi(ndx).*log(cXi(ndx)),1);% entropy of hidden states
end
