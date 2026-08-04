function [hmm,FrEntrain]=train(hmm,varargin)
% function [hmm,FrEn]=train(hmm,X,T)
%
% Train Hidden Markov Model 
%
% INPUTS:
%
% X - N x p data matrix
% T - length of each sequence (N must evenly divide by T, default T=N)
% hmm  - hidden markov model object
%
% OUTPUTS
% hmm - updated hidden markov model object
%


% Copy in and check existence of parameters from hmm data structure

if nargin<2,
  error('Require Training Data');
end

if isempty(hmm.obsmodel)
  error('Error in hmm_train: obsmodel not specified');
  return
end


% prepare data for training, depending on observation model
[Xtrain,Nb,T] = initXtrain (hmm,varargin{:});

% prepare data for training, depending on hidden state inference
hmm=inithsbeliefs(hmm,Xtrain,T);


% get plot paraemters
[plotoptions]= plotparams(hmm,Xtrain,T);


FrEntrain=[];
FrEn=0;

for cycle=1:hmm.train.cyc

  %%%% E step
  hmm=hsupdate(hmm,Xtrain,T);
  
  if hmm.train.plot
    contplot(hmm,Xtrain,plotoptions);
  end;

  %%%% M STEP 

  % transition matrices and initial state
  hmm=txupdate(hmm,T);

  % Observation model
  hmm=obsupdate(hmm,Xtrain);

  %  evaluate free energy
  oldFrEn=FrEn;
  frEn=evalfreeenergy(hmm,Xtrain,T);	% compute free energy
  FrEn=sum(frEn);
  FrEntrain=[FrEntrain; frEn];
  
  mesgstr='';
  if (cycle>2)
    if (FrEn-oldFrEn) > 0 & hmm.train.checkviol,
      mesgstr='(Violation)';
    end;
    if abs((FrEn - oldFrEn)/oldFrEn*100) < hmm.train.tol
      break;
    end;
  end;
  if hmm.train.rdisplay, 
    fprintf('cycle %i free energy = %f %s \n',cycle,FrEn,mesgstr);  
  end;

end

% for debugging etc
hmm.train.FrEn=FrEn;

disp(sprintf('HMM Model: %d kernels, [%s] data samples',...
	     hmm.K,num2str(T)));
disp(sprintf('Final Free-Energy (after %d iterations)  = %f',...
	     cycle,FrEn)); 

return;

