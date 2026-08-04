function [hmm]=inithsbeliefs(hmm,Xtrain,T)
% [varargout]=inithsbeliefs(hmm,Xtrain,T) 
% 
% initialise hidden state variables in HMMs
% 
% INPUT
%
% Xtrain    observation sequence
% T         lengths of individual blocks
% hmm      hmm data structure
%
% OUTPUT in case of forward-backward and gibbs sampling 
% 
% hmm      hmm data structrue
% 

for n=1:length(T)
  LL=cell(0);
  if n==1,				% P's doen't change in each block
      % get transition probs and intial probs
      P{1}=gettxpar(hmm,'P');
      Pi{1}=gettxpar(hmm,'Pi');
  end
  % get likelihood 
  L=obslike(hmm,Xtrain,n);
  LL=cat(2,LL,num2cell(L,2));
  B.block(n).L=LL;
end

% update hidden state chain
hmm=sethspar(hmm,'P',P);
hmm=sethspar(hmm,'Pi',Pi);

[hmm.hschain]=initbeliefs(hmm.hschain,B);
 
 
 
