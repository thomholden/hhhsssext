function [hmm,block]=mlhmmdemos(varargin)
% Maximum Likelihood HMM demos

plotflag=0;				% verbose flag/set to 0 if testing
justonce=0;				% if args then only 1 demo
while ~justonce
  noarg=isempty(varargin);
  if noarg
    [d]=requestdemo;
    justonce=0;				% loop forever
  else
    d=varargin{1};
    justonce=1;				% argument given - just once
  end
  if isempty(d)
    return;
  end
  switch d
   case 1
    load demgauss
    [hmm,block]=mlgaussdemo(arp,plotflag);
   case 2
    [hmm,block]=mlardemo([],plotflag);
   case 3 
    load demar;
    [hmm,block]=mlarspindeldemo(Xseries,ns,exp_state,plotflag);
   case 4
    load dempoisson
    [hmm,block]=mlpoissondemo(countdat,plotflag);
   case 5
    load demlike
    [hmm,block]=mllikedemo(pp_t,plotflag);
   case 6
    load demgamma
    [hmm,block]=mlgammademo(Xseries,plotflag);
  end
  disp(' ');
  disp(' ');
  disp('Press a key to continue');
  pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d]=requestdemo
% prompt user for demo number

disp('Maximum Likelihood HMM Demos with  ');
disp('Gaussian Observation model HMM                           [1]');
disp('Linear Observation Model HMM                             [2]');
disp('Linear Observation Model HMM for Spindel EEG             [3]');
disp('Poisson Observation model                                [4]');
disp('Likelihood observations                                  [5]');
disp('Gamma Observation model                                  [6]');
disp(' ');
disp('Quit                                         [q/x]');
disp(' ');
d=[];
while isempty(d)
  d=input('Enter Demo number:     ','s');
end
d=str2num(d);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=mlgaussdemo(data,plt)
% A demonstration of the HMM software using a Gaussian observation
% model on AR features 

T=length(data);
K=2;

% X   original time series
% data AR(4) features

if plt
  plot(data);
  title('Training Data');
  disp('The data consists of AR-4 features. They were extracted');
  disp('from the original data which had ad middle section with');
  disp('mainly 10Hz activity wheras the beginning and end');
  disp('sections were just noise.');
  disp(' ');
  disp('We will train a  Gaussian Mixture Model on the AR-4 features');
  disp('The resulting GMM will be used to initialise an HMM.');
  disp(' ');
  disp('Press a key to continue');
  pause
end

% Train up GMM on this data
hmm=MaLikHMM(K,data,'Gauss');

if plt
  disp('Means of HMM initialisation');
  getobspar(hmm,1,'Mu');
  getobspar(hmm,2,'Mu');

  % Train up HMM on observation sequence data using Baum-Welch
  % This uses the forward-backward method as a sub-routine
  disp('We will now train the HMM using Baum/Welch');
  disp(' ');
  disp('Press a key to continue');
  pause
  disp('Estimated HMM');
end

hmm=set(hmm,'train','cyc',30);

hmm=train(hmm,data,T);

if plt
  disp('Means');
  getobspar(hmm,1,'Mu')
  getobspar(hmm,2,'Mu')
  disp('Initial State Probabilities, Pi');
  gettxpar(hmm,'Pi')
  disp('State Transition Matrix, P');
  gettxpar(hmm,'P')
end

[block]=decode(hmm,data,T);

if plt
  % Find most likely hidden state sequence using Viterbi method
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
  title('Viterbi decoding');
  
  disp('The Viterbi decoding plot shows that the time series');
  disp('has been correctly partitioned.');
end
% ml gauss demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=mlardemo(data,plt)
% Generate noisy sine wave

f1=10; 
f2=20; 
ns=125; 
noise=0.3; 
t=[1/ns:1/ns:1];
Xseries=[sin(2*pi*f1*t)+noise*randn(size(t))...
	 sin(2*pi*f2*t)+noise*randn(size(t))]; 

T=length(t);

K=2;
obsmodelopt=struct('p',4);
options=struct('obsmodel',obsmodelopt);


