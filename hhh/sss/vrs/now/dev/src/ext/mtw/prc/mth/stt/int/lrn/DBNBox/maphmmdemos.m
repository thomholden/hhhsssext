function [hmm,block]=maphmmdemos(varargin)
% Maximum Aposteriori HMM demos

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
    [hmm,block]=mapgaussdemo(arp,plotflag);
   case 2
    load demgauss_traj
    [hmm,block]=mapgausstrajdemo(data,plotflag);
   case 3 
    load dempoisson
    [hmm,block]=mappoissondemo(countdat,plotflag);
   case 4
    load demlike
    [hmm,block]=maplikedemo(pp_t,plotflag);
  end
  disp(' ');
  disp(' ');
  disp('Press a key to continue');
  pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d]=requestdemo
% prompt user for demo number

disp('MAP HMM Demos with  ');
disp('Gaussian Observation model HMM                           [1]');
disp('Gaussian Observation model for tracking a trajectory     [2]');
disp('Poisson Observation model                                [3]');
disp('Likelihood observations                                  [4]');
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
function [hmm,block]=mapgaussdemo(data,plt)
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
hmm=MapHMM(K,data,'Gauss');

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
% map gauss demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=mapgausstrajdemo(data,plt)
% A demonstration of the HMM software using a Gaussian observation
% model on trajectory in 2-D space

T=length(data);
K=12;

% X   original time series

if plt
  plot(data);
  title('Training Data');
  disp('The data forms a trajectory in a 2-D space. It is composed of 2');
  disp(' sinusoidal waves with added gaussian random noise');
  disp(' ');
  disp('We will train an HMM model to trace the trajectory, ');
  disp('practically quantising the sequence');
  disp('Press a key to continue');
  pause
end

% Train up GMM on this data
hmm=MapHMM(K,data,'Gauss');

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
% sorting the labels s.t. lowest starts frist
block.sq_star=ones(size(block.q_star));
l=block.q_star(1);
for i=1:K
  ndx=find(~ismember(block.q_star,l));
  block.sq_star(ndx(:))=block.sq_star(ndx(:))+ones(1,length(ndx));
  if isempty(ndx), break; else l=[l block.q_star(ndx(1))]; end;
end;

if plt
   subplot(211),plot(data),title('Original data sequence'),axis off;
   subplot(212),plot(block.sq_star),
   title('Estimated and Sorted State sequence'),axis off;
end

% map gauss traj demo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=mappoissondemo(data,plt)
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
hmm=MapHMM(K,Xtrain,'Poisson');

if plt,
  disp('Mean rates of HMM initialisation');
  getobspar(hmm,1,'lambda')
  getobspar(hmm,2,'lambda')
  
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
  getobspar(hmm,1,'lambda')
  getobspar(hmm,2,'lambda')
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
function [hmm,block]=maplikedemo(data,plt)
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

hmm=MapHMM(K,Xseries,'Like');

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

% map like demo
