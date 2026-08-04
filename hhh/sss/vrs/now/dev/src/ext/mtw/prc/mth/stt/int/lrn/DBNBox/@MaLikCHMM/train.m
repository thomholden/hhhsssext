function [chmm,frEn]=train(chmm,varargin)
% function [chmm]=train(chmm,Xtrain,T)
%
% Train Coupled Hidden Markov Model
%
% Xtrain             - cell array containting N x p data matrix 
% T                  - length of each sequence (N must evenly divide by
%                      T, default T=N)
% chmm               - chmm object
%


% Copy in and check existence of parameters from hmm data structure
% Begin with common stuff

if length(varargin)<1
  error('Require Training Data');
end

% prepare data for training, depending on observation model
[Xtrain,Nb,T] = initXtrain (chmm,varargin{:});

% prepare data for training, depending on hidden state inference
chmm=inithsbeliefs(chmm,Xtrain,T);

% get plot paraemters
[plotoptions]= plotparams(chmm,Xtrain,T);


FrEntrain=[];
FrEn=0;

for cycle=1:chmm.train.cyc


  %%%% E step
  chmm=hsupdate(chmm,Xtrain,T);
  
  if chmm.train.plot
    contplot(chmm,Xtrain,plotoptions);
  end;

  %  evaluate free energy
  oldFrEn=FrEn;
  frEn=evalfreeenergy(chmm,Xtrain,T);	% compute free energy
  FrEntrain=[FrEntrain; frEn];
  FrEn=sum(frEn);
  
  mesgstr='';
  if (cycle>2)
    if cycle==3
      dirct=sign(sum(FrEntrain(3,:),2)-sum(FrEntrain(2,:),2));
    end
    dFrEn=FrEn-oldFrEn;
    if sign(dFrEn)~=dirct & chmm.train.checkviol,
      mesgstr='(Violation)';
    end;
    if abs(dFrEn/oldFrEn*100) < chmm.train.tol
      break;
    end;
  end;
  if chmm.train.rdisplay, 
    fprintf('cycle %i free energy = %f %s \n',cycle,FrEn,mesgstr);  
  end;

  %%%% M STEP 
  % transition matrices and initial state
  chmm=txupdate(chmm,T);
  
  % Observation model
  chmm=obsupdate(chmm,Xtrain);

end

frEn=evalfreeenergy(chmm,Xtrain,T);	% compute free energy
FrEn=sum(frEn);


% for debugging etc
chmm.train.FrEn=FrEn;
disp('----------------------------------------------------------------');
disp(sprintf('   Model: %d Chain(s) with dimensions [%s]',chmm.NChains,num2str(chmm.K)));
disp(sprintf('   %d block(s) of [%s] data samples',Nb,num2str(T)));
disp('   Topology:')
for c=1:chmm.NChains
  top=chmm.LagOpSpec{c}';
  nl=size(top,1);
  disp(sprintf('     Onto chain %d Links with',c));
  disp([repmat('      Lag ',nl,1),num2str(top(:,1)),...
	repmat(' from Chain ',nl,1),num2str(top(:,2))]);
end
disp(sprintf('   hidden state training using %s',chmm.train.inftype));
disp('----------------------------------------------------------------');
disp(sprintf('Final Free-Energy (after %d iterations) = %f\n\n',cycle,FrEn)); 