hmm=MaLikHMM(K,Xseries,'AR');

P=init_trans(K, 1, ns); 
hmm=settxpar(hmm,'P',P);
hmm=set(hmm,'train','cyc',20);

if plt
  for k=1:K,
    [P,fre] = ar_spec(-getobspar(hmm,k,'A'),[],ns);
    subplot(K,1,k),plot(fre,P); 
    title(sprintf('Intialisation Spectrum of Model %d',k));
  end;
  drawnow,
  disp('Spectrum of the AR models after initialisation');
  disp(' ');
  disp('Press a key to continue');
  pause
end


% Train HMM

hmm=train(hmm,Xseries);


if plt
  for k=1:K,
    [P,fre] = ar_spec(-getobspar(hmm,k,'A'),[],ns);
    subplot(K,1,k),plot(fre,P); 
    title(sprintf('Intialisation Spectrum of Model %d',k));
  end;
  drawnow,
  disp('Spectrum of the AR models after training');
  disp(' ');
  disp('Press a key to continue');
  pause
end


[block]=decode(hmm,Xseries);

if plt
  % Find most likely hidden state sequence using Viterbi method
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
  title('Viterbi decoding');
  
  disp('The Viterbi decoding plot shows that the time series');
  disp('has been correctly partitioned.');
end
% ml ar demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=mlarspindeldemo(data,ns,exp_state,plt)
% 
% A demonstration of the HMM software using an AR observation
% model on sleep spindle data

Xseries=data;
T=length(Xseries);

if plt
  plotseg(Xseries,[],[],40,ns,-5,10);
  drawnow,
  disp('Sleep Spindel Data');
  disp(' ');
  disp('Press a key to continue');
  pause
end

K=2;
obsmodelopt=struct('p',8);
options=struct('obsmodel',obsmodelopt);


hmm=MaLikHMM(K,Xseries,'AR');

%hmm=set(hmm,'train','cyc',30);

if plt
  for k=1:K,
    [P,fre] = ar_spec(-getobspar(hmm,k,'A'),[],ns);
    subplot(K,1,k),plot(fre,P); 
    title(sprintf('Intialisation Spectrum of Model %d',k));
  end;
  drawnow,
  disp('Spectrum of the AR models after training');
  disp(' ');
  disp('Press a key to continue');
  pause
end


% Train HMM

hmm=train(hmm,Xseries);


if plt
  for k=1:K,
    [P,fre] = ar_spec(-getobspar(hmm,k,'A'),[],ns);
    subplot(K,1,k),plot(fre,P); 
    title(sprintf('Intialisation Spectrum of Model %d',k));
  end;
  drawnow,
  disp('These plots show the spectra associated with each state');
  disp('after training');
  disp(' ');
  disp('Press a key to continue');
  pause
end


[block]=decode(hmm,Xseries);

if plt
  % Find most likely hidden state sequence using Viterbi method
  plotseg(Xseries,exp_state,block(1).q_star-K-1,40,ns,-4,9);
  disp(' ');
  disp('This plot shows the sleep spindle data along with ');
  disp('an experts labelling - red - ');
  disp('and the labelling from the HMM - green.');
end
% ml ar spindel demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=mlpoissondemo(data,plt)
% A demonstration of the HMM software using a Poisson observation
% model on count data


Xtrain=[data];
Xtrain=[ones(length(Xtrain),1) Xtrain];
T=length(Xtrain);
K=2;

if plt,
  plot(data);
  title('Original data');
  disp(' The data consist of a sequence of R-R intervals obtained from an');
  disp(' ECG recording. It can be considered a sequence of counts, the');
  disp(' counts being the number of sample intervals between each');
  disp(' heart-beat. In this particular case, the subject is asked to');
  disp(' take 6 deep breaths at 30secs into the recoding (lasting until');
  disp(' 90 seconds into the recording');
  disp(' ');
  disp('Press a key to continue');
  pause


  disp(' ');
  disp('We will take random samples to initialise the HMM.');
  disp(' ');
  disp('Press a key to continue');
  pause
end

