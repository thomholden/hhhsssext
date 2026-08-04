function [chmm]=hsdecode(chmm,Xtrain,T)
% [varargout]=hsdecode(chmm,Xtrain,T) 
% 
% inference of hidden states in  CHMMs
% 
% INPUT
%
% Xtrain    observation sequence
% T         lengths of individual blocks
% chmm      chmm data structure
%
% OUTPUT in case of forward-backward and gibbs sampling 
% 
% chmm      chmm data structrue
% 



for n=1:length(T)
  LL=cell(0);
  for c=1:chmm.NChains
    if n==1,				% P's doen't change in each block
      % get transition probs and intial probs
      P{c}=getchain(chmm,c,'txmodel','P');
      Pi{c}=getchain(chmm,c,'txmodel','Pi');
    end
    % get likelihood 
    L=obslike(chmm,c,Xtrain(c),n)+eps;
    LL=cat(2,LL,num2cell(L,2));
    B.block(n).L=LL;
  end
end

% update hidden state chain
chmm=sethspar(chmm,'P',P);
chmm=sethspar(chmm,'Pi',Pi);

chmm.chschain=decode(chmm.chschain,B);
 
 
 
