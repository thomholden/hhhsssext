function [hmm,FrKL]=train(hmm,varargin)
% function [hmm,FrKL]=train(hmm,X,T)
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


FrKLtrain=[];
FrKL=0;

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

  %  evaluate KL div
  oldFrKL=FrKL;
  frkl=evalfreeenergy(hmm,Xtrain,T);	% compute KL
  FrKL=sum(frkl);
  FrKLtrain=[FrKLtrain; frkl];
  
  
  mesgstr='';
  if (cycle>2)
    if (FrKL-oldFrKL) > 0 & hmm.train.checkviol,
      mesgstr='(Violation)';
    end;
    if abs((FrKL - oldFrKL)/oldFrKL*100) < hmm.train.tol
      break;
    end;
  end;
  if hmm.train.rdisplay, 
    fprintf('cycle %i free energy = %f %s \n',cycle,FrKL,mesgstr);  
  end;

end


% for debugging etc
hmm.train.FrKL=FrKLtrain;

disp(sprintf('HMM Model: %d kernels, [%s] data samples',...
	     hmm.K,num2str(T)));
disp(sprintf('Final KL divergence (after %d iterations)  = %f',...
	     cycle,FrKL)); 

return;

