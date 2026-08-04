function [block]=decode(chmm,varargin)
% function [block]=decode(chmm,Xtrain,T)
%
% Find best state sequence in Coupled Hidden Markov Model
%
% Xtrain             - cell array containting N x p data matrix 
% T                  - length of each sequence (N must evenly divide by
%                      T, default T=N)
% chmm               - chmm object
%
%
% block().q_star    maximum probability state sequence 
% block().gamma     the posterior: p(q_t=i given X)
% block().delta     proby of each previous state
% block().psi       most likely pre-cursor state


% Copy in and check existence of parameters from hmm data structure
% Begin with common stuff

if length(varargin)<1
  error('Require Training Data');
else
  Xtrain=varargin{1};
  if length(varargin)==2,
    T=varargin{2};
  end
end


% training data
if length(Xtrain)~=chmm.NChains
  error(sprintf('Need %d sets of training data',chmm.NChains));
end

% prepare data for training, depending on observation model
[Xtrain,Nb,T] = initXtrain (chmm,varargin{:});


chmm=hsdecode(chmm,Xtrain,T);
block=gethspar(chmm,'decode');


