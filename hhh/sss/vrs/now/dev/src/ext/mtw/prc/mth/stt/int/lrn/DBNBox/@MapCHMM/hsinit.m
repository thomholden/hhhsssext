function [chmm] = hsinit (chmm,varargin)
% function [chmm] = hsinit (chmm,K,txmodeloptions,priors)
% Initialise  CHMM Chain's hidden state paramaters
%
% chmm	chmm data structure
% 
%


% initialise state transition model
switch chmm.train.inftype,
 case 'forwback'
  chmm.chschain=FwBwCHMM(chmm.LagOpSpec,chmm.K);
  chmm.train.checkviol=1;
 case 'gibbs'
  chmm.chschain=GibbsCHMM(chmm.LagOpSpec,chmm.K,chmm.train.NSamp);
  chmm.train.checkviol=0;
 case 'meanfield'
  chmm.chschain=MFCHMM(chmm.LagOpSpec,chmm.K,chmm.train.NSweep);
  chmm.train.checkviol=1;
 case 'meanfieldchains'
  [chmm.LagOpSpec,flag]=sortLagOpSpec(chmm.LagOpSpec);
  if flag,
    warning(sprintf('%s \n %s','Found multiple parents in native chain',...
		    'MF of Chains assumes 1st order Markov property for each chain'));
  end
  chmm.chschain=MFChainCHMM(chmm.LagOpSpec,chmm.K,chmm.train.NSweep);
  chmm.train.checkviol=1;
 otherwise
  error(sprintf('Unknown Inference model %s',chmm.train.inftype));
end


  
