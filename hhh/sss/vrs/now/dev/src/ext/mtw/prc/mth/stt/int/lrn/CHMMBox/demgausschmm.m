% A demonstration of the CHMM software using a Gaussian observation
% model on AR features
clear all
load chmmsim
T=length(data.Xseries);
T=1024;
X=data.Xseries(1:T,:);
Y=data.Yseries(1:T,:);


% Train up GMM on this data
chmm=struct('hmmone',[],'hmmtwo',[]);
chmm.hmmone.K=2; 
chmm.hmmtwo.K=2;

%chmm=chmmrandinit(X,Y,chmm,['full';'full']);
chmm=chmminit(X,Y,chmm,['full';'full']);
% $$$ chmm.hmmone.state(1).Mu=simchmm.hmmone.state(2).Mu';
% $$$ chmm.hmmone.state(1).Cov=simchmm.hmmone.state(2).Cov;
% $$$ chmm.hmmtwo.state(1).Mu=simchmm.hmmtwo.state(1).Mu';
% $$$ chmm.hmmtwo.state(1).Cov=simchmm.hmmtwo.state(1).Cov;
% $$$ chmm.hmmone.state(2).Mu=simchmm.hmmone.state(1).Mu';
% $$$ chmm.hmmone.state(2).Cov=simchmm.hmmone.state(1).Cov;
% $$$ chmm.hmmtwo.state(2).Mu=simchmm.hmmtwo.state(2).Mu';
% $$$ chmm.hmmtwo.state(2).Cov=simchmm.hmmtwo.state(2).Cov;


disp('Means of CHMM initialisation');
chmm.hmmone.state(:).Mu;
chmm.hmmtwo.state(:).Mu;

% Train up HMM on observation sequence data using Baum-Welch
% This uses the forward-backward method as a sub-routine
disp('We will now train the CHMM using Baum/Welch');
disp(' ');
disp('Press a key to continue');
pause
disp('Estimating CHMM');

chmm.train.cyc=100;
chmm.hmmone.obsmodel='Gauss';
chmm.hmmtwo.obsmodel='Gauss';
chmm.hmmone.train.obsupdate=ones(1,chmm.hmmone.K);% update observation models ?
chmm.hmmtwo.train.obsupdate=ones(1,chmm.hmmtwo.K);% update observation models ?
chmm.hmmone.train.init=1;         % Yes, we've already done initialisation
chmm.hmmtwo.train.init=1;         % Yes, we've already done initialisation


chmm=chmmtrain(X,Y,T,chmm);
disp('Means');
chmm.hmmone.state.Mu
chmm.hmmtwo.state.Mu


disp('Initial State Probabilities, Pi');
chmm.Pi
disp('State Transition Matrix, P');
chmm.P

% For lag-1 models,  decoding is done identically to 
% decoding in standard HMMs with larger state space
disp('We will estimate the Viterbi path of the CHMM, ');
disp(' ');
disp('Press a key to continue');
pause

chmm.P=chmm.P';                        % Will's code uses transpose 
% joint viterbi path
[block.joint]=chmmdecode(X,Y,T,chmm);

% We are often interested in the Viterbi path of the individual chains. We can 
% estimate these in two ways: a) marginalise the transition probabilities and 
% run decoding for each of the two HMMs; b) marginalise the joint state
% sequence directly 
disp('We will estimate the Viterbi path of the each HMM, ');
disp(' ');
disp('First obtain Viterbi path directly from joint state sequence');
disp('Press a key to continue');
pause


block.jointviterbi=block.joint.q_star;
block.hmmoneviterbi=zeros(size(block.jointviterbi));
block.hmmtwoviterbi=zeros(size(block.jointviterbi));
clvlabels=[chmm.hmmone.K 1:chmm.hmmone.K-1];
clv=mod(block.joint.q_star,chmm.hmmone.K);
for i=0:max(clv),
  ndx=find(clv==i);
  block.hmmoneviterbi(ndx)=clvlabels(i+1)+zeros(size(ndx));
end;
clvlabels=[chmm.hmmtwo.K 1:chmm.hmmtwo.K-1];
clv=mod(ceil(block.joint.q_star/chmm.hmmone.K),chmm.hmmtwo.K);
for i=0:max(clv),
  ndx=find(clv==i);
  block.hmmtwoviterbi(ndx)=clvlabels(i+1)+zeros(size(ndx));
end;
clear ndx clv;
  



disp(['Second obtain Viterbi path by decoding each of the HMMs using a' ...
      ' marginalised transition propability']);
disp('Press a key to continue');
pause

% single chain viterbi path
  % priors for individual chains
  Pone=ones(1:chmm.hmmone.K);
  Pone=Pone./length(Pone);
  Ptwo=ones(1:chmm.hmmtwo.K);
  Ptwo=Ptwo./length(Ptwo);

  % first chain; integrate out 2nd chain
  hmm=chmm.hmmone;
  hmm.P=mdsum(mdprod(hmm.P,Ptwo,3),3)';
  [block.hmmone]=hmmdecode(X,T,hmm);

  % second chain; integrate out 1st chain
  hmm=chmm.hmmtwo;
  hmm.P=mdsum(mdprod(hmm.P,Pone,2),2)';
  [block.hmmtwo]=hmmdecode(Y,T,hmm);

  % find incorrect classification
  inccla=find((diff(data.jointclass(1:T))~=0)-(diff(block.joint.q_star)~=0))+1;
  Tvec=1:T;
  
  figure;
  subplot(611),plot(Tvec,data.jointclass(1:T)),title('Input Viterbi');
  axis off
  subplot(612),plot(Tvec,block.joint.q_star,...
		    Tvec(inccla),block.joint.q_star(inccla),'m*'),
  title('Joint Viterbi; asterisk marks deviation from input');
  axis off
  titstr='First Chain Viterbi Using TxProp Marginalisation';
  subplot(613),plot(Tvec,block.hmmone.q_star),title(titstr);
  axis off
  titstr='Second Chain Viterbi Using TxProp Marginalisation';
  subplot(614),plot(Tvec,block.hmmtwo.q_star),title(titstr);
  axis off
  titstr='First Chain Viterbi Using Joint Viterbi Marginalisation' ;
  subplot(615),plot(Tvec,block.hmmoneviterbi,'r'),title(titstr);
  axis off
  titstr='Second Chain Viterbi Using Joint Viterbi Marginalisation' ;
  subplot(616),plot(Tvec,block.hmmtwoviterbi,'r'),title(titstr);
  axis off

