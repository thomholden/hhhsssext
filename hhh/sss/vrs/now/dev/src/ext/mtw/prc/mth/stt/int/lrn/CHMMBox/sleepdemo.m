% A demonstration of the CHMM software using a Gaussian observation
% model on AR features
clear all
disp(sprintf(['A demonstration of the CHMM software using a Gaussian' ...
	      ' observation model on AR features extracted from an' ...
	      ' overnight sleep EEG recording.\n\n']));
disp(sprintf(['One Chain corresponds to features from the C3 Electrode' ...
	      ' position, and the other chain to features from the C4' ...
	      ' electrode position. \n']));
disp(sprintf('Press a key to continue\n\n'));
pause;


load sleep
T=length(A_C3);
X=A_C3(:,[1:3]);
Y=A_C4(:,[1:3]);

figure
plot(hyp),drawnow;


disp(sprintf(['The figure the manually scored sleep profile, the ' ...
	      'so-called hypnogram\n']));
disp(sprintf('Press a key to continue\n\n'));
pause;


% Train up GMM on this data
chmm=struct('hmmone',[],'hmmtwo',[]);
chmm.hmmone.K=3; 
chmm.hmmtwo.K=3;

disp(sprintf('Initialising a GMM to %d kernels (Might take a while!)\n\n', ...
	      chmm.hmmone.K));


chmm=chmminit(X,Y,chmm,['full';'full']);


chmm.train.cyc=30;
chmm.hmmone.obsmodel='Gauss';
chmm.hmmtwo.obsmodel='Gauss';
chmm.hmmone.train.obsupdate=ones(1,chmm.hmmone.K);% update observation models ?
chmm.hmmtwo.train.obsupdate=ones(1,chmm.hmmtwo.K);% update observation models ?
chmm.hmmone.train.init=1;         % Yes, we've already done initialisation
chmm.hmmtwo.train.init=1;         % Yes, we've already done initialisation


chmm=chmmtrain(X,Y,T,chmm);

 
disp('Initial State Probabilities, Pi');
chmm.Pi
disp('State Transition Matrix, P');
chmm.P

disp(sprintf(['For lag-1 models,  decoding is done identically to '...
	     'decoding in standard HMMs with enlarged state space.\n']));
disp(sprintf('We will estimate the Viterbi path of the CHMM.\n'));
disp(sprintf('Press a key to continue\n\n'));
pause;

chmm.P=chmm.P';                        % Will's code uses transpose 
% joint Viterbi path
[block.joint]=chmmdecode(X,Y,T,chmm);

  
Tvec=1:T;
figure;
subplot(211),plot(Tvec,block.joint.q_star),
title('Joint Viterbi');
axis off
titstr='Hypnogram' ;
subplot(212),plot(Tvec(1:length(hyp)),hyp,'r'),title(titstr);
axis off


disp(' ');
disp(sprintf(['The comparison shows that HMMs typically merge several' ...
	     ' manually scored states into one state. That is in part' ...
	     ' because the human labels might apply to only a fraction' ...
	     ' of the scoring window, whilst HMMs have much higher' ...
	     ' resolution\n\n\n']));
	     