% Train up HMM on this data
hmm=MaLikHMM(K,Xtrain,'Poisson');

if plt,
  disp('Mean rates of HMM initialisation');
  getobspar(hmm,1,'Gamma_alpha')./...
      getobspar(hmm,1,'Gamma_beta');
  getobspar(hmm,2,'Gamma_alpha')./...
      getobspar(hmm,2,'Gamma_beta');
  
  % Train up HMM on observation sequence data using Baum-Welch
  % This uses the forward-backward method as a sub-routine
  disp('We will now train the HMM using Baum/Welch');
  disp(' ');
  disp('Press a key to continue');
  pause
  disp('Estimated HMM');
end

hmm=set(hmm,'train','cyc',30);

hmm=train(hmm,Xtrain,T);

if plt,
  disp('Rates');
  getobspar(hmm,1,'Gamma_alpha')./...
      getobspar(hmm,1,'Gamma_beta');
  getobspar(hmm,2,'Gamma_alpha')./...
      getobspar(hmm,2,'Gamma_beta');
  disp('Initial State Probabilities, Pi');
  gettxpar(hmm,'Pi');
  disp('State Transition Matrix, P');
  gettxpar(hmm,'P');
end

[block]=decode(hmm,Xtrain,T);

if plt
  % Find most likely hidden state sequence using Viterbi method
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
  title('Viterbi decoding');
  
  disp('The Viterbi decoding plot shows whether the time series');
  disp('has been correctly partitioned.');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=mllikedemo(data,plt)
% A demonstration of the HMM software using the "Like" model
% which assumes the data are directly the odds of the hidden 
% states

Xseries=data;
K=2;

if plt
    figure
    plot(data(:,1));
    title('Original data - series 1');

    disp('The plot shows the likelihood of data given state/class 1');
    disp(' ');
    disp('Press a key to train up an HMM');
    disp(' ');
    pause
end


T=size(Xseries,1);

hmm=MaLikHMM(K,Xseries,'Like');

% Train HMM
hmm=train(hmm,Xseries);

[block,LL]=decode(hmm,Xseries);
        
% Find most likely hidden state sequence using Viterbi method
if plt
    figure
    plot(block(1).q_star);
    axis([0 800 0 3]);
    title('Viterbi decoding');
    
    disp('The Viterbi decoding plot shows that the time series');
    disp('has been correctly partitioned.')
end

% maxlike like demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=mlgammademo(data,plt)
% A demonstration of the HMM software using a Gamma observation
% model on simulated features 

T=length(data);
K=2;

if plt
  plot(data);
  title('Training Data');
  disp('The data consists of simulated time series')
  disp('where the respective components have these shape and scale parameters')
  disp('component 1: alpha=15, beta=2 ');
  disp('component 2: alpha=10, beta=1 ');
  disp(' ');
  disp('We will train a  Gamma Mixture Model on the data');
  disp(' ');
  disp('Press a key to continue');
  pause
end

% Train up GMM on this data
hmm=MaLikHMM(K,data,'Gamma');

if plt
  disp('Mean Rate at HMM initialisation');
  getobspar(hmm,1,'alpha')./getobspar(hmm,1,'beta')
  getobspar(hmm,2,'alpha')./getobspar(hmm,2,'beta')

  % Train up HMM on observation sequence data using Baum-Welch
  % This uses the forward-backward method as a sub-routine
  disp('We will now train the HMM using Baum/Welch');
  disp(' ');
  disp('Press a key to continue');
  pause
  disp('Estimated HMM');
end

hmm=set(hmm,'train','cyc',50);

hmm=train(hmm,data,T);

if plt
  disp('Mean Rate after HMM training');
  getobspar(hmm,1,'alpha')./getobspar(hmm,1,'beta')
  getobspar(hmm,2,'alpha')./getobspar(hmm,2,'beta')
  disp('Initial State Probabilities, Pi');
  gettxpar(hmm,'Pi')
  disp('State Transition Matrix, P');
  gettxpar(hmm,'P')
end

[block]=decode(hmm,data,T);

% ml gamma demo
