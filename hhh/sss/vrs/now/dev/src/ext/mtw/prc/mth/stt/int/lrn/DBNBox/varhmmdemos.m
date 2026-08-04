function [hmm,block]=varhmmdemos(varargin)
% Variational HMM demos

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
    [hmm,block]=vargaussdemo(arp,plotflag);
   case 2 
    load demgauss
    [hmm,block]=vargaussoutldemo(arp,plotflag);
   case 3
    [hmm,block]=vararsinedemo([],plotflag);
   case 4
    [hmm,block]=vararoutldemo([],plotflag);
   case 5
    load dempoisson
    [hmm,block]=varpoissondemo(countdat,plotflag);
   case 6
    [simdata,simhmm] = hmmsim('defMn');
    [hmm,block]=varmultinomialdemo(simdata,plotflag);
   case 7
    [hmm,block]=varftsinedemo([],plotflag);
   case 8
    [hmm,block]=varsegardemo([],plotflag);
   case 9
    [hmm,block]=varsegaroutldemo([],plotflag);
   case 10
    load demlike
    [hmm,block]=varlikedemo(pp_t,plotflag);
  end
  disp(' ');
  disp(' ');
  disp('Press a key to continue');
  pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d]=requestdemo
% prompt user for demo number

disp('Variational HMM Demos with  ');
disp('Gaussian Observation model HMM                           [1]');
disp('Gaussian Observation model HMM with outlier              [2]');
disp('Autoregressive Observation model on Sinusoids            [3]');
disp('Autoregressive Observation model with outlier            [4]');
disp('Poisson Observation model                                [5]');
disp('Multinomial Observation model                            [6]');
disp('Sinusoid Observation model                               [7]');
disp('Segmental Autoregressive Observation model               [8]');
disp('Segmetnal Autoregressive Observation model with outliers [9]');
disp('Likelihood observations                                  [10]');
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
function [hmm,block]=vargaussdemo(data,plt)
% A demonstration of the HMM software using a Gaussian observation
% model on AR features 
data=[data;data(1,:)];

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
hmm=VarHMM(K,data,'Gauss');

if plt
  disp('Means of HMM initialisation');
  getobspar(hmm,1,'Norm_Mu');
  getobspar(hmm,2,'Norm_Mu');

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
  getobspar(hmm,1,'Norm_Mu')
  getobspar(hmm,2,'Norm_Mu')
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
% var gauss demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=vargaussoutldemo(data,plt)
% A demonstration of the HMM software using a Gaussian observation
% model on AR features with added outliers

T=length(data);
K=3;					% add class for outliers

% X   original time series
% data AR(4) features

% replacing some signal with outliers
Nc=5;
outliers=repmat(4.5*range(data),Nc,1).*rand(Nc,4);
outloptions=struct('scale',50/1);
% Train up GMM on this data
hmm=VarHMM(K,data,'Gauss',[],outliers,'Uniform',outloptions);


[junk,outlierndx]=sort(rand(1,T)); outlierndx=outlierndx(1:Nc);
data(outlierndx,:)=outliers;

if plt
  plot(data);
  title('Training Data');
  disp('The data consists of AR-4 features with added outliers.');
  disp('The AR features were extracted from the original data ');
  disp('which had a middle section with mainly 10Hz activity ');
  disp('wheras the beginning and end sections were just noise.');
  disp(' ');
  disp('We will train a  Gaussian Mixture Model on the AR-4 features');
  disp('The resulting GMM will be used to initialise an HMM.');
  disp(' ');
  disp('Press a key to continue');
  pause
end

hmm=set(hmm,'train','cyc',30);

hmm=train(hmm,data,T);

[block]=decode(hmm,data,T);

if plt
  % Find most likely hidden state sequence using Viterbi method
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
  title('Viterbi decoding');
  
  disp('The Viterbi decoding plot shows whether the time series');
  disp('has been correctly partitioned.');
end
% var gauss outlier demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=vararsinedemo(data,plt)
% A demonstration of the HMM software using an Autoregressive observation
% model on 3 sets of sine waves


% generate the data first
f1=40; f2=25; f3=10;			% frequencies
ns=125;					% number of samples
noise=0.3;				% noise amplitude
t=[1/ns:1/ns:3];			% time index
data=10*[sin(2*pi*f1*t)+noise*randn(size(t)) ...
	 sin(2*pi*f2*t)+noise*randn(size(t)) ...
	 sin(2*pi*f3*t)+noise*randn(size(t))]; 

T=length(data);
K=3;					% 1 class per frequency


% Specify AR observation  model
options=struct('obsmodel',struct('p',2));
hmm=VarHMM(K,data,'AR',options);

