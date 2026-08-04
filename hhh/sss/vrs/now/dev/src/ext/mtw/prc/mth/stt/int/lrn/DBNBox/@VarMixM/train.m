function [mix,FrEn]=train(mix,varargin)
% function [mix,FrEn]=train(mix,X,T)
%
% Train Hidden Markov Model 
%
% INPUTS:
%
% X - N x p data matrix
% T - length of each sequence (N must evenly divide by T, default T=N)
% mix  - hidden markov model object
%
% OUTPUTS
% mix - updated hidden markov model object
%


% Copy in and check existence of parameters from mix data structure

if nargin<2,
  error('Require Training Data');
end

if isempty(mix.obsmodel)
  error('Error in mix_train: obsmodel not specified');
  return
end


% prepare data for training, depending on observation model
[Xtrain,Nb,T] = initXtrain (mix,varargin{:});

% prepare data for training, depending on hidden state inference
mix=inithsbeliefs(mix,Xtrain,T);

% get plot paraemters
[plotoptions]= plotparams(mix,Xtrain,T);


FrEntrain=[];
FrEn=0;

for cycle=1:mix.train.cyc

  %%%% E step
  mix=hsupdate(mix,Xtrain,T);

  if mix.train.plot
    contplot(mix,Xtrain,plotoptions);
  end;

  %%%% M STEP 

  % transition matrices and initial state
  mix=txupdate(mix,T);

  % Observation model
  mix=obsupdate(mix,Xtrain);

  %  evaluate free energy
  oldFrEn=FrEn;
  frEn=evalfreeenergy(mix,Xtrain,T);	% compute free energy
  FrEn=sum(frEn);
  FrEntrain=[FrEntrain; frEn];
  
  
  mesgstr='';
  if (cycle>2)
    if (FrEn-oldFrEn) > 0  & mix.train.checkviol,
      mesgstr='(Violation)';
    end;
    if abs((FrEn - oldFrEn)/oldFrEn*100) < mix.train.tol
      break;
    end;
  end;
  if mix.train.rdisplay, 
    fprintf('cycle %i free energy = %f %s \n',cycle,FrEn,mesgstr);  
  end;

end


% for debugging etc
mix.train.FrEn=FrEntrain;

disp(sprintf('Mixture Model: %d kernels, [%s] data samples',...
	     mix.K,num2str(T)));
disp(sprintf('Final Free-Energy (after %d iterations)  = %f',...
	     cycle,FrEn)); 

return;

