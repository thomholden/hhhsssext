function [hmm] = hsinit (hmm,varargin)
% function [hmm] = hsinit (hmm,K,txmodeloptions,priors)
% Initialise  HMM Chain's hidden state inference engine
%
% hmm	hmm data structure
% 
%

% initialise state transition model
switch hmm.train.inftype,
 case 'forwback'
  hmm.hschain=FwBwCHMM({[-1;1]},hmm.K);
 otherwise
  error(sprintf('Unknown Inference model %s',hmm.train.inftype));
end

  