if plt
  plot(data);
  title('Training Data');
  disp('The data consists of 3 segments of sine waves with ')
  disp('added Gaussian noise. We will train an Autoregressive');
  disp('observation model on this data');
  disp(' ');
  disp('Press a key to continue');
  pause
end

hmm=set(hmm,'train','cyc',70);

hmm=train(hmm,data,T);

[block]=decode(hmm,data,T);

if plt
  % Find most likely hidden state sequence using Viterbi method
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
  title('Viterbi decoding');
  
  disp('The Viterbi decoding plot shows whether the time series');
  disp('has been correctly partitioned.');
end
% var ar demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=vararoutldemo(data,plt)
% A demonstration of the HMM software using an Autoregressive observation
% model on 2 sets of ar simulated time series with outliers

addpath('/users/irezek/matlab/arfit');
T=400;

% Generate MAR(p) data using arsim routine (from arfit package)
[data]=[simmixar(T,0,1) simmixar(T,0,1)];   %2 mixtures of bivariate AR
rmpath('/users/irezek/matlab/arfit');

K=2;					% there are 2 simulated models
T=size(data,1);

% replacing some signal with outliers
Nc=20;
outliers=repmat(2.5*range(data),Nc,1).*rand(Nc,size(data,2));

[junk,outlierndx]=sort(rand(1,T)); outlierndx=outlierndx(1:Nc);
data(outlierndx,:)=outliers;


% Specify AR observation  model
options=struct('obsmodel',struct('p',2));
hmm=VarHMM(K,data,'AR',options,outliers,'Uniform');



if plt
  plot(data);
  title('Original data');
  disp('The middle section of data is drawn from a different AR model');
  disp('with inter-dimensional independence and we added outliers');
  disp(' ');
  disp('We will train two mixture of AR(2) models on the raw data');
  disp(' ');
  disp('Press a key to continue');
  pause
end

hmm=set(hmm,'train','cyc',70);

hmm=train(hmm,data,T);

[block]=decode(hmm,data,T);

if plt
  % Find most likely hidden state sequence using Viterbi method
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
  title('Viterbi decoding');
  
  disp('The Viterbi decoding plot shows whether the time series');
  disp('has been correctly partitioned.');
end
% var ar  demo with outliers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=varpoissondemo(data,plt)
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
hmm=VarHMM(K,Xtrain,'Poisson');

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
function [hmm,block]=varmultinomialdemo(data,plt)
% A demonstration of the HMM software using a Multinomial observation
% model on simulated data

Xtrain=data.Xseries;
T=length(Xtrain);
K=2;

if plt,
  plot(Xtrain);
  title('Original data');
  disp(' The data was generated by sampling from a 2-state HMM');
  disp(' with multinomial observation models. Each of the observation');
  disp(' models has 3 discrete states from which samples are drawn.');
  disp(' ');

  disp(' ');
  disp('We will take random samples to initialise the HMM.');
  disp(' ');
  disp('Press a key to continue');
  pause
end

% Train up HMM on this data
hmm=VarHMM(K,Xtrain,'Multinomial');



hmm=set(hmm,'train','cyc',20);

hmm=train(hmm,Xtrain,T);

[block]=decode(hmm,Xtrain,T);


