function [mix]=varmixdemos(varargin)
% Variational Mixture Model demos

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
    [mix]=vargaussdemo(arp,plotflag);
   case 2
    [mix]=vararsinedemo([],plotflag);
   case 3
    load dempoisson
    [mix]=varpoissondemo(countdat,plotflag);
% $$$    case 4
% $$$     load demgauss
% $$$     [mix]=vargaussoutldemo(arp,plotflag);
% $$$    case 5
% $$$     [mix]=vararoutldemo([],plotflag);
  end
  disp(' ');
  disp(' ');
  disp('Press a key to continue');
  pause
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [d]=requestdemo
% prompt user for demo number

disp('Variational Mixture Model Demos with  ');
disp('Gaussian Observation model Mixture Model                 [1]');
disp('Autoregressive Observation model on Sinusoids            [2]');
disp('Poisson Observation model                                [3]');
%disp('Gaussian Observation model Mixture Model with outlier    [4]');
%disp('Autoregressive Observation model with outlier            [5]');
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
function [mix]=vargaussdemo(data,plt)
% A demonstration of the Mixture Model software using a Gaussian observation
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
  disp('The resulting GMM will be used to initialise an Mixture Model.');
  disp(' ');
  disp('Press a key to continue');
  pause
end

% Train up GMM on this data
mix=VarMixM(K,data,'Gauss');

if plt
  disp('Means of Mixture Model initialisation');
  getobspar(mix,1,'Norm_Mu');
  getobspar(mix,2,'Norm_Mu');

  % Train up Mixture Model on observation sequence data 
  disp('We will now train the Mixture Model');
  disp(' ');
  disp('Press a key to continue');
  pause
  disp('Estimated Mixture Model');
end

mix=set(mix,'train','cyc',30);

mix=train(mix,data,T);

if plt
  disp('Means');
  getobspar(mix,1,'Norm_Mu')
  getobspar(mix,2,'Norm_Mu')
  disp('Kernel Probabilities, P');
  gettxpar(mix,'P')
end

% var gauss demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mix]=vargaussoutldemo(data,plt)
% A demonstration of the Mixture Model software using a Gaussian observation
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
mix=VarMixM(K,data,'Gauss',[],outliers,'Uniform',outloptions);


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
  disp('Press a key to continue');
  pause
end

mix=set(mix,'train','cyc',30);

mix=train(mix,data,T);

% var gauss outlier demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mix]=vararsinedemo(data,plt)
% A demonstration of the Mixture Model software using an Autoregressive observation
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
mix=VarMixM(K,data,'AR',options);

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

mix=set(mix,'train','cyc',70);

mix=train(mix,data,T);
% var ar demo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mix]=vararoutldemo(data,plt)
% A demonstration of the Mixture Model software using an Autoregressive observation
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
mix=VarMixM(K,data,'AR',options,outliers,'Uniform');



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

mix=set(mix,'train','cyc',70);

mix=train(mix,data,T);

% var ar  demo with outliers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mix]=varpoissondemo(data,plt)
% A demonstration of the Mixture Model software using a Poisson observation
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
  disp('We will take random samples to initialise the Mixture Model.');
  disp(' ');
  disp('Press a key to continue');
  pause
end

% Train up Mixture Model on this data
mix=VarMixM(K,Xtrain,'Poisson');

if plt,
  disp('Mean rates of Mixture Model initialisation');
  getobspar(mix,1,'Gamma_alpha')./...
      getobspar(mix,1,'Gamma_beta');
  getobspar(mix,2,'Gamma_alpha')./...
      getobspar(mix,2,'Gamma_beta');
  
  disp('We will now train the Mixture Model');
  disp(' ');
  disp('Press a key to continue');
  pause
  disp('Estimated Mixture Model');
end

mix=set(mix,'train','cyc',30);

mix=train(mix,Xtrain,T);

if plt,
  disp('Rates');
  getobspar(mix,1,'Gamma_alpha')./...
      getobspar(mix,1,'Gamma_beta');
  getobspar(mix,2,'Gamma_alpha')./...
      getobspar(mix,2,'Gamma_beta');
  disp('Kernel Probabilities, P');
  gettxpar(mix,'P');
end


