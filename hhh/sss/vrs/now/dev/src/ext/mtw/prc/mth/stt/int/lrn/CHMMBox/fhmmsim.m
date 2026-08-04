function [simdata] = fhmmsim (fhmm,N)
% [simdata] = fhmmsim (fhmm,N)
%
% simulates the output of an FHMM with gaussian observation model 
% and FHMM parameters
%   fhmm.Pi = prior probability
%   fhmm.P  = state transition probability
%   N  = number of samples generated
%
% The function returns:
%
%   data.Xseries sampled observation sequence
%   data.Xclass  sampled state sequence
% 
%   data.sorted  same as above but with sorted cart. state sequence
%   
% e.g.
% N=1024;
% fhmm.Pi=[[1/2;1/2],[1/2;1/2],[1/3;2/3]];
% fhmm.P=cat(3,[1/4 1/2; 3/4 1/2],[5/8 4/7; 3/8 3/7],[3/4 1/2; 1/4 1/2]);
% fhmm.K=[2,2,2];
% fhmm.obsmodel='Gauss';
% fhmm.state(1,1).Mu=-15;fhmm.state(2,1).Mu=10;
% fhmm.state(1,2).Mu=-7;fhmm.state(2,2).Mu=10;
% fhmm.state(1,3).Mu=15;fhmm.state(2,3).Mu=-15;
% fhmm.Cov=2;
% [simdata] = fhmmsim (fhmm,N)
  
  if ~isfield(fhmm,'Pi');
    disp('Need to specify prior probability');
    return;
  else
    Pi=fhmm.Pi;
  end;

  if ~isfield(fhmm,'P');
    disp('Need to specify transition probability');
    return;
  else
    P=fhmm.P;
  end;
  
  if ~isfield(fhmm,'K')
    disp('Need to specify state space dimension K ');
    return;
  else,
    K=fhmm.K;
    M=length(K);			% number of chains
  end;
  
  for i=1:length(K),
    if (length(Pi(:,i))~=size(P(:,:,i),1)) & ...
	  (length(Pi(:,i))~=size(P(:,:,i),2)),
      disp('Prior vector and transition matrix non-conformant');
      return;
    end;
  end;

  if ~isfield(fhmm,'obsmodel'),
    disp('Need to specify observation model');
    return;
  end;
  
switch fhmm.obsmodel
 case {'GaussComm', 'Gauss'},
  if ~isfield(fhmm.state,'Mu'),
    disp('Missing mean vector for Gaussian observation model');
    return;
  elseif ~isfield(fhmm,'Cov'),
      disp('Missing covariance matrix for Gaussian observation model');
      return;
  end
 case {'AR'},
  disp('Sorry. Not supporting AR at the moment');
  return;
 case {'LIKE'},
 otherwise
  disp('Unknown observation model');
  return
end;

% now sampling states
Muset=[];
for i=1:N,
  mue(i)=0;				% mue(i,:)=zeros(1,ndim);
  for m=1:M,
    if i==1,
      c(1,m)=find(multinom(Pi(:,m),1,1));	% sampling prior
    else
      c(i,m)=find(multinom(P(:,c(i-1),m),1,1)); % else transition
    end;
    mue(i)=fhmm.state(c(i,m),m).Mu + mue(i);
  end;
  if ~ismember(mue(i),Muset),
    Muset=[Muset,mue(i)];
  end;
  % sample from each observation model
  switch fhmm.obsmodel
   case {'GaussComm', 'Gauss'},
    x(i,:)=sampgauss(mue(i),fhmm.Cov,1)';
   case {'AR'},
    disp('Sorry. Not supporting AR at the moment');
    return;
   case {'LIKE'},
    x(i,:)=c(i,:);
  end; 
end;


disp(['Means: ' mat2str(sort(Muset))]);
% sorting to obtain a presentable viterbi path
[sc,ndx]=sort(c(:,1));
sx=x(ndx,:);

simdata.Xseries=x;
simdata.Xclass=c;

simdata.sorted.Xseries=sx;
simdata.sorted.Xclass=c(ndx,:);