if plt
  disp('The average error of the estimated class wrt to true class');
  classdev=abs(sum(block.q_star'-data.Xclass))/T*100;
  disp(sprintf('Error=%d percent',classdev));

  % Find most likely hidden state sequence using Viterbi method
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
  title('Viterbi decoding');

end
% var multinomial demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=varftsinedemo(data,plt)
% A demonstration of the HMM software using an Sinusoidal observation
% model on 3 sets of sine waves


% generate the data first
f1=40; f2=25; f3=10;			% frequencies
fsamp=125; 
noise=0.3;				% noise amplitude
t=[1/fsamp:1/fsamp:3];
data=10*[sin(2*pi*f1*t)+noise*randn(size(t)) ...
	 sin(2*pi*f2*t)+noise*randn(size(t)) ...
	 sin(2*pi*f3*t)+noise*randn(size(t))]; 

T=length(data);
K=3;					% 1 class per frequency


% Specify FT observation  model
options=struct('obsmodel',struct('fsamp',fsamp,...
    'w',[f1 f2 f3]*2*pi/fsamp));	% fsignal*2*pi*samplingperiod
      
hmm=VarHMM(K,data,'FT',options);

if plt
  plot(data);
  title('Training Data');
  disp('The data consists of 3 segments of sine waves with ')
  disp('added Gaussian noise. We will train an Autoregressive');
  disp('observation model on this data');
  disp(' ');
  disp('Press a key to continue');
  pause
end

hmm=set(hmm,'train','cyc',10);

hmm=train(hmm,data,T);

[block]=decode(hmm,data,T);

if plt
  % Find most likely hidden state sequence using Viterbi method
  plot(block(1).q_star);
  axis([0 T 0 K+1]);
  title('Viterbi decoding');
  
  disp('The Viterbi decoding plot shows whether the time series');
  disp('has been correctly partitioned.');
end
% var ft demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=varsegardemo(data,plt)
% A demonstration of the HMM software using a Segment
% Autoregressive observation model on 2 sets of ar simulated
% time series 

addpath('/users/irezek/matlab/arfit');
T=100;
sps=12;				% samples per segemnt
isps=12;			% samples per segment for initialisation

% Generate MAR(p) data using arsim routine (from hmmsim package)
[simdata] = hmmsim ('defbvAR',T,sps); 

rmpath('/users/irezek/matlab/arfit');

data=simdata.Xseries;
K=2;					% there are 2 simulated models
T=size(data,1);

% Specify AR observation  model
options=struct('obsmodel',...
	       struct('p',2,'offset',sps,'segsize',sps,...
		      'initoffset',isps,'initsegsize',isps,...
		      'initmeth','mvkalman'));

hmm=VarHMM(K,data,'SegAR',options);


if plt
  subplot(211),plot(simdata.Xclass),axis([0 T 0 3]);
  subplot(212),plot(simdata.Xseries)
  title('Original data');
  disp('The top plot shows the classes from which the AR samples were drawn');
  disp('from and the lower plot shows the bivariate training data.');
  disp(' ');
  disp('We will train two mixture of AR(2) models on the raw data, segmented');
  disp('into 12 samples per segment');
  disp(' ');
  disp('Press a key to continue');
  pause
end

hmm=set(hmm,'train','cyc',30);

hmm=train(hmm,data,T);

[block]=decode(hmm,data,T);

if plt
  % Find most likely hidden state sequence using Viterbi method
  subplot(211),plot(block(1).q_star);
  title('Viterbi decoding'),
  axis([0 length(block(1).q_star) 0 K+1]);
  subplot(212),plot(simdata.Xclass);
  title('True Labels'),axis([0 T 0 K+1]);
  disp('The Viterbi decoding plot shows whether the time series');
  disp('has been correctly partitioned.');
end
% var seg ar  demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=varsegaroutldemo(data,plt)
% A demonstration of the HMM software using a Segment
% Autoregressive observation model on 2 sets of ar simulated
% time series with outliers

addpath('/users/irezek/matlab/arfit');
T=200;
sps=12;				% samples per segemnt
isps=12;			% samples per segment for initialisation

% Generate MAR(p) data using arsim routine (from hmmsim package)
[simdata] = hmmsim ('defbvAR',T,sps); 

rmpath('/users/irezek/matlab/arfit');

Xtrain=simdata.Xseries;
Xclass=simdata.Xclass;
K=3;		
% there are 2 simulated models
T=size(Xtrain,1);
% $$$ % replacing some signal with outliers
Nc=20;
outliers=repmat(2.5*range(Xtrain),Nc,1).*rand(Nc,size(Xtrain,2));
[junk,outlierndx]=sort(rand(1,T)); outlierndx=outlierndx(1:Nc);
Xtrain(outlierndx,:)=outliers;
Xclass(outlierndx)=3*ones(1,length(outlierndx));



if plt
  subplot(211),plot(Xclass),axis([0 T 0 3]);
  subplot(212),plot(Xtrain)
  title('Original data');
  disp('The top plot shows the classes from which the AR samples were drawn');
  disp('from and the lower plot shows the bivariate training data.');
  disp('Note the outliers added to the original  data.');
  disp(' ');
  disp('We will train two mixture of AR(2) models on the raw data, segmented');
  disp('into 12 samples per segment');
  disp(' ');
  disp('Press a key to continue');
  pause
end

% Specify AR observation  model
options=struct('obsmodel',...
	       struct('p',2,'offset',sps,'segsize',sps,...
		      'initoffset',isps,'initsegsize',isps,...
		      'initmeth','mvkalman'));
outloptions=struct('scale',1/1);

hmm=VarHMM(K,Xtrain,'SegAR',options,outliers,'Uniform',outloptions);

hmm=set(hmm,'train','cyc',30);

hmm=train(hmm,Xtrain,T);

[block]=decode(hmm,Xtrain,T);

if plt
  % Find most likely hidden state sequence using Viterbi method
  subplot(211),plot(block(1).q_star);
  title('Viterbi decoding'),
  axis([0 length(block(1).q_star) 0 K+1]);
  subplot(212),plot(simdata.Xclass);
  title('True Labels'),axis([0 T 0 K+1]);
  disp('The Viterbi decoding plot shows whether the time series');
  disp('has been correctly partitioned.');
end
% var seg ar demo with outliers


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hmm,block]=varlikedemo(data,plt)
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

hmm=VarHMM(K,Xseries,'Like');

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
